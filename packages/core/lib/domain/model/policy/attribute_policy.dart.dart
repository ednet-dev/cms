part of ednet_core;

/// A policy that validates entity attributes.
///
/// The [AttributePolicy] class extends [Policy] to provide validation
/// for entity attributes. It can validate:
/// - Direct attributes of an entity
/// - Parent attributes
/// - Child attributes
/// - Complex validation rules using custom validators
///
/// Example usage:
/// ```dart
/// final pricePolicy = AttributePolicy(
///   name: 'PricePolicy',
///   description: 'Product price must be positive',
///   attributeName: 'price',
///   validator: AttributeValidators.isPositive,
/// );
///
/// final emailPolicy = AttributePolicy(
///   name: 'EmailPolicy',
///   description: 'Customer email must be valid',
///   attributeName: 'email',
///   validator: AttributeValidators.isEmail,
/// );
/// ```
class AttributePolicy extends Policy {
  /// The name of the attribute to validate.
  final String attributeName;

  /// The function that validates the attribute value.
  final bool Function(dynamic value) validator;

  /// Creates a new [AttributePolicy] instance.
  ///
  /// [name] is the unique name of the policy.
  /// [description] is a human-readable description of what the policy enforces.
  /// [attributeName] is the name of the attribute to validate.
  /// [validator] is the function that validates the attribute value.
  /// [scope] is the scope at which the policy should be evaluated.
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

/// Provides common attribute validation functions.
///
/// The [AttributeValidators] class contains static functions for common
/// attribute validation scenarios. These can be used with [AttributePolicy]
/// to create policies for common attribute constraints.
///
/// Example usage:
/// ```dart
/// // Basic validators
/// final isNotNull = AttributeValidators.isNotNull;
/// final isPositive = AttributeValidators.isPositive;
/// final isEmail = AttributeValidators.isEmail;
///
/// // Numeric validators
/// final isInRange = AttributeValidators.isBetween(0, 100);
/// final isGreaterThan = AttributeValidators.isGreaterThan(0);
///
/// // String validators
/// final isValidEmail = AttributeValidators.isEmail;
/// final isValidPhone = AttributeValidators.isPhoneNumber;
/// final hasMinLength = AttributeValidators.hasMinLength(3);
///
/// // Type validators
/// final isString = AttributeValidators.isType(String);
/// final isNumber = AttributeValidators.isType(num);
///
/// // Relationship validators
/// final hasParent = AttributeValidators.hasParentType('Category');
/// final hasChild = AttributeValidators.hasChildType(Product);
/// ```
class AttributeValidators {
  /// Wraps a validator with debug logging.
  ///
  /// [validator] is the validator to wrap.
  /// Returns a new validator that logs validation failures.
  static bool Function(dynamic) withDebug(bool Function(dynamic) validator) =>
      (value) {
        final result = validator(value);
        if (!result) {
          // print('Validation failed for value: $value');
          return false;
        }
        return result;
      };

  /// Validates that a value is not null.
  static bool Function(dynamic) isNotNull = withDebug((value) => value != null);

  /// Creates a validator that checks if a value is greater than a threshold.
  ///
  /// [threshold] is the value to compare against.
  /// Returns a validator that checks if the value is greater than [threshold].
  static bool Function(dynamic) isGreaterThan(num threshold) =>
      withDebug((value) => value is num && value > threshold);

  /// Creates a validator that checks if a value is less than a threshold.
  ///
  /// [threshold] is the value to compare against.
  /// Returns a validator that checks if the value is less than [threshold].
  static bool Function(dynamic) isLessThan(num threshold) =>
      withDebug((value) => value is num && value < threshold);

  /// Creates a validator that checks if a value is within a range.
  ///
  /// [min] is the minimum allowed value.
  /// [max] is the maximum allowed value.
  /// Returns a validator that checks if the value is between [min] and [max].
  static bool Function(dynamic) isBetween(num min, num max) =>
      withDebug((value) => value is num && value >= min && value <= max);

  /// Creates a validator that checks if a string matches a regex pattern.
  ///
  /// [pattern] is the regex pattern to match against.
  /// Returns a validator that checks if the string matches [pattern].
  static bool Function(dynamic) matchesRegex(String pattern) =>
      withDebug((value) => value is String && RegExp(pattern).hasMatch(value));

  /// Creates a validator that checks if a value is in a list of allowed values.
  ///
  /// [allowedValues] is the list of allowed values.
  /// Returns a validator that checks if the value is in [allowedValues].
  static bool Function(dynamic) isOneOf(List<dynamic> allowedValues) =>
      withDebug((value) => allowedValues.contains(value));

  /// Creates a validator that checks if a string has a minimum length.
  ///
  /// [minLength] is the minimum required length.
  /// Returns a validator that checks if the string length is >= [minLength].
  static bool Function(dynamic) hasMinLength(int minLength) =>
      withDebug((value) => value is String && value.length >= minLength);

  /// Creates a validator that checks if a string has a maximum length.
  ///
  /// [maxLength] is the maximum allowed length.
  /// Returns a validator that checks if the string length is <= [maxLength].
  static bool Function(dynamic) hasMaxLength(int maxLength) =>
      withDebug((value) => value is String && value.length <= maxLength);

  /// Validates that a value is a valid email address.
  static bool Function(dynamic) isEmail = withDebug((value) =>
      value is String &&
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value));

  /// Validates that a value is a valid URL.
  static bool Function(dynamic) isUrl =
      withDebug((value) => value is String && Uri.tryParse(value) != null);

  /// Validates that a value is a valid phone number.
  static bool Function(dynamic) isPhoneNumber = withDebug((value) =>
      value is String &&
      RegExp(r'^\+?[0-9]{1,3}-?[0-9]{3,14}$').hasMatch(value));

  /// Validates that a value is a valid date string.
  static bool Function(dynamic) isDate =
      withDebug((value) => value is String && DateTime.tryParse(value) != null);

  /// Creates a validator that checks if a value is of a specific type.
  ///
  /// [type] is the type to check against.
  /// Returns a validator that checks if the value's runtime type matches [type].
  static bool Function(dynamic) isType(Type type) =>
      withDebug((value) => value.runtimeType == type);

  /// Creates a validator that checks if a value is >= a minimum value.
  ///
  /// [minValue] is the minimum allowed value.
  /// Returns a validator that checks if the value is >= [minValue].
  static bool Function(dynamic) hasMinValue(num minValue) =>
      withDebug((value) => value is num && value >= minValue);

  /// Creates a validator that checks if a value is <= a maximum value.
  ///
  /// [maxValue] is the maximum allowed value.
  /// Returns a validator that checks if the value is <= [maxValue].
  static bool Function(dynamic) hasMaxValue(num maxValue) =>
      withDebug((value) => value is num && value <= maxValue);

  /// Validates that a value is positive (> 0).
  static bool Function(dynamic) isPositive =
      withDebug((value) => value is num && value > 0);

  /// Validates that a value is negative (< 0).
  static bool Function(dynamic) isNegative =
      withDebug((value) => value is num && value < 0);

  /// Validates that a value is non-negative (>= 0).
  static bool Function(dynamic) isNonNegative =
      withDebug((value) => value is num && value >= 0);

  /// Validates that a value is non-positive (<= 0).
  static bool Function(dynamic) isNonPositive =
      withDebug((value) => value is num && value <= 0);

  /// Creates a validator that checks if an entity has a parent of a specific type.
  ///
  /// [parentType] is the type of parent to check for.
  /// Returns a validator that checks if the entity has a parent of type [parentType].
  static bool Function(Entity) hasParentType(String parentType) =>
      withDebug((e) =>
          e.concept.parents.any((parent) => parent.runtimeType == parentType));

  /// Creates a validator that checks if an entity has a child of a specific type.
  ///
  /// [childType] is the type of child to check for.
  /// Returns a validator that checks if the entity has a child of type [childType].
  static bool Function(Entity) hasChildType(Type childType) => withDebug(
      (e) => e.concept.children.any((child) => child.runtimeType == childType));

  /// Creates a validator that checks if an entity has a parent with a specific attribute.
  ///
  /// [attributeName] is the name of the attribute to check for.
  /// Returns a validator that checks if any parent has the attribute [attributeName].
  static bool Function(Entity) hasParentWithAttribute(String attributeName) =>
      withDebug((e) => e.concept.parents
          .any((parent) => parent.getAttribute(attributeName) != null));

  /// Creates a validator that checks if an entity has a child with a specific attribute.
  ///
  /// [attributeName] is the name of the attribute to check for.
  /// Returns a validator that checks if any child has the attribute [attributeName].
  static bool Function(Entity) hasChildWithAttribute(String attributeName) =>
      withDebug((e) => e.concept.children
          .any((child) => child.getAttribute(attributeName) != null));

  /// Creates a validator that checks if an entity is a neighbor of another entity.
  ///
  /// [neighbor] is the entity to check for.
  /// Returns a validator that checks if the entity is a neighbor of [neighbor].
  static bool Function(Entity) isNeighborOf(Entity neighbor) => withDebug((e) =>
      e.concept.children.contains(neighbor.concept) ||
      e.concept.parents.contains(neighbor.concept));

  /// Creates a validator that checks if an entity is of a specific type and has a property.
  ///
  /// [type] is the type to check for.
  /// [property] is the name of the property to check for.
  /// Returns a validator that checks if the entity is of type [type] and has property [property].
  static bool Function(Entity) isTypeWithProperty(Type type, String property) =>
      withDebug(
          (e) => e.runtimeType == type && e.getAttribute(property) != null);

  /// Creates a validator that checks if an entity is of a specific type and has a parent of a specific type.
  ///
  /// [type] is the type to check for.
  /// [parentType] is the type of parent to check for.
  /// Returns a validator that checks if the entity is of type [type] and has a parent of type [parentType].
  static bool Function(Entity) isTypeWithParentType(
          Type type, Type parentType) =>
      withDebug((e) =>
          e.runtimeType == type &&
          e.concept.parents.any((parent) => parent.runtimeType == parentType));

  /// Creates a validator that checks if an entity is of a specific type and has a child of a specific type.
  ///
  /// [type] is the type to check for.
  /// [childType] is the type of child to check for.
  /// Returns a validator that checks if the entity is of type [type] and has a child of type [childType].
  static bool Function(Entity) isTypeWithChildType(Type type, Type childType) =>
      withDebug((e) =>
          e.runtimeType == type &&
          e.concept.children.any((child) => child.runtimeType == childType));

  /// Creates a validator that checks if an entity is of a specific type and has a neighbor.
  ///
  /// [neighbor] is the entity to check for.
  /// Returns a validator that checks if the entity is of type [neighbor]'s type or has [neighbor] as a neighbor.
  static bool Function(Entity) isTypeWithNeighbor(Entity neighbor) =>
      withDebug((e) =>
          e.runtimeType == neighbor.runtimeType ||
          e.concept.children.contains(neighbor.concept) ||
          e.concept.parents.contains(neighbor.concept));

  /// Creates a validator that checks if an entity is of a specific type and has a parent.
  ///
  /// [parent] is the parent entity to check for.
  /// Returns a validator that checks if the entity is of type [parent]'s type or has [parent] as a parent.
  static bool Function(Entity) isTypeWithParent(Entity parent) =>
      withDebug((e) =>
          e.runtimeType == parent.runtimeType ||
          e.concept.parents.contains(parent.concept));

  /// Creates a validator that checks if an entity is of a specific type and has a child.
  ///
  /// [child] is the child entity to check for.
  /// Returns a validator that checks if the entity is of type [child]'s type or has [child] as a child.
  static bool Function(Entity) isTypeWithChild(Entity child) => withDebug((e) =>
      e.runtimeType == child.runtimeType ||
      e.concept.children.contains(child.concept));

  /// Creates a validator that checks if an entity is of a specific type and has a neighbor of a specific type.
  ///
  /// [neighborType] is the type of neighbor to check for.
  /// Returns a validator that checks if the entity is of type [neighborType] or has a neighbor of type [neighborType].
  static bool Function(Entity) isTypeWithNeighborType(Type neighborType) =>
      withDebug((e) =>
          e.runtimeType == neighborType ||
          e.concept.children
              .any((child) => child.runtimeType == neighborType) ||
          e.concept.parents
              .any((parent) => parent.runtimeType == neighborType));

  /// Creates a validator that checks if an entity is of a specific type, has a parent of a specific type, and the parent has a property.
  ///
  /// [type] is the type to check for.
  /// [parentType] is the type of parent to check for.
  /// [property] is the name of the property to check for.
  /// Returns a validator that checks all three conditions.
  static bool Function(Entity) isTypeWithParentTypeAndProperty(
          Type type, Type parentType, String property) =>
      withDebug((e) =>
          e.runtimeType == type &&
          e.concept.parents.any((parent) =>
              parent.runtimeType == parentType &&
              parent.getAttribute(property) != null));

  /// Creates a validator that checks if an entity is of a specific type, has a child of a specific type, and the child has an attribute.
  ///
  /// [type] is the type to check for.
  /// [childType] is the type of child to check for.
  /// [attribute] is the name of the attribute to check for.
  /// Returns a validator that checks all three conditions.
  static bool Function(Entity) isTypeWithChildTypeAndAttribute(
          Type type, Type childType, String attribute) =>
      withDebug((e) =>
          e.runtimeType == type &&
          e.concept.children.any((child) =>
              child.runtimeType == childType &&
              child.getAttribute(attribute) != null));

  /// Creates a validator that combines multiple validators.
  ///
  /// [validators] is the list of validators to combine.
  /// Returns a validator that checks if all validators pass.
  static bool Function(Entity) compositeValidator(
          List<bool Function(dynamic)> validators) =>
      withDebug((e) => validators.every((validator) => validator(e)));
}
