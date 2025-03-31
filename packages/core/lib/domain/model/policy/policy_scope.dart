part of ednet_core;

/// Defines the scope of applicability for domain policies.
///
/// The [PolicyScope] class determines when a policy should be applied by specifying:
/// - Which domain concepts the policy applies to
/// - What conditions must be met for the policy to be applicable
///
/// Example usage:
/// ```dart
/// // Create a scope that applies to all products
/// final productScope = PolicyScope({'Product'});
///
/// // Create a scope that applies to active products
/// final activeProductScope = PolicyScope(
///   {'Product'},
///   {'status': 'active'},
/// );
///
/// // Check if an entity is within scope
/// if (productScope.isWithinScope(productEntity)) {
///   // Apply policy...
/// }
///
/// // Merge two scopes
/// final mergedScope = productScope.merge(activeProductScope);
/// ```
class PolicyScope {
  /// The set of concept codes that this scope applies to.
  /// If empty, the scope applies to all concepts.
  final Set<String> applicableConcepts;

  /// A map of attribute conditions that must be met for the scope to apply.
  /// Key: attribute code; Value: expected attribute value.
  final Map<String, dynamic> conditions;

  /// Creates a new [PolicyScope] instance.
  ///
  /// [applicableConcepts] is the set of concept codes that this scope applies to.
  /// [conditions] is an optional map of attribute conditions that must be met.
  PolicyScope(this.applicableConcepts, [this.conditions = const {}]);

  /// Checks if the given entity is within this scope.
  ///
  /// [entity] is the entity to check.
  /// Returns true if:
  /// 1. The entity's concept is in [applicableConcepts] (or [applicableConcepts] is empty)
  /// 2. All conditions in [conditions] are satisfied by the entity's attributes
  bool isWithinScope(Entity entity) {
    if (applicableConcepts.isNotEmpty &&
        !applicableConcepts.contains(entity.concept.code)) {
      return false;
    }
    for (var entry in conditions.entries) {
      if (entity.getAttribute(entry.key) != entry.value) {
        return false;
      }
    }
    return true;
  }

  /// Merges this scope with another scope.
  ///
  /// [other] is the scope to merge with. If null, returns this scope.
  /// Returns a new scope that:
  /// 1. Applies to the union of both scopes' applicable concepts
  /// 2. Requires all conditions from both scopes to be met
  PolicyScope merge(PolicyScope? other) {
    if (other == null) return this;
    return PolicyScope(
      applicableConcepts.union(other.applicableConcepts),
      {...conditions, ...other.conditions},
    );
  }
}
