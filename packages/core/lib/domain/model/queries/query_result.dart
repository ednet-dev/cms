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
  
  /// Creates a new query result.
  ///
  /// Parameters:
  /// - [isSuccess]: Whether the query was successful
  /// - [data]: The result data (null if the query failed)
  /// - [errorMessage]: Error message (null if the query succeeded)
  /// - [metadata]: Additional metadata for the result
  QueryResult({
    required this.isSuccess,
    this.data,
    this.errorMessage,
    this.metadata = const {},
  });
  
  /// Creates a successful query result.
  ///
  /// Parameters:
  /// - [data]: The result data
  /// - [metadata]: Additional metadata for the result
  factory QueryResult.success(T data, {Map<String, dynamic> metadata = const {}}) {
    return QueryResult(
      isSuccess: true,
      data: data,
      metadata: metadata,
    );
  }
  
  /// Creates a failed query result.
  ///
  /// Parameters:
  /// - [errorMessage]: The error message
  /// - [metadata]: Additional metadata for the result
  factory QueryResult.failure(String errorMessage, {Map<String, dynamic> metadata = const {}}) {
    return QueryResult(
      isSuccess: false,
      errorMessage: errorMessage,
      metadata: metadata,
    );
  }
  
  /// Creates an empty successful result.
  ///
  /// This is useful for queries that don't return data but need to indicate success.
  ///
  /// Parameters:
  /// - [metadata]: Additional metadata for the result
  factory QueryResult.empty({Map<String, dynamic> metadata = const {}}) {
    return QueryResult(
      isSuccess: true,
      metadata: metadata,
    );
  }
} 