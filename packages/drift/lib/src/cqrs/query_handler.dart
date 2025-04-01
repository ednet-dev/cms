part of cqrs_drift;

/// Query handler for executing domain model queries against a Drift database.
///
/// This class implements the application layer query handler interface,
/// providing concrete implementation for Drift-specific query execution.
///
/// It delegates the actual query execution to the [DriftQueryAdapter].
///
/// Example usage:
/// ```dart
/// final handler = DriftQueryHandler<Task>(
///   driftDb,
///   taskRepository,
///   taskConcept
/// );
///
/// // Register with query dispatcher
/// dispatcher.registerHandler<FindTasksQuery, EntityQueryResult<Task>>(handler);
/// ```
class DriftQueryHandler<T extends Entity<T>> extends app.ConceptQueryHandler<T> {
  /// The Drift database instance
  final EDNetDriftDatabase _db;
  
  /// The query adapter for translating queries
  final DriftQueryAdapter _queryAdapter;
  
  /// Creates a new query handler for the given database.
  ///
  /// Parameters:
  /// - [db]: The Drift database to execute queries against
  /// - [repository]: Repository for accessing entities
  /// - [concept]: The concept this handler processes queries for
  DriftQueryHandler(
    this._db,
    Repository<T> repository,
    model.Concept concept,
  ) : _queryAdapter = DriftQueryAdapter(_db),
      super(repository, concept);
  
  /// Executes a concept query against the Drift database.
  ///
  /// This method translates the concept query to a Drift query,
  /// executes it, and returns the results.
  ///
  /// Parameters:
  /// - [query]: The concept query to execute
  ///
  /// Returns a Future with the entity query result
  @override
  Future<model.EntityQueryResult<T>> executeConceptQuery(model.ConceptQuery query) async {
    try {
      // Use the query adapter to execute the query
      final result = await _queryAdapter.executeQuery(query);
      
      // Convert the generic result to a typed result
      if (result.isSuccess) {
        // Convert the entities to the correct type
        final typedEntities = result.data!
            .map((e) => e as T)
            .toList();
        
        return model.EntityQueryResult<T>.success(
          typedEntities,
          concept: concept,
          metadata: result.metadata,
        );
      } else {
        return model.EntityQueryResult<T>.failure(
          result.errorMessage ?? 'Unknown error',
          concept: concept,
          metadata: result.metadata,
        );
      }
    } catch (e) {
      return model.EntityQueryResult<T>.failure(
        'Error executing query: $e',
        concept: concept,
      );
    }
  }
}

/// Factory for creating query handlers for Drift database.
///
/// This class provides factory methods for creating different types
/// of query handlers for Drift databases.
class DriftQueryHandlerFactory {
  /// The Drift database instance
  final EDNetDriftDatabase _db;
  
  /// Creates a new query handler factory.
  ///
  /// [db] is the Drift database to create handlers for.
  DriftQueryHandlerFactory(this._db);
  
  /// Creates a query handler for a specific concept and entity type.
  ///
  /// This method uses the provided repository and concept to create
  /// a query handler that can process queries for the specified entity type.
  ///
  /// Type parameters:
  /// - [T]: The type of entity the handler will process
  ///
  /// Parameters:
  /// - [repository]: Repository for accessing entities
  /// - [concept]: The concept the handler will process queries for
  ///
  /// Returns a query handler for the specified entity type
  app.ConceptQueryHandler<T> createHandler<T extends Entity<T>>(
    Repository<T> repository,
    model.Concept concept,
  ) {
    return DriftQueryHandler<T>(_db, repository, concept);
  }
  
  /// Creates a default query handler for a specific concept.
  ///
  /// This method creates a default query handler that supports
  /// standard query operations for the specified concept.
  ///
  /// Type parameters:
  /// - [T]: The type of entity the handler will process
  ///
  /// Parameters:
  /// - [repository]: Repository for accessing entities
  /// - [concept]: The concept the handler will process queries for
  ///
  /// Returns a default query handler for the specified concept
  app.DefaultConceptQueryHandler<T> createDefaultHandler<T extends Entity<T>>(
    Repository<T> repository,
    model.Concept concept,
  ) {
    return app.DefaultConceptQueryHandler<T>(repository, concept);
  }
  
  /// Registers all concept handlers for the specified domain.
  ///
  /// This method creates and registers query handlers for all concepts
  /// in the domain with the provided dispatcher.
  ///
  /// Parameters:
  /// - [domain]: The domain containing concepts to register handlers for
  /// - [dispatcher]: The query dispatcher to register handlers with
  /// - [repositoryFactory]: Factory function for creating repositories
  ///
  /// Returns the number of handlers registered
  int registerAllConceptHandlers(
    Domain domain,
    app.QueryDispatcher dispatcher,
    Repository<Entity<dynamic>> Function(model.Concept) repositoryFactory,
  ) {
    int count = 0;
    
    // For each concept in the domain
    for (final concept in domain.concepts) {
      // Create a repository for the concept
      final repository = repositoryFactory(concept);
      
      // Create a query handler for the concept
      final handler = DriftQueryHandler<Entity<dynamic>>(
        _db,
        repository,
        concept,
      );
      
      // Register standard queries with the dispatcher
      dispatcher.registerConceptHandler(
        concept.code,
        app.DefaultConceptQueryHandler.FIND_ALL,
        handler,
      );
      
      dispatcher.registerConceptHandler(
        concept.code,
        app.DefaultConceptQueryHandler.FIND_BY_ID,
        handler,
      );
      
      dispatcher.registerConceptHandler(
        concept.code,
        app.DefaultConceptQueryHandler.FIND_BY_CRITERIA,
        handler,
      );
      
      count += 3;
    }
    
    return count;
  }
} 