part of ednet_core;

/// Base class for all attribute constraints in the system.
///
/// Constraints are used to validate attribute values based on domain-specific rules.
/// They can be applied to attribute types to enforce validation when values change.
abstract class Constraint<T> {
  /// Validates a value against this constraint.
  ///
  /// Returns true if the value satisfies the constraint, false otherwise.
  bool validate(T value);

  /// Gets a descriptive error message when validation fails.
  ///
  /// This message should explain why the value failed validation and
  /// provide guidance on what would make a valid value.
  String get errorMessage;
}

/// Constraint for numeric values (int, double, num).
///
/// Allows enforcing minimum and maximum value ranges.
class NumericConstraint extends Constraint<num> {
  final num? _min;
  final num? _max;
  final String _errorMessage;

  // Private constructor to use with factory methods
  NumericConstraint._({num? min, num? max, required String errorMessage})
    : _min = min,
      _max = max,
      _errorMessage = errorMessage;

  /// Creates a minimum value constraint.
  ///
  /// The created constraint validates that values are >= the given minimum.
  factory NumericConstraint.minimum(num min) {
    return NumericConstraint._(
      min: min,
      errorMessage: 'Value must be at least $min',
    );
  }

  /// Creates a maximum value constraint.
  ///
  /// The created constraint validates that values are <= the given maximum.
  factory NumericConstraint.maximum(num max) {
    return NumericConstraint._(
      max: max,
      errorMessage: 'Value must be at most $max',
    );
  }

  /// Creates a range constraint with both minimum and maximum values.
  ///
  /// The created constraint validates that values are within the given range (inclusive).
  factory NumericConstraint.range(num min, num max) {
    return NumericConstraint._(
      min: min,
      max: max,
      errorMessage: 'Value must be between $min and $max',
    );
  }

  @override
  bool validate(num value) {
    if (_min != null && value < _min) {
      return false;
    }
    if (_max != null && value > _max) {
      return false;
    }
    return true;
  }

  @override
  String get errorMessage => _errorMessage;
}

/// Constraint for string values.
///
/// Allows enforcing length and pattern/format rules.
class StringConstraint extends Constraint<String> {
  final int? _minLength;
  final int? _maxLength;
  final String? _pattern;
  final RegExp? _regex;
  final String _errorMessage;

  // Private constructor to use with factory methods
  StringConstraint._({
    int? minLength,
    int? maxLength,
    String? pattern,
    required String errorMessage,
  }) : _minLength = minLength,
       _maxLength = maxLength,
       _pattern = pattern,
       _regex = pattern != null ? RegExp(pattern) : null,
       _errorMessage = errorMessage;

  /// Creates a minimum length constraint.
  ///
  /// The created constraint validates that strings have at least the given length.
  factory StringConstraint.minLength(int minLength) {
    return StringConstraint._(
      minLength: minLength,
      errorMessage: 'String must have at least $minLength characters',
    );
  }

  /// Creates a maximum length constraint.
  ///
  /// The created constraint validates that strings don't exceed the given length.
  factory StringConstraint.maxLength(int maxLength) {
    return StringConstraint._(
      maxLength: maxLength,
      errorMessage: 'String must have at most $maxLength characters',
    );
  }

  /// Creates a length range constraint.
  ///
  /// The created constraint validates that string length is within the given range.
  factory StringConstraint.lengthRange(int minLength, int maxLength) {
    return StringConstraint._(
      minLength: minLength,
      maxLength: maxLength,
      errorMessage: 'String length must be between $minLength and $maxLength',
    );
  }

  /// Creates a pattern constraint using a regular expression.
  ///
  /// The created constraint validates that strings match the given pattern.
  factory StringConstraint.pattern(String pattern) {
    return StringConstraint._(
      pattern: pattern,
      errorMessage: 'String must match pattern: $pattern',
    );
  }

  @override
  bool validate(String value) {
    if (_minLength != null && value.length < _minLength!) {
      return false;
    }
    if (_maxLength != null && value.length > _maxLength) {
      return false;
    }
    if (_regex != null && !_regex.hasMatch(value)) {
      return false;
    }
    return true;
  }

  @override
  String get errorMessage => _errorMessage;
}

/// Specialized constraint for email validation.
class EmailConstraint extends Constraint<String> {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  bool validate(String value) {
    return _emailRegex.hasMatch(value);
  }

  @override
  String get errorMessage => 'Must be a valid email address';
}

/// Specialized constraint for URI/URL validation.
class UriConstraint extends Constraint<dynamic> {
  @override
  bool validate(dynamic value) {
    if (value is Uri) {
      return value.scheme.isNotEmpty && value.host.isNotEmpty;
    } else if (value is String) {
      try {
        final uri = Uri.parse(value);
        return uri.scheme.isNotEmpty && uri.host.isNotEmpty;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  @override
  String get errorMessage => 'Must be a valid URL (e.g., https://example.com)';
}
