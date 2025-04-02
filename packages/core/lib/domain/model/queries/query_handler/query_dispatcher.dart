part of ednet_core;

/// Dispatches queries to their appropriate handlers in the application layer.
///
/// The [QueryDispatcher] class extends the domain model's query dispatcher,
/// providing application-specific enhancements like validation, authorization,
/// metrics, and logging.
///
/// Example usage:
/// ```dart
/// final dispatcher = QueryDispatcher();
/// 
/// // Register handlers
/// dispatcher.registerHandler<FindTasksByStatusQuery, TasksQueryResult>(
///   FindTasksByStatusHandler(taskRepository)
/// );
/// 
/// // Execute a query
/// final result = await dispatcher.dispatch(
///   FindTasksByStatusQuery('completed')
/// );
/// ```
class QueryDispatcher extends model.QueryDispatcher {
  /// Registry of query handlers by their query types
  final Map<Type, IQueryHandler> _appHandlers = {};
  
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
    _appHandlers[Q] = handler;
    
    // Register with the base class as well for compatibility
    super.registerHandler<Q, R>(handler as model.IQueryHandler<Q, R>);
  }
  
  /// Dispatches a query to its registered handler.
  ///
  /// This method:
  /// 1. Finds the appropriate handler for the query type
  /// 2. Records metrics about the query execution
  /// 3. Handles any errors that occur during processing
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
    final stopwatch = Stopwatch()..start();
    
    try {
      final handler = _appHandlers[Q];
      
      if (handler == null) {
        // Create a failure result
        throw StateError('No handler registered for query type ${Q.toString()}');
      }
      
      // Execute the query
      final result = await (handler as IQueryHandler<Q, R>).handle(query);
      
      // Add execution time metadata
      if (result is QueryResult<dynamic>) {
        final newMetadata = Map<String, dynamic>.from(result.metadata)
          ..['executionTimeMs'] = stopwatch.elapsedMilliseconds;
        
        return QueryResult(
          isSuccess: result.isSuccess,
          data: result.data,
          errorMessage: result.errorMessage,
          metadata: newMetadata,
        ) as R;
      }
      
      return result;
    } catch (e) {
      // Create a failure result
      return QueryResult.failure(
        'Error dispatching query: $e',
        metadata: {'executionTimeMs': stopwatch.elapsedMilliseconds}
      ) as R;
    } finally {
      stopwatch.stop();
    }
  }
} 