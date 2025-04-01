import 'dart:async';

import 'interfaces/i_query.dart';
import 'interfaces/i_query_handler.dart';
import 'interfaces/i_query_result.dart';
import 'query_result.dart';

/// Dispatches queries to their appropriate handlers.
///
/// The [QueryDispatcher] class is responsible for routing queries to their
/// registered handlers, providing a centralized entry point for query processing.
/// This follows the mediator pattern, decoupling query senders from handlers.
///
/// Example usage:
/// ```dart
/// final dispatcher = QueryDispatcher();
/// dispatcher.registerHandler<FindTasksByStatusQuery, TasksQueryResult>(
///   findTasksHandler
/// );
///
/// // Later, dispatch a query
/// final result = await dispatcher.dispatch(FindTasksByStatusQuery('completed'));
/// ```
class QueryDispatcher {
  /// Map of query types to their handlers
  final Map<Type, IQueryHandler> _handlers = {};
  
  /// Registers a query handler for a specific query type.
  ///
  /// Type parameters:
  /// - [Q]: The type of query to handle
  /// - [R]: The type of result the handler returns
  ///
  /// Parameters:
  /// - [handler]: The handler to register
  void registerHandler<Q extends IQuery, R extends IQueryResult>(
    IQueryHandler<Q, R> handler
  ) {
    _handlers[Q] = handler;
  }
  
  /// Dispatches a query to its registered handler.
  ///
  /// This method:
  /// 1. Finds the appropriate handler for the query type
  /// 2. Invokes the handler with the query
  /// 3. Returns the result or an error
  ///
  /// Type parameters:
  /// - [Q]: The type of query to dispatch
  /// - [R]: The expected result type
  ///
  /// Parameters:
  /// - [query]: The query to dispatch
  ///
  /// Returns:
  /// A Future with the query result
  Future<R> dispatch<Q extends IQuery, R extends IQueryResult>(Q query) async {
    final handler = _handlers[Q];
    
    if (handler == null) {
      // Create a failure result of the expected type
      // This is a bit complex due to dart generics
      throw StateError('No handler registered for query type ${Q.toString()}');
    }
    
    try {
      return await (handler as IQueryHandler<Q, R>).handle(query);
    } catch (e) {
      // We can't create a typed QueryResult.failure here easily due to type erasure
      // So we have to throw and let the caller handle it
      throw StateError('Error handling query: ${e.toString()}');
    }
  }
} 