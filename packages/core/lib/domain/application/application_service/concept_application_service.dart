part of application;

import 'package:ednet_core/domain/model.dart' as model;

/// Application service specialized for concept-based operations.
///
/// This class extends the standard [ApplicationService] with capabilities
/// specifically designed for working with concepts, including support for
/// concept-aware queries and validation.
///
/// Type parameters:
/// - [T]: The type of entity this service manages
///
/// Example usage:
/// ```dart
/// final service = ConceptApplicationService<Task>(
///   taskRepository,
///   taskConcept,
///   name: 'TaskService',
///   dependencies: [],
/// );
///
/// // Execute a concept-aware query
/// final result = await service.executeConceptQuery(
///   'FindByStatus',
///   {'status': 'completed'}
/// );
/// ```
class ConceptApplicationService<T extends AggregateRoot> extends ApplicationService<T> {
  /// The concept this service is responsible for.
  final model.Concept concept;
  
  /// Creates a new concept application service.
  ///
  /// Parameters:
  /// - [repository]: Repository for the aggregate type
  /// - [concept]: The concept this service is responsible for
  /// - [name]: Name of the service
  /// - [dependencies]: Other services this one depends on
  /// - [session]: Optional domain session for transaction management
  /// - [queryDispatcher]: Optional query dispatcher for handling queries
  ConceptApplicationService(
    Repository<T> repository,
    this.concept, {
    required String name,
    List<ApplicationService> dependencies = const [],
    IDomainSession? session,
    QueryDispatcher? queryDispatcher,
  }) : super(
    repository,
    name: name,
    dependencies: dependencies,
    session: session,
    queryDispatcher: queryDispatcher,
  );
  
  /// Executes a concept-specific query with the given parameters.
  ///
  /// This method creates a [model.ConceptQuery] from the provided
  /// query name and parameters, then executes it.
  ///
  /// Parameters:
  /// - [queryName]: The name of the query to execute
  /// - [parameters]: Optional parameters for the query
  ///
  /// Returns:
  /// A Future with the query result, specialized for entities
  Future<model.EntityQueryResult<T>> executeConceptQuery(
    String queryName, [
    Map<String, dynamic>? parameters,
  ]) async {
    // Create a concept query
    final query = model.ConceptQuery(queryName, concept);
    if (parameters != null) {
      query.withParameters(parameters);
    }
    
    // Validate against concept structure
    if (!query.validate()) {
      return model.EntityQueryResult.failure(
        'Query validation failed: parameters do not match concept structure',
        concept: concept,
      );
    }
    
    try {
      // Try to execute using dispatcher if available
      if (queryDispatcher != null) {
        final result = await queryDispatcher!.dispatch(query);
        
        // If the result is already an EntityQueryResult, return it
        if (result is model.EntityQueryResult<T>) {
          return result;
        }
        
        // Otherwise, if it's a regular QueryResult, convert it
        if (result is model.QueryResult) {
          if (result.isSuccess && result.data is List<T>) {
            return model.EntityQueryResult.success(
              result.data as List<T>,
              concept: concept,
              metadata: result.metadata,
            );
          } else {
            return model.EntityQueryResult.failure(
              result.errorMessage ?? 'Unknown error',
              concept: concept,
              metadata: result.metadata,
            );
          }
        }
        
        // Default fallback if types don't match
        return model.EntityQueryResult.failure(
          'Unexpected result type: ${result.runtimeType}',
          concept: concept,
        );
      } else {
        // If no dispatcher, handle directly using repository
        return await _executeConceptQueryWithRepository(query);
      }
    } catch (e) {
      return model.EntityQueryResult.failure(
        'Error executing query: $e',
        concept: concept,
      );
    }
  }
  
  /// Executes a concept query using the repository directly.
  ///
  /// This is an internal method used when no query dispatcher is available.
  ///
  /// Parameters:
  /// - [query]: The concept query to execute
  ///
  /// Returns:
  /// A Future with the entity query result
  Future<model.EntityQueryResult<T>> _executeConceptQueryWithRepository(
    model.ConceptQuery query
  ) async {
    try {
      // Extract pagination parameters if present
      int? page = query.getParameters()['page'] as int?;
      int? pageSize = query.getParameters()['pageSize'] as int?;
      
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
      
      // Execute the query
      List<T> results;
      int totalCount = 0;
      
      if (page != null && pageSize != null) {
        // Get paginated results
        totalCount = await repository.countByCriteria(criteria);
        results = await repository.findByCriteria(
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
        results = await repository.findByCriteria(criteria);
        return model.EntityQueryResult.success(
          results,
          concept: concept,
        );
      }
    } catch (e) {
      return model.EntityQueryResult.failure(
        'Error executing query with repository: $e',
        concept: concept,
      );
    }
  }
} 