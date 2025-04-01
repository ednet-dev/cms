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
  
  /// Creates a new query with the specified name.
  ///
  /// The [name] parameter should clearly indicate the query's purpose,
  /// typically using a verb-noun format that describes what is being retrieved.
  Query(this.name);
  
  @override
  Map<String, dynamic> getParameters() => {};
} 