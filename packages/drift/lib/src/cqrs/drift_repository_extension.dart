part of cqrs_drift;

/// Extends the EDNetDriftRepository with CQRS capabilities.
///
/// This class adds command and query handling functionality
/// to the standard EDNetDriftRepository, enabling CQRS-based
/// operations with Drift persistence.
///
/// Example usage:
/// ```dart
/// final repository = EDNetDriftCqrsRepository(
///   domain: domain,
///   sqlitePath: 'database.sqlite',
/// );
///
/// // Execute a query
/// final tasks = await repository.executeQuery(findActiveTasksQuery);
/// ```
class EDNetDriftCqrsRepository extends EDNetDriftRepository {
  /// The command adapter for handling commands
  late final DriftCommandAdapter _commandAdapter;
  
  /// The query adapter for handling queries
  late final DriftQueryAdapter _queryAdapter;
  
  /// The expression query adapter for handling complex queries
  late final DriftExpressionQueryAdapter _expressionQueryAdapter;
  
  /// The query dispatcher for routing queries to handlers
  late final app.QueryDispatcher _queryDispatcher;
  
  /// The REST query adapter for handling REST API requests
  late final RestQueryAdapter _restQueryAdapter;
  
  /// Creates a new CQRS repository with Drift persistence.
  ///
  /// Parameters:
  /// - [domain]: The domain model
  /// - [sqlitePath]: Path to the SQLite database file
  /// - [schemaVersion]: Optional schema version
  EDNetDriftCqrsRepository({
    required Domain domain,
    required String sqlitePath,
    int? schemaVersion,
  }) : super(
    domain: domain,
    sqlitePath: sqlitePath,
    schemaVersion: schemaVersion,
  ) {
    _initializeCqrs();
  }
  
  /// Initializes CQRS components.
  void _initializeCqrs() {
    // Create adapters
    _commandAdapter = DriftCommandAdapter(_db);
    _queryAdapter = DriftQueryAdapter(_db);
    _expressionQueryAdapter = DriftExpressionQueryAdapter(_db);
    _queryDispatcher = app.QueryDispatcher();
    _restQueryAdapter = RestQueryAdapter();
    
    // Register default handlers for all concepts
    _registerQueryHandlers();
  }
  
  /// Registers query handlers for all concepts in the domain.
  void _registerQueryHandlers() {
    final handlerFactory = DriftQueryHandlerFactory(_db);
    handlerFactory.registerAllConceptHandlers(
      _domain,
      _queryDispatcher,
      (concept) => this,
    );
  }
  
  /// Executes a command against the repository.
  ///
  /// This method delegates to the command adapter to handle
  /// the command execution.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  ///
  /// Returns a Future with the command result
  Future<app.CommandResult> executeCommand(app.ICommand command) {
    return _commandAdapter.executeCommand(command);
  }
  
  /// Executes a query against the repository.
  ///
  /// This method delegates to the query dispatcher to route
  /// the query to the appropriate handler.
  ///
  /// Parameters:
  /// - [query]: The query to execute
  ///
  /// Returns a Future with the query result
  Future<model.IQueryResult> executeQuery(model.IQuery query) {
    if (query is model.ConceptQuery) {
      return _queryDispatcher.dispatch(query);
    } else if (query is model.ExpressionQuery) {
      return _expressionQueryAdapter.executeExpressionQuery(query);
    } else {
      return Future.value(
        model.QueryResult.failure('Unsupported query type: ${query.runtimeType}')
      );
    }
  }
  
  /// Creates and executes a query for a concept with optional filters.
  ///
  /// This is a convenience method for creating and executing
  /// simple concept queries without needing to construct a query object.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to query
  /// - [filters]: Optional filters (attribute-value pairs)
  /// - [sort]: Optional field to sort by
  /// - [sortDirection]: Optional sort direction ('asc' or 'desc')
  /// - [page]: Optional page number for pagination
  /// - [pageSize]: Optional page size for pagination
  ///
  /// Returns a Future with the query result
  Future<model.EntityQueryResult<Entity<dynamic>>> query(
    String conceptCode, {
    Map<String, dynamic>? filters,
    String? sort,
    String? sortDirection,
    int? page,
    int? pageSize,
  }) async {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return model.EntityQueryResult.failure(
        'Concept not found: $conceptCode',
        concept: null,
      );
    }
    
    final query = model.ConceptQuery('FindByCriteria', concept);
    
    // Apply filters
    if (filters != null) {
      filters.forEach((key, value) {
        query.withParameter(key, value);
      });
    }
    
    // Apply sorting
    if (sort != null) {
      query.withSorting(sort, ascending: sortDirection?.toLowerCase() != 'desc');
    }
    
    // Apply pagination
    if (page != null && pageSize != null) {
      query.withPagination(page: page, pageSize: pageSize);
    }
    
    final result = await executeQuery(query);
    
    if (result is model.EntityQueryResult<Entity<dynamic>>) {
      return result;
    } else {
      return model.EntityQueryResult.failure(
        'Query returned unexpected result type',
        concept: concept,
      );
    }
  }
  
  /// Creates and executes a query builder for a concept.
  ///
  /// This method provides a fluent interface for constructing
  /// expression-based queries without needing to construct complex objects.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to query
  /// - [buildQuery]: A function that configures the query builder
  ///
  /// Returns a Future with the query result
  Future<model.EntityQueryResult<Entity<dynamic>>> queryWhere(
    String conceptCode,
    void Function(QueryBuilder builder) buildQuery
  ) async {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return model.EntityQueryResult.failure(
        'Concept not found: $conceptCode',
        concept: null,
      );
    }
    
    final builder = QueryBuilder.forConcept(concept, 'FindWhere');
    buildQuery(builder);
    final query = builder.build();
    
    return _expressionQueryAdapter.executeExpressionQuery(query);
  }
  
  /// Executes a query from REST API request parameters.
  ///
  /// This method uses the REST query adapter to convert
  /// REST API parameters to a domain model query.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to query
  /// - [params]: The REST API query parameters
  /// - [queryName]: Optional query name (defaults to 'FindByCriteria')
  ///
  /// Returns a Future with the query result
  Future<model.EntityQueryResult<Entity<dynamic>>> executeRestQuery(
    String conceptCode,
    Map<String, dynamic> params, [
    String queryName = RestQueryAdapter.DEFAULT_QUERY_NAME,
  ]) async {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return model.EntityQueryResult.failure(
        'Concept not found: $conceptCode',
        concept: null,
      );
    }
    
    final query = _restQueryAdapter.fromRequestParameters(
      concept,
      params,
      queryName,
    );
    
    return executeQuery(query) as Future<model.EntityQueryResult<Entity<dynamic>>>;
  }
  
  /// Find a single entity by its ID.
  ///
  /// This is a convenience method for finding an entity by its ID
  /// without needing to construct a query.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to query
  /// - [id]: The ID of the entity to find
  ///
  /// Returns a Future with the entity, or null if not found
  Future<Entity<dynamic>?> findById(
    String conceptCode,
    dynamic id
  ) async {
    final result = await query(conceptCode, filters: {'id': id});
    
    if (result.isSuccess && result.data!.isNotEmpty) {
      return result.data!.first;
    }
    
    return null;
  }
  
  /// Create a new entity.
  ///
  /// This is a convenience method for creating an entity
  /// without needing to construct a command.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to create
  /// - [data]: The attribute values for the new entity
  ///
  /// Returns a Future with the command result
  Future<app.CommandResult> create(
    String conceptCode,
    Map<String, dynamic> data
  ) async {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return app.CommandResult.failure('Concept not found: $conceptCode');
    }
    
    final command = GenericCommand('Create$conceptCode')
      ..withParameter('concept', concept)
      ..withParameter('data', data);
    
    return executeCommand(command);
  }
  
  /// Update an existing entity.
  ///
  /// This is a convenience method for updating an entity
  /// without needing to construct a command.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to update
  /// - [id]: The ID of the entity to update
  /// - [data]: The attribute values to update
  ///
  /// Returns a Future with the command result
  Future<app.CommandResult> update(
    String conceptCode,
    dynamic id,
    Map<String, dynamic> data
  ) async {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return app.CommandResult.failure('Concept not found: $conceptCode');
    }
    
    // Ensure the ID is included in the data
    final updateData = Map<String, dynamic>.from(data);
    updateData['id'] = id;
    
    final command = GenericCommand('Update$conceptCode')
      ..withParameter('concept', concept)
      ..withParameter('data', updateData);
    
    return executeCommand(command);
  }
  
  /// Delete an entity.
  ///
  /// This is a convenience method for deleting an entity
  /// without needing to construct a command.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to delete
  /// - [id]: The ID of the entity to delete
  ///
  /// Returns a Future with the command result
  Future<app.CommandResult> delete(
    String conceptCode,
    dynamic id
  ) async {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return app.CommandResult.failure('Concept not found: $conceptCode');
    }
    
    final command = GenericCommand('Delete$conceptCode')
      ..withParameter('concept', concept)
      ..withParameter('data', {'id': id});
    
    return executeCommand(command);
  }
  
  /// Gets a typed repository for a specific concept.
  ///
  /// This method provides access to a type-safe repository
  /// for the specified concept, making it easier to work with
  /// strongly-typed entities.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to get a repository for
  ///
  /// Returns a DriftQueryRepository for the concept
  DriftQueryRepository<Entity<dynamic>> getRepository(String conceptCode) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      throw ArgumentError('Concept not found: $conceptCode');
    }
    
    return DriftQueryRepository<Entity<dynamic>>(_db, concept);
  }
}

/// Extension methods for the EDNetDriftRepository class.
///
/// These methods add CQRS capabilities to the standard repository
/// without modifying the original class.
extension EDNetDriftRepositoryCqrsExtension on EDNetDriftRepository {
  /// Creates a CQRS-enabled version of this repository.
  ///
  /// This method wraps the standard repository with CQRS capabilities,
  /// enabling command and query handling.
  ///
  /// Returns a new EDNetDriftCqrsRepository with the same configuration
  EDNetDriftCqrsRepository withCqrs() {
    return EDNetDriftCqrsRepository(
      domain: _domain,
      sqlitePath: _db.executor is NativeDatabase && _db.executor.path.isNotEmpty
          ? (_db.executor as NativeDatabase).path
          : ':memory:',
      schemaVersion: _db.schemaVersion,
    );
  }
} 

/// Extensions for concept-aware querying with Drift.
extension ConceptQueryExtensions on EDNetDriftRepository {
  /// Creates a query repository for a specific concept.
  ///
  /// This method provides access to the full range of query capabilities
  /// for the specified concept, making it easier to work with domain entities.
  ///
  /// [conceptCode] is the code of the concept to query.
  ///
  /// Returns a DriftQueryRepository for the concept, or throws an exception
  /// if the concept is not found.
  DriftQueryRepository<Entity<dynamic>> forConcept(String conceptCode) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      throw ArgumentError('Concept not found: $conceptCode');
    }
    return DriftQueryRepository<Entity<dynamic>>(database, concept);
  }
}

/// A generic command implementation for the CQRS repository.
///
/// This class provides a simple command implementation that can be used
/// with the EDNetDriftCqrsRepository for common operations.
class GenericCommand implements app.ICommand {
  final String _name;
  final Map<String, dynamic> _parameters = {};
  
  GenericCommand(this._name);
  
  @override
  String get name => _name;
  
  @override
  Map<String, dynamic> getParameters() => Map.unmodifiable(_parameters);
  
  /// Adds a parameter to this command.
  GenericCommand withParameter(String name, dynamic value) {
    _parameters[name] = value;
    return this;
  }
  
  /// Adds multiple parameters to this command.
  GenericCommand withParameters(Map<String, dynamic> parameters) {
    _parameters.addAll(parameters);
    return this;
  }
  
  @override
  List<app.IDomainEvent> getEvents() => [];
  
  @override
  bool doIt() => true;
} 
