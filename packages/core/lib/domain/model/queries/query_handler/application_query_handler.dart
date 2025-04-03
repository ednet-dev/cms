// part of ednet_core;
//
// /// Base class for application-level query handlers.
// ///
// /// This class provides a foundation for implementing query handlers that work with
// /// the unified query system, handling application-specific validation and processing.
// ///
// /// Type parameters:
// /// - [Q]: The type of query this handler processes
// /// - [R]: The type of result this handler returns
// ///
// /// Example usage:
// /// ```dart
// /// class FindActiveTasksHandler extends ApplicationQueryHandler<FindActiveTasksQuery, TaskQueryResult> {
// ///   final TaskRepository repository;
// ///
// ///   FindActiveTasksHandler(this.repository);
// ///
// ///   @override
// ///   Future<TaskQueryResult> processQuery(FindActiveTasksQuery query) async {
// ///     final tasks = await repository.findByStatus('active');
// ///     return TaskQueryResult(tasks);
// ///   }
// /// }
// /// ```
// abstract class ApplicationQueryHandler<Q extends IQuery, R extends IQueryResult> implements model.IQueryHandler<Q, R> {
//   /// Validates the query before processing.
//   ///
//   /// This method calls the query's validate method and provides additional
//   /// application-specific validation.
//   ///
//   /// Override this method to add custom validation logic.
//   ///
//   /// Parameters:
//   /// - [query]: The query to validate
//   ///
//   /// Returns true if the query is valid, false otherwise.
//   bool validateQuery(Q query) {
//     // Call the query's validate method if it's an application query
//     if (query is Query) {
//       return query.validate();
//     }
//
//     // Default to true for other query types
//     return true;
//   }
//
//   /// Process the validated query and return a result.
//   ///
//   /// Implement this method to define the core query handling logic.
//   ///
//   /// Parameters:
//   /// - [query]: The validated query to process
//   ///
//   /// Returns a Future with the query result.
//   Future<R> processQuery(Q query);
//
//   @override
//   Future<R> handle(Q query) async {
//     // Validate the query
//     if (!validateQuery(query)) {
//       // Create a failure result
//       // This is a bit complex due to type erasure in Dart
//       dynamic result;
//
//       if (R == model.QueryResult || R == model.EntityQueryResult) {
//         result = model.QueryResult.failure('Query validation failed');
//       } else if (R == QueryResult) {
//         result = QueryResult.failure('Query validation failed');
//       } else {
//         throw StateError('Cannot create failure result for type $R');
//       }
//
//       return result as R;
//     }
//
//     try {
//       // Process the query
//       return await processQuery(query);
//     } catch (e) {
//       // Handle exceptions
//       dynamic result;
//
//       if (R == model.QueryResult || R == model.EntityQueryResult) {
//         result = model.QueryResult.failure('Query processing failed: $e');
//       } else if (R == QueryResult) {
//         result = QueryResult.failure('Query processing failed: $e');
//       } else {
//         throw StateError('Cannot create failure result for type $R');
//       }
//
//       return result as R;
//     }
//   }
// }