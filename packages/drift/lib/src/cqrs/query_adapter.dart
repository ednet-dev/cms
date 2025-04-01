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
        variables.add(Variable(_convertParameterValue(value)));
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
        'Error executing query: $e',
        concept: concept,
      );
    }
  }
  
  /// Converts a Drift query result row to a domain entity.
  ///
  /// [row] is the database row to convert.
  /// [concept] is the concept that defines the entity structure.
  ///
  /// Returns a domain entity populated with data from the row.
  Entity<dynamic> _rowToEntity(QueryRow row, model.Concept concept) {
    final entity = Entity<dynamic>();
    entity.concept = concept;
    
    // Set entity data from row
    row.data.forEach((key, value) {
      // Try to find the attribute for this column
      final attribute = concept.getAttribute<Attribute>(key);
      if (attribute != null) {
        // Convert value based on attribute type if needed
        final convertedValue = _convertValueForAttribute(value, attribute);
        entity.setAttribute(key, convertedValue);
      }
    });
    
    // If the concept has timestamps and they exist in the data
    if (row.data.containsKey('whenAdded')) {
      final whenAdded = row.read<dynamic>('whenAdded');
      if (whenAdded != null) {
        entity.whenAdded = _convertToDateTime(whenAdded);
      }
    }
    
    if (row.data.containsKey('whenSet')) {
      final whenSet = row.read<dynamic>('whenSet');
      if (whenSet != null) {
        entity.whenSet = _convertToDateTime(whenSet);
      }
    }
    
    if (row.data.containsKey('whenRemoved')) {
      final whenRemoved = row.read<dynamic>('whenRemoved');
      if (whenRemoved != null) {
        entity.whenRemoved = _convertToDateTime(whenRemoved);
      }
    }
    
    return entity;
  }
  
  /// Converts a database value to the appropriate type for an attribute.
  ///
  /// This method ensures that the value retrieved from the database
  /// is of the correct type for the domain model.
  ///
  /// [value] is the value to convert.
  /// [attribute] is the attribute that defines the expected type.
  ///
  /// Returns the converted value.
  dynamic _convertValueForAttribute(dynamic value, Attribute attribute) {
    if (value == null) {
      return null;
    }
    
    if (attribute.type?.code == 'DateTime') {
      return _convertToDateTime(value);
    } else if (attribute.type?.code == 'bool') {
      return value == 1 || value == true;
    } else if (attribute.type?.code == 'int') {
      return value is int ? value : int.tryParse(value.toString());
    } else if (attribute.type?.code == 'double') {
      return value is double ? value : double.tryParse(value.toString());
    } else if (attribute.type?.code == 'Uri') {
      return value is Uri ? value : Uri.tryParse(value.toString());
    }
    
    // For other types, return as is
    return value;
  }
  
  /// Converts a parameter value for use in a SQL query.
  ///
  /// This method ensures that values from the domain model
  /// are correctly converted for the database.
  ///
  /// [value] is the value to convert.
  ///
  /// Returns the converted value suitable for SQL.
  dynamic _convertParameterValue(dynamic value) {
    if (value == null) {
      return null;
    }
    
    if (value is DateTime) {
      // Store as milliseconds since epoch
      return value.millisecondsSinceEpoch;
    } else if (value is bool) {
      // Store as integer (0/1)
      return value ? 1 : 0;
    } else if (value is Uri) {
      // Store as string
      return value.toString();
    }
    
    // For other types, return as is
    return value;
  }
  
  /// Converts a database value to a DateTime.
  ///
  /// Handles different storage formats for DateTime values.
  ///
  /// [value] is the value to convert.
  ///
  /// Returns a DateTime.
  DateTime _convertToDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    } else if (value is int) {
      // Stored as milliseconds since epoch
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      // Stored as ISO 8601 string
      return DateTime.parse(value);
    } else {
      throw ArgumentError('Cannot convert $value to DateTime');
    }
  }
} 