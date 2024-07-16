part of ednet_core;

class CompositePolicy implements IPolicy {
  @override
  final String name;
  @override
  final String description;
  final List<IPolicy> policies;
  final CompositePolicyType type;
  @override
  final PolicyScope? scope;

  CompositePolicy({
    required this.name,
    required this.description,
    required this.policies,
    required this.type,
    this.scope,
  });

  @override
  bool evaluate(Entity entity) {
    int passCount = 0;
    int failCount = 0;

    for (var policy in policies) {
      var mergedScope = scope?.merge(policy.scope) ?? policy.scope;
      if (mergedScope != null && !mergedScope.isWithinScope(entity)) continue;
      if (policy.evaluate(entity)) {
        passCount++;
      } else {
        failCount++;
      }
    }

    switch (type) {
      case CompositePolicyType.all:
        return failCount == 0;
      case CompositePolicyType.any:
        return passCount > 0;
      case CompositePolicyType.none:
        return passCount == 0;
      case CompositePolicyType.majority:
        return passCount > failCount;
    }
  }

  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    List<PolicyViolation> violations = [];
    int passCount = 0;
    int failCount = 0;

    for (var policy in policies) {
      var mergedScope = scope?.merge(policy.scope) ?? policy.scope;
      if (mergedScope != null && !mergedScope.isWithinScope(entity)) continue;
      var result = policy.evaluateWithDetails(entity);
      if (result.success) {
        passCount++;
        if (type == CompositePolicyType.any) {
          return PolicyEvaluationResult(true, []);
        }
      } else {
        failCount++;
        violations.addAll(result.violations);
        if (type == CompositePolicyType.any) {
          break;
        }
      }
    }

    bool success;
    switch (type) {
      case CompositePolicyType.all:
        success = failCount == 0;
        break;
      case CompositePolicyType.any:
        success = passCount > 0;
        break;
      case CompositePolicyType.none:
        success = passCount == 0;
        break;
      case CompositePolicyType.majority:
        success = passCount > failCount;
        break;
    }

    return PolicyEvaluationResult(success, violations);
  }

  bool _evaluateWithScope(IPolicy policy, Entity entity) {
    var mergedScope = scope?.merge(policy.scope) ?? policy.scope;
    if (mergedScope != null && !mergedScope.isWithinScope(entity)) {
      return true; // Policy doesn't apply, so it's considered successful
    }
    return policy.evaluate(entity);
  }
}

enum CompositePolicyType {
  all, // All policies must pass
  any, // At least one policy must pass
  none, // No policies should pass
  majority // More than half of the policies must pass
}
