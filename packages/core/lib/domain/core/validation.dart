part of ednet_core;

/// A utility class for validating data.
class Validation {
  /// Validate that a string is not empty
  static bool notEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }

  /// Validate that a number is positive
  static bool positive(num? value) {
    return value != null && value > 0;
  }

  /// Validate that a number is non-negative
  static bool nonNegative(num? value) {
    return value != null && value >= 0;
  }

  /// Validate that a string contains a valid email
  static bool email(String? value) {
    if (value == null || value.isEmpty) return false;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value);
  }

  /// Validate that a string matches a regular expression
  static bool matches(String? value, String pattern) {
    if (value == null) return false;

    final regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  /// Validate that a value is within a range (inclusive)
  static bool withinRange(num? value, num min, num max) {
    return value != null && value >= min && value <= max;
  }

  /// Validate that a string has a minimum length
  static bool minLength(String? value, int minLength) {
    return value != null && value.length >= minLength;
  }

  /// Validate that a string doesn't exceed a maximum length
  static bool maxLength(String? value, int maxLength) {
    return value != null && value.length <= maxLength;
  }

  /// Validate that a list is not empty
  static bool notEmptyList<T>(List<T>? list) {
    return list != null && list.isNotEmpty;
  }

  /// Validate that a string is a valid URL
  static bool url(String? value) {
    if (value == null || value.isEmpty) return false;

    try {
      final uri = Uri.parse(value);
      return uri.scheme.isNotEmpty && uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
