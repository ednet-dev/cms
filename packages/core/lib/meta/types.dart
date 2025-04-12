part of ednet_core;

class AttributeTypes extends Entities<AttributeType> {}

/// Represents a data type in the domain model with support for constraints.
///
/// AttributeType defines the validation rules for attribute values, including:
/// - Basic type validation (int, String, DateTime, etc.)
/// - Min/max value constraints for numeric types
/// - Min/max length and pattern constraints for string types
/// - Format validation for specialized types (Email, Uri)
///
/// These types can be used to:
/// - Validate entity attribute values
/// - Generate UI validation
/// - Document domain constraints
class AttributeType extends Entity<AttributeType> {
  /// The base type name (String, int, double, etc.)
  late String base;

  /// Maximum length for string values, or storage size for other types
  late int length;

  /// Minimum value constraint for numeric types
  num? _minValue;

  /// Maximum value constraint for numeric types
  num? _maxValue;

  /// Minimum length constraint for string types
  int? _minLength;

  /// Pattern constraint for string validation
  String? _pattern;

  /// The constraint validator instance (created on demand)
  TypeConstraintValidator? _constraintValidator;

  /// The domain that owns this type
  Domain domain;

  /// Creates a new attribute type in the specified domain with the given code.
  ///
  /// The type details are set based on the typeCode:
  /// - String types have various default lengths depending on their semantic meaning
  /// - Numeric types have default sizes
  /// - Specialized types like Email, URL, etc. have appropriate base types and lengths
  ///
  /// Parameters:
  /// - domain: The domain that owns this type
  /// - typeCode: The code identifying this type (e.g., 'String', 'int', 'Email')
  AttributeType(this.domain, String typeCode) {
    if (typeCode == 'String') {
      base = typeCode;
      length = 64;
    } else if (typeCode == 'num') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'int') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'double') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'bool') {
      base = typeCode;
      length = 8;
    } else if (typeCode == 'DateTime') {
      base = typeCode;
      length = 16;
    } else if (typeCode == 'Duration') {
      base = typeCode;
      length = 16;
    } else if (typeCode == 'Uri') {
      base = typeCode;
      length = 80;
    } else if (typeCode == 'Email') {
      base = 'String';
      length = 48;
    } else if (typeCode == 'Telephone') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'PostalCode') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'ZipCode') {
      base = 'String';
      length = 16;
    } else if (typeCode == 'Name') {
      base = 'String';
      length = 32;
    } else if (typeCode == 'Description') {
      base = 'String';
      length = 256;
    } else if (typeCode == 'Money') {
      base = 'double';
      length = 8;
    } else if (typeCode == 'dynamic') {
      base = typeCode;
      length = 64;
    } else if (typeCode == 'Other') {
      base = 'dynamic';
      length = 128;
    } else {
      base = typeCode;
      length = 96;
    }
    code = typeCode;
    domain.types.add(this);
  }

  /// Sets a minimum value constraint for numeric types.
  ///
  /// This constraint ensures that numeric values are greater than or equal to
  /// the specified minimum value during validation.
  ///
  /// Parameters:
  /// - minValue: The minimum allowed value
  ///
  /// Throws:
  /// - TypeException if applied to a non-numeric type
  void setMinValue(num minValue) {
    if (base != 'int' && base != 'double' && base != 'num') {
      throw TypeException(
        'Minimum value constraint can only be set for numeric types',
      );
    }
    _minValue = minValue;
    _constraintValidator =
        null; // Reset validator to regenerate with new constraints
  }

  /// Sets a maximum value constraint for numeric types.
  ///
  /// This constraint ensures that numeric values are less than or equal to
  /// the specified maximum value during validation.
  ///
  /// Parameters:
  /// - maxValue: The maximum allowed value
  ///
  /// Throws:
  /// - TypeException if applied to a non-numeric type
  void setMaxValue(num maxValue) {
    if (base != 'int' && base != 'double' && base != 'num') {
      throw TypeException(
        'Maximum value constraint can only be set for numeric types',
      );
    }
    _maxValue = maxValue;
    _constraintValidator =
        null; // Reset validator to regenerate with new constraints
  }

  /// Sets a minimum length constraint for string types.
  ///
  /// This constraint ensures that string values have at least the specified
  /// number of characters during validation.
  ///
  /// Parameters:
  /// - minLength: The minimum required length
  ///
  /// Throws:
  /// - TypeException if applied to a non-string type
  void setMinLength(int minLength) {
    if (base != 'String') {
      throw TypeException(
        'Minimum length constraint can only be set for string types',
      );
    }
    _minLength = minLength;
    _constraintValidator =
        null; // Reset validator to regenerate with new constraints
  }

  /// Sets a pattern constraint for string types.
  ///
  /// This constraint ensures that string values match the specified regular expression
  /// pattern during validation.
  ///
  /// Parameters:
  /// - pattern: The regular expression pattern to match against
  ///
  /// Throws:
  /// - TypeException if applied to a non-string type
  void setPattern(String pattern) {
    if (base != 'String') {
      throw TypeException(
        'Pattern constraint can only be set for string types',
      );
    }
    _pattern = pattern;
    _constraintValidator =
        null; // Reset validator to regenerate with new constraints
  }

  /// Creates or retrieves the constraint validator for this type
  TypeConstraintValidator _getConstraintValidator() {
    if (_constraintValidator != null) {
      return _constraintValidator!;
    }

    // Create appropriate validator based on type
    if (base == 'int') {
      _constraintValidator = TypeConstraintValidator.forInt(
        min: _minValue as int?,
        max: _maxValue as int?,
      );
    } else if (base == 'double') {
      _constraintValidator = TypeConstraintValidator.forDouble(
        min: _minValue as double?,
        max: _maxValue as double?,
      );
    } else if (base == 'String') {
      _constraintValidator = TypeConstraintValidator.forString(
        minLength: _minLength,
        maxLength: length,
        pattern: _pattern,
      );
    } else if (code == 'Email') {
      _constraintValidator = TypeConstraintValidator.forEmail();
    } else if (code == 'Uri') {
      _constraintValidator = TypeConstraintValidator.forUrl();
    } else {
      // Default validator that always returns true for types without constraints
      _constraintValidator = TypeConstraintValidator._('default', (_) => true);
    }

    return _constraintValidator!;
  }

  /// Checks if a string value matches the email format pattern.
  ///
  /// Parameters:
  /// - email: The string to validate as an email address
  ///
  /// Returns:
  /// - true if the string has a valid email format, false otherwise
  bool isEmail(String email) {
    var regexp = RegExp(r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b');
    return regexp.hasMatch(email);
  }

  /// Validates a string value against the type's rules.
  ///
  /// This method is used for validating string representations of values,
  /// such as when parsing user input or importing data.
  ///
  /// Parameters:
  /// - value: The string value to validate
  ///
  /// Returns:
  /// - true if the string can be parsed as a valid value of this type, false otherwise
  bool validate(String value) {
    if (base == 'num') {
      try {
        num.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'int') {
      try {
        int.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'double') {
      try {
        double.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'bool') {
      if (value != 'true' && value != 'false') {
        return false;
      }
    } else if (base == 'DateTime') {
      try {
        DateTime.parse(value);
      } on FormatException {
        return false;
      }
    } else if (base == 'Duration') {
      // validation?
    } else if (base == 'Uri') {
      var uri = Uri.parse(value);
      if (uri.host == '') {
        return false;
      }
    } else if (code == 'Email') {
      return isEmail(value);
    }
    return true;
  }

  /// Validates a value against this type's constraints.
  ///
  /// This performs both basic type checking and additional constraint validation:
  /// - Checks if the value is of the correct type (int, String, etc.)
  /// - If constraints are defined, applies them (min/max value, length, pattern, etc.)
  ///
  /// Parameters:
  /// - value: The value to validate
  ///
  /// Returns:
  /// - true if the value is valid for this type and satisfies all constraints, false otherwise
  bool validateValue(dynamic value) {
    // Skip validation for null values
    if (value == null) {
      return true;
    }

    // First check if the basic type is correct
    bool basicTypeValid = _validateBasicType(value);
    if (!basicTypeValid) {
      return false;
    }

    // Apply additional constraint validation if any constraints are set
    if (_hasConstraints()) {
      return _getConstraintValidator().validate(value);
    }

    // If no constraints, basic type validation is sufficient
    return true;
  }

  /// Checks if the value matches the basic type requirements
  bool _validateBasicType(dynamic value) {
    if (base == 'num') {
      return value is num;
    } else if (base == 'int') {
      return value is int;
    } else if (base == 'double') {
      return value is double;
    } else if (base == 'bool') {
      return value is bool;
    } else if (base == 'DateTime') {
      return value is DateTime;
    } else if (base == 'Duration') {
      return value is Duration;
    } else if (base == 'Uri') {
      return value is Uri;
    } else if (code == 'Email') {
      return value is String;
    } else if (base == 'String') {
      return value is String;
    }
    return true;
  }

  /// Checks if any constraints are defined for this type
  bool _hasConstraints() {
    return _minValue != null ||
        _maxValue != null ||
        _minLength != null ||
        _pattern != null ||
        code == 'Email' ||
        code == 'Uri';
  }

  /// Gets the most recent validation error message.
  ///
  /// After a call to [validateValue] that returns false, this method can be
  /// called to retrieve a detailed description of why validation failed.
  ///
  /// Returns:
  /// - A descriptive error message, or null if no validation has been performed
  ///   or the last validation was successful
  String? getValidationError() {
    return _hasConstraints() ? _getConstraintValidator().getLastError() : null;
  }

  /// Compares two values of this type.
  ///
  /// This method enables sorting and comparison operations on values of the same type.
  ///
  /// Parameters:
  /// - value1: The first value to compare
  /// - value2: The second value to compare
  ///
  /// Returns:
  /// - A negative number if value1 < value2
  /// - Zero if value1 == value2
  /// - A positive number if value1 > value2
  ///
  /// Throws:
  /// - OrderException if the type doesn't support comparison
  int compare(var value1, var value2) {
    var compare = 0;
    if (base == 'String') {
      compare = value1.compareTo(value2);
    } else if (base == 'num' || base == 'int' || base == 'double') {
      compare = value1.compareTo(value2);
    } else if (base == 'bool') {
      compare = value1.toString().compareTo(value2.toString());
    } else if (base == 'DateTime') {
      compare = value1.compareTo(value2);
    } else if (base == 'Duration') {
      compare = value1.compareTo(value2);
    } else if (base == 'Uri') {
      compare = value1.toString().compareTo(value2.toString());
    } else {
      String msg = 'cannot compare then order on this type: $code type.';
      throw OrderException(msg);
    }
    return compare;
  }

  /// Converts this type to a map suitable for serialization.
  ///
  /// This method enhances the base toGraph implementation by adding
  /// type-specific details and constraints.
  ///
  /// Returns:
  /// - A map containing the serialized representation of this type
  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['base'] = base;
    graph['length'] = length;

    // Include constraints in the graph representation
    if (_minValue != null) graph['minValue'] = _minValue;
    if (_maxValue != null) graph['maxValue'] = _maxValue;
    if (_minLength != null) graph['minLength'] = _minLength;
    if (_pattern != null) graph['pattern'] = _pattern;

    return graph;
  }
}
