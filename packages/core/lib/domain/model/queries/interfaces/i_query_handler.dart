import 'i_query.dart';
import 'i_query_result.dart';

/// Interface for query handlers in CQRS.
///
/// The [IQueryHandler] interface defines the contract for components that handle
/// queries. It ensures that query handlers:
/// - Accept a specific query type
/// - Return a specific result type
/// - Have a consistent execution pattern
///
/// This promotes a clear separation of query handling logic from command processing.
///
/// Type parameters:
/// - [Q]: The type of query this handler processes
/// - [R]: The type of result this handler returns
abstract class IQueryHandler<Q extends IQuery, R extends IQueryResult> {
  /// Handles a query and returns a result.
  ///
  /// This method should:
  /// - Process the query without side effects
  /// - Return a result containing the requested data
  /// - Handle any errors that occur during processing
  ///
  /// Parameters:
  /// - [query]: The query to handle
  ///
  /// Returns:
  /// A Future with the query result
  Future<R> handle(Q query);
} 