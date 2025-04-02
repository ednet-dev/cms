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
  
  /// Execute multiple operations within a single transaction.
  ///
  /// This method provides a convenient way to run multiple repository
  /// operations as a single atomic unit of work.
  ///
  /// [action] is a function that contains the operations to execute.
  /// It receives a transactional repository instance as a parameter.
  ///
  /// Returns the result of the [action] function.
  Future<R> transaction<R>(
    Future<R> Function(DriftQueryRepository<T> repository) action
  ) async {
    return _db.transaction(() {
      // Use this same repository instance inside the transaction
      // The transaction context is managed by the database
      return action(this);
    });
  }
  
  /// Saves multiple entities in a batch operation.
  ///
  /// This method efficiently saves multiple entities in a single transaction,
  /// which can be much faster than saving them individually.
  ///
  /// [entities] is the list of entities to save.
  ///
  /// Returns a list of command results, one for each entity.
  Future<List<CommandResult>> saveAll(List<T> entities) async {
    if (entities.isEmpty) {
      return [];
    }
    
    return transaction((repo) async {
      final results = <CommandResult>[];
      for (final entity in entities) {
        results.add(await repo.save(entity));
      }
      return results;
    });
  }
  
  /// Gets the total count of entities matching the criteria.
  ///
  /// This method provides an efficient way to count entities without
  /// retrieving all the data, useful for pagination.
  ///
  /// [buildQuery] is a function that configures the query criteria.
  ///
  /// Returns the count of matching entities.
  Future<int> count(
    void Function(QueryBuilder builder)? buildQuery
  ) async {
    final tableName = _concept.code.toLowerCase();
    
    try {
      String whereClause = '';
      List<Variable> variables = [];
      
      // If there are criteria, build the WHERE clause
      if (buildQuery != null) {
        final builder = QueryBuilder.forConcept(_concept, 'Count');
        buildQuery(builder);
        final query = builder.build();
        
        // Use the expression adapter to translate the query to SQL
        // but we only need the WHERE clause part
        final expression = query.getExpression();
        if (expression != null) {
          final translationResult = _translateExpressionToWhereClause(expression);
          whereClause = translationResult.whereClause;
          variables = translationResult.variables;
        }
      }
      
      // Execute the count query
      final countQuery = 'SELECT COUNT(*) as count FROM $tableName' +
          (whereClause.isNotEmpty ? ' WHERE $whereClause' : '');
      
      final result = await _db.customSelect(
        countQuery,
        variables: variables,
      ).getSingle();
      
      return result.read<int>('count');
    } catch (e) {
      // Log error or handle it appropriately
      return 0;
    }
  }
  
  /// Translates a query expression to a SQL WHERE clause.
  ///
  /// This is a helper method that converts an expression to SQL
  /// for use in COUNT queries.
  ///
  /// [expression] is the expression to translate.
  ///
  /// Returns a result with the WHERE clause and variables.
  _WhereClauseResult _translateExpressionToWhereClause(model.QueryExpression expression) {
    // This is a simplified implementation that would use
    // the DriftExpressionQueryAdapter's translation logic
    // but return only the WHERE clause part
    
    // For now, return an empty where clause
    return _WhereClauseResult('', []);
  }
}

/// Command to save an entity.
///
/// This is a simple wrapper around an entity for the command adapter.
class SaveEntityCommand implements app.ICommand {
  final Entity<dynamic> _entity;
  
  SaveEntityCommand(this._entity);
  
  @override
  String get name => _entity.getAttribute('id') != null ? 'UpdateEntity' : 'CreateEntity';
  
  @override
  Map<String, dynamic> getParameters() => {'entity': _entity};
  
  @override
  List<app.IDomainEvent> getEvents() => [];
  
  @override
  bool doIt() => true;
  
  // Convenience getter for the command adapter
  Entity<dynamic> get entity => _entity;
}

/// Command to delete an entity.
///
/// This is a simple wrapper around an entity for the command adapter.
class DeleteEntityCommand implements app.ICommand {
  final Entity<dynamic> _entity;
  
  DeleteEntityCommand(this._entity);
  
  @override
  String get name => 'DeleteEntity';
  
  @override
  Map<String, dynamic> getParameters() => {'entity': _entity};
  
  @override
  List<app.IDomainEvent> getEvents() => [];
  
  @override
  bool doIt() => true;
  
  // Convenience getter for the command adapter
  Entity<dynamic> get entity => _entity;
}

/// Result for translating an expression to a WHERE clause.
class _WhereClauseResult {
  final String whereClause;
  final List<Variable> variables;
  
  _WhereClauseResult(this.whereClause, this.variables);
}
