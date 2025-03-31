part of ednet_core;

/// Enumeration of basic Dart types used in the domain model.
///
/// This enum represents the primitive and basic collection types available in Dart
/// that can be used as attribute types in domain entities. It includes:
/// - Boolean values ([bool])
/// - Numeric types ([int], [double])
/// - Text type ([string])
/// - Collection types ([list], [map], [set])
/// - Dynamic type ([dynamic]) for values of unknown type
///
/// Example usage:
/// ```dart
/// final type = DartBasicType.string;
/// if (type == DartBasicType.string) {
///   // Handle string type
/// }
/// ```
enum DartBasicType {
  /// Boolean type (true/false)
  bool,

  /// Integer type (whole numbers)
  int,

  /// Double type (floating-point numbers)
  double,

  /// String type (text)
  string,

  /// List type (ordered collection)
  list,

  /// Map type (key-value pairs)
  map,

  /// Set type (unique collection)
  set,

  /// Dynamic type (any value)
  dynamic,
}
