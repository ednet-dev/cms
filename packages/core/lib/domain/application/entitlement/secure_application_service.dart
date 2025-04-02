part of ednet_core;

/// A secure application service that enforces authorization rules.
///
/// The [SecureApplicationService] class extends [ApplicationService] to add:
/// - Command authorization checks
/// - Query authorization checks
/// - Result filtering based on permissions
/// - Audit logging for security events
///
/// This class integrates with the [SecurityContext] to enforce permissions
/// based on the current security subject.
///
/// Example usage:
/// ```dart
/// class OrderService extends SecureApplicationService<Order> {
///   OrderService(Repository<Order> repository) : 
///     super(repository, name: 'OrderService');
///     
///   @override
///   List<Permission> getPermissionsForCommand(ICommand command) {
///     switch(command.name) {
///       case 'CreateOrder': return [Permission('Order', 'create')];
///       case 'UpdateOrder': return [Permission('Order', 'update')];
///       default: return super.getPermissionsForCommand(command);
///     }
///   }
/// }
/// ```
class SecureApplicationService<T extends AggregateRoot> extends ApplicationService<T> {
  /// Whether to enforce command authorization
  final bool enforceCommandAuthorization;
  
  /// Whether to enforce query authorization
  final bool enforceQueryAuthorization;
  
  /// Whether to filter query results based on permissions
  final bool filterQueryResults;
  
  /// Whether to log security events
  final bool logSecurityEvents;
  
  /// Creates a new secure application service.
  ///
  /// Parameters:
  /// - [repository]: Repository for the aggregate type
  /// - [name]: Name of the service
  /// - [dependencies]: Other services this one depends on
  /// - [session]: Optional domain session for transaction management
  /// - [queryDispatcher]: Optional query dispatcher for handling queries
  /// - [enforceCommandAuthorization]: Whether to enforce command authorization
  /// - [enforceQueryAuthorization]: Whether to enforce query authorization
  /// - [filterQueryResults]: Whether to filter query results based on permissions
  /// - [logSecurityEvents]: Whether to log security events
  SecureApplicationService(
    Repository<T> repository, {
    required String name,
    List<ApplicationService> dependencies = const [],
    IDomainSession? session,
    QueryDispatcher? queryDispatcher,
    this.enforceCommandAuthorization = true,
    this.enforceQueryAuthorization = true,
    this.filterQueryResults = true,
    this.logSecurityEvents = true,
  }) : super(
    repository,
    name: name,
    dependencies: dependencies,
    session: session,
    queryDispatcher: queryDispatcher,
  );
  
  /// Gets the permissions required for a command.
  ///
  /// Override this method to specify which permissions are required
  /// for specific commands.
  ///
  /// The default implementation derives permissions from the command name:
  /// - For commands like "CreateX", requires "X:create" permission
  /// - For commands like "UpdateX", requires "X:update" permission
  /// - For commands like "DeleteX", requires "X:delete" permission
  ///
  /// Parameters:
  /// - [command]: The command to get permissions for
  ///
  /// Returns:
  /// The list of permissions required for the command
  List<Permission> getPermissionsForCommand(ICommand command) {
    final commandName = command.name;
    final resourceName = getResourceNameFromGenericType();
    
    // Handle common command name patterns
    if (commandName.startsWith('Create')) {
      return [Permission(resourceName, 'create')];
    } else if (commandName.startsWith('Update')) {
      return [Permission(resourceName, 'update')];
    } else if (commandName.startsWith('Delete')) {
      return [Permission(resourceName, 'delete')];
    } else if (commandName.startsWith('Get') || commandName.startsWith('Find')) {
      return [Permission(resourceName, 'read')];
    }
    
    // Default to requiring a permission based on the command name
    // Convert CamelCase to lower-case with hyphens
    // e.g., "ArchiveOrder" -> "archive"
    final operation = commandName
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match[1]}_${match[2]}')
        .toLowerCase()
        .split('_')
        .first;
    
    return [Permission(resourceName, operation)];
  }
  
  /// Gets the permissions required for a query.
  ///
  /// Override this method to specify which permissions are required
  /// for specific queries.
  ///
  /// The default implementation requires a "read" permission on the resource.
  ///
  /// Parameters:
  /// - [query]: The query to get permissions for
  ///
  /// Returns:
  /// The list of permissions required for the query
  List<Permission> getPermissionsForQuery(IQuery query) {
    final resourceName = getResourceNameFromGenericType();
    return [Permission(resourceName, 'read')];
  }
  
  /// Validates a command and checks authorization.
  ///
  /// This method extends [validateCommand] to add authorization checks:
  /// 1. Calls the base validation
  /// 2. Checks if the current subject has the required permissions
  ///
  /// Parameters:
  /// - [command]: The command to validate
  ///
  /// Returns:
  /// True if the command is valid and authorized, false otherwise
  @override
  bool validateCommand(ICommand command) {
    if (!super.validateCommand(command)) {
      return false;
    }
    
    if (enforceCommandAuthorization) {
      final permissions = getPermissionsForCommand(command);
      if (!permissions.isEmpty && !SecurityContext.hasAnyPermission(permissions)) {
        if (logSecurityEvents) {
          logSecurityViolation('Unauthorized command execution', command);
        }
        return false;
      }
    }
    
    return true;
  }
  
  /// Executes a query with authorization checks.
  ///
  /// This method extends [executeQuery] to add authorization checks
  /// and result filtering:
  /// 1. Checks if the current subject has the required permissions
  /// 2. Executes the query
  /// 3. Filters the results based on permissions
  ///
  /// Parameters:
  /// - [query]: The query to execute
  ///
  /// Returns:
  /// A Future with the query result
  @override
  Future<R> executeQuery<Q extends IQuery, R extends IQueryResult>(Q query) async {
    if (enforceQueryAuthorization) {
      final permissions = getPermissionsForQuery(query);
      if (!permissions.isEmpty && !SecurityContext.hasAnyPermission(permissions)) {
        if (logSecurityEvents) {
          logSecurityViolation('Unauthorized query execution', query);
        }
        return QueryResult.failure('Not authorized to execute this query') as R;
      }
    }
    
    final result = await super.executeQuery<Q, R>(query);
    
    if (filterQueryResults && result is QueryResult && result.isSuccess) {
      return filterResultsByPermissions(result) as R;
    }
    
    return result;
  }
  
  /// Filters query results based on permissions.
  ///
  /// This method filters the results of a query based on the current
  /// subject's permissions. It removes entities that the subject
  /// doesn't have permission to read.
  ///
  /// Parameters:
  /// - [result]: The query result to filter
  ///
  /// Returns:
  /// A filtered query result
  QueryResult filterResultsByPermissions(QueryResult result) {
    if (result.data is List<T>) {
      final resourceName = getResourceNameFromGenericType();
      final filteredData = (result.data as List<T>).where((entity) => 
        hasReadPermissionForEntity(entity, resourceName)
      ).toList();
      
      return QueryResult(
        isSuccess: result.isSuccess,
        data: filteredData,
        errorMessage: result.errorMessage,
        metadata: result.metadata,
      );
    }
    
    return result;
  }
  
  /// Checks if the current subject has permission to read an entity.
  ///
  /// This method checks if the current subject has permission to read a
  /// specific entity. It can be overridden to implement custom access control
  /// logic based on entity attributes.
  ///
  /// Parameters:
  /// - [entity]: The entity to check read permission for
  /// - [resourceName]: The name of the resource
  ///
  /// Returns:
  /// True if the current subject has permission to read the entity
  bool hasReadPermissionForEntity(T entity, String resourceName) {
    // Default implementation checks for a read permission on the resource
    // Override this for more fine-grained control based on entity attributes
    return SecurityContext.hasPermission(Permission(resourceName, 'read'));
  }
  
  /// Logs a security violation.
  ///
  /// This method logs information about a security violation, including:
  /// - The message describing the violation
  /// - The object that caused the violation
  /// - The current security subject
  ///
  /// Parameters:
  /// - [message]: The message describing the violation
  /// - [violationSource]: The object that caused the violation
  void logSecurityViolation(String message, Object violationSource) {
    // In a real implementation, this would log to a secure audit log
    print('SECURITY VIOLATION: $message');
    print('  Source: $violationSource');
    print('  Subject: ${SecurityContext.getCurrentSubject()}');
  }
  
  /// Gets the resource name from the generic type parameter.
  ///
  /// This method extracts the resource name from the generic type parameter
  /// of the service. For example, if the service is OrderService<Order>,
  /// this method returns "Order".
  ///
  /// Returns:
  /// The resource name
  String getResourceNameFromGenericType() {
    return T.toString();
  }
} 