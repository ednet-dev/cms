part of ednet_core;

class AttributePolicy extends Policy {
  final String attributeName;
  final bool Function(dynamic value) validator;

  AttributePolicy({
    required String name,
    required String description,
    required this.attributeName,
    required this.validator,
  }) : super(
            name,
            description,
            (Entity e) =>
                e.getAttribute(attributeName) != null &&
                validator(e.getAttribute(attributeName)));

  @override
  bool evaluate(Entity entity) {
    var attributeValue = entity.getAttribute(attributeName);
    var parentValue = entity.getParent(attributeName);
    var childValue = entity.getChild(attributeName);
    if (attributeValue == null && parentValue == null && childValue == null) {
      return false;
    }
    return validator(attributeValue ?? parentValue ?? childValue);
  }
}

// Convenience functions for common attribute validations
class AttributeValidators {
  static bool Function(dynamic) isNotNull = (value) => value != null;

  static bool Function(dynamic) isGreaterThan(num threshold) =>
      (value) => value is num && value > threshold;

  static bool Function(dynamic) isLessThan(num threshold) =>
      (value) => value is num && value < threshold;

  static bool Function(dynamic) isBetween(num min, num max) =>
      (value) => value is num && value >= min && value <= max;

  static bool Function(dynamic) matchesRegex(String pattern) =>
      (value) => value is String && RegExp(pattern).hasMatch(value);

  static bool Function(dynamic) isOneOf(List<dynamic> allowedValues) =>
      (value) => allowedValues.contains(value);

  static bool Function(dynamic) hasMinLength(int minLength) =>
      (value) => value is String && value.length >= minLength;

  static bool Function(dynamic) hasMaxLength(int maxLength) =>
      (value) => value is String && value.length <= maxLength;

  static bool Function(dynamic) isEmail = (value) =>
      value is String &&
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);

  static bool Function(dynamic) isUrl =
      (value) => value is String && Uri.tryParse(value) != null;

  static bool Function(dynamic) isPhoneNumber = (value) =>
      value is String &&
      RegExp(r'^\+?[0-9]{1,3}-?[0-9]{3,14}$').hasMatch(value);

  static bool Function(dynamic) isDate =
      (value) => value is String && DateTime.tryParse(value) != null;

  static bool Function(dynamic) isType(Type type) =>
      (value) => value.runtimeType == type;

  Function(dynamic) hasMinValue(num minValue) =>
      (value) => value is num && value >= minValue;

  static bool Function(dynamic) hasMaxValue(num maxValue) =>
      (value) => value is num && value <= maxValue;

  static bool Function(dynamic) isPositive =
      (value) => value is num && value > 0;

  static bool Function(dynamic) isNegative =
      (value) => value is num && value < 0;

  static bool Function(dynamic) isNonNegative =
      (value) => value is num && value >= 0;

  static bool Function(dynamic) isNonPositive =
      (value) => value is num && value <= 0;

  // Parent-Child Validators
  static bool Function(Entity) hasParentType(String parentType) => (Entity e) =>
      e.concept.parents.any((parent) => parent.runtimeType == parentType);

  static bool Function(Entity) hasChildType(Type childType) => (Entity e) =>
      e.concept.children.any((child) => child.runtimeType == childType);

  static bool Function(Entity) hasParentWithAttribute(String attributeName) =>
      (Entity e) => e.concept.parents
          .any((parent) => parent.getAttribute(attributeName) != null);

  static bool Function(Entity) hasChildWithAttribute(String attributeName) =>
      (Entity e) => e.concept.children
          .any((child) => child.getAttribute(attributeName) != null);

  // Neighbor Validators
  static bool Function(Entity) isNeighborOf(Entity neighbor) => (Entity e) =>
      e.concept.children.contains(neighbor.concept) ||
      e.concept.parents.contains(neighbor.concept);

  // Type and Property Validators
  static bool Function(Entity) isTypeWithProperty(Type type, String property) =>
      (Entity e) => e.runtimeType == type && e.getAttribute(property) != null;

  static bool Function(Entity) isTypeWithParentType(
          Type type, Type parentType) =>
      (Entity e) =>
          e.runtimeType == type &&
          e.concept.parents.any((parent) => parent.runtimeType == parentType);

  static bool Function(Entity) isTypeWithChildType(Type type, Type childType) =>
      (Entity e) =>
          e.runtimeType == type &&
          e.concept.children.any((child) => child.runtimeType == childType);

  static bool Function(Entity) isTypeWithNeighbor(Entity neighbor) =>
      (Entity e) =>
          e.runtimeType == neighbor.runtimeType ||
          e.concept.children.contains(neighbor.concept) ||
          e.concept.parents.contains(neighbor.concept);

  static bool Function(Entity) isTypeWithParent(Entity parent) => (Entity e) =>
      e.runtimeType == parent.runtimeType ||
      e.concept.parents.contains(parent.concept);

  static bool Function(Entity) isTypeWithChild(Entity child) => (Entity e) =>
      e.runtimeType == child.runtimeType ||
      e.concept.children.contains(child.concept);

  static bool Function(Entity) isTypeWithNeighborType(Type neighborType) =>
      (Entity e) =>
          e.runtimeType == neighborType ||
          e.concept.children
              .any((child) => child.runtimeType == neighborType) ||
          e.concept.parents.any((parent) => parent.runtimeType == neighborType);

  static bool Function(Entity) isTypeWithParentTypeAndProperty(
          Type type, Type parentType, String property) =>
      (Entity e) =>
          e.runtimeType == type &&
          e.concept.parents.any((parent) =>
              parent.runtimeType == parentType &&
              parent.getAttribute(property) != null);

  static bool Function(Entity) isTypeWithChildTypeAndAttribute(
          Type type, Type childType, String attribute) =>
      (Entity e) =>
          e.runtimeType == type &&
          e.concept.children.any((child) =>
              child.runtimeType == childType &&
              child.getAttribute(attribute) != null);

  static bool Function(Entity) compositeValidator(
          List<bool Function(dynamic)> validators) =>
      (Entity e) => validators.every((validator) => validator(e));
}
