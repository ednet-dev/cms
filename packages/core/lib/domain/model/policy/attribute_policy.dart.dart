part of ednet_core;

class AttributePolicy extends Policy {
  final String attributeName;
  final bool Function(dynamic value) validator;

  AttributePolicy({
    required String name,
    required String description,
    required this.attributeName,
    required this.validator,
    PolicyScope? scope,
  }) : super(
          name,
          description,
          (e) {
            final value = e.getAttribute(attributeName) ??
                e.getParent(attributeName) ??
                e.getChild(attributeName);
            final isValid = value != null && validator(value);
            if (!isValid) {
              print('Policy "$name" failed for value: $value');
            }
            return isValid;
          },
          scope: scope,
        );

  @override
  bool evaluate(Entity entity) {
    final attributeValue = entity.getAttribute(attributeName);
    final parentValue = entity.getParent(attributeName);
    final childValue = entity.getChild(attributeName);
    final value = attributeValue ?? parentValue ?? childValue;
    if (value == null) {
      print('Policy "$name" failed: attribute "$attributeName" is null.');
      return false;
    }
    final isValid = validator(value);
    if (!isValid) {
      print('Policy "$name: $description" failed for value: $value');
    }
    return isValid;
  }
}

// Convenience functions for common attribute validations
class AttributeValidators {
  static bool Function(dynamic) withDebug(bool Function(dynamic) validator) =>
      (value) {
        final result = validator(value);
        if (!result) {
          // print('Validation failed for value: $value');
          return false;
        }
        return result;
      };

  static bool Function(dynamic) isNotNull = withDebug((value) => value != null);

  static bool Function(dynamic) isGreaterThan(num threshold) =>
      withDebug((value) => value is num && value > threshold);

  static bool Function(dynamic) isLessThan(num threshold) =>
      withDebug((value) => value is num && value < threshold);

  static bool Function(dynamic) isBetween(num min, num max) =>
      withDebug((value) => value is num && value >= min && value <= max);

  static bool Function(dynamic) matchesRegex(String pattern) =>
      withDebug((value) => value is String && RegExp(pattern).hasMatch(value));

  static bool Function(dynamic) isOneOf(List<dynamic> allowedValues) =>
      withDebug((value) => allowedValues.contains(value));

  static bool Function(dynamic) hasMinLength(int minLength) =>
      withDebug((value) => value is String && value.length >= minLength);

  static bool Function(dynamic) hasMaxLength(int maxLength) =>
      withDebug((value) => value is String && value.length <= maxLength);

  static bool Function(dynamic) isEmail = withDebug((value) =>
      value is String &&
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value));

  static bool Function(dynamic) isUrl =
      withDebug((value) => value is String && Uri.tryParse(value) != null);

  static bool Function(dynamic) isPhoneNumber = withDebug((value) =>
      value is String &&
      RegExp(r'^\+?[0-9]{1,3}-?[0-9]{3,14}$').hasMatch(value));

  static bool Function(dynamic) isDate =
      withDebug((value) => value is String && DateTime.tryParse(value) != null);

  static bool Function(dynamic) isType(Type type) =>
      withDebug((value) => value.runtimeType == type);

  static bool Function(dynamic) hasMinValue(num minValue) =>
      withDebug((value) => value is num && value >= minValue);

  static bool Function(dynamic) hasMaxValue(num maxValue) =>
      withDebug((value) => value is num && value <= maxValue);

  static bool Function(dynamic) isPositive =
      withDebug((value) => value is num && value > 0);

  static bool Function(dynamic) isNegative =
      withDebug((value) => value is num && value < 0);

  static bool Function(dynamic) isNonNegative =
      withDebug((value) => value is num && value >= 0);

  static bool Function(dynamic) isNonPositive =
      withDebug((value) => value is num && value <= 0);

  // Parent-Child Validators
  static bool Function(Entity) hasParentType(String parentType) =>
      withDebug((e) =>
          e.concept.parents.any((parent) => parent.runtimeType == parentType));

  static bool Function(Entity) hasChildType(Type childType) => withDebug(
      (e) => e.concept.children.any((child) => child.runtimeType == childType));

  static bool Function(Entity) hasParentWithAttribute(String attributeName) =>
      withDebug((e) => e.concept.parents
          .any((parent) => parent.getAttribute(attributeName) != null));

  static bool Function(Entity) hasChildWithAttribute(String attributeName) =>
      withDebug((e) => e.concept.children
          .any((child) => child.getAttribute(attributeName) != null));

  // Neighbor Validators
  static bool Function(Entity) isNeighborOf(Entity neighbor) => withDebug((e) =>
      e.concept.children.contains(neighbor.concept) ||
      e.concept.parents.contains(neighbor.concept));

  // Type and Property Validators
  static bool Function(Entity) isTypeWithProperty(Type type, String property) =>
      withDebug(
          (e) => e.runtimeType == type && e.getAttribute(property) != null);

  static bool Function(Entity) isTypeWithParentType(
          Type type, Type parentType) =>
      withDebug((e) =>
          e.runtimeType == type &&
          e.concept.parents.any((parent) => parent.runtimeType == parentType));

  static bool Function(Entity) isTypeWithChildType(Type type, Type childType) =>
      withDebug((e) =>
          e.runtimeType == type &&
          e.concept.children.any((child) => child.runtimeType == childType));

  static bool Function(Entity) isTypeWithNeighbor(Entity neighbor) =>
      withDebug((e) =>
          e.runtimeType == neighbor.runtimeType ||
          e.concept.children.contains(neighbor.concept) ||
          e.concept.parents.contains(neighbor.concept));

  static bool Function(Entity) isTypeWithParent(Entity parent) =>
      withDebug((e) =>
          e.runtimeType == parent.runtimeType ||
          e.concept.parents.contains(parent.concept));

  static bool Function(Entity) isTypeWithChild(Entity child) => withDebug((e) =>
      e.runtimeType == child.runtimeType ||
      e.concept.children.contains(child.concept));

  static bool Function(Entity) isTypeWithNeighborType(Type neighborType) =>
      withDebug((e) =>
          e.runtimeType == neighborType ||
          e.concept.children
              .any((child) => child.runtimeType == neighborType) ||
          e.concept.parents
              .any((parent) => parent.runtimeType == neighborType));

  static bool Function(Entity) isTypeWithParentTypeAndProperty(
          Type type, Type parentType, String property) =>
      withDebug((e) =>
          e.runtimeType == type &&
          e.concept.parents.any((parent) =>
              parent.runtimeType == parentType &&
              parent.getAttribute(property) != null));

  static bool Function(Entity) isTypeWithChildTypeAndAttribute(
          Type type, Type childType, String attribute) =>
      withDebug((e) =>
          e.runtimeType == type &&
          e.concept.children.any((child) =>
              child.runtimeType == childType &&
              child.getAttribute(attribute) != null));

  static bool Function(Entity) compositeValidator(
          List<bool Function(dynamic)> validators) =>
      withDebug((e) => validators.every((validator) => validator(e)));
}
