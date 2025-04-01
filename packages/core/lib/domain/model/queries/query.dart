import 'interfaces/i_query.dart';

/// Base implementation of the [IQuery] interface.
///
/// This class provides a common foundation for all queries in the system,
/// handling basic query functionality like name and parameter management.
///
/// Example usage:
/// ```dart
/// class FindTasksByStatusQuery extends Query {
///   final String status;
///
///   FindTasksByStatusQuery(this.status) : super('FindTasksByStatus');
///
///   @override
///   Map<String, dynamic> getParameters() => {'status': status};
/// }
/// ```
class Query implements IQuery {
  @override
  final String name;
  
  @override
  final String? conceptCode;
  
  /// Parameters for this query.
  final Map<String, dynamic> _parameters = {};
  
  /// Creates a new query with the specified name.
  ///
  /// The [name] parameter should clearly indicate the query's purpose,
  /// typically using a verb-noun format that describes what is being retrieved.
  /// 
  /// [conceptCode] optionally specifies which concept this query targets.
  Query(this.name, {this.conceptCode});
  
  /// Creates a new query targeting a specific concept.
  /// 
  /// This factory constructor makes it explicit that the query is for a particular
  /// concept, which can be used for validation and routing.
  /// 
  /// [name] is the name of the query.
  /// [conceptCode] is the code of the concept being queried.
  /// Returns a new concept-specific query.
  factory Query.forConcept(String name, String conceptCode) {
    return Query(name, conceptCode: conceptCode);
  }
  
  /// Adds a parameter to this query.
  /// 
  /// This is useful for building queries with multiple parameters.
  /// 
  /// [name] is the parameter name.
  /// [value] is the parameter value.
  /// Returns this query for method chaining.
  Query withParameter(String name, dynamic value) {
    _parameters[name] = value;
    return this;
  }
  
  /// Adds multiple parameters to this query.
  /// 
  /// This is useful for building queries with multiple parameters at once.
  /// 
  /// [parameters] is a map of parameter names to values.
  /// Returns this query for method chaining.
  Query withParameters(Map<String, dynamic> parameters) {
    _parameters.addAll(parameters);
    return this;
  }
  
  @override
  Map<String, dynamic> getParameters() => Map.unmodifiable(_parameters);
} 