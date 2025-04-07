part of ednet_core;

/// A utility class for type checking and type conversion.
class Types {
  /// Check if a value is of a specific type
  static bool isType(Object? value, String typeName) {
    switch (typeName.toLowerCase()) {
      case 'string':
        return value is String;
      case 'int':
      case 'integer':
        return value is int;
      case 'double':
      case 'float':
        return value is double;
      case 'num':
      case 'number':
        return value is num;
      case 'bool':
      case 'boolean':
        return value is bool;
      case 'datetime':
        return value is DateTime;
      case 'list':
      case 'array':
        return value is List;
      case 'map':
      case 'object':
        return value is Map;
      default:
        return false;
    }
  }

  /// Attempt to convert a value to the specified type
  static Object? as(Object? value, String typeName) {
    if (value == null) return null;

    switch (typeName.toLowerCase()) {
      case 'string':
        return value.toString();
      case 'int':
      case 'integer':
        if (value is int) return value;
        if (value is num) return value.toInt();
        if (value is String) return int.tryParse(value);
        return null;
      case 'double':
      case 'float':
        if (value is double) return value;
        if (value is num) return value.toDouble();
        if (value is String) return double.tryParse(value);
        return null;
      case 'bool':
      case 'boolean':
        if (value is bool) return value;
        if (value is String) {
          final lowercased = value.toLowerCase();
          if (lowercased == 'true' || lowercased == '1') return true;
          if (lowercased == 'false' || lowercased == '0') return false;
        }
        if (value is num) return value != 0;
        return null;
      case 'datetime':
        if (value is DateTime) return value;
        if (value is String) return DateTime.tryParse(value);
        if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
        return null;
      default:
        return value;
    }
  }

  /// Compare two values of the same type
  static int compare(Object? a, Object? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;

    if (a is num && b is num) {
      return a.compareTo(b);
    }

    if (a is String && b is String) {
      return a.compareTo(b);
    }

    if (a is DateTime && b is DateTime) {
      return a.compareTo(b);
    }

    if (a is bool && b is bool) {
      return a == b ? 0 : (a ? 1 : -1);
    }

    return a.toString().compareTo(b.toString());
  }
}
