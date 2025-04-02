part of ednet_core;

/// Represents a query in the application layer.
///
/// The [Query] class extends the domain model's query class, adding
/// application-specific functionality while maintaining compatibility with
/// the domain model layer.
///
/// This class serves as the foundation for all application-level queries,
/// providing enhanced features like validation and metadata.
///
/// Example usage:
/// ```dart
/// class FindActiveTasksQuery extends Query {
///   final DateTime cutoffDate;
///
///   FindActiveTasksQuery(this.cutoffDate) : super('FindActiveTasks');
///
///   @override
///   Map<String, dynamic> getParameters() => {
///     'cutoffDate': cutoffDate.toIso8601String(),
///   };
///
///   @override
///   bool validate() => cutoffDate.isAfter(DateTime.now());
/// }
/// ```
class Query extends model.Query implements IQuery {
  /// Metadata associated with this query.
  final Map<String, dynamic> metadata;
  
  /// Creates a new application-level query.
  ///
  /// Parameters:
  /// - [name]: The name of the query
  /// - [conceptCode]: Optional concept code this query targets
  /// - [metadata]: Additional metadata for the query
  Query(
    String name, {
    String? conceptCode,
    this.metadata = const {},
  }) : super(name, conceptCode: conceptCode);
  
  /// Validates the query before execution.
  ///
  /// Override this method to implement specific validation logic
  /// for queries in your application.
  ///
  /// Returns true if the query is valid, false otherwise.
  bool validate() => true;
  
  @override
  Map<String, dynamic> getParameters() => super.getParameters();
}

/// Interface for application-level queries.
///
/// This interface extends the domain model query interface,
/// providing a contract for application-specific query capabilities.
/// 
/// This interface is being maintained for backward compatibility,
/// but future code should prefer using model.IQuery directly.
abstract class IQuery implements model.IQuery {
  /// Validates the query before execution.
  bool validate();
  
  /// Metadata associated with this query.
  Map<String, dynamic> get metadata;
} 