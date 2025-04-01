import 'query.dart';

/// Represents a query specifically for concept operations.
///
/// This class extends the standard [Query] to provide capabilities
/// specifically designed for querying concepts, including support for
/// validation against concept attributes and constraints.
///
/// Example usage:
/// ```dart
/// final query = ConceptQuery(
///   'FindTasksByStatus',
///   taskConcept,
///   {'status': 'completed'}
/// );
///
/// // Or with method chaining
/// final query = ConceptQuery.create('FindTasksByStatus', taskConcept)
///   .withAttribute('status', 'completed')
///   .withPagination(page: 1, pageSize: 10);
/// ```
class ConceptQuery extends Query {
  /// The concept this query targets.
  final Concept concept;
  
  /// Creates a new concept query.
  ///
  /// Parameters:
  /// - [name]: The name of the query
  /// - [concept]: The concept being queried
  /// - [parameters]: Initial parameters for the query
  ConceptQuery(
    String name,
    this.concept, [
    Map<String, dynamic>? parameters,
  ]) : super(name, conceptCode: concept.code) {
    if (parameters != null) {
      withParameters(parameters);
    }
  }
  
  /// Factory constructor for cleaner creation.
  ///
  /// Parameters:
  /// - [name]: The name of the query
  /// - [concept]: The concept being queried
  factory ConceptQuery.create(String name, Concept concept) {
    return ConceptQuery(name, concept);
  }
  
  /// Adds a filter based on a concept attribute.
  ///
  /// This method ensures the attribute exists in the concept
  /// before adding it as a filter parameter.
  ///
  /// Parameters:
  /// - [attributeCode]: The code of the attribute to filter by
  /// - [value]: The value to filter for
  ///
  /// Returns this query for method chaining.
  /// Throws [AttributeException] if the attribute doesn't exist.
  ConceptQuery withAttribute(String attributeCode, dynamic value) {
    // Verify the attribute exists
    Attribute? attribute = concept.getAttribute<Attribute>(attributeCode);
    if (attribute == null) {
      throw AttributeException(
        'Attribute $attributeCode does not exist in concept ${concept.code}'
      );
    }
    
    return withParameter(attributeCode, value) as ConceptQuery;
  }
  
  /// Adds pagination parameters to the query.
  ///
  /// This is a convenience method for adding standard pagination parameters.
  ///
  /// Parameters:
  /// - [page]: The page number to retrieve (1-based)
  /// - [pageSize]: The number of items per page
  ///
  /// Returns this query for method chaining.
  ConceptQuery withPagination({int page = 1, int pageSize = 20}) {
    return withParameters({
      'page': page,
      'pageSize': pageSize,
    }) as ConceptQuery;
  }
  
  /// Adds sorting parameters to the query.
  ///
  /// This method verifies that the attribute exists in the concept
  /// before adding the sort parameter.
  ///
  /// Parameters:
  /// - [attributeCode]: The code of the attribute to sort by
  /// - [ascending]: Whether to sort in ascending order
  ///
  /// Returns this query for method chaining.
  /// Throws [AttributeException] if the attribute doesn't exist.
  ConceptQuery withSorting(String attributeCode, {bool ascending = true}) {
    // Verify the attribute exists
    Attribute? attribute = concept.getAttribute<Attribute>(attributeCode);
    if (attribute == null) {
      throw AttributeException(
        'Cannot sort by attribute $attributeCode: it does not exist in concept ${concept.code}'
      );
    }
    
    return withParameters({
      'sortBy': attributeCode,
      'sortDirection': ascending ? 'asc' : 'desc',
    }) as ConceptQuery;
  }
  
  /// Validates this query against the concept's structure.
  ///
  /// This method checks that all attribute filters refer to valid
  /// attributes in the concept, and that the values are of the correct type.
  ///
  /// Returns true if the query is valid, false otherwise.
  bool validate() {
    for (String key in getParameters().keys) {
      // Skip standard parameters
      if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
        continue;
      }
      
      // Check if this is an attribute filter
      Attribute? attribute = concept.getAttribute<Attribute>(key);
      if (attribute != null) {
        // We found an attribute - check value type compatibility
        var value = getParameters()[key];
        if (value != null && attribute.type != null) {
          if (!attribute.type!.isCompatibleWith(value)) {
            return false;
          }
        }
      }
    }
    return true;
  }
} 