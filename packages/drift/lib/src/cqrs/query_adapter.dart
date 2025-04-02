part of cqrs_drift;

/// Adapter for translating EDNet Core queries to Drift database queries.
///
/// This class converts domain model query objects to Drift SQL operations,
/// bridging the gap between the domain and persistence layers.
///
/// It supports:
/// - Converting concept-based queries to SQL statements
/// - Converting filter criteria to WHERE clauses
/// - Handling pagination and sorting
/// - Parameter type conversion
///
/// Example usage:
/// ```dart
/// final adapter = DriftQueryAdapter(driftDatabase);
/// final queryResult = await adapter.executeQuery(conceptQuery);
/// ```
class DriftQueryAdapter {
  /// The Drift database instance
  final EDNetDriftDatabase _db;
  
  /// Creates a new query adapter for the given database.
  ///
  /// [database] is the Drift database to execute queries against.
  DriftQueryAdapter(this._db);
  
  /// Executes a concept query against the Drift database.
  ///
  /// This method translates the concept query to an appropriate
  /// Drift SQL query, executes it, and returns the results as
  /// domain entities.
  ///
  /// [query] is the concept query to execute.
  ///
  /// Returns a Future with a query result containing domain entities.
  Future<model.EntityQueryResult<Entity<dynamic>>> executeQuery(model.ConceptQuery query) async {
    final concept = query.concept;
    
    // Get the table name for this concept
    final tableName = concept.code.toLowerCase();
    
    try {
      // Extract pagination parameters if present
      final page = query.getParameters()['page'] as int?;
      final pageSize = query.getParameters()['pageSize'] as int?;
      
      // Extract sorting parameters if present
      final sortBy = query.getParameters()['sortBy'] as String?;
      final sortDirection = query.getParameters()['sortDirection'] as String?;
      
      // Build the query components
      final whereClauses = <String>[];
      final variables = <Variable>[];
      
      // Apply filters from query parameters
      for (var entry in query.getParameters().entries) {
        final key = entry.key;
        final value = entry.value;
        
        // Skip pagination and sorting parameters
        if (['page', 'pageSize', 'sortBy', 'sortDirection'].contains(key)) {
          continue;
        }
        
        // Handle different filter operations (equal, like, greater than, etc.)
        // Currently supporting only equality
        whereClauses.add('$key = ?');
        variables.add(Variable(DriftValueConverter.toDatabaseValue(value)));
      }
      
      // Build the WHERE clause
      String whereClause = '';
      if (whereClauses.isNotEmpty) {
        whereClause = 'WHERE ${whereClauses.join(' AND ')}';
      }
      
      // Build the ORDER BY clause
      String orderByClause = '';
      if (sortBy != null) {
        orderByClause = 'ORDER BY $sortBy ${sortDirection == 'desc' ? 'DESC' : 'ASC'}';
      }
      
      // Handle pagination
      String limitClause = '';
      if (page != null && pageSize != null) {
        final offset = (page - 1) * pageSize;
        limitClause = 'LIMIT $pageSize OFFSET $offset';
      }
      
      // Build and execute the query for the total count (for pagination)
      int totalCount = 0;
      if (page != null && pageSize != null) {
        final countQuery = 'SELECT COUNT(*) as count FROM $tableName $whereClause';
        final countResult = await _db.customSelect(
          countQuery,
          variables: variables,
        ).getSingle();
        totalCount = countResult.read<int>('count');
      }
      
      // Build and execute the main query
      final mainQuery = 'SELECT * FROM $tableName $whereClause $orderByClause $limitClause';
      final rows = await _db.customSelect(
        mainQuery,
        variables: variables,
      ).get();
      
      // Convert rows to domain entities
      final entities = rows.map((row) => DriftValueConverter.rowToEntity(row, concept)).toList();
      
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
        'Error executing query: $e',
        concept: concept,
      );
    }
  }
  
  /// Converts a database value for use in a SQL query parameter.
  ///
  /// This method ensures that values from the domain model
  /// are correctly converted for the database.
  ///
  /// [value] is the value to convert.
  ///
  /// Returns the converted value suitable for SQL.
  /// 
  /// @deprecated Use DriftValueConverter.toDatabaseValue instead
  dynamic _convertParameterValue(dynamic value) {
    return DriftValueConverter.toDatabaseValue(value);
  }
  
  /// Converts a QueryRow to a domain entity.
  ///
  /// [row] is the database row to convert.
  /// [concept] is the concept that defines the entity structure.
  ///
  /// Returns a domain entity populated with data from the row.
  /// 
  /// @deprecated Use DriftValueConverter.rowToEntity instead
  Entity<dynamic> _rowToEntity(QueryRow row, model.Concept concept) {
    return DriftValueConverter.rowToEntity(row, concept);
  }
} 