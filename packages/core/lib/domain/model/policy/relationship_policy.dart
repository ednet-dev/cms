part of ednet_core;

class RelationshipPolicy extends Policy {
  final String relationshipName;
  final RelationshipType relationshipType;
  final bool Function(Entity, dynamic) validator;

  RelationshipPolicy({
    required String name,
    required String description,
    required this.relationshipName,
    required this.relationshipType,
    required this.validator,
  }) : super(
            name,
            description,
            (Entity e) =>
                e.getRelationship(relationshipName) != null &&
                validator(e, e.getRelationship(relationshipName)));

  @override
  bool evaluate(Entity entity) {
    dynamic relationship = getRelationship(entity);
    if (relationship == null) {
      return false;
    }
    return validator(entity, relationship);
  }

  dynamic getRelationship(Entity entity) {
    switch (relationshipType) {
      case RelationshipType.parent:
        return entity.getParent(relationshipName);
      case RelationshipType.child:
        return entity.getChild(relationshipName);
      default:
        throw ArgumentError('Invalid relationship type');
    }
  }
}

enum RelationshipType { parent, child }

// Convenience functions for common relationship validations
class RelationshipValidators {
  static bool Function(Entity, dynamic) isNotNull = (_, value) => value != null;

  static bool Function(Entity, dynamic) hasMinimumChildren(int minCount) {
    return (_, value) {
      if (value is Entities) {
        return value.length >= minCount;
      }
      return false;
    };
  }

  static bool Function(Entity, dynamic) hasMaximumChildren(int maxCount) {
    return (_, value) {
      if (value is Entities) {
        return value.length <= maxCount;
      }
      return false;
    };
  }

  static bool Function(Entity, dynamic) parentHasAttribute(
      String attributeName, dynamic expectedValue) {
    return (_, value) {
      if (value is Entity) {
        return value.getAttribute(attributeName) == expectedValue;
      }
      return false;
    };
  }

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

  static bool Function(Entity, dynamic) customRelationshipValidator(
      bool Function(Entity parent, dynamic relationship) customValidator) {
    return (parent, relationship) => customValidator(parent, relationship);
  }
}
