part of ednet_core;

/// A policy that validates relationships between entities.
///
/// The [RelationshipPolicy] class extends [Policy] to provide specialized validation
/// for entity relationships. It can validate:
/// - Parent-child relationships
/// - Relationship existence
/// - Relationship cardinality
/// - Relationship attribute values
///
/// Example usage:
/// ```dart
/// final categoryPolicy = RelationshipPolicy(
///   name: 'CategoryPolicy',
///   description: 'Product must have a valid category',
///   relationshipName: 'category',
///   relationshipType: RelationshipType.parent,
///   validator: RelationshipValidators.isNotNull,
/// );
///
/// final minChildrenPolicy = RelationshipPolicy(
///   name: 'MinChildrenPolicy',
///   description: 'Category must have at least 3 products',
///   relationshipName: 'products',
///   relationshipType: RelationshipType.child,
///   validator: RelationshipValidators.hasMinimumChildren(3),
/// );
/// ```
class RelationshipPolicy extends Policy {
  /// The name of the relationship to validate.
  final String relationshipName;

  /// The type of relationship to validate (parent or child).
  final RelationshipType relationshipType;

  /// The function that validates the relationship.
  final bool Function(Entity, dynamic) validator;

  /// Creates a new [RelationshipPolicy] instance.
  ///
  /// [name] is the unique name of the policy.
  /// [description] is a human-readable description of what the policy enforces.
  /// [relationshipName] is the name of the relationship to validate.
  /// [relationshipType] is the type of relationship to validate.
  /// [validator] is the function that validates the relationship.
  /// [scope] is the scope at which the policy should be evaluated.
  RelationshipPolicy({
    required String name,
    required String description,
    required this.relationshipName,
    required this.relationshipType,
    required this.validator,
    PolicyScope? scope,
  }) : super(
            name,
            description,
            (Entity e) =>
                e.getRelationship(relationshipName) != null &&
                validator(e, e.getRelationship(relationshipName)),
            scope: scope);

  @override
  bool evaluate(Entity entity) {
    dynamic relationship = getRelationship(entity);
    if (relationship == null) {
      return false;
    }
    return validator(entity, relationship);
  }

  /// Gets the relationship value from the entity based on the relationship type.
  ///
  /// [entity] is the entity to get the relationship from.
  /// Returns the relationship value (parent entity or child collection).
  dynamic getRelationship(Entity entity) {
    switch (relationshipType) {
      case RelationshipType.parent:
        return entity.getParent(relationshipName);
      case RelationshipType.child:
        return entity.getChild(relationshipName);
    }
  }
}

/// Defines the types of relationships that can be validated.
enum RelationshipType {
  /// A parent relationship (e.g., a product's category).
  parent,

  /// A child relationship (e.g., a category's products).
  child
}

/// Provides common relationship validation functions.
///
/// The [RelationshipValidators] class contains static functions for common
/// relationship validation scenarios. These can be used with [RelationshipPolicy]
/// to create policies for common relationship constraints.
///
/// Example usage:
/// ```dart
/// // Check if a relationship exists
/// final hasCategory = RelationshipValidators.isNotNull;
///
/// // Check minimum number of children
/// final hasMinProducts = RelationshipValidators.hasMinimumChildren(3);
///
/// // Check parent attribute value
/// final categoryIsActive = RelationshipValidators.parentHasAttribute('status', 'active');
///
/// // Check all children have a specific attribute value
/// final allProductsInStock = RelationshipValidators.allChildrenHaveAttribute('inStock', true);
/// ```
class RelationshipValidators {
  /// Validates that a relationship exists (is not null).
  static bool Function(Entity, dynamic) isNotNull = (_, value) => value != null;

  /// Creates a validator that checks for a minimum number of children.
  ///
  /// [minCount] is the minimum number of children required.
  /// Returns a validator function that checks if the child collection has at least [minCount] items.
  static bool Function(Entity, dynamic) hasMinimumChildren(int minCount) {
    return (_, value) {
      if (value is Entities) {
        return value.length >= minCount;
      }
      return false;
    };
  }

  /// Creates a validator that checks for a maximum number of children.
  ///
  /// [maxCount] is the maximum number of children allowed.
  /// Returns a validator function that checks if the child collection has at most [maxCount] items.
  static bool Function(Entity, dynamic) hasMaximumChildren(int maxCount) {
    return (_, value) {
      if (value is Entities) {
        return value.length <= maxCount;
      }
      return false;
    };
  }

  /// Creates a validator that checks a parent's attribute value.
  ///
  /// [attributeName] is the name of the attribute to check.
  /// [expectedValue] is the expected value of the attribute.
  /// Returns a validator function that checks if the parent entity's attribute matches [expectedValue].
  static bool Function(Entity, dynamic) parentHasAttribute(
      String attributeName, dynamic expectedValue) {
    return (_, value) {
      if (value is Entity) {
        return value.getAttribute(attributeName) == expectedValue;
      }
      return false;
    };
  }

  /// Creates a validator that checks all children's attribute values.
  ///
  /// [attributeName] is the name of the attribute to check.
  /// [expectedValue] is the expected value of the attribute.
  /// Returns a validator function that checks if all child entities' attributes match [expectedValue].
  static bool Function(Entity, dynamic) allChildrenHaveAttribute(
      String attributeName, dynamic expectedValue) {
    return (_, value) {
      if (value is Entities) {
        return value.every(
            (child) => child.getAttribute(attributeName) == expectedValue);
      }
      return false;
    };
  }

  /// Creates a validator from a custom validation function.
  ///
  /// [customValidator] is the custom validation function to use.
  /// Returns a validator function that uses the custom validation logic.
  static bool Function(Entity, dynamic) customRelationshipValidator(
      bool Function(Entity parent, dynamic relationship) customValidator) {
    return (parent, relationship) => customValidator(parent, relationship);
  }
}
