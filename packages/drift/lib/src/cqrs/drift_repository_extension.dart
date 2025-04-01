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
    _queryDispatcher = app.QueryDispatcher();
    _restQueryAdapter = RestQueryAdapter();
    
    // Register default handlers for all concepts
    final handlerFactory = DriftQueryHandlerFactory(_db);
    handlerFactory.registerAllConceptHandlers(
      _domain,
      _queryDispatcher,
      (concept) {
        // Create a dynamic repository for the concept
        // This is a simple implementation - in a real app, you might
        // have specialized repositories for different concepts
        return this;
      },
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
    return _queryDispatcher.dispatch(query);
  }
  
  /// Executes a query for the specified concept with parameters.
  ///
  /// This is a convenience method for creating and executing
  /// concept queries with parameters.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept to query
  /// - [queryName]: The name of the query to execute
  /// - [parameters]: Optional parameters for the query
  ///
  /// Returns a Future with the query result
  Future<model.IQueryResult> executeConceptQuery(
    String conceptCode,
    String queryName, [
    Map<String, dynamic>? parameters,
  ]) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return Future.value(
        model.QueryResult.failure('Concept not found: $conceptCode')
      );
    }
    
    final query = model.ConceptQuery(queryName, concept);
    if (parameters != null) {
      query.withParameters(parameters);
    }
    
    return executeQuery(query);
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
  Future<model.IQueryResult> executeRestQuery(
    String conceptCode,
    Map<String, dynamic> params, [
    String queryName = RestQueryAdapter.DEFAULT_QUERY_NAME,
  ]) {
    final concept = _domain.findConcept(conceptCode);
    if (concept == null) {
      return Future.value(
        model.QueryResult.failure('Concept not found: $conceptCode')
      );
    }
    
    final query = _restQueryAdapter.fromRequestParameters(
      concept,
      params,
      queryName,
    );
    
    return executeQuery(query);
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
    // We can't directly access private fields, so this is a workaround
    // In a real implementation, you might want to add factory methods to the
    // original repository class instead
    return EDNetDriftCqrsRepository(
      domain: _domain,
      sqlitePath: '', // This is a limitation of the current implementation
      schemaVersion: _db.schemaVersion,
    );
  }
} 