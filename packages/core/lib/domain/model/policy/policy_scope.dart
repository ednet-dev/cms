part of ednet_core;

class PolicyScope {
  final Set<String> applicableConcepts;
  final Map<String, dynamic> conditions;

  PolicyScope(this.applicableConcepts, [this.conditions = const {}]);

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

  PolicyScope merge(PolicyScope? other) {
    if (other == null) return this;
    return PolicyScope(
      applicableConcepts.union(other.applicableConcepts),
      {...conditions, ...other.conditions},
    );
  }
}
