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
  
  /// The concept code this query targets, if applicable.
  /// 
  /// This enables concept-specific query handling and validation.
  /// If null, the query is not specific to a single concept.
  String? get conceptCode;
  
  /// Gets the parameters for this query.
  ///
  /// Returns a map of parameter names to their values.
  Map<String, dynamic> getParameters();
  
  /// Indicates if this query targets the specified concept.
  /// 
  /// This can be used for routing queries to the appropriate handlers
  /// based on concept metadata.
  /// 
  /// [code] is the concept code to check against.
  /// Returns true if this query targets the specified concept.
  bool forConcept(String code) {
    return conceptCode == code;
  }
  
  /// Creates a string representation of the query.
  ///
  /// This is useful for logging and debugging purposes.
  @override
  String toString() {
    String base = 'Query: $name, Parameters: ${getParameters()}';
    if (conceptCode != null) {
      base += ', Concept: $conceptCode';
    }
    return base;
  }
} 