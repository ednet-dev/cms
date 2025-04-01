/// Represents a query in the CQRS pattern.
///
/// Queries are used to retrieve data from the domain model without causing
/// state changes. This interface serves as the foundation for all query types
/// in the system, enabling clear separation from commands.
///
/// Queries should:
/// - Be named after their intent (e.g., 'FindTasksAssignedToUser')
/// - Return immutable data transfer objects
/// - Not cause side effects
/// - Be optimized for read operations
abstract class IQuery {
  /// The name of the query.
  String get name;
  
  /// Gets the parameters for this query.
  ///
  /// Returns a map of parameter names to their values.
  Map<String, dynamic> getParameters();
  
  /// Creates a string representation of the query.
  ///
  /// This is useful for logging and debugging purposes.
  @override
  String toString() => 'Query: $name, Parameters: ${getParameters()}';
} 