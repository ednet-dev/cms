// part of ednet_core;
//
// /// Represents the result of a query operation in the application layer.
// ///
// /// The [QueryResult] class extends the domain model's query result class,
// /// providing application-specific enhancements like pagination, filtering,
// /// and performance metrics.
// ///
// /// Example usage:
// /// ```dart
// /// // Create a successful result with pagination metadata
// /// final tasks = await repository.findByCriteria(criteria);
// /// return QueryResult.success(
// ///   tasks,
// ///   metadata: {
// ///     'totalCount': await repository.countByCriteria(criteria),
// ///     'page': page,
// ///     'pageSize': pageSize,
// ///     'executionTimeMs': stopwatch.elapsedMilliseconds,
// ///   }
// /// );
// /// ```
// class QueryResult<T> extends model.QueryResult<T> implements IQueryResult<T> {+
//   /// Creates a new query result.
//   ///
//   /// Parameters:
//   /// - [isSuccess]: Whether the query was successful
//   /// - [data]: The result data (null if the query failed)
//   /// - [errorMessage]: Error message (null if the query succeeded)
//   /// - [metadata]: Additional metadata for the result
//   QueryResult({
//     required bool isSuccess,
//     T? data,
//     String? errorMessage,
//     Map<String, dynamic> metadata = const {},
//   }) : super(
//     isSuccess: isSuccess,
//     data: data,
//     errorMessage: errorMessage,
//     metadata: metadata,
//   );
//
//   /// Creates a successful query result.
//   ///
//   /// Parameters:
//   /// - [data]: The result data
//   /// - [metadata]: Additional metadata for the result
//   factory QueryResult.success(T data, {Map<String, dynamic> metadata = const {}}) {
//     return QueryResult(
//       isSuccess: true,
//       data: data,
//       metadata: metadata,
//     );
//   }
//
//   /// Creates a failed query result.
//   ///
//   /// Parameters:
//   /// - [errorMessage]: The error message
//   /// - [metadata]: Additional metadata for the result
//   factory QueryResult.failure(String errorMessage, {Map<String, dynamic> metadata = const {}}) {
//     return QueryResult(
//       isSuccess: false,
//       errorMessage: errorMessage,
//       metadata: metadata,
//     );
//   }
//
//   /// Creates an empty successful result.
//   ///
//   /// This is useful for queries that don't return data but need to indicate success.
//   ///
//   /// Parameters:
//   /// - [metadata]: Additional metadata for the result
//   factory QueryResult.empty({Map<String, dynamic> metadata = const {}}) {
//     return QueryResult(
//       isSuccess: true,
//       metadata: metadata,
//     );
//   }
//
//   /// Adds pagination metadata to the result.
//   ///
//   /// Parameters:
//   /// - [page]: The current page number
//   /// - [pageSize]: The number of items per page
//   /// - [totalCount]: The total number of items
//   ///
//   /// Returns:
//   /// A new query result with updated metadata
//   QueryResult<T> withPagination({
//     required int page,
//     required int pageSize,
//     required int totalCount,
//   }) {
//     final newMetadata = Map<String, dynamic>.from(metadata)
//       ..addAll({
//         'page': page,
//         'pageSize': pageSize,
//         'totalCount': totalCount,
//         'totalPages': (totalCount / pageSize).ceil(),
//       });
//
//     return QueryResult(
//       isSuccess: isSuccess,
//       data: data,
//       errorMessage: errorMessage,
//       metadata: newMetadata,
//     );
//   }
// }
//
// /// Interface for application-level query results.
// ///
// /// This interface extends the domain model query result interface,
// /// providing a contract for application-specific result capabilities.
// abstract class IQueryResult<T> implements model.IQueryResult<T> {
//   /// Creates a new query result with updated pagination information.
//   ///
//   /// Parameters:
//   /// - [page]: The current page number
//   /// - [pageSize]: The number of items per page
//   /// - [totalCount]: The total number of items
//   ///
//   /// Returns:
//   /// A new query result with updated metadata
//   IQueryResult<T> withPagination({
//     required int page,
//     required int pageSize,
//     required int totalCount,
//   });
// }