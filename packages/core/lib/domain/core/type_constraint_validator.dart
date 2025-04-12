part of ednet_core;

/// Validates values against type-specific constraints such as:
/// - Numeric ranges (min/max values)
/// - String constraints (min/max length, patterns)
/// - Format validation (email, URL, etc.)
///
/// This validator complements the basic type validation in domain models by adding
/// support for additional constraints. It provides type-safe validation with detailed
/// error messages that can be used for both validation and user feedback.
///
/// Usage example:
/// ```dart
/// // Create a validator for integers with range constraints
/// final validator = TypeConstraintValidator.forInt(min: 5, max: 10);
///
/// // Validate values
/// bool isValid = validator.validate(7); // true
/// isValid = validator.validate(3);      // false
///
/// // Get error messages for failed validations
/// String? error = validator.getLastError(); // "Value must be greater than or equal to the minimum value of 5"
/// ```
class TypeConstraintValidator {
  /// The type of value this validator is for
  final String _type;

  /// The validation function to use
  final bool Function(dynamic) _validate;

  /// Error message from the last validation
  String? _lastError;

  /// Minimum value for numeric types or minimum length for strings
  final dynamic _min;

  /// Maximum value for numeric types or maximum length for strings
  final dynamic _max;

  /// Pattern for string validation
  final String? _pattern;

  /// Creates a new validator for the specified type with the provided validation function.
  ///
  /// This is a private constructor used by the factory methods to create
  /// type-specific validators.
  ///
  /// Parameters:
  /// - _type: The type identifier (e.g., 'int', 'string', 'email')
  /// - _validate: The function to use for validation
  /// - min: The minimum value or length constraint
  /// - max: The maximum value or length constraint
  /// - pattern: The regex pattern for string validation
  TypeConstraintValidator._(
    this._type,
    this._validate, {
    dynamic min,
    dynamic max,
    String? pattern,
  }) : _min = min,
       _max = max,
       _pattern = pattern;

  /// Creates a validator for integer values with optional min/max constraints.
  ///
  /// The validator checks:
  /// - If the value is an integer
  /// - If the value meets any specified min/max constraints
  ///
  /// Parameters:
  /// - min: The minimum allowed value (inclusive), or null for no minimum
  /// - max: The maximum allowed value (inclusive), or null for no maximum
  ///
  /// Returns:
  /// A validator configured for integer validation
  factory TypeConstraintValidator.forInt({int? min, int? max}) {
    return TypeConstraintValidator._(
      'int',
      (value) {
        if (value == null) return true;
        if (value is! int) return false;

        if (min != null && value < min) {
          return false;
        }
        if (max != null && value > max) {
          return false;
        }
        return true;
      },
      min: min,
      max: max,
    );
  }

  /// Creates a validator for double values with optional min/max constraints.
  ///
  /// The validator checks:
  /// - If the value is a double
  /// - If the value meets any specified min/max constraints
  ///
  /// Parameters:
  /// - min: The minimum allowed value (inclusive), or null for no minimum
  /// - max: The maximum allowed value (inclusive), or null for no maximum
  ///
  /// Returns:
  /// A validator configured for double validation
  factory TypeConstraintValidator.forDouble({double? min, double? max}) {
    return TypeConstraintValidator._(
      'double',
      (value) {
        if (value == null) return true;
        if (value is! double) return false;

        if (min != null && value < min) {
          return false;
        }
        if (max != null && value > max) {
          return false;
        }
        return true;
      },
      min: min,
      max: max,
    );
  }

  /// Creates a validator for string values with optional length and pattern constraints.
  ///
  /// The validator checks:
  /// - If the value is a string
  /// - If the string length meets any specified min/max length constraints
  /// - If the string matches any specified regex pattern
  ///
  /// Parameters:
  /// - minLength: The minimum allowed length, or null for no minimum
  /// - maxLength: The maximum allowed length, or null for no maximum
  /// - pattern: The regex pattern to match against, or null for no pattern matching
  ///
  /// Returns:
  /// A validator configured for string validation
  factory TypeConstraintValidator.forString({
    int? minLength,
    int? maxLength,
    String? pattern,
  }) {
    return TypeConstraintValidator._(
      'string',
      (value) {
        if (value == null) return true;
        if (value is! String) return false;

        if (minLength != null && value.length < minLength) {
          return false;
        }
        if (maxLength != null && value.length > maxLength) {
          return false;
        }
        if (pattern != null) {
          try {
            final regex = RegExp(pattern);
            if (!regex.hasMatch(value)) {
              return false;
            }
          } catch (e) {
            return false;
          }
        }
        return true;
      },
      min: minLength,
      max: maxLength,
      pattern: pattern,
    );
  }

  /// Creates a validator for email addresses.
  ///
  /// The validator checks:
  /// - If the value is a string
  /// - If the string is in a valid email format
  ///
  /// Returns:
  /// A validator configured for email validation
  factory TypeConstraintValidator.forEmail() {
    return TypeConstraintValidator._('email', (value) {
      if (value == null) return true;
      if (value is! String) return false;

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return emailRegex.hasMatch(value);
    });
  }

  /// Creates a validator for URLs.
  ///
  /// The validator checks:
  /// - If the value is a string
  /// - If the string is a valid URL (includes protocol and host)
  ///
  /// Returns:
  /// A validator configured for URL validation
  factory TypeConstraintValidator.forUrl() {
    return TypeConstraintValidator._('url', (value) {
      if (value == null) return true;
      if (value is! String) return false;

      try {
        final uri = Uri.parse(value);
        return uri.scheme.isNotEmpty && uri.host.isNotEmpty;
      } catch (_) {
        return false;
      }
    });
  }

  /// Validates a value against the constraints defined by this validator.
  ///
  /// This method runs the validation function and, if validation fails,
  /// sets an appropriate error message that can be retrieved with [getLastError].
  ///
  /// Parameters:
  /// - value: The value to validate
  ///
  /// Returns:
  /// - true if the value satisfies all constraints, false otherwise
  bool validate(dynamic value) {
    _lastError = null;

    final result = _validate(value);

    if (!result) {
      _setErrorMessage(value);
    }

    return result;
  }

  /// Sets an appropriate error message based on the failed validation.
  ///
  /// This method is called automatically when validation fails and sets
  /// a descriptive error message based on the type of constraint that was violated.
  ///
  /// Parameters:
  /// - value: The value that failed validation
  void _setErrorMessage(dynamic value) {
    if (value == null) {
      _lastError = 'Value cannot be null';
      return;
    }

    if (_type == 'int' || _type == 'double') {
      if (value is! num) {
        _lastError = 'Value must be a number';
        return;
      }

      // Check numeric range constraints
      if (_min != null && value < _min) {
        _lastError =
            'Value must be greater than or equal to the minimum value of $_min';
      } else if (_max != null && value > _max) {
        _lastError =
            'Value must be less than or equal to the maximum value of $_max';
      } else {
        _lastError = 'Value does not satisfy the constraints for $_type';
      }
    } else if (_type == 'string') {
      if (value is! String) {
        _lastError = 'Value must be a string';
        return;
      }

      // Check string length constraints
      if (_min != null && value.length < _min) {
        _lastError = 'String must have a minimum length of $_min';
      } else if (_max != null && value.length > _max) {
        _lastError = 'String must have a maximum length of $_max';
      } else if (_pattern != null) {
        _lastError = 'String does not match the required pattern: $_pattern';
      } else {
        _lastError = 'String does not satisfy the constraints';
      }
    } else if (_type == 'email') {
      _lastError = 'Invalid email format';
    } else if (_type == 'url') {
      _lastError = 'Invalid URL format';
    } else {
      _lastError = 'Value does not satisfy the constraints for $_type';
    }
  }

  /// Returns the error message from the last failed validation.
  ///
  /// This method should be called after [validate] returns false to get
  /// a detailed description of why validation failed.
  ///
  /// Returns:
  /// - A descriptive error message, or null if no validation has been performed
  ///   or the last validation was successful
  String? getLastError() {
    return _lastError;
  }
}
