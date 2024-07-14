part of ednet_core;

class PolicyEvaluator {
  final PolicyRegistry _policyRegistry;

  PolicyEvaluator(this._policyRegistry);

  PolicyEvaluationResult evaluate(Entity entity, {String? policyKey}) {
    if (policyKey != null) {
      return _evaluateSinglePolicy(entity, policyKey);
    } else {
      return _evaluateAllPolicies(entity);
    }
  }

  PolicyEvaluationResult _evaluateSinglePolicy(
      Entity entity, String policyKey) {
    try {
      var policy = _policyRegistry.getPolicy(policyKey);
      if (policy == null) {
        return PolicyEvaluationResult(
            false, [PolicyViolation(policyKey, 'Policy not found')]);
      }
      bool result = policy.evaluate(entity);
      if (!result) {
        return PolicyEvaluationResult(
            false, [PolicyViolation(policyKey, 'Policy evaluation failed')]);
      }
      return PolicyEvaluationResult(true, []);
    } catch (e) {
      return PolicyEvaluationResult(
          false, [PolicyViolation(policyKey, 'Error during evaluation: $e')]);
    }
  }

  PolicyEvaluationResult _evaluateAllPolicies(Entity entity) {
    var violations = <PolicyViolation>[];
    for (var entry in _policyRegistry._policies.entries) {
      try {
        if (!entry.value.evaluate(entity)) {
          violations
              .add(PolicyViolation(entry.key, 'Policy evaluation failed'));
        }
      } catch (e) {
        violations
            .add(PolicyViolation(entry.key, 'Error during evaluation: $e'));
      }
    }
    return PolicyEvaluationResult(violations.isEmpty, violations);
  }
}

class PolicyEvaluationResult {
  final bool success;
  final List<PolicyViolation> violations;

  PolicyEvaluationResult(this.success, this.violations);
}

class PolicyViolation {
  final String policyKey;
  final String message;

  PolicyViolation(this.policyKey, this.message);

  @override
  String toString() => 'Policy "$policyKey" violated: $message';
}
