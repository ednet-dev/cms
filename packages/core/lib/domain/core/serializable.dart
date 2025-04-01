part of ednet_core;

/// A mixin that provides serialization capabilities to domain objects.
///
/// The [Serializable] mixin defines a contract for objects that can be 
/// converted to and from JSON representations. This serves as a foundational
/// building block for the persistence and data transfer capabilities of the 
/// EDNet Core framework.
///
/// This mixin requires implementing classes to:
/// - Provide a [toJson] method to serialize object state to a JSON map
/// - Use the static [fromJson] method to deserialize JSON data
///
/// Example usage:
/// ```dart
/// class Person with Serializable {
///   final String name;
///   final int age;
///
///   Person({required this.name, required this.age});
///
///   @override
///   Map<String, dynamic> toJson() {
///     return {
///       'name': name,
///       'age': age,
///     };
///   }
///
///   static Person fromJson(Map<String, dynamic> json) {
///     return Person(
///       name: json['name'],
///       age: json['age'],
///     );
///   }
/// }
/// ```
mixin Serializable {
  /// Converts this object to a JSON representation.
  ///
  /// Implementations should return a map that can be serialized to JSON.
  /// All implementers must ensure that the returned map contains only
  /// JSON-compatible values (String, num, bool, null, List, or Map).
  Map<String, dynamic> toJson();

  /// Creates an object from its JSON representation.
  ///
  /// This method should be implemented by each class that uses this mixin
  /// to provide a way to deserialize JSON data back into an instance of the class.
  ///
  /// [json] is the map containing JSON data for the object.
  static fromJson(Map<String, dynamic> json) {}
}
