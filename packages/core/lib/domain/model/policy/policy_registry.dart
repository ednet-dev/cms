part of ednet_core;

class PolicyRegistry {
  final Map<String, IPolicy> _policies = {};

  void registerPolicy(String key, IPolicy policy) {
    if (_policies.containsKey(key)) {
      throw PolicyRegistrationException('Policy with key "$key" already exists.');
    }
    _policies[key] = policy;
  }

  IPolicy? getPolicy(String key) => _policies[key];

  void removePolicy(String key) {
    _policies.remove(key);
  }

  List<IPolicy> getAllPolicies() => _policies.values.toList();

  bool evaluatePolicy(String key, Entity entity) {
    var policy = getPolicy(key);
    if (policy == null) {
      throw PolicyNotFoundException('Policy not found: $key');
    }
    if (policy.scope != null && !policy.scope!.isWithinScope(entity)) {
      return true; // Skip evaluation for entities out of scope
    }
    return policy.evaluate(entity);
  }

  List<String> evaluateAllPolicies(Entity entity) {
    return _policies.entries
        .where((entry) => entry.value.scope == null || entry.value.scope!.isWithinScope(entity))
        .map((entry) => entry.value.evaluateWithDetails(entity))
        .expand((result) => result.violations)
        .map((violation) => violation.policyKey)
        .toList();
  }

  void clear() {
    _policies.clear();
  }
}

class PolicyRegistrationException implements Exception {
  final String message;

  PolicyRegistrationException(this.message);

  @override
  String toString() => 'PolicyRegistrationException: $message';
}

class PolicyNotFoundException implements Exception {
  final String message;

  PolicyNotFoundException(this.message);

  @override
  String toString() => 'PolicyNotFoundException: $message';
}
