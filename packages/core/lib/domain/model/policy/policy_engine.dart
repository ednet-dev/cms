part of ednet_core;

class PolicyEngine {
  final List<Policy> policies = [];
  final DomainSession session;

  PolicyEngine(this.session);

  void addPolicy(Policy policy) {
    policies.add(policy);
  }

  List<Policy> getApplicablePolicies(Entity entity) {
    return policies.where((policy) => policy.evaluate(entity)).toList();
  }

  void executePoliciGes(Entity entity) {
    final applicablePolicies = getApplicablePolicies(entity);
    for (var policy in applicablePolicies) {
      // Execute policy actions
      print('Executing policy: ${policy.name}');
      // You can add more complex logic here, such as creating and executing commands
    }
  }
}
