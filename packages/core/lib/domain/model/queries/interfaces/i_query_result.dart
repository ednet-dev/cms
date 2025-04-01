/// Represents the result of a query operation in CQRS.
///
/// The [IQueryResult] interface provides a standardized way to handle
/// query results, including support for pagination, metadata, and error handling.
///
/// This interface serves as the foundation for all query result types in the system,
/// providing a clear contract for components that process query results.
abstract class IQueryResult<T> {
  /// Indicates whether the query was successful.
  bool get isSuccess;
  
  /// The result data.
  ///
  /// This will contain the actual query result data when [isSuccess] is true.
  /// It will be null when [isSuccess] is false.
  T? get data;
  
  /// Error message when the query fails.
  ///
  /// This will contain an error message when [isSuccess] is false.
  /// It will be null when [isSuccess] is true.
  String? get errorMessage;
  
  /// Metadata associated with the query result.
  ///
  /// This can include information like total count, pagination details,
  /// execution time, etc.
  Map<String, dynamic> get metadata;
} 