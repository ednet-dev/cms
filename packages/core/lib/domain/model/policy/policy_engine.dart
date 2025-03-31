part of ednet_core;

/// A class that manages and executes domain policies.
///
/// The [PolicyEngine] class is responsible for:
/// - Managing a collection of domain policies
/// - Determining which policies apply to a given entity
/// - Executing applicable policies in the correct order
///
/// The engine can be associated with a [DomainSession] to provide context
/// for policy execution and access to domain services.
///
/// Example usage:
/// ```dart
/// final engine = PolicyEngine(session);
///
/// // Add policies
/// engine.addPolicy(PricePolicy());
/// engine.addPolicy(CategoryPolicy());
///
/// // Execute policies for an entity
/// engine.executePolicyGes(product);
/// ```
class PolicyEngine {
  /// The list of policies managed by this engine.
  final List<Policy> policies = [];

  /// The domain session associated with this engine.
  /// Provides context and access to domain services.
  final DomainSession? session;

  /// Creates a new [PolicyEngine] instance.
  ///
  /// [session] is the domain session to associate with this engine.
  /// If null, the engine will operate without session context.
  PolicyEngine(this.session);

  /// Adds a policy to this engine.
  ///
  /// [policy] is the policy to add.
  /// The policy will be evaluated when [executePolicyGes] is called.
  void addPolicy(Policy policy) {
    policies.add(policy);
  }

  /// Gets all policies that apply to the given entity.
  ///
  /// [entity] is the entity to check policies against.
  /// Returns a list of policies that evaluate to true for the entity.
  List<Policy> getApplicablePolicies(Entity entity) {
    return policies.where((policy) => policy.evaluate(entity)).toList();
  }

  /// Executes all applicable policies for the given entity.
  ///
  /// [entity] is the entity to execute policies for.
  /// This method:
  /// 1. Gets all applicable policies using [getApplicablePolicies]
  /// 2. Executes each policy in sequence
  /// 3. Logs policy execution (can be extended with more complex logic)
  void executePolicyGes(Entity entity) {
    final applicablePolicies = getApplicablePolicies(entity);
    for (var policy in applicablePolicies) {
      // Execute policy actions
      print('Executing policy: ${policy.name}');
      // You can add more complex logic here, such as creating and executing commands
    }
  }
}
