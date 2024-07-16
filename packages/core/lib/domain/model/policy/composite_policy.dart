part of ednet_core;

class CompositePolicy extends Policy {
  final List<IPolicy> policies;
  final CompositePolicyType type;

  CompositePolicy({
    required String name,
    required String description,
    required this.policies,
    required this.type,
  }) : super(name, description, (Entity e) => true) {
    // Override the evaluationFunction in the super constructor
    _evaluationFunction = (Entity e) => _evaluateComposite(e);
  }

  bool _evaluateComposite(Entity entity) {
    switch (type) {
      case CompositePolicyType.all:
        return policies.every((policy) => policy.evaluate(entity));
      case CompositePolicyType.any:
        return policies.any((policy) => policy.evaluate(entity));
      case CompositePolicyType.none:
        return !policies.any((policy) => policy.evaluate(entity));
      case CompositePolicyType.majority:
        int passCount =
            policies.where((policy) => policy.evaluate(entity)).length;
        return passCount > policies.length / 2;
    }
  }

  @override
  PolicyEvaluationResult evaluateWithDetails(Entity entity) {
    List<PolicyViolation> violations = [];
    bool overallResult = true;

    for (var policy in policies) {
      if (policy is Policy) {
        var result = policy.evaluateWithDetails(entity);
        if (!result.success) {
          violations.addAll(result.violations);
          if (type == CompositePolicyType.all) {
            overallResult = false;
          }
        } else if (type == CompositePolicyType.none) {
          violations
              .add(PolicyViolation(policy.name, 'Policy unexpectedly passed'));
          overallResult = false;
        }
      } else {
        if (!policy.evaluate(entity)) {
          violations.add(PolicyViolation(
              policy.name, 'Policy evaluation failed: ${policy.description}'));
          if (type == CompositePolicyType.all) {
            overallResult = false;
          }
        } else if (type == CompositePolicyType.none) {
          violations
              .add(PolicyViolation(policy.name, 'Policy unexpectedly passed'));
          overallResult = false;
        }
      }
    }

    if (type == CompositePolicyType.any &&
        violations.length == policies.length) {
      overallResult = false;
    } else if (type == CompositePolicyType.majority) {
      overallResult = violations.length < policies.length / 2;
    }

    return PolicyEvaluationResult(overallResult, violations);
  }
}

enum CompositePolicyType {
  all, // All policies must pass
  any, // At least one policy must pass
  none, // No policies should pass
  majority // More than half of the policies must pass
}
