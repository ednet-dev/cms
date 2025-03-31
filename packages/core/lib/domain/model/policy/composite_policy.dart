part of ednet_core;

/// A policy that combines multiple policies with a specified evaluation strategy.
///
/// The [CompositePolicy] class implements [IPolicy] to provide a way to combine
/// multiple policies into a single policy. It supports different evaluation strategies
/// through the [CompositePolicyType] enum:
/// - [CompositePolicyType.all]: All policies must pass
/// - [CompositePolicyType.any]: At least one policy must pass
/// - [CompositePolicyType.none]: No policies should pass
/// - [CompositePolicyType.majority]: More than half of the policies must pass
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
/// final stockPolicy = AttributePolicy(
///   name: 'StockPolicy',
///   description: 'Product must have stock',
///   attributeName: 'stock',
///   validator: AttributeValidators.isGreaterThan(0),
/// );
///
/// final productPolicies = CompositePolicy(
///   name: 'ProductPolicies',
///   description: 'Combined product validation policies',
///   policies: [pricePolicy, stockPolicy],
///   type: CompositePolicyType.all,
/// );
/// ```
class CompositePolicy implements IPolicy {
  /// The unique name of the composite policy.
  @override
  final String name;

  /// A human-readable description of what the composite policy enforces.
  @override
  final String description;

  /// The list of policies to evaluate.
  final List<IPolicy> policies;

  /// The type of composite policy that determines how the policies are evaluated.
  final CompositePolicyType type;

  /// The scope at which the composite policy should be evaluated.
  @override
  final PolicyScope? scope;

  /// Creates a new [CompositePolicy] instance.
  ///
  /// [name] is the unique name of the composite policy.
  /// [description] is a human-readable description of what the policy enforces.
  /// [policies] is the list of policies to evaluate.
  /// [type] is the type of composite policy that determines how the policies are evaluated.
  /// [scope] is the scope at which the policy should be evaluated.
  CompositePolicy({
    required this.name,
    required this.description,
    required this.policies,
    required this.type,
    this.scope,
  });

  /// Evaluates the composite policy against an entity.
  ///
  /// This method evaluates all policies in the [policies] list according to the
  /// [type] of composite policy. The evaluation strategy is:
  /// - [CompositePolicyType.all]: Returns true only if all policies pass
  /// - [CompositePolicyType.any]: Returns true if at least one policy passes
  /// - [CompositePolicyType.none]: Returns true if no policies pass
  /// - [CompositePolicyType.majority]: Returns true if more than half of the policies pass
  ///
  /// [entity] is the entity to evaluate the policy against.
  /// Returns true if the policy evaluation passes according to the composite type.
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

  /// Evaluates the composite policy against an entity and returns detailed results.
  ///
  /// This method evaluates all policies in the [policies] list according to the
  /// [type] of composite policy, collecting any policy violations that occur.
  /// The evaluation strategy is the same as [evaluate], but this method provides
  /// more detailed information about why the evaluation failed.
  ///
  /// [entity] is the entity to evaluate the policy against.
  /// Returns a [PolicyEvaluationResult] containing the success status and any violations.
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
}

/// Defines the different types of composite policy evaluation strategies.
///
/// The [CompositePolicyType] enum defines how multiple policies should be
/// evaluated in a [CompositePolicy]:
/// - [all]: All policies must pass for the composite policy to pass
/// - [any]: At least one policy must pass for the composite policy to pass
/// - [none]: No policies should pass for the composite policy to pass
/// - [majority]: More than half of the policies must pass for the composite policy to pass
enum CompositePolicyType {
  /// All policies must pass for the composite policy to pass.
  all,

  /// At least one policy must pass for the composite policy to pass.
  any,

  /// No policies should pass for the composite policy to pass.
  none,

  /// More than half of the policies must pass for the composite policy to pass.
  majority
}
