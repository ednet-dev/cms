part of ednet_core;

/// Dispatches queries to their appropriate handlers.
///
/// The [QueryDispatcher] class is responsible for routing queries to their
/// registered handlers, providing a centralized entry point for query processing.
/// This follows the mediator pattern, decoupling query senders from handlers.
///
/// This dispatcher serves as the single unified query handling mechanism for both
/// domain model and application layers, eliminating duplication and inconsistency.
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

  /// Map of query names to handlers (for application-level queries without concepts)
  final Map<String, IQueryHandler> _namedHandlers = {};
  
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

  /// Registers a query handler for a specific query name without a concept.
  ///
  /// This is useful for application-level queries that don't target a specific concept.
  ///
  /// Type parameters:
  /// - [Q]: The type of query to handle
  /// - [R]: The type of result the handler returns
  ///
  /// Parameters:
  /// - [queryName]: The name of the query this handler processes
  /// - [handler]: The handler to register
  void registerNamedHandler<Q extends IQuery, R extends IQueryResult>(
    String queryName,
    IQueryHandler<Q, R> handler
  ) {
    _namedHandlers[queryName] = handler;
  }
  
  /// Dispatches a query to its registered handler.
  ///
  /// This method implements a dispatch strategy that tries multiple approaches:
  /// 1. First tries concept-based dispatch if applicable
  /// 2. Then falls back to name-based dispatch 
  /// 3. Finally tries type-based dispatch
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
    // Try concept-based dispatch if applicable
    if (query.conceptCode != null) {
      final conceptHandlerMap = _conceptHandlers[query.conceptCode];
      if (conceptHandlerMap != null) {
        final handler = conceptHandlerMap[query.name];
        if (handler != null) {
          return await (handler as IQueryHandler<Q, R>).handle(query);
        }
      }
    }
    
    // Try name-based dispatch
    final namedHandler = _namedHandlers[query.name];
    if (namedHandler != null) {
      return await (namedHandler as IQueryHandler<Q, R>).handle(query);
    }
    
    // Fall back to type-based dispatch
    final handler = _handlers[Q];
    
    if (handler == null) {
      throw StateError('No handler registered for query type ${Q.toString()} with name ${query.name}');
    }
    
    try {
      return await (handler as IQueryHandler<Q, R>).handle(query);
    } catch (e) {
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

  /// Dispatches a query by name without requiring a concept.
  ///
  /// This method is useful for application-level queries that don't target a specific concept.
  ///
  /// Parameters:
  /// - [queryName]: The name of the query to dispatch
  /// - [parameters]: Query parameters
  ///
  /// Returns:
  /// A Future with the query result
  Future<IQueryResult> dispatchByNameOnly(
    String queryName,
    [Map<String, dynamic>? parameters]
  ) async {
    final handler = _namedHandlers[queryName];
    if (handler == null) {
      return QueryResult.failure(
        'No handler registered for query: $queryName',
      );
    }
    
    try {
      // Create a dynamic query
      final query = Query(queryName);
      if (parameters != null) {
        query.withParameters(parameters);
      }
      
      return await handler.handle(query);
    } catch (e) {
      return QueryResult.failure(
        'Error handling query: ${e.toString()}',
      );
    }
  }
} 