part of ednet_core;

/// Abstract ValueObject class providing contract for JSON serialization.
abstract class ValueObject {
  /// Converts the ValueObject to a JSON map.
  Map<String, dynamic> toJson();
}

/// A simple implementation of ValueObject that supports ednet_core Attributes.
class SimpleValueObject implements ValueObject {
  final String name;
  final String description;
  final String version;
  final List<ValueObjectAttribute> attributes;

  const SimpleValueObject({
    required this.name,
    required this.description,
    required this.version,
    required this.attributes,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'version': version,
      'attributes': attributes.map((e) => e.toJson()).toList(),
    };
  }

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SimpleValueObject) return false;
    return name == other.name &&
        description == other.description &&
        version == other.version &&
        attributes == other.attributes;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      version.hashCode ^
      attributes.hashCode;

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

/// A representation of an attribute with key-value pairs.
class ValueObjectAttribute {
  final String key;
  final dynamic value;

  const ValueObjectAttribute({required this.key, required this.value});

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  factory ValueObjectAttribute.fromJson(Map<String, dynamic> json) {
    return ValueObjectAttribute(
      key: json['key'],
      value: json['value'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ValueObjectAttribute) return false;
    return key == other.key && value == other.value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
