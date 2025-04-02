part of cqrs_drift;

/// A specialized repository that provides comprehensive query capabilities
/// with Drift database integration.
///
/// This repository combines the power of EdNet Core's query expressions
/// with Drift's SQL capabilities, enabling complex domain queries that
/// are efficiently translated to database operations.
class DriftQueryRepository<T extends Entity<T>> implements Repository<T> {
  /// The Drift database instance
  final EDNetDriftDatabase _db;
  
  /// The concept this repository manages
  final Concept _concept;
  
  /// Query adapter for expression-based queries
  late final DriftExpressionQueryAdapter _expressionAdapter;
  
  /// Command adapter for domain commands
  late final DriftCommandAdapter _commandAdapter;
  
  /// Creates a new Drift query repository.
  ///
  /// [db] is the Drift database to execute queries against.
  /// [concept] is the concept managed by this repository.
  DriftQueryRepository(this._db, this._concept) {
    _expressionAdapter = DriftExpressionQueryAdapter(_db);
    _commandAdapter = DriftCommandAdapter(_db);
  }
  
  /// Executes an expression query directly.
  ///
  /// This is the most powerful way to query the repository, supporting
  /// the full range of expressions, relationships, and functions.
  ///
  /// [query] is the expression query to execute.
  Future<EntityQueryResult<T>> executeExpressionQuery(ExpressionQuery query) async {
    if (query.concept != _concept) {
      return EntityQueryResult.failure(
        'Query concept does not match repository concept',
        concept: _concept
      );
    }
    
    final result = await _expressionAdapter.executeExpressionQuery(query);
    
    // Convert generic result to typed result
    if (result.isSuccess) {
      final typedEntities = result.data!.map((e) => e as T).toList();
      return EntityQueryResult.success(
        typedEntities, 
        concept: _concept,
        metadata: result.metadata
      );
    } else {
      return EntityQueryResult.failure(
        result.errorMessage ?? 'Unknown error',
        concept: _concept,
        metadata: result.metadata
      );
    }
  }
  
  /// Find entities using a fluent query builder.
  ///
  /// This method provides a clean, fluent API for building queries
  /// without manually constructing expression objects.
  ///
  /// [buildQuery] is a function that configures the query builder.
  Future<EntityQueryResult<T>> findWhere(
    void Function(QueryBuilder builder) buildQuery
  ) async {
    final builder = QueryBuilder.forConcept(_concept, 'FindWhere');
    buildQuery(builder);
    final query = builder.build();
    return executeExpressionQuery(query);
  }
  
  /// Find all entities matching an attribute condition.
  ///
  /// This is a convenience method for simple attribute equality checks.
  ///
  /// [attributeCode] is the attribute to check.
  /// [value] is the value to compare against.
  Future<EntityQueryResult<T>> findByAttribute(
    String attributeCode, 
    dynamic value
  ) async {
    final query = ExpressionQuery.withAttribute(
      'FindBy$attributeCode',
      _concept,
      attributeCode,
      ComparisonOperator.equals,
      value
    );
    return executeExpressionQuery(query);
  }
  
  /// Find a single entity by its ID.
  ///
  /// This method attempts to find an entity with the specified ID.
  /// Returns null if no entity is found.
  ///
  /// [id] is the ID of the entity to find.
  Future<T?> findById(dynamic id) async {
    final result = await findByAttribute('id', id);
    if (result.isSuccess && result.data!.isNotEmpty) {
      return result.data!.first;
    }
    return null;
  }
  
  /// Save an entity to the repository.
  ///
  /// This method inserts or updates the entity in the database.
  ///
  /// [entity] is the entity to save.
  Future<CommandResult> save(T entity) async {
    final command = SaveEntityCommand(entity);
    return _commandAdapter.executeCommand(command);
  }
  
  /// Delete an entity from the repository.
  ///
  /// This method removes the entity from the database.
  ///
  /// [entity] is the entity to delete.
  Future<CommandResult> delete(T entity) async {
    final command = DeleteEntityCommand(entity);
    return _commandAdapter.executeCommand(command);
  }
  
  // Implement other Repository methods...
}
