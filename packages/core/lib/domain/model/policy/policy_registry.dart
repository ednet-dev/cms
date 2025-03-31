part of ednet_core;

/// A registry for managing domain policies.
///
/// The [PolicyRegistry] class provides a central location for registering, retrieving,
/// and evaluating domain policies. It maintains a map of policy keys to their implementations
/// and provides methods for policy management and evaluation.
///
/// Example usage:
/// ```dart
/// final registry = PolicyRegistry();
///
/// // Register a policy
/// registry.registerPolicy('pricePolicy', pricePolicy);
///
/// // Evaluate a specific policy
/// if (!registry.evaluateNamedPolicy('pricePolicy', product)) {
///   print('Price policy violation');
/// }
///
/// // Evaluate all applicable policies
/// final violations = registry.evaluateAllPolicies(product);
/// ```
class PolicyRegistry {
  /// Internal map of policy keys to their implementations.
  final Map<String, IPolicy> _policies = {};

  /// Registers a policy with the given key.
  ///
  /// [key] is the unique identifier for the policy.
  /// [policy] is the policy implementation to register.
  /// Throws [PolicyRegistrationException] if a policy with the same key already exists.
  void registerPolicy(String key, IPolicy policy) {
    if (_policies.containsKey(key)) {
      throw PolicyRegistrationException('Policy with key "$key" already exists.');
    }
    _policies[key] = policy;
  }

  /// Retrieves a policy by its key.
  ///
  /// [key] is the unique identifier of the policy to retrieve.
  /// Returns the policy if found, null otherwise.
  IPolicy? getPolicy(String key) => _policies[key];

  /// Removes a policy from the registry.
  ///
  /// [key] is the unique identifier of the policy to remove.
  void removePolicy(String key) {
    _policies.remove(key);
  }

  /// Returns all registered policies.
  ///
  /// Returns a list of all policy implementations.
  List<IPolicy> getAllPolicies() => _policies.values.toList();

  /// Evaluates a specific policy against an entity.
  ///
  /// [key] is the unique identifier of the policy to evaluate.
  /// [entity] is the entity to evaluate.
  /// Returns true if the policy is satisfied, false otherwise.
  /// Throws [PolicyNotFoundException] if the policy is not found.
  /// Skips evaluation if the entity is outside the policy's scope.
  bool evaluateNamedPolicy(String key, Entity entity) {
    var policy = getPolicy(key);
    if (policy == null) {
      throw PolicyNotFoundException('Policy not found: $key');
    }
    if (policy.scope != null && !policy.scope!.isWithinScope(entity)) {
      return true; // Skip evaluation for entities out of scope
    }
    return policy.evaluate(entity);
  }

  /// Evaluates all applicable policies against an entity.
  ///
  /// [entity] is the entity to evaluate.
  /// Returns a list of policy keys that were violated.
  /// Only evaluates policies whose scope includes the entity.
  List<String> evaluateAllPolicies(Entity entity) {
    return _policies.entries
        .where((entry) => entry.value.scope == null || entry.value.scope!.isWithinScope(entity))
        .map((entry) => entry.value.evaluateWithDetails(entity))
        .expand((result) => result.violations)
        .map((violation) => violation.policyKey)
        .toList();
  }

  /// Removes all policies from the registry.
  void clear() {
    _policies.clear();
  }
}

/// Exception thrown when attempting to register a policy with a key that already exists.
///
/// Example usage:
/// ```dart
/// try {
///   registry.registerPolicy('existingKey', policy);
/// } on PolicyRegistrationException catch (e) {
///   print('Registration failed: ${e.toString()}');
/// }
/// ```
class PolicyRegistrationException implements Exception {
  /// The error message describing the registration failure.
  final String message;

  /// Creates a new [PolicyRegistrationException] instance.
  ///
  /// [message] is the error message describing the registration failure.
  PolicyRegistrationException(this.message);

  /// Returns a string representation of this exception.
  @override
  String toString() => 'PolicyRegistrationException: $message';
}

/// Exception thrown when attempting to evaluate a policy that doesn't exist.
///
/// Example usage:
/// ```dart
/// try {
///   registry.evaluateNamedPolicy('nonexistentKey', entity);
/// } on PolicyNotFoundException catch (e) {
///   print('Evaluation failed: ${e.toString()}');
/// }
/// ```
class PolicyNotFoundException implements Exception {
  /// The error message describing the policy not found error.
  final String message;

  /// Creates a new [PolicyNotFoundException] instance.
  ///
  /// [message] is the error message describing the policy not found error.
  PolicyNotFoundException(this.message);

  /// Returns a string representation of this exception.
  @override
  String toString() => 'PolicyNotFoundException: $message';
}
