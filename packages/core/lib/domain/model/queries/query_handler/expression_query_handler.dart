part of ednet_core;

/// Handler for expression-based queries.
///
/// The [ExpressionQueryHandler] class implements the query handler interface
/// for [ExpressionQuery] objects. It executes the query expression against
/// entities from a repository.
///
/// Example usage:
/// ```dart
/// final handler = ExpressionQueryHandler(productRepository, productConcept);
/// dispatcher.registerHandler<ExpressionQuery, EntityQueryResult<Product>>(handler);
/// ```
class ExpressionQueryHandler<T extends Entity<T>> implements IQueryHandler<ExpressionQuery, EntityQueryResult<T>> {
  /// The repository to query entities from.
  final Repository<T> _repository;
  
  /// The concept being queried.
  final Concept _concept;
  
  /// Creates a new expression query handler.
  ///
  /// Parameters:
  /// - [repository]: The repository to query entities from
  /// - [concept]: The concept being queried
  ExpressionQueryHandler(this._repository, this._concept);
  
  @override
  Future<EntityQueryResult<T>> handle(ExpressionQuery query) async {
    try {
      // Validate that the query is for the correct concept
      if (query.concept != _concept) {
        return EntityQueryResult.failure(
          'Query concept does not match handler concept',
          concept: _concept,
        );
      }
      
      // Get all entities from the repository
      final allEntities = await _repository.getEntities();
      
      // Apply the expression to filter the entities
      final filteredEntities = query.apply(allEntities).cast<T>().toList();
      
      // Count the total number of entities (before pagination)
      final totalCount = filteredEntities.length;
      
      // Return the result with metadata
      final page = query.getParameters()['page'] as int?;
      final pageSize = query.getParameters()['pageSize'] as int?;
      
      if (page != null && pageSize != null && pageSize > 0) {
        return EntityQueryResult.success(
          filteredEntities,
          concept: _concept,
          metadata: {
            'page': page,
            'pageSize': pageSize,
            'totalCount': totalCount,
          },
        );
      } else {
        return EntityQueryResult.success(
          filteredEntities,
          concept: _concept,
        );
      }
    } catch (e) {
      return EntityQueryResult.failure(
        'Error executing query: $e',
        concept: _concept,
      );
    }
  }
} 