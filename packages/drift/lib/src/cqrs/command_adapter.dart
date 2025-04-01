part of cqrs_drift;

/// Adapter for translating EDNet Core commands to Drift database operations.
///
/// This class converts domain model command objects to Drift SQL operations,
/// bridging the gap between the domain and persistence layers.
///
/// It supports:
/// - Converting entity commands to INSERT/UPDATE/DELETE operations
/// - Transaction management
/// - Event tracking
///
/// Example usage:
/// ```dart
/// final adapter = DriftCommandAdapter(driftDatabase);
/// final result = await adapter.executeCommand(command);
/// ```
class DriftCommandAdapter {
  /// The Drift database instance
  final EDNetDriftDatabase _db;
  
  /// Creates a new command adapter for the given database.
  ///
  /// [database] is the Drift database to execute commands against.
  DriftCommandAdapter(this._db);
  
  /// Executes a domain command against the Drift database.
  ///
  /// This method translates the domain command to an appropriate
  /// Drift SQL operation, executes it, and returns the result.
  ///
  /// [command] is the domain command to execute.
  ///
  /// Returns a Future with the command result.
  Future<app.CommandResult> executeCommand(app.ICommand command) async {
    // Get the command type to determine the operation
    final commandType = command.runtimeType.toString();
    
    try {
      // Wrap the operation in a transaction
      return await _db.transaction(() async {
        // Handle different command types
        if (commandType.contains('Add') || commandType.contains('Create')) {
          return await _handleAddCommand(command);
        } else if (commandType.contains('Update') || commandType.contains('Set')) {
          return await _handleUpdateCommand(command);
        } else if (commandType.contains('Remove') || commandType.contains('Delete')) {
          return await _handleRemoveCommand(command);
        } else {
          // For custom commands, extract the entity and determine the operation
          return await _handleCustomCommand(command);
        }
      });
    } catch (e) {
      return app.CommandResult.failure('Command execution failed: $e');
    }
  }
  
  /// Handles an add/create command.
  ///
  /// [command] is the command to handle.
  ///
  /// Returns a Future with the command result.
  Future<app.CommandResult> _handleAddCommand(app.ICommand command) async {
    // Extract the entity from the command
    final entity = _extractEntityFromCommand(command);
    if (entity == null) {
      return app.CommandResult.failure('No entity provided for add command');
    }
    
    final concept = entity.concept;
    final tableName = concept.code.toLowerCase();
    
    // Build the INSERT statement
    final columns = <String>[];
    final placeholders = <String>[];
    final variables = <Variable>[];
    
    // Add columns and values for each attribute
    for (final attribute in concept.attributes.whereType<Attribute>()) {
      final value = entity.getAttribute(attribute.code);
      if (value != null || attribute.required) {
        columns.add(attribute.code);
        placeholders.add('?');
        variables.add(Variable(_convertValueForDatabase(value, attribute)));
      }
    }
    
    // Timestamp handling
    if (entity.whenAdded != null) {
      columns.add('whenAdded');
      placeholders.add('?');
      variables.add(Variable(_convertValueForDatabase(entity.whenAdded, null)));
    }
    
    if (entity.whenSet != null) {
      columns.add('whenSet');
      placeholders.add('?');
      variables.add(Variable(_convertValueForDatabase(entity.whenSet, null)));
    }
    
    // Build and execute the insert statement
    if (columns.isNotEmpty) {
      final sql = 'INSERT INTO $tableName (${columns.join(', ')}) VALUES (${placeholders.join(', ')})';
      final id = await _db.customInsert(sql, variables: variables);
      
      // Signal that the table has been modified
      _db.markTableAsModified(tableName, UpdateKind.insert);
      
      return app.CommandResult.success(data: {'id': id});
    } else {
      return app.CommandResult.failure('No columns to insert');
    }
  }
  
  /// Handles an update command.
  ///
  /// [command] is the command to handle.
  ///
  /// Returns a Future with the command result.
  Future<app.CommandResult> _handleUpdateCommand(app.ICommand command) async {
    // Extract the entity from the command
    final entity = _extractEntityFromCommand(command);
    if (entity == null) {
      return app.CommandResult.failure('No entity provided for update command');
    }
    
    final concept = entity.concept;
    final tableName = concept.code.toLowerCase();
    
    // Find the primary key for the WHERE clause
    Attribute? primaryKey;
    var primaryKeyValue;
    
    for (final attribute in concept.attributes.whereType<Attribute>()) {
      if (attribute.identifier) {
        primaryKey = attribute;
        primaryKeyValue = entity.getAttribute(attribute.code);
        break;
      }
    }
    
    if (primaryKey == null || primaryKeyValue == null) {
      // If no primary key attribute, try using the OID
      primaryKey = Attribute();
      primaryKey.code = 'oid';
      primaryKeyValue = entity.oid.toString();
    }
    
    // Build the SET clause
    final setClauses = <String>[];
    final variables = <Variable>[];
    
    // Add SET expressions for each attribute
    for (final attribute in concept.attributes.whereType<Attribute>()) {
      // Skip the primary key in the SET clause
      if (attribute.code == primaryKey.code) {
        continue;
      }
      
      final value = entity.getAttribute(attribute.code);
      setClauses.add('${attribute.code} = ?');
      variables.add(Variable(_convertValueForDatabase(value, attribute)));
    }
    
    // Handle timestamps
    if (entity.whenSet != null) {
      setClauses.add('whenSet = ?');
      variables.add(Variable(_convertValueForDatabase(entity.whenSet, null)));
    }
    
    // Add primary key value for WHERE clause
    variables.add(Variable(_convertValueForDatabase(primaryKeyValue, primaryKey)));
    
    // Build and execute the update statement
    if (setClauses.isNotEmpty) {
      final sql = 'UPDATE $tableName SET ${setClauses.join(', ')} WHERE ${primaryKey.code} = ?';
      final rowsAffected = await _db.customUpdate(sql, variables: variables);
      
      // Signal that the table has been modified
      _db.markTableAsModified(tableName, UpdateKind.update);
      
      if (rowsAffected > 0) {
        return app.CommandResult.success(data: {'rowsAffected': rowsAffected});
      } else {
        return app.CommandResult.failure('No rows affected by update');
      }
    } else {
      return app.CommandResult.failure('No columns to update');
    }
  }
  
  /// Handles a remove/delete command.
  ///
  /// [command] is the command to handle.
  ///
  /// Returns a Future with the command result.
  Future<app.CommandResult> _handleRemoveCommand(app.ICommand command) async {
    // Extract the entity from the command
    final entity = _extractEntityFromCommand(command);
    if (entity == null) {
      return app.CommandResult.failure('No entity provided for remove command');
    }
    
    final concept = entity.concept;
    final tableName = concept.code.toLowerCase();
    
    // Find the primary key for the WHERE clause
    Attribute? primaryKey;
    var primaryKeyValue;
    
    for (final attribute in concept.attributes.whereType<Attribute>()) {
      if (attribute.identifier) {
        primaryKey = attribute;
        primaryKeyValue = entity.getAttribute(attribute.code);
        break;
      }
    }
    
    if (primaryKey == null || primaryKeyValue == null) {
      // If no primary key attribute, try using the OID
      primaryKey = Attribute();
      primaryKey.code = 'oid';
      primaryKeyValue = entity.oid.toString();
    }
    
    // Build and execute the delete statement
    final sql = 'DELETE FROM $tableName WHERE ${primaryKey.code} = ?';
    final rowsAffected = await _db.customUpdate(
      sql,
      variables: [Variable(_convertValueForDatabase(primaryKeyValue, primaryKey))],
    );
    
    // Signal that the table has been modified
    _db.markTableAsModified(tableName, UpdateKind.delete);
    
    if (rowsAffected > 0) {
      return app.CommandResult.success(data: {'rowsAffected': rowsAffected});
    } else {
      return app.CommandResult.failure('No rows affected by delete');
    }
  }
  
  /// Handles a custom command by determining the operation type.
  ///
  /// [command] is the command to handle.
  ///
  /// Returns a Future with the command result.
  Future<app.CommandResult> _handleCustomCommand(app.ICommand command) async {
    // Try to determine the operation type from the command
    final commandName = command.name.toLowerCase();
    
    if (commandName.contains('add') || 
        commandName.contains('create') || 
        commandName.contains('insert')) {
      return await _handleAddCommand(command);
    } else if (commandName.contains('update') || 
               commandName.contains('edit') || 
               commandName.contains('modify') ||
               commandName.contains('set')) {
      return await _handleUpdateCommand(command);
    } else if (commandName.contains('remove') || 
               commandName.contains('delete') || 
               commandName.contains('erase')) {
      return await _handleRemoveCommand(command);
    } else {
      // If we can't determine the operation, use a fallback
      return app.CommandResult.failure(
        'Unsupported command type: ${command.runtimeType}. ' +
        'Command must indicate operation type (add/update/remove).'
      );
    }
  }
  
  /// Extracts the entity from a command.
  ///
  /// This method attempts to find the entity in the command's data
  /// or parameters.
  ///
  /// [command] is the command to extract from.
  ///
  /// Returns the entity or null if not found.
  Entity<dynamic>? _extractEntityFromCommand(app.ICommand command) {
    // Try different approaches to find the entity
    
    // Check if command has a getEntity() method
    try {
      final entity = command.getEntity?.call();
      if (entity is Entity) {
        return entity;
      }
    } catch (_) {}
    
    // Check if the command has an entity property
    try {
      final entity = command.entity;
      if (entity is Entity) {
        return entity;
      }
    } catch (_) {}
    
    // Check command parameters
    final params = command.getParameters();
    
    // Look for common entity parameter names
    for (final key in ['entity', 'data', 'model', 'item']) {
      if (params.containsKey(key) && params[key] is Entity) {
        return params[key] as Entity;
      }
    }
    
    // If we still haven't found the entity, check if we have enough
    // data to create a new entity
    if (params.containsKey('concept') && params.containsKey('data')) {
      final concept = params['concept'];
      if (concept is Concept) {
        try {
          final entity = Entity<dynamic>();
          entity.concept = concept;
          
          if (params['data'] is Map) {
            final data = params['data'] as Map;
            for (var key in data.keys) {
              entity.setAttribute(key.toString(), data[key]);
            }
          }
          
          return entity;
        } catch (_) {}
      }
    }
    
    // Couldn't find or create an entity
    return null;
  }
  
  /// Converts a value for storage in the database.
  ///
  /// This method ensures that values from the domain model
  /// are correctly converted for the database.
  ///
  /// [value] is the value to convert.
  /// [attribute] is the attribute that defines the expected type.
  ///
  /// Returns the converted value suitable for SQL.
  dynamic _convertValueForDatabase(dynamic value, Attribute? attribute) {
    if (value == null) {
      return null;
    }
    
    // If we have an attribute, use its type for conversion
    if (attribute != null && attribute.type != null) {
      if (attribute.type!.code == 'DateTime' && value is DateTime) {
        // Store as milliseconds since epoch
        return value.millisecondsSinceEpoch;
      } else if (attribute.type!.code == 'bool' && value is bool) {
        // Store as integer (0/1)
        return value ? 1 : 0;
      } else if (attribute.type!.code == 'Uri' && value is Uri) {
        // Store as string
        return value.toString();
      }
    } else {
      // No attribute, use the runtime type
      if (value is DateTime) {
        return value.millisecondsSinceEpoch;
      } else if (value is bool) {
        return value ? 1 : 0;
      } else if (value is Uri) {
        return value.toString();
      }
    }
    
    // For other types, return as is
    return value;
  }
} 