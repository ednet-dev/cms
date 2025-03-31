part of ednet_core;

/// Evaluates domain policies against entities and provides detailed evaluation results.
///
/// The [PolicyEvaluator] class is responsible for:
/// - Evaluating individual policies or all applicable policies
/// - Tracking policy evaluation through a tracer
/// - Handling policy scope and exceptions
/// - Providing detailed evaluation results and violations
///
/// Example usage:
/// ```dart
/// final registry = PolicyRegistry();
/// final evaluator = PolicyEvaluator(registry);
///
/// // Evaluate a specific policy
/// final result = evaluator.evaluate(product, policyKey: 'pricePolicy');
/// if (!result.success) {
///   print('Policy violations: ${result.violations}');
/// }
///
/// // Evaluate all applicable policies
/// final allResults = evaluator.evaluate(product);
///
/// // Get evaluation trace
/// print(evaluator.getEvaluationTrace());
/// ```
class PolicyEvaluator {
  /// The registry containing all available policies.
  final PolicyRegistry _policyRegistry;

  /// The tracer for tracking policy evaluation.
  final PolicyEvaluationTracer _tracer;

  /// Creates a new [PolicyEvaluator] instance.
  ///
  /// [_policyRegistry] is the registry containing the policies to evaluate.
  PolicyEvaluator(this._policyRegistry) : _tracer = PolicyEvaluationTracer();

  /// Evaluates policies against the given entity.
  ///
  /// [entity] is the entity to evaluate.
  /// [policyKey] is an optional key to evaluate a specific policy.
  /// Returns a [PolicyEvaluationResult] containing the evaluation results.
  PolicyEvaluationResult evaluate(Entity entity, {String? policyKey}) {
    _tracer.clear();

    if (policyKey != null) {
      return _evaluateSinglePolicy(entity, policyKey);
    } else {
      return _evaluateAllPolicies(entity);
    }
  }

  /// Evaluates a single policy against the given entity.
  ///
  /// [entity] is the entity to evaluate.
  /// [policyKey] is the key of the policy to evaluate.
  /// Returns a [PolicyEvaluationResult] containing the evaluation results.
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

  /// Evaluates all applicable policies against the given entity.
  ///
  /// [entity] is the entity to evaluate.
  /// Returns a [PolicyEvaluationResult] containing all violations.
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

  /// Gets the evaluation trace as a string.
  ///
  /// Returns a formatted string containing the evaluation history.
  String getEvaluationTrace() {
    return _tracer.getTrace();
  }
}

/// Represents the result of evaluating one or more policies.
///
/// The [PolicyEvaluationResult] class contains:
/// - Whether the evaluation was successful
/// - Any policy violations that occurred
///
/// Example usage:
/// ```dart
/// final result = evaluator.evaluate(entity);
/// if (!result.success) {
///   print('Violations: ${result.violations}');
/// }
/// ```
class PolicyEvaluationResult {
  /// Whether all evaluated policies passed.
  final bool success;

  /// The list of policy violations that occurred.
  final List<PolicyViolation> violations;

  /// Creates a new [PolicyEvaluationResult] instance.
  ///
  /// [success] indicates whether all policies passed.
  /// [violations] is the list of policy violations that occurred.
  PolicyEvaluationResult(this.success, this.violations);
}

/// Represents a single policy violation.
///
/// The [PolicyViolation] class contains:
/// - The key of the violated policy
/// - A message describing the violation
///
/// Example usage:
/// ```dart
/// final violation = PolicyViolation('pricePolicy', 'Price must be positive');
/// print(violation.toString()); // "Policy "pricePolicy" violated: Price must be positive"
/// ```
class PolicyViolation {
  /// The key of the violated policy.
  final String policyKey;

  /// A message describing the violation.
  final String message;

  /// Creates a new [PolicyViolation] instance.
  ///
  /// [policyKey] is the key of the violated policy.
  /// [message] is a description of the violation.
  PolicyViolation(this.policyKey, this.message);

  /// Returns a string representation of this violation.
  @override
  String toString() => 'Policy "$policyKey" violated: $message';
}
