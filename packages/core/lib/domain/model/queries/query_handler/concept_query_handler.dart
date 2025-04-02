part of ednet_core;

/// Base implementation for concept-specific query handlers.
///
/// This class extends [BaseQueryHandler] with capabilities
/// specifically designed for handling concept-specific queries,
/// including validation against concept attributes.
///
/// Type parameters:
/// - [T]: The type of entity being queried
///
/// Example usage:
/// ```dart
/// class FindTasksByStatusHandler extends ConceptQueryHandler<Task> {
///   FindTasksByStatusHandler(Repository<Task> repository, Concept concept)
///     : super(repository, concept);
///
///   @override
///   Future<EntityQueryResult<Task>> executeConceptQuery(
///     model.ConceptQuery query
///   ) async {
///     final status = query.getParameters()['status'];
///     final tasks = await repository.findByStatus(status);
///     return EntityQueryResult.success(tasks, concept: concept);
///   }
/// }
/// ```
abstract class ConceptQueryHandler<T extends AggregateRoot> 
    extends BaseQueryHandler<model.ConceptQuery, model.EntityQueryResult<T>> {
  
  /// The repository for accessing entities.
  final Repository<T> repository;
  
  /// The concept this handler processes queries for.
  final model.Concept concept;
  
  /// Creates a new concept query handler.
  ///
  /// Parameters:
  /// - [repository]: Repository for accessing entities
  /// - [concept]: The concept this handler processes queries for
  ConceptQueryHandler(this.repository, this.concept);
  
  /// Creates a failure result with the given error message.
  ///
  /// Parameters:
  /// - [errorMessage]: The error message
  ///
  /// Returns a concept-aware failure result
  @override
  model.IQueryResult createFailureResult(String errorMessage) {
    return model.EntityQueryResult<T>.failure(
      errorMessage,
      concept: concept,
    );
  }
  
  /// Validates the query against the concept's structure.
  ///
  /// This method uses the concept query's validate method,
  /// which checks attribute compatibility.
  ///
  /// Parameters:
  /// - [query]: The query to validate
  ///
  /// Returns true if the query is valid, false otherwise
  @override
  bool validateQuery(model.ConceptQuery query) {
    // Check that the query is for this concept
    if (query.conceptCode != concept.code) {
      return false;
    }
    
    return query.validate();
  }
  
  /// Authorizes the execution of a query.
  ///
  /// This implementation checks if any attribute in the query
  /// is marked as sensitive, and if so, requires additional authorization.
  ///
  /// Parameters:
  /// - [query]: The query to authorize
  ///
  /// Returns true if execution is authorized, false otherwise
  @override
  bool authorizeExecution(model.ConceptQuery query) {
    // Check for sensitive attributes
    for (String key in query.getParameters().keys) {
      if (concept.isAttributeSensitive(key)) {
        return hasPermissionForSensitiveData();
      }
    }
    
    return true;
  }
  
  /// Checks if the current context has permission to access sensitive data.
  ///
  /// This method should be overridden by subclasses to implement
  /// proper authorization logic.
  ///
  /// Returns true if the current context has permission, false otherwise
  bool hasPermissionForSensitiveData() {
    // Default implementation allows access
    // Subclasses should override this with proper authorization logic
    return true;
  }
  
  /// Handles a concept query and returns a result.
  ///
  /// This method delegates to the base class handle method,
  /// which implements the template method pattern.
  ///
  /// Parameters:
  /// - [query]: The query to handle
  ///
  /// Returns a Future with the query result
  @override
  Future<model.EntityQueryResult<T>> handle(model.ConceptQuery query) {
    return super.handle(query);
  }
  
  /// Executes the query and returns a result.
  ///
  /// This method does the actual query execution,
  /// after validation and authorization have passed.
  ///
  /// Parameters:
  /// - [query]: The query to execute
  ///
  /// Returns a Future with the query result
  @override
  Future<model.EntityQueryResult<T>> executeQuery(model.ConceptQuery query) {
    return executeConceptQuery(query);
  }
  
  /// Executes a concept query and returns an entity result.
  ///
  /// This method should be implemented by subclasses to
  /// handle specific query types.
  ///
  /// Parameters:
  /// - [query]: The concept query to execute
  ///
  /// Returns a Future with the entity query result
  Future<model.EntityQueryResult<T>> executeConceptQuery(model.ConceptQuery query);
} 