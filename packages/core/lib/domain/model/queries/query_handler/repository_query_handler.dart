// part of ednet_core;
//
// /// Query handler that works directly with repositories.
// ///
// /// This handler simplifies common query operations against a repository,
// /// providing standard implementations for common query patterns.
// ///
// /// Type parameters:
// /// - [T]: The entity type this handler works with
// /// - [Q]: The query type this handler processes
// /// - [R]: The result type this handler returns
// ///
// /// Example usage:
// /// ```dart
// /// final handler = RepositoryQueryHandler<Task, FindTasksQuery, EntityQueryResult<Task>>(
// ///   taskRepository,
// ///   buildCriteria: (query) => FilterCriteria<Task>()
// ///     ..addCriterion(Criterion('status', query.status))
// /// );
// ///
// /// queryDispatcher.registerHandler<FindTasksQuery, EntityQueryResult<Task>>(handler);
// /// ```
// class RepositoryQueryHandler<T extends Entity, Q extends IQuery, R extends model.EntityQueryResult<T>>
//     extends ApplicationQueryHandler<Q, R> {
//   /// The repository this handler queries.
//   final Repository<T> repository;
//
//   /// Function to build criteria from a query.
//   final FilterCriteria<T> Function(Q query)? buildCriteria;
//
//   /// Function to transform repository results before returning.
//   final List<T> Function(List<T> results, Q query)? transformResults;
//
//   /// Function to extract pagination parameters from a query.
//   final Map<String, dynamic>? Function(Q query)? extractPagination;
//
//   /// Function to extract sorting parameters from a query.
//   final Map<String, dynamic>? Function(Q query)? extractSorting;
//
//   /// The concept this handler is associated with.
//   final model.Concept? concept;
//
//   /// Creates a new repository query handler.
//   ///
//   /// Parameters:
//   /// - [repository]: The repository to query
//   /// - [buildCriteria]: Optional function to build criteria from a query
//   /// - [transformResults]: Optional function to transform results
//   /// - [extractPagination]: Optional function to extract pagination parameters
//   /// - [extractSorting]: Optional function to extract sorting parameters
//   /// - [concept]: Optional concept this handler is associated with
//   RepositoryQueryHandler(
//     this.repository, {
//     this.buildCriteria,
//     this.transformResults,
//     this.extractPagination,
//     this.extractSorting,
//     this.concept,
//   });
//
//   @override
//   Future<R> processQuery(Q query) async {
//     try {
//       // Build criteria if a builder is provided
//       FilterCriteria<T>? criteria;
//       if (buildCriteria != null) {
//         criteria = buildCriteria!(query);
//       } else {
//         // Default to empty criteria
//         criteria = FilterCriteria<T>();
//
//         // If query has parameters, try to use them
//         if (query is model.Query) {
//           // Apply filters from query parameters
//           for (var entry in query.getParameters().entries) {
//             final key = entry.key;
//             final value = entry.value;
//
//             // Skip standard parameters
//             if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
//               continue;
//             }
//
//             // Add criterion for this parameter
//             criteria.addCriterion(model.Criterion(key, value));
//           }
//         }
//       }
//
//       // Extract pagination parameters
//       int? page;
//       int? pageSize;
//
//       if (extractPagination != null) {
//         final pagination = extractPagination!(query);
//         if (pagination != null) {
//           page = pagination['page'] as int?;
//           pageSize = pagination['pageSize'] as int?;
//         }
//       } else if (query is model.Query) {
//         // Try to get pagination from query parameters
//         page = query.getParameters()['page'] as int?;
//         pageSize = query.getParameters()['pageSize'] as int?;
//       }
//
//       // Extract sorting parameters
//       String? sortBy;
//       bool? ascending;
//
//       if (extractSorting != null) {
//         final sorting = extractSorting!(query);
//         if (sorting != null) {
//           sortBy = sorting['sortBy'] as String?;
//           final sortDirection = sorting['sortDirection'] as String?;
//           if (sortBy != null) {
//             ascending = sortDirection != 'desc';
//           }
//         }
//       } else if (query is model.Query) {
//         // Try to get sorting from query parameters
//         sortBy = query.getParameters()['sortBy'] as String?;
//         final sortDirection = query.getParameters()['sortDirection'] as String?;
//         if (sortBy != null) {
//           ascending = sortDirection != 'desc';
//         }
//       }
//
//       // Apply sorting if specified
//       if (sortBy != null && ascending != null) {
//         criteria.orderBy(sortBy, ascending: ascending);
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
//       } else {
//         // Get all results
//         results = await repository.findByCriteria(criteria);
//         totalCount = results.length;
//       }
//
//       // Transform results if a transformer is provided
//       if (transformResults != null) {
//         results = transformResults!(results, query);
//       }
//
//       // Create metadata
//       final metadata = <String, dynamic>{};
//
//       if (page != null && pageSize != null) {
//         metadata['page'] = page;
//         metadata['pageSize'] = pageSize;
//         metadata['totalCount'] = totalCount;
//       }
//
//       // Create success result
//       // This is a bit complex due to type erasure in Dart
//       dynamic result;
//
//       // Create the appropriate result type
//       if (R == model.EntityQueryResult<T>) {
//         result = model.EntityQueryResult<T>.success(
//           results,
//           concept: concept,
//           conceptCode: concept?.code,
//           metadata: metadata,
//         );
//       } else if (R == model.QueryResult) {
//         result = model.QueryResult.success(
//           results,
//           conceptCode: concept?.code,
//           metadata: metadata,
//         );
//       } else {
//         throw StateError('Cannot create success result for type $R');
//       }
//
//       return result as R;
//     } catch (e) {
//       // Create failure result
//       dynamic result;
//
//       if (R == model.EntityQueryResult<T>) {
//         result = model.EntityQueryResult<T>.failure(
//           'Error processing query: $e',
//           concept: concept,
//           conceptCode: concept?.code,
//         );
//       } else if (R == model.QueryResult) {
//         result = model.QueryResult.failure(
//           'Error processing query: $e',
//           conceptCode: concept?.code,
//         );
//       } else {
//         throw StateError('Cannot create failure result for type $R');
//       }
//
//       return result as R;
//     }
//   }
// }