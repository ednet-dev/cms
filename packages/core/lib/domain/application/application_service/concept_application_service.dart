// part of ednet_core;
//
// /// Application service specialized for concept-based operations.
// ///
// /// This class extends the standard [ApplicationService] with capabilities
// /// specifically designed for working with concepts, including support for
// /// concept-aware queries and validation.
// ///
// /// Type parameters:
// /// - [T]: The type of entity this service manages
// ///
// /// Example usage:
// /// ```dart
// /// final service = ConceptApplicationService<Task>(
// ///   taskRepository,
// ///   taskConcept,
// ///   name: 'TaskService',
// ///   dependencies: [],
// /// );
// ///
// /// // Execute a concept-aware query
// /// final result = await service.executeConceptQuery(
// ///   'FindByStatus',
// ///   {'status': 'completed'}
// /// );
// /// ```
// class ConceptApplicationService<T extends AggregateRoot> extends ApplicationService<T> {
//   /// The concept this service is responsible for.
//   final model.Concept concept;
//
//   /// Creates a new concept application service.
//   ///
//   /// Parameters:
//   /// - [repository]: Repository for the aggregate type
//   /// - [concept]: The concept this service is responsible for
//   /// - [name]: Name of the service
//   /// - [dependencies]: Other services this one depends on
//   /// - [session]: Optional domain session for transaction management
//   /// - [queryDispatcher]: Optional query dispatcher for handling queries
//   ConceptApplicationService(
//     Repository<T> repository,
//     this.concept, {
//     required String name,
//     List<ApplicationService> dependencies = const [],
//     IDomainSession? session,
//     QueryDispatcher? queryDispatcher,
//   }) : super(
//     repository,
//     name: name,
//     dependencies: dependencies,
//     session: session,
//     queryDispatcher: queryDispatcher,
//   ) {
//     _validateConcept();
//   }
//
//   /// Validates that the concept is compatible with the service.
//   void _validateConcept() {
//     if (concept == null) {
//       throw ArgumentError('Concept cannot be null');
//     }
//
//     if (!concept.isValid) {
//       throw ArgumentError('Invalid concept: ${concept.name}');
//     }
//
//     // Verify that the concept's type matches the service's type parameter
//     if (T != concept.type) {
//       throw ArgumentError(
//         'Concept type mismatch: Expected ${T.toString()}, got ${concept.type.toString()}',
//       );
//     }
//   }
//
//   /// Executes a concept-specific query with the given parameters.
//   ///
//   /// This method creates a [model.ConceptQuery] from the provided
//   /// query name and parameters, then executes it using the unified query
//   /// dispatcher.
//   ///
//   /// Parameters:
//   /// - [queryName]: The name of the query to execute
//   /// - [parameters]: Optional parameters for the query
//   ///
//   /// Returns:
//   /// A Future with the query result, specialized for entities
//   Future<model.EntityQueryResult<T>> executeConceptQuery(
//     String queryName, [
//     Map<String, dynamic>? parameters,
//   ]) async {
//     if (queryName.isEmpty) {
//       return model.EntityQueryResult.failure(
//         'Query name cannot be empty',
//         concept: concept,
//       );
//     }
//
//     try {
//       // Create a concept query
//       final query = model.ConceptQuery(queryName, concept);
//       if (parameters != null) {
//         query.withParameters(parameters);
//       }
//
//       // Validate against concept structure
//       if (!query.validate()) {
//         return model.EntityQueryResult.failure(
//           'Query validation failed: parameters do not match concept structure',
//           concept: concept,
//         );
//       }
//
//       // Try to execute using dispatcher if available
//       if (queryDispatcher != null) {
//         final result = await queryDispatcher!.dispatch(query);
//
//         // If the result is already an EntityQueryResult, return it
//         if (result is model.EntityQueryResult<T>) {
//           return result;
//         }
//
//         // Otherwise, if it's a regular QueryResult, convert it
//         if (result is model.QueryResult) {
//           if (result.isSuccess && result.data is List<T>) {
//             return model.EntityQueryResult.success(
//               result.data as List<T>,
//               concept: concept,
//               metadata: result.metadata,
//             );
//           } else {
//             return model.EntityQueryResult.failure(
//               result.errorMessage ?? 'Unknown error',
//               concept: concept,
//               metadata: result.metadata,
//             );
//           }
//         }
//
//         // Default fallback if types don't match
//         return model.EntityQueryResult.failure(
//           'Unexpected result type: ${result.runtimeType}',
//           concept: concept,
//         );
//       } else {
//         // If no dispatcher, handle directly using repository
//         return await _executeConceptQueryWithRepository(query);
//       }
//     } catch (e, stackTrace) {
//       return model.EntityQueryResult.failure(
//         'Error executing query: $e\n$stackTrace',
//         concept: concept,
//       );
//     }
//   }
//
//   /// Creates and executes an expression-based concept query.
//   ///
//   /// This method provides a more powerful way to query entities using
//   /// the expression query system, which supports complex filtering and
//   /// traversal operations.
//   ///
//   /// Parameters:
//   /// - [queryName]: The name of the query to execute
//   /// - [expression]: The query expression to apply
//   /// - [pagination]: Optional pagination parameters
//   /// - [sorting]: Optional sorting parameters
//   ///
//   /// Returns:
//   /// A Future with the query result, specialized for entities
//   Future<model.EntityQueryResult<T>> executeExpressionQuery(
//     String queryName,
//     model.QueryExpression expression, {
//     Map<String, dynamic>? pagination,
//     Map<String, dynamic>? sorting,
//   }) async {
//     if (queryName.isEmpty) {
//       return model.EntityQueryResult.failure(
//         'Query name cannot be empty',
//         concept: concept,
//       );
//     }
//
//     if (expression == null) {
//       return model.EntityQueryResult.failure(
//         'Expression cannot be null',
//         concept: concept,
//       );
//     }
//
//     try {
//       // Create an expression query
//       final query = model.ExpressionQuery(queryName, concept, expression);
//
//       // Add pagination if specified
//       if (pagination != null) {
//         int? page = pagination['page'] as int?;
//         int? pageSize = pagination['pageSize'] as int?;
//
//         if (page != null && pageSize != null) {
//           if (page < 1 || pageSize < 1) {
//             return model.EntityQueryResult.failure(
//               'Invalid pagination parameters: page and pageSize must be positive',
//               concept: concept,
//             );
//           }
//           query.withParameters({
//             'page': page,
//             'pageSize': pageSize,
//           });
//         }
//       }
//
//       // Add sorting if specified
//       if (sorting != null) {
//         String? sortBy = sorting['sortBy'] as String?;
//         String? sortDirection = sorting['sortDirection'] as String?;
//
//         if (sortBy != null) {
//           // Validate sort field exists in concept
//           if (!concept.hasAttribute(sortBy)) {
//             return model.EntityQueryResult.failure(
//               'Invalid sort field: $sortBy does not exist in concept',
//               concept: concept,
//             );
//           }
//
//           query.withParameters({
//             'sortBy': sortBy,
//             'sortDirection': sortDirection ?? 'asc',
//           });
//         }
//       }
//
//       // Try to execute using dispatcher if available
//       if (queryDispatcher != null) {
//         final result = await queryDispatcher!.dispatch(query);
//
//         // If the result is already an EntityQueryResult, return it
//         if (result is model.EntityQueryResult<T>) {
//           return result;
//         }
//
//         // Default fallback if types don't match
//         return model.EntityQueryResult.failure(
//           'Unexpected result type: ${result.runtimeType}',
//           concept: concept,
//         );
//       } else {
//         // If no dispatcher is available, handle directly
//         return model.EntityQueryResult.failure(
//           'No query dispatcher available to execute expression query',
//           concept: concept,
//         );
//       }
//     } catch (e, stackTrace) {
//       return model.EntityQueryResult.failure(
//         'Error executing expression query: $e\n$stackTrace',
//         concept: concept,
//       );
//     }
//   }
//
//   /// Executes a concept query using the repository directly.
//   ///
//   /// This is an internal method used when no query dispatcher is available.
//   ///
//   /// Parameters:
//   /// - [query]: The concept query to execute
//   ///
//   /// Returns:
//   /// A Future with the entity query result
//   Future<model.EntityQueryResult<T>> _executeConceptQueryWithRepository(
//     model.ConceptQuery query
//   ) async {
//     try {
//       // Extract pagination parameters if present
//       int? page = query.getParameters()['page'] as int?;
//       int? pageSize = query.getParameters()['pageSize'] as int?;
//
//       // Validate pagination parameters
//       if (page != null && pageSize != null) {
//         if (page < 1 || pageSize < 1) {
//           return model.EntityQueryResult.failure(
//             'Invalid pagination parameters: page and pageSize must be positive',
//             concept: concept,
//           );
//         }
//       }
//
//       // Create criteria from query parameters
//       final criteria = model.FilterCriteria<T>();
//
//       // Apply filters from query parameters
//       for (var entry in query.getParameters().entries) {
//         final key = entry.key;
//         final value = entry.value;
//
//         // Skip pagination and sorting parameters
//         if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
//           continue;
//         }
//
//         // Validate attribute exists in concept
//         if (!concept.hasAttribute(key)) {
//           return model.EntityQueryResult.failure(
//             'Invalid filter field: $key does not exist in concept',
//             concept: concept,
//           );
//         }
//
//         // Add criterion for this attribute
//         criteria.addCriterion(model.Criterion(key, value));
//       }
//
//       // Apply sorting if specified
//       final sortBy = query.getParameters()['sortBy'] as String?;
//       final sortDirection = query.getParameters()['sortDirection'] as String?;
//
//       if (sortBy != null) {
//         // Validate sort field exists in concept
//         if (!concept.hasAttribute(sortBy)) {
//           return model.EntityQueryResult.failure(
//             'Invalid sort field: $sortBy does not exist in concept',
//             concept: concept,
//           );
//         }
//
//         criteria.orderBy(
//           sortBy,
//           ascending: sortDirection != 'desc',
//         );
//       }
//
//       // Execute the query
//       List<T> results;
//       int totalCount = 0;
//
//       if (page != null && pageSize != null) {
//         // Get paginated results
//         totalCount = await repository.countByCriteria(criteria);
//         results = await repository.findByCriteria(
//           criteria,
//           skip: (page - 1) * pageSize,
//           take: pageSize,
//         );
//
//         return model.EntityQueryResult.success(
//           results,
//           concept: concept,
//           metadata: {
//             'page': page,
//             'pageSize': pageSize,
//             'totalCount': totalCount,
//             'totalPages': (totalCount / pageSize).ceil(),
//           },
//         );
//       } else {
//         // Get all results
//         results = await repository.findByCriteria(criteria);
//         return model.EntityQueryResult.success(
//           results,
//           concept: concept,
//         );
//       }
//     } catch (e, stackTrace) {
//       return model.EntityQueryResult.failure(
//         'Error executing query with repository: $e\n$stackTrace',
//         concept: concept,
//       );
//     }
//   }
//
//   /// Validates that a given attribute exists in the concept.
//   ///
//   /// Parameters:
//   /// - [attributeName]: The name of the attribute to validate
//   ///
//   /// Returns:
//   /// True if the attribute exists, false otherwise
//   bool hasAttribute(String attributeName) {
//     return concept.hasAttribute(attributeName);
//   }
//
//   /// Gets the type of a given attribute in the concept.
//   ///
//   /// Parameters:
//   /// - [attributeName]: The name of the attribute
//   ///
//   /// Returns:
//   /// The type of the attribute, or null if it doesn't exist
//   Type? getAttributeType(String attributeName) {
//     return concept.getAttributeType(attributeName);
//   }
// }