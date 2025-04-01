part of cqrs_drift;

/// Adapter for translating EDNet expression-based queries to Drift SQL operations.
///
/// This class extends the standard query adapter with support for
/// translating the powerful expression-based query system to SQL.
///
/// Example usage:
/// ```dart
/// final adapter = DriftExpressionQueryAdapter(driftDatabase);
/// final queryResult = await adapter.executeQuery(expressionQuery);
/// ```
class DriftExpressionQueryAdapter extends DriftQueryAdapter {
  /// Creates a new expression query adapter for the given database.
  ///
  /// [database] is the Drift database to execute queries against.
  DriftExpressionQueryAdapter(EDNetDriftDatabase db) : super(db);
  
  /// Executes an expression-based query against the Drift database.
  ///
  /// This method translates the expression query to appropriate SQL,
  /// executes it, and returns the results as domain entities.
  ///
  /// [query] is the expression query to execute.
  ///
  /// Returns a Future with a query result containing domain entities.
  Future<model.EntityQueryResult<Entity<dynamic>>> executeExpressionQuery(model.ExpressionQuery query) async {
    final concept = query.concept;
    final tableName = concept.code.toLowerCase();
    
    try {
      // Extract the expression from the query
      final expression = query.getExpression();
      
      // Convert the expression to SQL WHERE clause components
      final SqlTranslationResult translationResult = _translateExpressionToSql(expression, tableName);
      
      // Extract pagination parameters
      final page = query.getParameters()['page'] as int?;
      final pageSize = query.getParameters()['pageSize'] as int?;
      
      // Extract sorting parameters
      final sortBy = query.getParameters()['sortBy'] as String?;
      final sortDirection = query.getParameters()['sortDirection'] as String?;
      
      // Build the WHERE clause
      String whereClause = '';
      if (translationResult.whereClauses.isNotEmpty) {
        whereClause = 'WHERE ${translationResult.whereClauses.join(' AND ')}';
      }
      
      // Build the ORDER BY clause
      String orderByClause = '';
      if (sortBy != null) {
        orderByClause = 'ORDER BY $sortBy ${sortDirection == 'desc' ? 'DESC' : 'ASC'}';
      }
      
      // Handle joins if needed
      String joinClauses = translationResult.joinClauses.join(' ');
      
      // Handle pagination
      String limitClause = '';
      if (page != null && pageSize != null) {
        final offset = (page - 1) * pageSize;
        limitClause = 'LIMIT $pageSize OFFSET $offset';
      }
      
      // Build and execute the query for the total count (for pagination)
      int totalCount = 0;
      if (page != null && pageSize != null) {
        final countQuery = 'SELECT COUNT(*) as count FROM $tableName $joinClauses $whereClause';
        final countResult = await _db.customSelect(
          countQuery,
          variables: translationResult.variables,
        ).getSingle();
        totalCount = countResult.read<int>('count');
      }
      
      // Build and execute the main query
      final mainQuery = 'SELECT ${tableName}.* FROM $tableName $joinClauses $whereClause $orderByClause $limitClause';
      final rows = await _db.customSelect(
        mainQuery,
        variables: translationResult.variables,
      ).get();
      
      // Convert rows to domain entities
      final entities = rows.map((row) => _rowToEntity(row, concept)).toList();
      
      // Build and return the query result
      if (page != null && pageSize != null) {
        return model.EntityQueryResult.success(
          entities,
          concept: concept,
          metadata: {
            'page': page,
            'pageSize': pageSize,
            'totalCount': totalCount,
          },
        );
      } else {
        return model.EntityQueryResult.success(
          entities,
          concept: concept,
        );
      }
    } catch (e) {
      return model.EntityQueryResult.failure(
        'Error executing expression query: $e',
        concept: concept,
      );
    }
  }
  
  /// Translates a query expression to SQL WHERE clause components.
  ///
  /// This method recursively converts the expression tree to SQL fragments,
  /// handling different expression types appropriately.
  ///
  /// [expression] is the expression to translate.
  /// [tableName] is the name of the main table being queried.
  /// [tableAlias] is an optional alias for the table in complex queries.
  ///
  /// Returns a translation result with WHERE clauses, JOIN clauses, and variables.
  SqlTranslationResult _translateExpressionToSql(
    model.QueryExpression expression,
    String tableName, {
    String? tableAlias,
  }) {
    final alias = tableAlias ?? tableName;
    
    // Handle different expression types
    if (expression is model.AttributeExpression) {
      return _translateAttributeExpression(expression, alias);
    } else if (expression is model.LogicalExpression) {
      return _translateLogicalExpression(expression, tableName, tableAlias: alias);
    } else if (expression is model.NotExpression) {
      return _translateNotExpression(expression, tableName, tableAlias: alias);
    } else if (expression is model.RelationshipExpression) {
      return _translateRelationshipExpression(expression, tableName, tableAlias: alias);
    } else if (expression is model.ConstantExpression) {
      return _translateConstantExpression(expression);
    } else if (expression is model.FunctionExpression) {
      return _translateFunctionExpression(expression, alias);
    } else {
      // Unknown expression type
      throw ArgumentError('Unsupported expression type: ${expression.runtimeType}');
    }
  }
  
  /// Translates an attribute expression to SQL.
  ///
  /// [expression] is the attribute expression to translate.
  /// [tableAlias] is the alias for the table containing the attribute.
  ///
  /// Returns a translation result with WHERE clauses and variables.
  SqlTranslationResult _translateAttributeExpression(
    model.AttributeExpression expression,
    String tableAlias,
  ) {
    final attributeCode = expression.attributeCode;
    final operator = expression.operator;
    final value = expression.value;
    
    // Build the WHERE clause for the attribute expression
    String whereClause;
    List<Variable> variables = [];
    
    switch (operator) {
      case model.ComparisonOperator.equals:
        if (value == null) {
          whereClause = '$tableAlias.$attributeCode IS NULL';
        } else {
          whereClause = '$tableAlias.$attributeCode = ?';
          variables.add(Variable(_convertParameterValue(value)));
        }
        break;
      case model.ComparisonOperator.notEquals:
        if (value == null) {
          whereClause = '$tableAlias.$attributeCode IS NOT NULL';
        } else {
          whereClause = '$tableAlias.$attributeCode != ?';
          variables.add(Variable(_convertParameterValue(value)));
        }
        break;
      case model.ComparisonOperator.greaterThan:
        whereClause = '$tableAlias.$attributeCode > ?';
        variables.add(Variable(_convertParameterValue(value)));
        break;
      case model.ComparisonOperator.greaterThanOrEqual:
        whereClause = '$tableAlias.$attributeCode >= ?';
        variables.add(Variable(_convertParameterValue(value)));
        break;
      case model.ComparisonOperator.lessThan:
        whereClause = '$tableAlias.$attributeCode < ?';
        variables.add(Variable(_convertParameterValue(value)));
        break;
      case model.ComparisonOperator.lessThanOrEqual:
        whereClause = '$tableAlias.$attributeCode <= ?';
        variables.add(Variable(_convertParameterValue(value)));
        break;
      case model.ComparisonOperator.contains:
        whereClause = '$tableAlias.$attributeCode LIKE ?';
        variables.add(Variable('%${_convertParameterValue(value)}%'));
        break;
      case model.ComparisonOperator.startsWith:
        whereClause = '$tableAlias.$attributeCode LIKE ?';
        variables.add(Variable('${_convertParameterValue(value)}%'));
        break;
      case model.ComparisonOperator.endsWith:
        whereClause = '$tableAlias.$attributeCode LIKE ?';
        variables.add(Variable('%${_convertParameterValue(value)}'));
        break;
      case model.ComparisonOperator.isNull:
        whereClause = '$tableAlias.$attributeCode IS NULL';
        break;
      case model.ComparisonOperator.isNotNull:
        whereClause = '$tableAlias.$attributeCode IS NOT NULL';
        break;
      case model.ComparisonOperator.inList:
        if (value is List && value.isNotEmpty) {
          final placeholders = List.filled(value.length, '?').join(', ');
          whereClause = '$tableAlias.$attributeCode IN ($placeholders)';
          variables.addAll(value.map((v) => Variable(_convertParameterValue(v))));
        } else {
          // An empty list in IN clause would always be false
          whereClause = '1 = 0';
        }
        break;
      case model.ComparisonOperator.notInList:
        if (value is List && value.isNotEmpty) {
          final placeholders = List.filled(value.length, '?').join(', ');
          whereClause = '$tableAlias.$attributeCode NOT IN ($placeholders)';
          variables.addAll(value.map((v) => Variable(_convertParameterValue(v))));
        } else {
          // An empty list in NOT IN clause would always be true
          whereClause = '1 = 1';
        }
        break;
      case model.ComparisonOperator.between:
        if (value is List && value.length == 2) {
          whereClause = '$tableAlias.$attributeCode BETWEEN ? AND ?';
          variables.add(Variable(_convertParameterValue(value[0])));
          variables.add(Variable(_convertParameterValue(value[1])));
        } else {
          throw ArgumentError('BETWEEN operator requires a list of two values');
        }
        break;
      default:
        throw ArgumentError('Unsupported operator: $operator');
    }
    
    return SqlTranslationResult(
      whereClauses: [whereClause],
      variables: variables,
      joinClauses: [],
    );
  }
  
  /// Translates a logical expression to SQL.
  ///
  /// This method combines the SQL fragments from the left and right expressions
  /// with the appropriate logical operator.
  ///
  /// [expression] is the logical expression to translate.
  /// [tableName] is the name of the main table being queried.
  /// [tableAlias] is an optional alias for the table.
  ///
  /// Returns a translation result with combined WHERE clauses, JOINs, and variables.
  SqlTranslationResult _translateLogicalExpression(
    model.LogicalExpression expression,
    String tableName, {
    String? tableAlias,
  }) {
    // Translate the left and right expressions
    final leftResult = _translateExpressionToSql(expression.left, tableName, tableAlias: tableAlias);
    final rightResult = _translateExpressionToSql(expression.right, tableName, tableAlias: tableAlias);
    
    // Combine the WHERE clauses with the appropriate operator
    List<String> combinedWhereClauses = [];
    
    if (leftResult.whereClauses.isNotEmpty && rightResult.whereClauses.isNotEmpty) {
      final leftClause = leftResult.whereClauses.join(' AND ');
      final rightClause = rightResult.whereClauses.join(' AND ');
      
      if (expression.operator == model.LogicalOperator.and) {
        combinedWhereClauses.add('($leftClause) AND ($rightClause)');
      } else if (expression.operator == model.LogicalOperator.or) {
        combinedWhereClauses.add('($leftClause) OR ($rightClause)');
      }
    } else if (leftResult.whereClauses.isNotEmpty) {
      combinedWhereClauses.addAll(leftResult.whereClauses);
    } else if (rightResult.whereClauses.isNotEmpty) {
      combinedWhereClauses.addAll(rightResult.whereClauses);
    }
    
    // Combine the variables
    final combinedVariables = [...leftResult.variables, ...rightResult.variables];
    
    // Combine the JOIN clauses (deduplicating)
    final joinSet = <String>{...leftResult.joinClauses, ...rightResult.joinClauses};
    final combinedJoinClauses = joinSet.toList();
    
    return SqlTranslationResult(
      whereClauses: combinedWhereClauses,
      variables: combinedVariables,
      joinClauses: combinedJoinClauses,
    );
  }
  
  /// Translates a NOT expression to SQL.
  ///
  /// This method negates the SQL fragment from the inner expression.
  ///
  /// [expression] is the NOT expression to translate.
  /// [tableName] is the name of the main table being queried.
  /// [tableAlias] is an optional alias for the table.
  ///
  /// Returns a translation result with negated WHERE clauses.
  SqlTranslationResult _translateNotExpression(
    model.NotExpression expression,
    String tableName, {
    String? tableAlias,
  }) {
    // Translate the inner expression
    final innerResult = _translateExpressionToSql(expression.expression, tableName, tableAlias: tableAlias);
    
    // Negate the WHERE clauses
    List<String> negatedWhereClauses = [];
    
    if (innerResult.whereClauses.isNotEmpty) {
      final innerClause = innerResult.whereClauses.join(' AND ');
      negatedWhereClauses.add('NOT ($innerClause)');
    }
    
    return SqlTranslationResult(
      whereClauses: negatedWhereClauses,
      variables: innerResult.variables,
      joinClauses: innerResult.joinClauses,
    );
  }
  
  /// Translates a relationship expression to SQL with JOINs.
  ///
  /// This method adds a JOIN clause for the relationship and 
  /// applies the inner expression to the joined table.
  ///
  /// [expression] is the relationship expression to translate.
  /// [tableName] is the name of the main table being queried.
  /// [tableAlias] is an optional alias for the table.
  ///
  /// Returns a translation result with JOIN clauses and relationship filtering.
  SqlTranslationResult _translateRelationshipExpression(
    model.RelationshipExpression expression,
    String tableName, {
    String? tableAlias,
  }) {
    final relationshipCode = expression.relationshipCode;
    final relationshipType = expression.relationshipType;
    final alias = tableAlias ?? tableName;
    
    // Determine the related table name and join type
    String relatedTableName;
    String joinType;
    String parentColumn;
    String childColumn;
    
    if (relationshipType == model.RelationshipType.parent) {
      // For parent relationships, we join to the parent table
      relatedTableName = relationshipCode.toLowerCase();
      joinType = 'LEFT JOIN';
      parentColumn = 'id'; // Assuming parent's primary key is 'id'
      childColumn = '${relationshipCode}_id'; // Foreign key in the child table
    } else {
      // For child relationships, we join to the child table
      relatedTableName = relationshipCode.toLowerCase();
      joinType = 'LEFT JOIN';
      parentColumn = 'id'; // Assuming parent's primary key is 'id'
      childColumn = '${tableName}_id'; // Foreign key in the child table
    }
    
    // Create a unique alias for the related table to avoid conflicts in nested joins
    final relatedTableAlias = '${relatedTableName}_${_getNextAliasId()}';
    
    // Build the JOIN clause
    String joinClause;
    
    if (relationshipType == model.RelationshipType.parent) {
      joinClause = '$joinType $relatedTableName AS $relatedTableAlias ON $alias.$childColumn = $relatedTableAlias.$parentColumn';
    } else {
      joinClause = '$joinType $relatedTableName AS $relatedTableAlias ON $alias.$parentColumn = $relatedTableAlias.$childColumn';
    }
    
    // Translate the inner expression for the related table
    final innerResult = _translateExpressionToSql(expression.expression, relatedTableName, tableAlias: relatedTableAlias);
    
    // Combine the JOIN clauses (adding our new join)
    final combinedJoinClauses = [joinClause, ...innerResult.joinClauses];
    
    // If it's a child relationship with multiple records, we need to handle EXISTS
    List<String> whereClauses = [];
    if (relationshipType == model.RelationshipType.child && innerResult.whereClauses.isNotEmpty) {
      final innerClause = innerResult.whereClauses.join(' AND ');
      whereClauses.add('EXISTS (SELECT 1 FROM $relatedTableName WHERE $innerClause AND ${tableName}_id = $alias.id)');
    } else {
      whereClauses.addAll(innerResult.whereClauses);
    }
    
    return SqlTranslationResult(
      whereClauses: whereClauses,
      variables: innerResult.variables,
      joinClauses: combinedJoinClauses,
    );
  }
  
  /// Translates a constant expression to SQL.
  ///
  /// [expression] is the constant expression to translate.
  ///
  /// Returns a translation result with a fixed WHERE clause.
  SqlTranslationResult _translateConstantExpression(model.ConstantExpression expression) {
    return SqlTranslationResult(
      whereClauses: expression.value ? ['1 = 1'] : ['1 = 0'],
      variables: [],
      joinClauses: [],
    );
  }
  
  /// Translates a function expression to SQL.
  ///
  /// This method converts function-based expressions to SQL functions.
  ///
  /// [expression] is the function expression to translate.
  /// [tableAlias] is the alias for the table containing the attribute.
  ///
  /// Returns a translation result with function-based WHERE clauses.
  SqlTranslationResult _translateFunctionExpression(
    model.FunctionExpression expression,
    String tableAlias,
  ) {
    final attributeCode = expression.attributeCode;
    final functionName = expression.functionName;
    final parameters = expression.parameters;
    
    String whereClause;
    List<Variable> variables = [];
    
    switch (functionName) {
      case 'currentMonth':
        whereClause = "strftime('%Y-%m', $tableAlias.$attributeCode) = strftime('%Y-%m', 'now')";
        break;
      case 'lastNDays':
        if (parameters.containsKey('days')) {
          final days = parameters['days'] as int;
          whereClause = "julianday('now') - julianday($tableAlias.$attributeCode) <= ?";
          variables.add(Variable(days));
        } else {
          throw ArgumentError('lastNDays function requires a "days" parameter');
        }
        break;
      case 'length':
        if (parameters.containsKey('operator') && parameters.containsKey('value')) {
          final op = model.ComparisonOperator.fromString(parameters['operator']);
          final value = parameters['value'] as int;
          
          String sqlOperator;
          switch (op) {
            case model.ComparisonOperator.equals:
              sqlOperator = '=';
              break;
            case model.ComparisonOperator.notEquals:
              sqlOperator = '!=';
              break;
            case model.ComparisonOperator.greaterThan:
              sqlOperator = '>';
              break;
            case model.ComparisonOperator.greaterThanOrEqual:
              sqlOperator = '>=';
              break;
            case model.ComparisonOperator.lessThan:
              sqlOperator = '<';
              break;
            case model.ComparisonOperator.lessThanOrEqual:
              sqlOperator = '<=';
              break;
            default:
              throw ArgumentError('Unsupported operator for length: $op');
          }
          
          whereClause = "length($tableAlias.$attributeCode) $sqlOperator ?";
          variables.add(Variable(value));
        } else {
          throw ArgumentError('length function requires "operator" and "value" parameters');
        }
        break;
      default:
        throw ArgumentError('Unsupported function: $functionName');
    }
    
    return SqlTranslationResult(
      whereClauses: [whereClause],
      variables: variables,
      joinClauses: [],
    );
  }
  
  // Counter for generating unique table aliases in complex queries
  int _aliasCounter = 0;
  
  /// Gets the next unique alias ID.
  ///
  /// Returns a unique integer for alias generation.
  int _getNextAliasId() {
    return _aliasCounter++;
  }
}

/// Represents the result of translating an expression to SQL components.
///
/// This class encapsulates the WHERE clauses, JOIN clauses, and variables
/// generated from translating a query expression to SQL.
class SqlTranslationResult {
  /// The WHERE clauses generated from the expression.
  final List<String> whereClauses;
  
  /// The variables to bind to the SQL query.
  final List<Variable> variables;
  
  /// The JOIN clauses needed for relationship traversal.
  final List<String> joinClauses;
  
  /// Creates a new SQL translation result.
  ///
  /// [whereClauses] are the WHERE clauses generated from the expression.
  /// [variables] are the variables to bind to the SQL query.
  /// [joinClauses] are the JOIN clauses needed for relationship traversal.
  SqlTranslationResult({
    required this.whereClauses,
    required this.variables,
    required this.joinClauses,
  });
} 