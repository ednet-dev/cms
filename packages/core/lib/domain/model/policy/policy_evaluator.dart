part of ednet_core;

class PolicyEvaluator {
  final PolicyRegistry _policyRegistry;
  final PolicyEvaluationTracer _tracer;

  PolicyEvaluator(this._policyRegistry) : _tracer = PolicyEvaluationTracer();

  PolicyEvaluationResult evaluate(Entity entity, {String? policyKey}) {
    _tracer.clear();

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
        return PolicyEvaluationResult(false, [
          PolicyViolation(policyKey, 'Policy not found'),
        ]);
      }

      _tracer.startEvaluation(policy.name, entity);

      if (policy.scope != null && !policy.scope!.isWithinScope(entity)) {
        _tracer.endEvaluation(policy.name, false);
        return PolicyEvaluationResult(true, []);
      }

      var details = policy.evaluateWithDetails(entity);
      _tracer.endEvaluation(policy.name, true);

      return details;
    } catch (e) {
      return PolicyEvaluationResult(
        false,
        [PolicyViolation(policyKey, 'Error during evaluation: $e')],
      );
    }
  }

  PolicyEvaluationResult _evaluateAllPolicies(Entity entity) {
    var violations = <PolicyViolation>[];
    for (var policy in _policyRegistry.getAllPolicies()) {
      _tracer.startEvaluation(policy.name, entity);

      if (policy.scope == null || policy.scope!.isWithinScope(entity)) {
        var result = policy.evaluateWithDetails(entity);
        if (!result.success) {
          violations.addAll(result.violations);
        }
        _tracer.endEvaluation(policy.name, violations.isEmpty);
      } else {
        _tracer.endEvaluation(policy.name, false);
      }
    }
    return PolicyEvaluationResult(violations.isEmpty, violations);
  }

  String getEvaluationTrace() {
    return _tracer.getTrace();
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
