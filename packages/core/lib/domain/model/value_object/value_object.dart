part of ednet_core;

/// Abstract base class for value objects in the domain model.
///
/// A value object is an immutable object that represents a descriptive aspect of the domain
/// with no conceptual identity. Value objects are defined by their attributes rather than
/// their identity.
///
/// This interface provides the contract for JSON serialization of value objects.
///
/// Example usage:
/// ```dart
/// class Address implements ValueObject {
///   final String street;
///   final String city;
///   final String country;
///
///   const Address({
///     required this.street,
///     required this.city,
///     required this.country,
///   });
///
///   @override
///   Map<String, dynamic> toJson() {
///     return {
///       'street': street,
///       'city': city,
///       'country': country,
///     };
///   }
/// }
/// ```
abstract class ValueObject {
  /// Converts the value object to a JSON map.
  Map<String, dynamic> toJson();
}

/// A simple implementation of [ValueObject] that supports ednet_core attributes.
///
/// This class provides a basic structure for value objects with:
/// - A name and description
/// - A version number
/// - A list of attributes
///
/// It supports JSON serialization/deserialization and provides methods for
/// equality comparison and copying.
///
/// Example usage:
/// ```dart
/// final vo = SimpleValueObject(
///   name: 'ProductSpec',
///   description: 'Product specification',
///   version: '1.0',
///   attributes: [
///     ValueObjectAttribute(key: 'color', value: 'red'),
///     ValueObjectAttribute(key: 'size', value: 'large'),
///   ],
/// );
///
/// final json = vo.toJson();
/// final copy = vo.copyWith(name: 'NewSpec');
/// ```
class SimpleValueObject implements ValueObject {
  /// The name of the value object.
  final String name;

  /// A description of the value object.
  final String description;

  /// The version of the value object.
  final String version;

  /// The list of attributes in this value object.
  final List<ValueObjectAttribute> attributes;

  /// Creates a new [SimpleValueObject] with the given properties.
  const SimpleValueObject({
    required this.name,
    required this.description,
    required this.version,
    required this.attributes,
  });

  /// Converts this value object to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'version': version,
      'attributes': attributes.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a [SimpleValueObject] from a JSON map.
  factory SimpleValueObject.fromJson(Map<String, dynamic> json) {
    return SimpleValueObject(
      name: json['name'],
      description: json['description'],
      version: json['version'],
      attributes: (json['attributes'] as List)
          .map((e) => ValueObjectAttribute.fromJson(e))
          .toList(),
    );
  }

  /// Compares this value object with [other] for equality.
  /// Two value objects are equal if they have the same name, description,
  /// version, and attributes.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SimpleValueObject) return false;
    return name == other.name &&
        description == other.description &&
        version == other.version &&
        attributes == other.attributes;
  }

  /// Computes the hash code for this value object.
  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      version.hashCode ^
      attributes.hashCode;

  /// Creates a copy of this value object with the given fields replaced with new values.
  SimpleValueObject copyWith({
    String? name,
    String? description,
    String? version,
    List<ValueObjectAttribute>? attributes,
  }) {
    return SimpleValueObject(
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      attributes: attributes ?? this.attributes,
    );
  }
}

/// A representation of an attribute with a key-value pair.
///
/// This class is used to represent attributes in [SimpleValueObject] instances.
/// It supports JSON serialization/deserialization and provides methods for
/// equality comparison.
///
/// Example usage:
/// ```dart
/// final attr = ValueObjectAttribute(
///   key: 'color',
///   value: 'red',
/// );
///
/// final json = attr.toJson();
/// ```
class ValueObjectAttribute {
  /// The key of the attribute.
  final String key;

  /// The value of the attribute.
  final dynamic value;

  /// Creates a new [ValueObjectAttribute] with the given key and value.
  const ValueObjectAttribute({required this.key, required this.value});

  /// Converts this attribute to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  /// Creates a [ValueObjectAttribute] from a JSON map.
  factory ValueObjectAttribute.fromJson(Map<String, dynamic> json) {
    return ValueObjectAttribute(
      key: json['key'],
      value: json['value'],
    );
  }

  /// Compares this attribute with [other] for equality.
  /// Two attributes are equal if they have the same key and value.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ValueObjectAttribute) return false;
    return key == other.key && value == other.value;
  }

  /// Computes the hash code for this attribute.
  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
