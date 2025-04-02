part of ednet_core;

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
  
  /// The concept code related to this query result, if applicable.
  ///
  /// This is used to identify which concept's entities are being returned
  /// or processed in this result.
  String? get conceptCode;
  
  /// Indicates whether this result contains pagination information.
  ///
  /// Returns true if the metadata contains standard pagination fields.
  bool get isPaginated {
    return metadata.containsKey('page') && 
           metadata.containsKey('pageSize') && 
           metadata.containsKey('totalCount');
  }
  
  /// Gets the total number of items available across all pages.
  ///
  /// This is only available when the result is paginated.
  /// Returns the total count or null if pagination information is not available.
  int? get totalCount {
    return isPaginated ? metadata['totalCount'] as int? : null;
  }
  
  /// Gets the current page number.
  ///
  /// This is only available when the result is paginated.
  /// Returns the current page or null if pagination information is not available.
  int? get page {
    return isPaginated ? metadata['page'] as int? : null;
  }
  
  /// Gets the number of items per page.
  ///
  /// This is only available when the result is paginated.
  /// Returns the page size or null if pagination information is not available.
  int? get pageSize {
    return isPaginated ? metadata['pageSize'] as int? : null;
  }
} 