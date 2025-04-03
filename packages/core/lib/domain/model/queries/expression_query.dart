// part of ednet_core;
//
// /// Implements a query using the expression system for powerful filtering.
// ///
// /// The [ExpressionQuery] class extends [ConceptQuery] to provide advanced
// /// querying capabilities using the expression system. This allows for
// /// more complex filtering, sorting, and relationship traversal.
// ///
// /// Example usage:
// /// ```dart
// /// // Create an expression to find products with price < 100 that have 'electronics' category
// /// final priceExpression = AttributeExpression('price', ComparisonOperator.lessThan, 100);
// /// final categoryExpression = RelationshipExpression(
// ///   'category',
// ///   RelationshipType.parent,
// ///   AttributeExpression('name', ComparisonOperator.equals, 'electronics')
// /// );
// ///
// /// final combinedExpression = priceExpression.and(categoryExpression);
// ///
// /// final query = ExpressionQuery('FindAffordableElectronics', productConcept, combinedExpression)
// ///   .withPagination(page: 1, pageSize: 20)
// ///   .withSorting('price');
// /// ```
// class ExpressionQuery extends ConceptQuery {
//   /// The expression to evaluate against entities.
//   final QueryExpression expression;
//
//   /// Creates a new expression-based query.
//   ///
//   /// Parameters:
//   /// - [name]: The name of the query
//   /// - [concept]: The concept being queried
//   /// - [expression]: The expression to evaluate
//   /// - [parameters]: Additional parameters for the query
//   ExpressionQuery(
//     String name,
//     Concept concept,
//     this.expression, [
//     Map<String, dynamic>? parameters,
//   ]) : super(name, concept, parameters);
//
//   /// Factory method for creating a query with an attribute expression.
//   ///
//   /// This convenience method creates a query with an attribute expression
//   /// using the specified operator and value.
//   ///
//   /// Parameters:
//   /// - [name]: The name of the query
//   /// - [concept]: The concept being queried
//   /// - [attributeCode]: The attribute to filter on
//   /// - [operator]: The comparison operator
//   /// - [value]: The value to compare against
//   ///
//   /// Returns a new expression query.
//   factory ExpressionQuery.withAttribute(
//     String name,
//     Concept concept,
//     String attributeCode,
//     ComparisonOperator operator,
//     dynamic value
//   ) {
//     return ExpressionQuery(
//       name,
//       concept,
//       AttributeExpression(attributeCode, operator, value)
//     );
//   }
//
//   /// Factory method for creating a query with a relationship expression.
//   ///
//   /// This convenience method creates a query that filters based on
//   /// a relationship with the specified expression.
//   ///
//   /// Parameters:
//   /// - [name]: The name of the query
//   /// - [concept]: The concept being queried
//   /// - [relationshipCode]: The relationship to traverse
//   /// - [relationshipType]: The type of relationship
//   /// - [relatedExpression]: The expression to apply to related entities
//   ///
//   /// Returns a new expression query.
//   factory ExpressionQuery.withRelationship(
//     String name,
//     Concept concept,
//     String relationshipCode,
//     RelationshipType relationshipType,
//     QueryExpression relatedExpression
//   ) {
//     return ExpressionQuery(
//       name,
//       concept,
//       RelationshipExpression(relationshipCode, relationshipType, relatedExpression)
//     );
//   }
//
//   /// Adds the expression to the query parameters.
//   @override
//   Map<String, dynamic> getParameters() {
//     final params = super.getParameters();
//
//     // Clone the parameters map since super.getParameters() returns an unmodifiable map
//     final mutableParams = Map<String, dynamic>.from(params);
//
//     // Add the expression to the parameters
//     mutableParams['expression'] = expression;
//
//     return Map.unmodifiable(mutableParams);
//   }
//
//   /// Gets the expression from this query.
//   ///
//   /// This method is useful for query handlers to access the expression
//   /// for evaluation.
//   ///
//   /// Returns the query expression.
//   QueryExpression getExpression() => expression;
//
//   /// Applies the expression to a collection of entities.
//   ///
//   /// This method filters a collection of entities using the expression,
//   /// and applies any additional filtering, sorting, and pagination from
//   /// the query parameters.
//   ///
//   /// Parameters:
//   /// - [entities]: The collection of entities to filter
//   ///
//   /// Returns a filtered collection of entities.
//   Iterable<Entity> apply(Iterable<Entity> entities) {
//     // Filter entities using the expression
//     var result = entities.where((entity) => expression.evaluate(entity));
//
//     // Apply sorting if specified
//     final sortBy = getParameters()['sortBy'] as String?;
//     final sortDirection = getParameters()['sortDirection'] as String?;
//
//     if (sortBy != null) {
//       final ascending = sortDirection != 'desc';
//
//       result = result.toList()
//         ..sort((a, b) {
//           final aValue = a.getAttribute(sortBy);
//           final bValue = b.getAttribute(sortBy);
//
//           // Handle null values
//           if (aValue == null && bValue == null) return 0;
//           if (aValue == null) return ascending ? -1 : 1;
//           if (bValue == null) return ascending ? 1 : -1;
//
//           // Compare values
//           if (aValue is Comparable && bValue is Comparable) {
//             final comparison = aValue.compareTo(bValue);
//             return ascending ? comparison : -comparison;
//           }
//
//           // If not comparable, use toString()
//           final comparison = aValue.toString().compareTo(bValue.toString());
//           return ascending ? comparison : -comparison;
//         });
//     }
//
//     // Apply pagination if specified
//     final page = getParameters()['page'] as int?;
//     final pageSize = getParameters()['pageSize'] as int?;
//
//     if (page != null && pageSize != null && pageSize > 0) {
//       final start = (page - 1) * pageSize;
//       final end = start + pageSize;
//
//       final asList = result.toList();
//       if (start < asList.length) {
//         result = asList.sublist(start, end > asList.length ? asList.length : end);
//       } else {
//         result = [];
//       }
//     }
//
//     return result;
//   }
// }