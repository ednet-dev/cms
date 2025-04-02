part of ednet_core;

/// Standard implementation of a concept query handler that supports common queries.
///
/// This class extends [ConceptQueryHandler] with implementations of
/// standard query operations like findAll, findById, and findByCriteria.
///
/// Type parameters:
/// - [T]: The type of entity being queried
///
/// Example usage:
/// ```dart
/// final handler = DefaultConceptQueryHandler<Task>(
///   taskRepository,
///   taskConcept,
/// );
///
/// // Register with query dispatcher
/// dispatcher.registerConceptHandler<model.ConceptQuery, model.EntityQueryResult<Task>>(
///   'Task',
///   'FindAll',
///   handler
/// );
/// ```
class DefaultConceptQueryHandler<T extends AggregateRoot> extends ConceptQueryHandler<T> {
  /// Standard query names supported by this handler
  static const String FIND_ALL = 'FindAll';
  static const String FIND_BY_ID = 'FindById';
  static const String FIND_BY_CRITERIA = 'FindByCriteria';
  
  /// Creates a new default concept query handler.
  ///
  /// Parameters:
  /// - [repository]: Repository for accessing entities
  /// - [concept]: The concept this handler processes queries for
  DefaultConceptQueryHandler(
    Repository<T> repository,
    model.Concept concept,
  ) : super(repository, concept);
  
  /// Executes a concept query, dispatching to the appropriate method
  /// based on the query name.
  ///
  /// Supports the following standard queries:
  /// - FindAll: Returns all entities
  /// - FindById: Returns a single entity by ID
  /// - FindByCriteria: Returns entities matching criteria derived from parameters
  ///
  /// Parameters:
  /// - [query]: The concept query to execute
  ///
  /// Returns a Future with the entity query result
  @override
  Future<model.EntityQueryResult<T>> executeConceptQuery(model.ConceptQuery query) async {
    switch (query.name) {
      case FIND_ALL:
        return _handleFindAll(query);
      case FIND_BY_ID:
        return _handleFindById(query);
      case FIND_BY_CRITERIA:
        return _handleFindByCriteria(query);
      default:
        return model.EntityQueryResult.failure(
          'Unsupported query name: ${query.name}',
          concept: concept,
        );
    }
  }
  
  /// Handles the FindAll query.
  ///
  /// Returns all entities of this concept, with optional pagination.
  ///
  /// Parameters:
  /// - [query]: The query containing pagination parameters
  ///
  /// Returns a Future with the entity query result
  Future<model.EntityQueryResult<T>> _handleFindAll(model.ConceptQuery query) async {
    try {
      // Extract pagination parameters if present
      final page = query.getParameters()['page'] as int?;
      final pageSize = query.getParameters()['pageSize'] as int?;
      
      if (page != null && pageSize != null) {
        // Get count for pagination
        final totalCount = await repository.count();
        
        // Get paginated results
        final results = await repository.findAll(
          skip: (page - 1) * pageSize,
          take: pageSize,
        );
        
        return model.EntityQueryResult.success(
          results,
          concept: concept,
          metadata: {
            'page': page,
            'pageSize': pageSize,
            'totalCount': totalCount,
          },
        );
      } else {
        // Get all results
        final results = await repository.findAll();
        return model.EntityQueryResult.success(
          results,
          concept: concept,
        );
      }
    } catch (e) {
      return model.EntityQueryResult.failure(
        'Error executing FindAll query: $e',
        concept: concept,
      );
    }
  }
  
  /// Handles the FindById query.
  ///
  /// Returns a single entity by ID.
  ///
  /// Parameters:
  /// - [query]: The query containing the ID parameter
  ///
  /// Returns a Future with the entity query result
  Future<model.EntityQueryResult<T>> _handleFindById(model.ConceptQuery query) async {
    try {
      // Get the ID parameter
      final id = query.getParameters()['id'];
      if (id == null) {
        return model.EntityQueryResult.failure(
          'Missing required parameter: id',
          concept: concept,
        );
      }
      
      // Find the entity
      final entity = await repository.findById(id);
      if (entity == null) {
        return model.EntityQueryResult.failure(
          'Entity not found with id: $id',
          concept: concept,
        );
      }
      
      return model.EntityQueryResult.success(
        [entity],
        concept: concept,
      );
    } catch (e) {
      return model.EntityQueryResult.failure(
        'Error executing FindById query: $e',
        concept: concept,
      );
    }
  }
  
  /// Handles the FindByCriteria query.
  ///
  /// Returns entities matching criteria derived from query parameters.
  ///
  /// Parameters:
  /// - [query]: The query containing filter parameters
  ///
  /// Returns a Future with the entity query result
  Future<model.EntityQueryResult<T>> _handleFindByCriteria(model.ConceptQuery query) async {
    try {
      // Extract pagination parameters if present
      final page = query.getParameters()['page'] as int?;
      final pageSize = query.getParameters()['pageSize'] as int?;
      
      // Create criteria from query parameters
      final criteria = model.FilterCriteria<T>();
      
      // Apply filters from query parameters
      for (var entry in query.getParameters().entries) {
        final key = entry.key;
        final value = entry.value;
        
        // Skip pagination and sorting parameters
        if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
          continue;
        }
        
        // Add criterion for this attribute
        criteria.addCriterion(model.Criterion(key, value));
      }
      
      // Apply sorting if specified
      final sortBy = query.getParameters()['sortBy'] as String?;
      final sortDirection = query.getParameters()['sortDirection'] as String?;
      
      if (sortBy != null) {
        criteria.orderBy(
          sortBy,
          ascending: sortDirection != 'desc',
        );
      }
      
      if (page != null && pageSize != null) {
        // Get count for pagination
        final totalCount = await repository.countByCriteria(criteria);
        
        // Get paginated results
        final results = await repository.findByCriteria(
          criteria,
          skip: (page - 1) * pageSize,
          take: pageSize,
        );
        
        return model.EntityQueryResult.success(
          results,
          concept: concept,
          metadata: {
            'page': page,
            'pageSize': pageSize,
            'totalCount': totalCount,
          },
        );
      } else {
        // Get all results
        final results = await repository.findByCriteria(criteria);
        return model.EntityQueryResult.success(
          results,
          concept: concept,
        );
      }
    } catch (e) {
      return model.EntityQueryResult.failure(
        'Error executing FindByCriteria query: $e',
        concept: concept,
      );
    }
  }
} 