part of ednet_core;

/// Provides a fluent API for building queries.
///
/// The [QueryBuilder] class simplifies the construction of complex queries
/// by providing a fluent, chainable interface. It supports building attribute
/// filters, relationship traversals, and logical combinations.
///
/// Example usage:
/// ```dart
/// final query = QueryBuilder.forConcept(productConcept, 'FindProducts')
///   .where('price').lessThan(100)
///   .and('name').contains('laptop')
///   .andWhere('category', RelationshipType.parent)
///     .where('name').equals('electronics')
///   .orderBy('price')
///   .paginate(1, 20)
///   .build();
/// ```
class QueryBuilder {
  /// The concept being queried.
  final Concept _concept;
  
  /// The name of the query.
  final String _name;
  
  /// The current expression being built.
  QueryExpression? _expression;
  
  /// Additional query parameters.
  final Map<String, dynamic> _parameters = {};
  
  /// Creates a new query builder for the specified concept.
  ///
  /// Parameters:
  /// - [concept]: The concept to query
  /// - [name]: The name of the query
  QueryBuilder.forConcept(this._concept, this._name);
  
  /// Starts an attribute filter clause.
  ///
  /// This method begins a filter on the specified attribute.
  ///
  /// Parameters:
  /// - [attributeCode]: The attribute to filter on
  ///
  /// Returns an attribute filter builder for chaining.
  AttributeFilterBuilder where(String attributeCode) {
    return AttributeFilterBuilder(this, attributeCode);
  }
  
  /// Starts a relationship traversal clause.
  ///
  /// This method begins a filter on entities related to the current entity.
  ///
  /// Parameters:
  /// - [relationshipCode]: The relationship to traverse
  /// - [relationshipType]: The type of relationship (parent or child)
  ///
  /// Returns a relationship builder for chaining.
  RelationshipBuilder whereRelated(String relationshipCode, RelationshipType relationshipType) {
    return RelationshipBuilder(this, relationshipCode, relationshipType);
  }
  
  /// Adds a sort clause to the query.
  ///
  /// Parameters:
  /// - [attributeCode]: The attribute to sort by
  /// - [ascending]: Whether to sort in ascending order
  ///
  /// Returns this builder for chaining.
  QueryBuilder orderBy(String attributeCode, {bool ascending = true}) {
    _parameters['sortBy'] = attributeCode;
    _parameters['sortDirection'] = ascending ? 'asc' : 'desc';
    return this;
  }
  
  /// Adds pagination to the query.
  ///
  /// Parameters:
  /// - [page]: The page number to retrieve (1-based)
  /// - [pageSize]: The number of items per page
  ///
  /// Returns this builder for chaining.
  QueryBuilder paginate(int page, int pageSize) {
    _parameters['page'] = page;
    _parameters['pageSize'] = pageSize;
    return this;
  }
  
  /// Sets the current expression.
  ///
  /// This is an internal method used by the filter builders.
  ///
  /// Parameters:
  /// - [expression]: The expression to set
  void _setExpression(QueryExpression expression) {
    if (_expression == null) {
      _expression = expression;
    } else {
      _expression = LogicalExpression(_expression!, expression, LogicalOperator.and);
    }
  }
  
  /// Adds a logical AND with another filter.
  ///
  /// This method adds an AND clause to the query and starts a new attribute filter.
  ///
  /// Parameters:
  /// - [attributeCode]: The attribute to filter on
  ///
  /// Returns an attribute filter builder for chaining.
  AttributeFilterBuilder and(String attributeCode) {
    return AttributeFilterBuilder(this, attributeCode, isAnd: true);
  }
  
  /// Adds a logical OR with another filter.
  ///
  /// This method adds an OR clause to the query and starts a new attribute filter.
  ///
  /// Parameters:
  /// - [attributeCode]: The attribute to filter on
  ///
  /// Returns an attribute filter builder for chaining.
  AttributeFilterBuilder or(String attributeCode) {
    return AttributeFilterBuilder(this, attributeCode, isOr: true);
  }
  
  /// Adds a logical AND with a relationship filter.
  ///
  /// This method adds an AND clause to the query and starts a relationship traversal.
  ///
  /// Parameters:
  /// - [relationshipCode]: The relationship to traverse
  /// - [relationshipType]: The type of relationship
  ///
  /// Returns a relationship builder for chaining.
  RelationshipBuilder andWhere(String relationshipCode, RelationshipType relationshipType) {
    return RelationshipBuilder(this, relationshipCode, relationshipType, isAnd: true);
  }
  
  /// Adds a logical OR with a relationship filter.
  ///
  /// This method adds an OR clause to the query and starts a relationship traversal.
  ///
  /// Parameters:
  /// - [relationshipCode]: The relationship to traverse
  /// - [relationshipType]: The type of relationship
  ///
  /// Returns a relationship builder for chaining.
  RelationshipBuilder orWhere(String relationshipCode, RelationshipType relationshipType) {
    return RelationshipBuilder(this, relationshipCode, relationshipType, isOr: true);
  }
  
  /// Builds the final query.
  ///
  /// This method creates an [ExpressionQuery] from the built expression
  /// and parameters.
  ///
  /// Returns the built query.
  ExpressionQuery build() {
    if (_expression == null) {
      // If no expression has been set, create a default that matches everything
      _expression = ConstantExpression(true);
    }
    
    return ExpressionQuery(_name, _concept, _expression!, _parameters);
  }
}

/// Builder for attribute filters.
///
/// This class provides methods for filtering on attribute values
/// with various comparison operators.
class AttributeFilterBuilder {
  /// The parent query builder.
  final QueryBuilder _parent;
  
  /// The attribute code to filter on.
  final String _attributeCode;
  
  /// Whether this is part of an AND clause.
  final bool _isAnd;
  
  /// Whether this is part of an OR clause.
  final bool _isOr;
  
  /// Creates a new attribute filter builder.
  ///
  /// Parameters:
  /// - [parent]: The parent query builder
  /// - [attributeCode]: The attribute to filter on
  /// - [isAnd]: Whether this is part of an AND clause
  /// - [isOr]: Whether this is part of an OR clause
  AttributeFilterBuilder(
    this._parent,
    this._attributeCode, {
    bool isAnd = false,
    bool isOr = false,
  })  : _isAnd = isAnd,
        _isOr = isOr;
  
  /// Helper method to add an expression to the parent builder.
  ///
  /// This method creates an attribute expression and adds it to the
  /// parent query builder with the appropriate logical operator.
  ///
  /// Parameters:
  /// - [operator]: The comparison operator
  /// - [value]: The value to compare against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder _addExpression(ComparisonOperator operator, dynamic value) {
    final expression = AttributeExpression(_attributeCode, operator, value);
    
    if (_isAnd) {
      _parent._setExpression(LogicalExpression(_parent._expression!, expression, LogicalOperator.and));
    } else if (_isOr) {
      _parent._setExpression(LogicalExpression(_parent._expression!, expression, LogicalOperator.or));
    } else {
      _parent._setExpression(expression);
    }
    
    return _parent;
  }
  
  /// Adds an equals filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder equals(dynamic value) {
    return _addExpression(ComparisonOperator.equals, value);
  }
  
  /// Adds a not equals filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder notEquals(dynamic value) {
    return _addExpression(ComparisonOperator.notEquals, value);
  }
  
  /// Adds a greater than filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder greaterThan(dynamic value) {
    return _addExpression(ComparisonOperator.greaterThan, value);
  }
  
  /// Adds a greater than or equal filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder greaterThanOrEqual(dynamic value) {
    return _addExpression(ComparisonOperator.greaterThanOrEqual, value);
  }
  
  /// Adds a less than filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder lessThan(dynamic value) {
    return _addExpression(ComparisonOperator.lessThan, value);
  }
  
  /// Adds a less than or equal filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder lessThanOrEqual(dynamic value) {
    return _addExpression(ComparisonOperator.lessThanOrEqual, value);
  }
  
  /// Adds a contains filter for string attributes.
  ///
  /// Parameters:
  /// - [value]: The substring to check for
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder contains(String value) {
    return _addExpression(ComparisonOperator.contains, value);
  }
  
  /// Adds a starts with filter for string attributes.
  ///
  /// Parameters:
  /// - [value]: The prefix to check for
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder startsWith(String value) {
    return _addExpression(ComparisonOperator.startsWith, value);
  }
  
  /// Adds an ends with filter for string attributes.
  ///
  /// Parameters:
  /// - [value]: The suffix to check for
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder endsWith(String value) {
    return _addExpression(ComparisonOperator.endsWith, value);
  }
  
  /// Adds a null check filter.
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder isNull() {
    return _addExpression(ComparisonOperator.isNull, null);
  }
  
  /// Adds a not null check filter.
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder isNotNull() {
    return _addExpression(ComparisonOperator.isNotNull, null);
  }
  
  /// Adds an in list filter.
  ///
  /// Parameters:
  /// - [values]: The list of values to check against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder inList(List<dynamic> values) {
    return _addExpression(ComparisonOperator.inList, values);
  }
  
  /// Adds a not in list filter.
  ///
  /// Parameters:
  /// - [values]: The list of values to check against
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder notInList(List<dynamic> values) {
    return _addExpression(ComparisonOperator.notInList, values);
  }
  
  /// Adds a between filter.
  ///
  /// Parameters:
  /// - [min]: The minimum value (inclusive)
  /// - [max]: The maximum value (inclusive)
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder between(dynamic min, dynamic max) {
    return _addExpression(ComparisonOperator.between, [min, max]);
  }
}

/// Builder for relationship filters.
///
/// This class provides methods for filtering entities based on
/// their relationships with other entities.
class RelationshipBuilder {
  /// The parent query builder.
  final QueryBuilder _parent;
  
  /// The relationship code to traverse.
  final String _relationshipCode;
  
  /// The type of relationship.
  final RelationshipType _relationshipType;
  
  /// Whether this is part of an AND clause.
  final bool _isAnd;
  
  /// Whether this is part of an OR clause.
  final bool _isOr;
  
  /// The current nested expression being built.
  QueryExpression? _nestedExpression;
  
  /// Creates a new relationship builder.
  ///
  /// Parameters:
  /// - [parent]: The parent query builder
  /// - [relationshipCode]: The relationship to traverse
  /// - [relationshipType]: The type of relationship
  /// - [isAnd]: Whether this is part of an AND clause
  /// - [isOr]: Whether this is part of an OR clause
  RelationshipBuilder(
    this._parent,
    this._relationshipCode,
    this._relationshipType, {
    bool isAnd = false,
    bool isOr = false,
  })  : _isAnd = isAnd,
        _isOr = isOr;
  
  /// Helper method to set a nested expression.
  ///
  /// This method stores a nested expression for use in the relationship.
  ///
  /// Parameters:
  /// - [expression]: The expression to set
  void _setNestedExpression(QueryExpression expression) {
    if (_nestedExpression == null) {
      _nestedExpression = expression;
    } else {
      _nestedExpression = LogicalExpression(_nestedExpression!, expression, LogicalOperator.and);
    }
  }
  
  /// Finalizes the relationship expression and adds it to the parent builder.
  ///
  /// This method creates a relationship expression from the nested expression
  /// and adds it to the parent query builder.
  ///
  /// Returns the parent query builder.
  QueryBuilder _finalize() {
    if (_nestedExpression == null) {
      // If no nested expression, create a default that matches everything
      _nestedExpression = ConstantExpression(true);
    }
    
    final relationshipExpression = RelationshipExpression(
      _relationshipCode,
      _relationshipType,
      _nestedExpression!
    );
    
    if (_isAnd) {
      _parent._setExpression(LogicalExpression(_parent._expression!, relationshipExpression, LogicalOperator.and));
    } else if (_isOr) {
      _parent._setExpression(LogicalExpression(_parent._expression!, relationshipExpression, LogicalOperator.or));
    } else {
      _parent._setExpression(relationshipExpression);
    }
    
    return _parent;
  }
  
  /// Starts an attribute filter on the related entity.
  ///
  /// Parameters:
  /// - [attributeCode]: The attribute to filter on
  ///
  /// Returns a nested attribute filter builder.
  NestedAttributeFilterBuilder where(String attributeCode) {
    return NestedAttributeFilterBuilder(this, attributeCode);
  }
  
  /// Adds a nested relationship filter.
  ///
  /// This method allows traversing multiple relationships in a chain.
  ///
  /// Parameters:
  /// - [relationshipCode]: The relationship to traverse
  /// - [relationshipType]: The type of relationship
  ///
  /// Returns a nested relationship builder.
  NestedRelationshipBuilder andRelated(String relationshipCode, RelationshipType relationshipType) {
    return NestedRelationshipBuilder(this, relationshipCode, relationshipType);
  }
  
  /// Adds a logical AND with another attribute filter.
  ///
  /// Parameters:
  /// - [attributeCode]: The attribute to filter on
  ///
  /// Returns a nested attribute filter builder.
  NestedAttributeFilterBuilder and(String attributeCode) {
    return NestedAttributeFilterBuilder(this, attributeCode, isAnd: true);
  }
  
  /// Adds a logical OR with another attribute filter.
  ///
  /// Parameters:
  /// - [attributeCode]: The attribute to filter on
  ///
  /// Returns a nested attribute filter builder.
  NestedAttributeFilterBuilder or(String attributeCode) {
    return NestedAttributeFilterBuilder(this, attributeCode, isOr: true);
  }
  
  /// Completes the relationship filter and returns to the parent builder.
  ///
  /// Returns the parent query builder for chaining.
  QueryBuilder end() {
    return _finalize();
  }
}

/// Builder for nested attribute filters within a relationship.
///
/// This class provides methods for filtering attributes of related entities.
class NestedAttributeFilterBuilder {
  /// The parent relationship builder.
  final RelationshipBuilder _parent;
  
  /// The attribute code to filter on.
  final String _attributeCode;
  
  /// Whether this is part of an AND clause.
  final bool _isAnd;
  
  /// Whether this is part of an OR clause.
  final bool _isOr;
  
  /// Creates a new nested attribute filter builder.
  ///
  /// Parameters:
  /// - [parent]: The parent relationship builder
  /// - [attributeCode]: The attribute to filter on
  /// - [isAnd]: Whether this is part of an AND clause
  /// - [isOr]: Whether this is part of an OR clause
  NestedAttributeFilterBuilder(
    this._parent,
    this._attributeCode, {
    bool isAnd = false,
    bool isOr = false,
  })  : _isAnd = isAnd,
        _isOr = isOr;
  
  /// Helper method to add an expression to the parent relationship builder.
  ///
  /// This method creates an attribute expression and adds it to the
  /// parent relationship builder with the appropriate logical operator.
  ///
  /// Parameters:
  /// - [operator]: The comparison operator
  /// - [value]: The value to compare against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder _addExpression(ComparisonOperator operator, dynamic value) {
    final expression = AttributeExpression(_attributeCode, operator, value);
    
    if (_isAnd) {
      final parentExpr = _parent._nestedExpression;
      if (parentExpr != null) {
        _parent._setNestedExpression(LogicalExpression(parentExpr, expression, LogicalOperator.and));
      } else {
        _parent._setNestedExpression(expression);
      }
    } else if (_isOr) {
      final parentExpr = _parent._nestedExpression;
      if (parentExpr != null) {
        _parent._setNestedExpression(LogicalExpression(parentExpr, expression, LogicalOperator.or));
      } else {
        _parent._setNestedExpression(expression);
      }
    } else {
      _parent._setNestedExpression(expression);
    }
    
    return _parent;
  }
  
  /// Adds an equals filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder equals(dynamic value) {
    return _addExpression(ComparisonOperator.equals, value);
  }
  
  /// Adds a not equals filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder notEquals(dynamic value) {
    return _addExpression(ComparisonOperator.notEquals, value);
  }
  
  /// Adds a greater than filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder greaterThan(dynamic value) {
    return _addExpression(ComparisonOperator.greaterThan, value);
  }
  
  /// Adds a greater than or equal filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder greaterThanOrEqual(dynamic value) {
    return _addExpression(ComparisonOperator.greaterThanOrEqual, value);
  }
  
  /// Adds a less than filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder lessThan(dynamic value) {
    return _addExpression(ComparisonOperator.lessThan, value);
  }
  
  /// Adds a less than or equal filter.
  ///
  /// Parameters:
  /// - [value]: The value to compare against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder lessThanOrEqual(dynamic value) {
    return _addExpression(ComparisonOperator.lessThanOrEqual, value);
  }
  
  /// Adds a contains filter for string attributes.
  ///
  /// Parameters:
  /// - [value]: The substring to check for
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder contains(String value) {
    return _addExpression(ComparisonOperator.contains, value);
  }
  
  /// Adds a starts with filter for string attributes.
  ///
  /// Parameters:
  /// - [value]: The prefix to check for
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder startsWith(String value) {
    return _addExpression(ComparisonOperator.startsWith, value);
  }
  
  /// Adds an ends with filter for string attributes.
  ///
  /// Parameters:
  /// - [value]: The suffix to check for
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder endsWith(String value) {
    return _addExpression(ComparisonOperator.endsWith, value);
  }
  
  /// Adds a null check filter.
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder isNull() {
    return _addExpression(ComparisonOperator.isNull, null);
  }
  
  /// Adds a not null check filter.
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder isNotNull() {
    return _addExpression(ComparisonOperator.isNotNull, null);
  }
  
  /// Adds an in list filter.
  ///
  /// Parameters:
  /// - [values]: The list of values to check against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder inList(List<dynamic> values) {
    return _addExpression(ComparisonOperator.inList, values);
  }
  
  /// Adds a not in list filter.
  ///
  /// Parameters:
  /// - [values]: The list of values to check against
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder notInList(List<dynamic> values) {
    return _addExpression(ComparisonOperator.notInList, values);
  }
  
  /// Adds a between filter.
  ///
  /// Parameters:
  /// - [min]: The minimum value (inclusive)
  /// - [max]: The maximum value (inclusive)
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder between(dynamic min, dynamic max) {
    return _addExpression(ComparisonOperator.between, [min, max]);
  }
}

/// Builder for nested relationship traversals.
///
/// This class provides methods for traversing relationships of related entities.
class NestedRelationshipBuilder {
  /// The parent relationship builder.
  final RelationshipBuilder _parent;
  
  /// The relationship code to traverse.
  final String _relationshipCode;
  
  /// The type of relationship.
  final RelationshipType _relationshipType;
  
  /// The nested expression being built.
  QueryExpression? _nestedExpression;
  
  /// Creates a new nested relationship builder.
  ///
  /// Parameters:
  /// - [parent]: The parent relationship builder
  /// - [relationshipCode]: The relationship to traverse
  /// - [relationshipType]: The type of relationship
  NestedRelationshipBuilder(
    this._parent,
    this._relationshipCode,
    this._relationshipType
  );
  
  /// Helper method to set a nested expression.
  ///
  /// This method stores a nested expression for use in the relationship.
  ///
  /// Parameters:
  /// - [expression]: The expression to set
  void _setNestedExpression(QueryExpression expression) {
    if (_nestedExpression == null) {
      _nestedExpression = expression;
    } else {
      _nestedExpression = LogicalExpression(_nestedExpression!, expression, LogicalOperator.and);
    }
  }
  
  /// Finalizes the nested relationship expression and adds it to the parent builder.
  ///
  /// This method creates a relationship expression from the nested expression
  /// and adds it to the parent relationship builder.
  ///
  /// Returns the parent relationship builder.
  RelationshipBuilder _finalize() {
    if (_nestedExpression == null) {
      // If no nested expression, create a default that matches everything
      _nestedExpression = ConstantExpression(true);
    }
    
    final relationshipExpression = RelationshipExpression(
      _relationshipCode,
      _relationshipType,
      _nestedExpression!
    );
    
    _parent._setNestedExpression(relationshipExpression);
    
    return _parent;
  }
  
  /// Starts an attribute filter on the related entity.
  ///
  /// Parameters:
  /// - [attributeCode]: The attribute to filter on
  ///
  /// Returns a nested attribute filter builder.
  NestedAttributeFilterBuilder where(String attributeCode) {
    return NestedAttributeFilterBuilder(this, attributeCode);
  }
  
  /// Completes the nested relationship filter and returns to the parent builder.
  ///
  /// Returns the parent relationship builder for chaining.
  RelationshipBuilder end() {
    return _finalize();
  }
}

/// Extension on NestedAttributeFilterBuilder to redirect methods to the nested relationship builder.
extension NestedAttributeFilterBuilderExtension on NestedAttributeFilterBuilder {
  /// Redirects the _addExpression method to work with a NestedRelationshipBuilder.
  ///
  /// This extension allows the same fluent API to be used with nested relationship traversals.
  RelationshipBuilder _addExpression(ComparisonOperator operator, dynamic value) {
    final expression = AttributeExpression(_attributeCode, operator, value);
    
    if (_parent is NestedRelationshipBuilder) {
      final nestedParent = _parent as NestedRelationshipBuilder;
      
      if (_isAnd) {
        final parentExpr = nestedParent._nestedExpression;
        if (parentExpr != null) {
          nestedParent._setNestedExpression(LogicalExpression(parentExpr, expression, LogicalOperator.and));
        } else {
          nestedParent._setNestedExpression(expression);
        }
      } else if (_isOr) {
        final parentExpr = nestedParent._nestedExpression;
        if (parentExpr != null) {
          nestedParent._setNestedExpression(LogicalExpression(parentExpr, expression, LogicalOperator.or));
        } else {
          nestedParent._setNestedExpression(expression);
        }
      } else {
        nestedParent._setNestedExpression(expression);
      }
      
      return nestedParent;
    }
    
    return _parent;
  }
} 