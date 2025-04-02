part of ednet_core;

/// Base implementation of the query handler interface.
///
/// This class provides a foundation for all query handlers in the application layer,
/// implementing common functionality like validation, authorization, and error handling.
///
/// Example usage:
/// ```dart
/// class FindTasksByStatusHandler extends BaseQueryHandler<FindTasksByStatusQuery, TasksQueryResult> {
///   final TaskRepository repository;
///   
///   FindTasksByStatusHandler(this.repository);
///   
///   @override
///   Future<TasksQueryResult> executeQuery(FindTasksByStatusQuery query) async {
///     try {
///       final tasks = await repository.findByStatus(query.status);
///       return TasksQueryResult.success(tasks);
///     } catch (e) {
///       return TasksQueryResult.failure('Failed to find tasks: $e');
///     }
///   }
/// }
/// ```
abstract class BaseQueryHandler<Q extends IQuery, R extends IQueryResult> 
    implements IQueryHandler<Q, R> {
  
  /// Handles a query and returns a result.
  ///
  /// This implementation follows a template method pattern:
  /// 1. Validates the query
  /// 2. Performs authorization checks
  /// 3. Executes the query
  /// 4. Returns the result
  ///
  /// Parameters:
  /// - [query]: The query to handle
  ///
  /// Returns:
  /// A Future with the query result
  @override
  Future<R> handle(covariant Q query) async {
    try {
      // Validation
      if (!validateQuery(query)) {
        return createFailureResult('Query validation failed') as R;
      }
      
      // Authorization
      if (!authorizeExecution(query)) {
        return createFailureResult('Not authorized to execute this query') as R;
      }
      
      // Execution
      return await executeQuery(query);
    } catch (e) {
      return createFailureResult('Error handling query: $e') as R;
    }
  }
  
  /// Validates a query before processing.
  ///
  /// The default implementation checks the query's validate() method,
  /// but subclasses can override this for more complex validation.
  ///
  /// Parameters:
  /// - [query]: The query to validate
  ///
  /// Returns:
  /// True if the query is valid, false otherwise
  @override
  bool validateQuery(Q query) {
    return query.validate();
  }
  
  /// Authorizes the execution of a query.
  ///
  /// The default implementation allows all queries,
  /// but subclasses should override this for proper authorization.
  ///
  /// Parameters:
  /// - [query]: The query to authorize
  ///
  /// Returns:
  /// True if execution is authorized, false otherwise
  @override
  bool authorizeExecution(Q query) {
    return true;
  }
  
  /// Creates a failure result with the given error message.
  ///
  /// This method should be implemented by subclasses to create
  /// the appropriate failure result for their result type.
  ///
  /// Parameters:
  /// - [errorMessage]: The error message
  ///
  /// Returns:
  /// A failure result
  IQueryResult createFailureResult(String errorMessage);
  
  /// Executes the query and returns a result.
  ///
  /// This method should implement the actual query execution logic,
  /// retrieving data from repositories or other sources.
  ///
  /// Parameters:
  /// - [query]: The query to execute
  ///
  /// Returns:
  /// A Future with the query result
  Future<R> executeQuery(Q query);
} 