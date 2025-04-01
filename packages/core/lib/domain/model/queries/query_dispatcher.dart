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
  
  /// Map of concept codes to their handlers
  final Map<String, Map<String, IQueryHandler>> _conceptHandlers = {};
  
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
  
  /// Registers a query handler for a specific concept and query name.
  ///
  /// This enables dispatching queries based on concept code and query name,
  /// which is useful for dynamic query handling based on metadata.
  ///
  /// Type parameters:
  /// - [Q]: The type of query to handle
  /// - [R]: The type of result the handler returns
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept this handler targets
  /// - [queryName]: The name of the query this handler processes
  /// - [handler]: The handler to register
  void registerConceptHandler<Q extends IQuery, R extends IQueryResult>(
    String conceptCode,
    String queryName,
    IQueryHandler<Q, R> handler
  ) {
    _conceptHandlers.putIfAbsent(conceptCode, () => {});
    _conceptHandlers[conceptCode]![queryName] = handler;
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
    // First try concept-based dispatch if applicable
    if (query.conceptCode != null) {
      final conceptHandlerMap = _conceptHandlers[query.conceptCode];
      if (conceptHandlerMap != null) {
        final handler = conceptHandlerMap[query.name];
        if (handler != null) {
          return await (handler as IQueryHandler<Q, R>).handle(query);
        }
      }
    }
    
    // Fall back to type-based dispatch
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
  
  /// Dispatches a query using its concept code and name.
  ///
  /// This method is useful for dynamic query dispatching based on
  /// concept metadata rather than static types.
  ///
  /// Parameters:
  /// - [conceptCode]: The code of the concept being queried
  /// - [queryName]: The name of the query to dispatch
  /// - [parameters]: Query parameters
  ///
  /// Returns:
  /// A Future with the query result
  Future<IQueryResult> dispatchByName(
    String conceptCode,
    String queryName,
    [Map<String, dynamic>? parameters]
  ) async {
    final conceptHandlerMap = _conceptHandlers[conceptCode];
    if (conceptHandlerMap == null) {
      return QueryResult.failure(
        'No handlers registered for concept: $conceptCode',
        conceptCode: conceptCode,
      );
    }
    
    final handler = conceptHandlerMap[queryName];
    if (handler == null) {
      return QueryResult.failure(
        'No handler registered for query: $queryName in concept: $conceptCode',
        conceptCode: conceptCode,
      );
    }
    
    try {
      // Create a dynamic query
      final query = Query(queryName, conceptCode: conceptCode);
      if (parameters != null) {
        query.withParameters(parameters);
      }
      
      return await handler.handle(query);
    } catch (e) {
      return QueryResult.failure(
        'Error handling query: ${e.toString()}',
        conceptCode: conceptCode,
      );
    }
  }
} 