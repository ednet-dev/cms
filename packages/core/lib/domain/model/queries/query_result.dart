import 'interfaces/i_query_result.dart';

/// Implementation of the [IQueryResult] interface.
///
/// This class provides a standard implementation of query results,
/// supporting success/failure status, data payloads, and result metadata.
///
/// Example usage:
/// ```dart
/// // Success result with data
/// final successResult = QueryResult.success(
///   tasks,
///   metadata: {'totalCount': 42, 'page': 1}
/// );
///
/// // Failure result with error message
/// final failureResult = QueryResult.failure('Tasks not found');
/// ```
class QueryResult<T> implements IQueryResult<T> {
  @override
  final bool isSuccess;
  
  @override
  final T? data;
  
  @override
  final String? errorMessage;
  
  @override
  final Map<String, dynamic> metadata;
  
  @override
  final String? conceptCode;
  
  /// Creates a new query result.
  ///
  /// Parameters:
  /// - [isSuccess]: Whether the query was successful
  /// - [data]: The result data (null if the query failed)
  /// - [errorMessage]: Error message (null if the query succeeded)
  /// - [metadata]: Additional metadata for the result
  /// - [conceptCode]: Optional code of the concept related to this result
  QueryResult({
    required this.isSuccess,
    this.data,
    this.errorMessage,
    this.metadata = const {},
    this.conceptCode,
  });
  
  /// Creates a successful query result.
  ///
  /// Parameters:
  /// - [data]: The result data
  /// - [metadata]: Additional metadata for the result
  /// - [conceptCode]: Optional code of the concept related to this result
  factory QueryResult.success(T data, {
    Map<String, dynamic> metadata = const {},
    String? conceptCode,
  }) {
    return QueryResult(
      isSuccess: true,
      data: data,
      metadata: metadata,
      conceptCode: conceptCode,
    );
  }
  
  /// Creates a failed query result.
  ///
  /// Parameters:
  /// - [errorMessage]: The error message
  /// - [metadata]: Additional metadata for the result
  /// - [conceptCode]: Optional code of the concept related to this result
  factory QueryResult.failure(String errorMessage, {
    Map<String, dynamic> metadata = const {},
    String? conceptCode,
  }) {
    return QueryResult(
      isSuccess: false,
      errorMessage: errorMessage,
      metadata: metadata,
      conceptCode: conceptCode,
    );
  }
  
  /// Creates an empty successful result.
  ///
  /// This is useful for queries that don't return data but need to indicate success.
  ///
  /// Parameters:
  /// - [metadata]: Additional metadata for the result
  /// - [conceptCode]: Optional code of the concept related to this result
  factory QueryResult.empty({
    Map<String, dynamic> metadata = const {},
    String? conceptCode,
  }) {
    return QueryResult(
      isSuccess: true,
      metadata: metadata,
      conceptCode: conceptCode,
    );
  }
  
  /// Creates a new result with updated pagination information.
  ///
  /// Parameters:
  /// - [page]: The current page number
  /// - [pageSize]: The number of items per page
  /// - [totalCount]: The total number of items
  ///
  /// Returns a new query result with updated metadata
  QueryResult<T> withPagination({
    required int page,
    required int pageSize,
    required int totalCount,
  }) {
    final newMetadata = Map<String, dynamic>.from(metadata)
      ..addAll({
        'page': page,
        'pageSize': pageSize,
        'totalCount': totalCount,
        'totalPages': (totalCount / pageSize).ceil(),
      });
    
    return QueryResult(
      isSuccess: isSuccess,
      data: data,
      errorMessage: errorMessage,
      metadata: newMetadata,
      conceptCode: conceptCode,
    );
  }
} 