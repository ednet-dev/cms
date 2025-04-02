import 'package:drift/drift.dart';
import 'package:ednet_core/ednet_core.dart';

/// A query specifically designed for Drift repositories.
///
/// This query extends the EDNet Core unified query system with Drift-specific
/// capabilities, such as SQL expressions and Drift-specific parameters.
///
/// Example usage:
/// ```dart
/// final query = DriftQuery(
///   'FindActiveUsers',
///   conceptCode: 'Users',
///   driftParameters: {
///     'isActive': Variable.withBool(true),
///   },
///   rawSql: 'status = ? AND created_at > ?',
///   sqlVariables: [Variable('active'), Variable(DateTime.now().subtract(Duration(days: 30)))],
/// );
/// ```
class DriftQuery extends Query {
  /// Drift-specific query parameters.
  ///
  /// These can include Drift-specific types like `Variable` that
  /// aren't supported in standard EDNet queries.
  final Map<String, dynamic> driftParameters;
  
  /// Raw SQL WHERE clause to use in the query.
  ///
  /// This allows for more complex queries than the standard
  /// parameter-based approach. Variables should use '?' placeholders.
  final String? rawSql;
  
  /// Variables for the raw SQL query.
  ///
  /// These should be `Variable` instances for Drift to properly
  /// handle them in prepared statements.
  final List<Variable>? sqlVariables;
  
  /// SQL JOIN clauses to add to the query.
  final List<String>? joins;
  
  /// Custom expressions for WHERE clauses.
  final Expression<bool>? whereExpression;
  
  /// Whether to use SQLite JSON functions for nested properties.
  final bool useJsonFunctions;
  
  /// Creates a new Drift query.
  ///
  /// Parameters:
  /// - [name]: The name of the query
  /// - [conceptCode]: Optional concept code this query targets
  /// - [driftParameters]: Drift-specific parameters
  /// - [rawSql]: Raw SQL WHERE clause
  /// - [sqlVariables]: Variables for the raw SQL query
  /// - [joins]: SQL JOIN clauses
  /// - [whereExpression]: Custom expression for WHERE clause
  /// - [useJsonFunctions]: Whether to use SQLite JSON functions
  DriftQuery(
    String name, {
    String? conceptCode,
    this.driftParameters = const {},
    this.rawSql,
    this.sqlVariables,
    this.joins,
    this.whereExpression,
    this.useJsonFunctions = false,
    Map<String, dynamic> parameters = const {},
  }) : super(name, conceptCode: conceptCode) {
    // Add any standard parameters
    if (parameters.isNotEmpty) {
      withParameters(parameters);
    }
  }
  
  /// Creates a new Drift query for a specific concept.
  ///
  /// This factory constructor makes it easier to create concept-specific
  /// queries with Drift features.
  ///
  /// Parameters:
  /// - [name]: The name of the query
  /// - [concept]: The concept this query targets
  /// - [driftParameters]: Drift-specific parameters
  /// - [rawSql]: Raw SQL WHERE clause
  /// - [sqlVariables]: Variables for the raw SQL query
  /// - [joins]: SQL JOIN clauses
  /// - [whereExpression]: Custom expression for WHERE clause
  factory DriftQuery.forConcept(
    String name,
    Concept concept, {
    Map<String, dynamic> driftParameters = const {},
    String? rawSql,
    List<Variable>? sqlVariables,
    List<String>? joins,
    Expression<bool>? whereExpression,
    bool useJsonFunctions = false,
    Map<String, dynamic> parameters = const {},
  }) {
    return DriftQuery(
      name,
      conceptCode: concept.code,
      driftParameters: driftParameters,
      rawSql: rawSql,
      sqlVariables: sqlVariables,
      joins: joins,
      whereExpression: whereExpression,
      useJsonFunctions: useJsonFunctions,
      parameters: parameters,
    );
  }
  
  /// Adds a Drift-specific parameter to this query.
  ///
  /// This is useful for parameters that use Drift types.
  ///
  /// Parameters:
  /// - [name]: The parameter name
  /// - [value]: The parameter value
  ///
  /// Returns this query for method chaining.
  DriftQuery withDriftParameter(String name, dynamic value) {
    driftParameters[name] = value;
    return this;
  }
  
  /// Gets all parameters including Drift-specific ones.
  ///
  /// This combines standard EDNet query parameters with
  /// Drift-specific parameters.
  ///
  /// Returns a map of all parameters.
  Map<String, dynamic> getAllParameters() {
    final result = Map<String, dynamic>.from(getParameters());
    result.addAll(driftParameters);
    return result;
  }
  
  /// Gets the SQL representation of this query.
  ///
  /// Returns the raw SQL if provided, or null if not applicable.
  String? getSql() => rawSql;
  
  /// Gets the variables for the SQL query.
  ///
  /// Returns the SQL variables if provided, or an empty list.
  List<Variable> getSqlVariables() => sqlVariables ?? [];
  
  /// Gets the JOIN clauses for the query.
  ///
  /// Returns the JOIN clauses if provided, or an empty list.
  List<String> getJoins() => joins ?? [];
  
  /// Gets the WHERE expression for the query.
  ///
  /// Returns the WHERE expression if provided, or null.
  Expression<bool>? getWhereExpression() => whereExpression;
} 