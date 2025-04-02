part of cqrs_drift;

/// Utilities for handling value conversions between EDNet model and Drift database.
///
/// This class centralizes all conversion logic for consistency across the library.
class DriftValueConverter {
  /// Converts a domain model value to a database value.
  ///
  /// This method ensures that values from the domain model
  /// are correctly converted for the database.
  ///
  /// [value] is the value to convert.
  /// [attribute] is the attribute that defines the expected type (optional).
  ///
  /// Returns the converted value suitable for SQL.
  static dynamic toDatabaseValue(dynamic value, [Attribute? attribute]) {
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
  
  /// Converts a database value to a domain model value.
  ///
  /// This method ensures that values from the database
  /// are correctly converted for the domain model.
  ///
  /// [value] is the value to convert.
  /// [attribute] is the attribute that defines the expected type (optional).
  ///
  /// Returns the converted value suitable for the domain model.
  static dynamic fromDatabaseValue(dynamic value, [Attribute? attribute]) {
    if (value == null) {
      return null;
    }
    
    // If we have an attribute, use its type for conversion
    if (attribute != null && attribute.type != null) {
      if (attribute.type!.code == 'DateTime') {
        return _convertToDateTime(value);
      } else if (attribute.type!.code == 'bool') {
        return value == 1 || value == true;
      } else if (attribute.type!.code == 'int') {
        return value is int ? value : int.tryParse(value.toString());
      } else if (attribute.type!.code == 'double') {
        return value is double ? value : double.tryParse(value.toString());
      } else if (attribute.type!.code == 'Uri') {
        return value is Uri ? value : Uri.tryParse(value.toString());
      }
    } else {
      // No attribute, use best guess based on runtime type
      if (value is int && value > 946684800000) { // Timestamp after 2000-01-01
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value == 0 || value == 1) {
        // Could be boolean, but hard to tell without attribute
        return value == 1;
      }
    }
    
    // For other types, return as is
    return value;
  }
  
  /// Converts a REST API parameter value to the appropriate type.
  ///
  /// This method tries to convert string values to their
  /// appropriate types (number, boolean, date, etc.).
  ///
  /// [value] is the value to convert.
  ///
  /// Returns the converted value.
  static dynamic fromRestParameter(dynamic value) {
    if (value == null) {
      return null;
    }
    
    // If it's not a string, return as is
    if (value is! String) {
      return value;
    }
    
    // Try to convert string to appropriate type
    String stringValue = value.trim();
    
    // Boolean values
    if (stringValue.toLowerCase() == 'true') {
      return true;
    } else if (stringValue.toLowerCase() == 'false') {
      return false;
    } else if (stringValue.toLowerCase() == 'null') {
      return null;
    }
    
    // Numeric values
    if (RegExp(r'^\d+$').hasMatch(stringValue)) {
      return int.tryParse(stringValue);
    } else if (RegExp(r'^\d+\.\d+$').hasMatch(stringValue)) {
      return double.tryParse(stringValue);
    }
    
    // Date values
    if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(stringValue)) {
      try {
        return DateTime.parse(stringValue);
      } catch (_) {
        // Not a valid date, return as string
      }
    }
    
    // Return as string by default
    return stringValue;
  }
  
  /// Converts a value to a DateTime.
  ///
  /// Handles different storage formats for DateTime values.
  ///
  /// [value] is the value to convert.
  ///
  /// Returns a DateTime or null if conversion is not possible.
  static DateTime? _convertToDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    
    if (value is DateTime) {
      return value;
    } else if (value is int) {
      // Stored as milliseconds since epoch
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      try {
        // Stored as ISO 8601 string
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    
    return null;
  }
  
  /// Converts a QueryRow to a domain entity.
  ///
  /// [row] is the database row to convert.
  /// [concept] is the concept that defines the entity structure.
  ///
  /// Returns a domain entity populated with data from the row.
  static Entity<dynamic> rowToEntity(QueryRow row, model.Concept concept) {
    final entity = Entity<dynamic>();
    entity.concept = concept;
    
    // Set entity data from row
    row.data.forEach((key, value) {
      // Find the attribute for this column (if it exists)
      final attribute = concept.attributes
          .whereType<Attribute>()
          .where((a) => a.code == key)
          .firstOrNull;
      
      // Convert value based on attribute type if needed
      final convertedValue = fromDatabaseValue(value, attribute);
      entity.setAttribute(key, convertedValue);
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
} 