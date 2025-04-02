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

/// Extensions for concept-aware querying with Drift.
extension ConceptQueryExtensions on  EDNetDriftRepository {
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
    final concept = domain.findConcept(conceptCode);
    if (concept == null) {
      throw ArgumentError('Concept not found: $conceptCode');
    }
    return DriftQueryRepository<Entity<dynamic>>(database, concept);
  }
  
  /// Executes a query using the expression builder pattern.
  ///
  /// This method provides a clean way to build and execute complex queries
  /// without manually constructing expression objects.
  ///
  /// [conceptCode] is the code of the concept to query.
  /// [buildQuery] is a function that configures the query builder.
  ///
  /// Returns a Future with the query result.
  Future<EntityQueryResult<Entity<dynamic>>> queryWhere(
    String conceptCode,
    void Function(QueryBuilder builder) buildQuery
  ) async {
    return forConcept(conceptCode).findWhere(buildQuery);
  }
  
  /// Executes a search query with multiple optional filters.
  ///
  /// This method is designed for search screens and advanced filtering
  /// scenarios, handling all the common filtering patterns.
  ///
  /// Parameters:
  /// - [conceptCode]: The concept to query
  /// - [searchText]: Optional text to search for in text fields
  /// - [filters]: Optional attribute filters
  /// - [sort]: Optional field to sort by
  /// - [sortDirection]: Optional sort direction
  /// - [page]: Page number for pagination
  /// - [pageSize]: Page size for pagination
  ///
  /// Returns a Future with the search results.
  Future<EntityQueryResult<Entity<dynamic>>> search({
    required String conceptCode,
    String? searchText,
    Map<String, dynamic>? filters,
    String? sort,
    bool ascending = true,
    int page = 1,
    int pageSize = 20,
  }) async {
    return queryWhere(conceptCode, (builder) {
      // Add text search if provided
      if (searchText != null && searchText.isNotEmpty) {
        // Find text attributes to search
        final concept = domain.findConcept(conceptCode)!;
        final textAttributes = concept.attributes
            .whereType<Attribute>()
            .where((a) => a.type?.code == 'String')
            .toList();
        
        if (textAttributes.isNotEmpty) {
          // Create OR conditions for each text attribute
          var first = true;
          for (final attr in textAttributes) {
            if (first) {
              builder.where(attr.code).contains(searchText);
              first = false;
            } else {
              builder.or(attr.code).contains(searchText);
            }
          }
        }
      }
      
      // Add filters if provided
      if (filters != null && filters.isNotEmpty) {
        filters.forEach((key, value) {
          if (value != null) {
            builder.and(key).equals(value);
          }
        });
      }
      
      // Add sorting if provided
      if (sort != null) {
        builder.orderBy(sort, ascending: ascending);
      }
      
      // Add pagination
      builder.paginate(page, pageSize);
    });
  }
} 
