part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Utility for common string operations used across the application
class StringUtils {
  /// Capitalizes the first letter of a string
  static String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  /// Converts a string to title case (each word capitalized)
  static String toTitleCase(String str) {
    if (str.isEmpty) return str;
    return str.split(' ').map(capitalize).join(' ');
  }

  /// Converts camelCase to snake_case
  static String camelToSnake(String str) {
    return str.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }

  /// Converts snake_case to camelCase
  static String snakeToCamel(String str) {
    return str.replaceAllMapped(
      RegExp(r'_([a-z])'),
      (match) => match.group(1)!.toUpperCase(),
    );
  }

  /// Converts snake_case to PascalCase
  static String snakeToPascal(String str) {
    final camel = snakeToCamel(str);
    return capitalize(camel);
  }

  /// Converts camelCase to PascalCase
  static String camelToPascal(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  /// Converts PascalCase to camelCase
  static String pascalToCamel(String str) {
    if (str.isEmpty) return str;
    return str[0].toLowerCase() + str.substring(1);
  }

  /// Truncates a string to a specified length and adds an ellipsis if truncated
  static String truncate(String str, int maxLength) {
    if (str.length <= maxLength) return str;
    return '${str.substring(0, maxLength)}...';
  }

  /// Removes all HTML tags from a string
  static String stripHtml(String str) {
    return str.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Checks if a string is null, empty, or contains only whitespace
  static bool isNullOrEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  /// Converts newlines to HTML <br> tags
  static String newlinesToHtml(String str) {
    return str.replaceAll('\n', '<br>');
  }

  /// Extracts the first n characters from a string, or the entire string if shorter
  static String firstChars(String str, int n) {
    if (str.length <= n) return str;
    return str.substring(0, n);
  }

  /// Creates an acronym from a string (first letter of each word)
  static String toAcronym(String str) {
    if (str.isEmpty) return str;
    final words = str.split(' ');
    return words
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }

  /// Creates a slug from a string (lowercase, no spaces, only alphanumeric and dashes)
  static String toSlug(String str) {
    return str
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  /// Returns a default value if the string is null or empty
  static String defaultIfEmpty(String? str, String defaultValue) {
    return isNullOrEmpty(str) ? defaultValue : str!;
  }
}
