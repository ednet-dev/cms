// part of ednet_core;
//
// /// A secure query handler that enforces authorization rules.
// ///
// /// The [SecureQueryHandler] class extends [BaseQueryHandler] to add:
// /// - Authorization checks before execution
// /// - Field-level access control for query results
// /// - Security audit logging
// ///
// /// This handler works with the [SecurityContext] to ensure that queries
// /// are only executed by authorized subjects.
// ///
// /// Example usage:
// /// ```dart
// /// class FindTasksHandler extends SecureQueryHandler<FindTasksQuery, TasksQueryResult> {
// ///   FindTasksHandler(Repository<Task> repository) : super(repository);
// ///
// ///   @override
// ///   List<Permission> getPermissionsForQuery(FindTasksQuery query) {
// ///     return [Permission('Task', 'read')];
// ///   }
// ///
// ///   @override
// ///   Future<TasksQueryResult> executeQuery(FindTasksQuery query) async {
// ///     // Implementation
// ///   }
// /// }
// /// ```
// abstract class SecureQueryHandler<Q extends IQuery, R extends IQueryResult>
//     extends BaseQueryHandler<Q, R> {
//
//   /// The repository for accessing entities.
//   final Repository? repository;
//
//   /// Whether to log security events.
//   final bool logSecurityEvents;
//
//   /// Creates a new secure query handler.
//   ///
//   /// Parameters:
//   /// - [repository]: Optional repository for accessing entities
//   /// - [logSecurityEvents]: Whether to log security events
//   SecureQueryHandler({
//     this.repository,
//     this.logSecurityEvents = true,
//   });
//
//   /// Gets the permissions required for a query.
//   ///
//   /// Override this method to specify which permissions are required
//   /// for the query. The default implementation returns an empty list,
//   /// which means no permissions are required.
//   ///
//   /// Parameters:
//   /// - [query]: The query to get permissions for
//   ///
//   /// Returns:
//   /// The list of permissions required for the query
//   List<Permission> getPermissionsForQuery(Q query) {
//     // Default implementation returns an empty list
//     // Subclasses should override this to specify required permissions
//     return [];
//   }
//
//   /// Authorizes the execution of a query.
//   ///
//   /// This method checks if the current subject has the permissions
//   /// required to execute the query. If not, it logs a security violation
//   /// and returns false.
//   ///
//   /// Parameters:
//   /// - [query]: The query to authorize
//   ///
//   /// Returns:
//   /// True if the query is authorized, false otherwise
//   @override
//   bool authorizeExecution(Q query) {
//     final permissions = getPermissionsForQuery(query);
//
//     if (permissions.isEmpty) {
//       // No permissions required
//       return true;
//     }
//
//     if (!SecurityContext.hasAnyPermission(permissions)) {
//       if (logSecurityEvents) {
//         logSecurityViolation('Unauthorized query execution', query);
//       }
//       return false;
//     }
//
//     return true;
//   }
//
//   /// Filters an entity based on field permissions.
//   ///
//   /// This method creates a filtered copy of an entity, removing any fields
//   /// that the current subject doesn't have permission to read.
//   ///
//   /// Parameters:
//   /// - [entity]: The entity to filter
//   /// - [resourceName]: The name of the resource
//   ///
//   /// Returns:
//   /// A filtered copy of the entity
//   T filterEntityFields<T extends Entity<T>>(T entity, String resourceName) {
//     if (SecurityContext.hasPermission(Permission(resourceName, 'read_all'))) {
//       // Subject has full read access, return the entity as-is
//       return entity;
//     }
//
//     // Create a copy of the entity
//     final filteredEntity = entity.copy() as T;
//
//     // Create a field access checker function
//     final canAccessField = SecurityContext.createFieldAccessChecker(resourceName, 'read');
//
//     // Get the concept for the entity
//     final concept = entity.concept;
//
//     // Filter attributes
//     for (var attribute in concept.attributes) {
//       if (!canAccessField(attribute.code)) {
//         // Subject doesn't have permission to read this field
//         filteredEntity.setAttribute(attribute.code, null);
//       }
//     }
//
//     return filteredEntity;
//   }
//
//   /// Filters a list of entities based on field permissions.
//   ///
//   /// This method creates a filtered copy of a list of entities,
//   /// applying field-level filtering to each entity.
//   ///
//   /// Parameters:
//   /// - [entities]: The list of entities to filter
//   /// - [resourceName]: The name of the resource
//   ///
//   /// Returns:
//   /// A filtered copy of the entity list
//   List<T> filterEntitiesFields<T extends Entity<T>>(List<T> entities, String resourceName) {
//     if (SecurityContext.hasPermission(Permission(resourceName, 'read_all'))) {
//       // Subject has full read access, return the entities as-is
//       return entities;
//     }
//
//     // Filter each entity
//     return entities.map((entity) => filterEntityFields(entity, resourceName)).toList();
//   }
//
//   /// Creates a failure result with the given error message.
//   ///
//   /// This method creates a failure result for the given error message,
//   /// which can be returned from the handler.
//   ///
//   /// Parameters:
//   /// - [errorMessage]: The error message
//   ///
//   /// Returns:
//   /// A failure result
//   @override
//   IQueryResult createFailureResult(String errorMessage) {
//     // Default implementation, subclasses should override
//     return QueryResult.failure(errorMessage);
//   }
//
//   /// Logs a security violation.
//   ///
//   /// This method logs information about a security violation, including:
//   /// - The message describing the violation
//   /// - The object that caused the violation
//   /// - The current security subject
//   ///
//   /// Parameters:
//   /// - [message]: The message describing the violation
//   /// - [violationSource]: The object that caused the violation
//   void logSecurityViolation(String message, Object violationSource) {
//     // In a real implementation, this would log to a secure audit log
//     print('SECURITY VIOLATION: $message');
//     print('  Source: $violationSource');
//     print('  Subject: ${SecurityContext.getCurrentSubject()}');
//   }
// }
//
// /// A secure concept query handler that enforces authorization rules.
// ///
// /// The [SecureConceptQueryHandler] class extends [ConceptQueryHandler] to add:
// /// - Concept-specific authorization checks
// /// - Field-level access control for query results
// /// - Security audit logging
// ///
// /// This handler works with the [SecurityContext] to ensure that queries
// /// are only executed by authorized subjects.
// ///
// /// Example usage:
// /// ```dart
// /// class TaskQueryHandler extends SecureConceptQueryHandler<Task> {
// ///   TaskQueryHandler(Repository<Task> repository, Concept concept)
// ///     : super(repository, concept);
// ///
// ///   @override
// ///   Future<EntityQueryResult<Task>> executeConceptQuery(ConceptQuery query) async {
// ///     // Implementation
// ///   }
// /// }
// /// ```
// class SecureConceptQueryHandler<T extends AggregateRoot>
//     extends ConceptQueryHandler<T> {
//
//   /// Whether to log security events.
//   final bool logSecurityEvents;
//
//   /// Creates a new secure concept query handler.
//   ///
//   /// Parameters:
//   /// - [repository]: Repository for accessing entities
//   /// - [concept]: The concept this handler processes queries for
//   /// - [logSecurityEvents]: Whether to log security events
//   SecureConceptQueryHandler(
//     Repository<T> repository,
//     model.Concept concept, {
//     this.logSecurityEvents = true,
//   }) : super(repository, concept);
//
//   /// Checks if the current context has permission to access sensitive data.
//   ///
//   /// This method checks if the current subject has the permission to
//   /// access sensitive data for this concept.
//   ///
//   /// Returns:
//   /// True if the current subject has permission to access sensitive data
//   @override
//   bool hasPermissionForSensitiveData() {
//     return SecurityContext.hasPermission(
//       Permission(concept.code, 'read_sensitive')
//     );
//   }
//
//   /// Filters the results of a concept query based on permissions.
//   ///
//   /// This method applies field-level filtering to query results,
//   /// removing fields that the current subject doesn't have permission to read.
//   ///
//   /// Parameters:
//   /// - [result]: The original query result
//   ///
//   /// Returns:
//   /// A filtered query result
//   model.EntityQueryResult<T> filterResultFields(model.EntityQueryResult<T> result) {
//     if (!result.isSuccess || result.data.isEmpty) {
//       return result;
//     }
//
//     if (SecurityContext.hasPermission(Permission(concept.code, 'read_all'))) {
//       // Subject has full read access, return the result as-is
//       return result;
//     }
//
//     // Create a field access checker function
//     final canAccessField = SecurityContext.createFieldAccessChecker(concept.code, 'read');
//
//     // Filter each entity in the result
//     final filteredEntities = result.data.map((entity) {
//       final filteredEntity = entity.copy() as T;
//
//       // Filter attributes
//       for (var attribute in concept.attributes) {
//         if (!canAccessField(attribute.code)) {
//           // Subject doesn't have permission to read this field
//           filteredEntity.setAttribute(attribute.code, null);
//         }
//       }
//
//       return filteredEntity;
//     }).toList();
//
//     // Create a new result with filtered entities
//     return model.EntityQueryResult.success(
//       filteredEntities,
//       concept: concept,
//       metadata: result.metadata,
//     );
//   }
//
//   /// Executes a concept query with permission checks and filtering.
//   ///
//   /// This method extends [executeConceptQuery] to add field-level filtering
//   /// to the query results.
//   ///
//   /// Parameters:
//   /// - [query]: The concept query to execute
//   ///
//   /// Returns:
//   /// A Future with the filtered entity query result
//   @override
//   Future<model.EntityQueryResult<T>> executeQuery(model.ConceptQuery query) async {
//     final result = await super.executeQuery(query);
//
//     if (result.isSuccess) {
//       return filterResultFields(result);
//     }
//
//     return result;
//   }
//
//   /// Logs a security violation.
//   ///
//   /// This method logs information about a security violation, including:
//   /// - The message describing the violation
//   /// - The object that caused the violation
//   /// - The current security subject
//   ///
//   /// Parameters:
//   /// - [message]: The message describing the violation
//   /// - [violationSource]: The object that caused the violation
//   void logSecurityViolation(String message, Object violationSource) {
//     // In a real implementation, this would log to a secure audit log
//     print('SECURITY VIOLATION: $message');
//     print('  Source: $violationSource');
//     print('  Subject: ${SecurityContext.getCurrentSubject()}');
//     print('  Concept: ${concept.code}');
//   }
// }