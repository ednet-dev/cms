part of cqrs_drift;

/// Interface for providing the current tenant context.
///
/// This interface allows for different strategies to determine
/// the current tenant, such as:
/// - From HTTP request context
/// - From environment configuration
/// - From user/session information
///
/// Example usage:
/// ```dart
/// class HttpRequestTenantProvider implements TenantContextProvider {
///   final HttpRequest request;
///   
///   HttpRequestTenantProvider(this.request);
///   
///   @override
///   String get currentTenantId => 
///     request.headers['X-Tenant-ID'] ?? 'default';
/// }
/// ```
abstract class TenantContextProvider {
  /// Gets the current tenant ID.
  ///
  /// Returns:
  /// The ID of the current tenant
  String get currentTenantId;
}

/// Repository that enforces tenant isolation.
///
/// This repository enhances any other repository with tenant isolation,
/// ensuring that data from one tenant cannot be accessed by another:
/// - Automatically filters queries by tenant ID
/// - Adds tenant ID to all created entities
/// - Validates tenant ID on updates
///
/// This is a key component for multi-tenant SaaS applications.
///
/// Example usage:
/// ```dart
/// final repository = MultiTenantRepository<Task>(
///   baseRepository,
///   tenantContextProvider,
///   'tenantId'
/// );
/// 
/// // Will only return tasks for the current tenant
/// final tasks = await repository.findAll();
/// ```
class MultiTenantRepository<T extends Entity<T>> implements Repository<T> {
  /// The underlying repository
  final Repository<T> _repository;
  
  /// Provider for the current tenant context
  final TenantContextProvider _tenantContext;
  
  /// The name of the tenant ID field in entities
  final String _tenantIdField;
  
  /// Creates a new multi-tenant repository.
  ///
  /// Parameters:
  /// - [repository]: The underlying repository to delegate to
  /// - [tenantContext]: Provider for the current tenant context
  /// - [tenantIdField]: Name of the tenant ID field (defaults to 'tenantId')
  MultiTenantRepository(
    this._repository,
    this._tenantContext, {
    String tenantIdField = 'tenantId',
  }) : _tenantIdField = tenantIdField;
  
  /// Finds an entity by ID, filtered by tenant.
  ///
  /// This method only returns the entity if it belongs to the current tenant.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  ///
  /// Returns:
  /// The entity if it belongs to the current tenant, otherwise null
  @override
  Future<T?> findById(dynamic id) async {
    final entity = await _repository.findById(id);
    
    // Filter by tenant
    if (entity != null) {
      final entityTenantId = entity.getAttribute(_tenantIdField);
      if (entityTenantId == _tenantContext.currentTenantId) {
        return entity;
      }
    }
    
    return null;
  }
  
  /// Saves an entity, ensuring it belongs to the current tenant.
  ///
  /// This method:
  /// - Sets the tenant ID on new entities
  /// - Verifies tenant ID on existing entities
  ///
  /// Parameters:
  /// - [entity]: The entity to save
  ///
  /// Returns:
  /// The command result
  ///
  /// Throws:
  /// SecurityException if trying to update an entity from another tenant
  @override
  Future<CommandResult> save(T entity) async {
    final isNew = entity.getAttribute('id') == null;
    final entityTenantId = entity.getAttribute(_tenantIdField);
    final currentTenantId = _tenantContext.currentTenantId;
    
    if (isNew) {
      // For new entities, set the tenant ID
      entity.setAttribute(_tenantIdField, currentTenantId);
    } else if (entityTenantId != null && entityTenantId != currentTenantId) {
      // For existing entities, verify tenant ID
      throw SecurityException(
        'Cannot update entity from another tenant: ' +
        'Entity tenant: $entityTenantId, Current tenant: $currentTenantId'
      );
    }
    
    return _repository.save(entity);
  }
  
  /// Deletes an entity, ensuring it belongs to the current tenant.
  ///
  /// This method only deletes the entity if it belongs to the current tenant.
  ///
  /// Parameters:
  /// - [entity]: The entity to delete
  ///
  /// Returns:
  /// The command result
  ///
  /// Throws:
  /// SecurityException if trying to delete an entity from another tenant
  @override
  Future<CommandResult> delete(T entity) async {
    final entityTenantId = entity.getAttribute(_tenantIdField);
    final currentTenantId = _tenantContext.currentTenantId;
    
    if (entityTenantId != null && entityTenantId != currentTenantId) {
      throw SecurityException(
        'Cannot delete entity from another tenant: ' +
        'Entity tenant: $entityTenantId, Current tenant: $currentTenantId'
      );
    }
    
    return _repository.delete(entity);
  }
}

/// Enhances a DriftQueryRepository with multi-tenant capabilities.
///
/// This repository extends the standard [DriftQueryRepository] with
/// tenant isolation:
/// - Automatically filters all queries by tenant ID
/// - Secures all operations to prevent cross-tenant access
/// - Provides efficient tenant filtering for complex queries
///
/// Example usage:
/// ```dart
/// final repository = MultiTenantDriftRepository<Task>(
///   db,
///   taskConcept,
///   tenantContextProvider
/// );
/// 
/// // Only returns tasks for the current tenant
/// final tasks = await repository.findWhere((builder) => 
///   builder.where('status').equals('pending')
/// );
/// ```
class MultiTenantDriftRepository<T extends Entity<T>> extends DriftQueryRepository<T> {
  /// Provider for the current tenant context
  final TenantContextProvider _tenantContext;
  
  /// The name of the tenant ID field in entities
  final String _tenantIdField;
  
  /// Creates a new multi-tenant Drift repository.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  /// - [concept]: The concept for this repository
  /// - [tenantContext]: Provider for the current tenant context
  /// - [tenantIdField]: Name of the tenant ID field (defaults to 'tenantId')
  MultiTenantDriftRepository(
    EDNetDriftDatabase db,
    Concept concept,
    this._tenantContext, {
    String tenantIdField = 'tenantId',
  }) : _tenantIdField = tenantIdField,
       super(db, concept);
  
  /// Finds entities using a query builder, filtered by tenant.
  ///
  /// This method wraps the original query builder with a tenant filter.
  ///
  /// Parameters:
  /// - [buildQuery]: Function to build the query
  ///
  /// Returns:
  /// The query result, filtered by tenant
  @override
  Future<EntityQueryResult<T>> findWhere(
    void Function(QueryBuilder builder) buildQuery
  ) async {
    return super.findWhere((builder) {
      // Apply tenant filter first
      builder.where(_tenantIdField).equals(_tenantContext.currentTenantId);
      
      // Then apply the original query
      buildQuery(builder);
    });
  }
  
  /// Finds an entity by ID, filtered by tenant.
  ///
  /// This method overrides the default implementation to add tenant filtering.
  ///
  /// Parameters:
  /// - [id]: The entity ID
  ///
  /// Returns:
  /// The entity if it belongs to the current tenant, otherwise null
  @override
  Future<T?> findById(dynamic id) async {
    // Use query builder to apply tenant filter efficiently
    final result = await findWhere((builder) {
      builder.where('id').equals(id);
    });
    
    if (result.isSuccess && result.data!.isNotEmpty) {
      return result.data!.first;
    }
    
    return null;
  }
  
  /// Saves an entity, ensuring it belongs to the current tenant.
  ///
  /// This method:
  /// - Sets the tenant ID on new entities
  /// - Verifies tenant ID on existing entities
  ///
  /// Parameters:
  /// - [entity]: The entity to save
  ///
  /// Returns:
  /// The command result
  ///
  /// Throws:
  /// SecurityException if trying to update an entity from another tenant
  @override
  Future<CommandResult> save(T entity) async {
    final isNew = entity.getAttribute('id') == null;
    final entityTenantId = entity.getAttribute(_tenantIdField);
    final currentTenantId = _tenantContext.currentTenantId;
    
    if (isNew) {
      // For new entities, set the tenant ID
      entity.setAttribute(_tenantIdField, currentTenantId);
    } else if (entityTenantId != null && entityTenantId != currentTenantId) {
      // For existing entities, verify tenant ID
      throw SecurityException(
        'Cannot update entity from another tenant: ' +
        'Entity tenant: $entityTenantId, Current tenant: $currentTenantId'
      );
    }
    
    return super.save(entity);
  }
  
  /// Executes an expression query, filtered by tenant.
  ///
  /// This method adds a tenant filter to the expression query.
  ///
  /// Parameters:
  /// - [query]: The expression query to execute
  ///
  /// Returns:
  /// The query result, filtered by tenant
  @override
  Future<EntityQueryResult<T>> executeExpressionQuery(ExpressionQuery query) async {
    // Add tenant filter to the expression
    final tenantExpression = AttributeExpression(
      _tenantIdField,
      ComparisonOperator.equals,
      _tenantContext.currentTenantId,
    );
    
    // Create a new query that combines the original expression with the tenant filter
    final existingExpression = query.getExpression();
    final combinedExpression = existingExpression != null
      ? LogicalExpression(tenantExpression, LogicalOperator.and, existingExpression)
      : tenantExpression;
    
    // Create a new query with the combined expression
    final tenantQuery = ExpressionQuery(
      query.getName(),
      query.concept,
      combinedExpression,
    );
    
    // Copy all parameters
    query.getParameters().forEach((key, value) {
      tenantQuery.withParameter(key, value);
    });
    
    // Execute the query with tenant filter
    return super.executeExpressionQuery(tenantQuery);
  }
}

/// Factory for creating multi-tenant repositories.
///
/// This factory simplifies the creation of multi-tenant repositories
/// by handling the common setup and configuration details.
class MultiTenantRepositoryFactory {
  /// The Drift database
  final EDNetDriftDatabase _db;
  
  /// The domain model
  final Domain _domain;
  
  /// Provider for the current tenant context
  final TenantContextProvider _tenantContext;
  
  /// The name of the tenant ID field in entities
  final String _tenantIdField;
  
  /// Creates a new multi-tenant repository factory.
  ///
  /// Parameters:
  /// - [db]: The Drift database
  /// - [domain]: The domain model
  /// - [tenantContext]: Provider for the current tenant context
  /// - [tenantIdField]: Name of the tenant ID field (defaults to 'tenantId')
  MultiTenantRepositoryFactory(
    this._db,
    this._domain,
    this._tenantContext, {
    String tenantIdField = 'tenantId',
  }) : _tenantIdField = tenantIdField;
  
  /// Creates a multi-tenant repository for a specific entity type.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept
  ///
  /// Type parameters:
  /// - [T]: The entity type
  ///
  /// Returns:
  /// A multi-tenant repository for the specified entity type
  MultiTenantDriftRepository<T> createRepository<T extends Entity<T>>(
    String conceptCode
  ) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      throw ArgumentError('Concept not found: $conceptCode');
    }
    
    return MultiTenantDriftRepository<T>(
      _db,
      concept,
      _tenantContext,
      tenantIdField: _tenantIdField,
    );
  }
  
  /// Wraps an existing repository with multi-tenant capabilities.
  ///
  /// This method is useful when you have existing repositories
  /// that you want to enhance with tenant isolation.
  ///
  /// Parameters:
  /// - [repository]: The repository to wrap
  ///
  /// Type parameters:
  /// - [T]: The entity type
  ///
  /// Returns:
  /// A multi-tenant wrapper around the specified repository
  MultiTenantRepository<T> wrapRepository<T extends Entity<T>>(
    Repository<T> repository
  ) {
    return MultiTenantRepository<T>(
      repository,
      _tenantContext,
      tenantIdField: _tenantIdField,
    );
  }
}

/// Exception thrown when a security constraint is violated.
///
/// This exception is used to report security violations,
/// such as attempting to access data from another tenant.
class SecurityException implements Exception {
  /// The error message
  final String message;
  
  /// Creates a new security exception.
  ///
  /// Parameters:
  /// - [message]: The error message
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
} 