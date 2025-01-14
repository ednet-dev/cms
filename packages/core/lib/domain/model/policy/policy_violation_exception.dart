part of ednet_core;

class PolicyViolationException implements Exception {
  final List<PolicyViolation> violations;

  PolicyViolationException(this.violations);

  @override
  String toString() {
    return 'Policy violations: ${violations.map((v) => v.toString()).join(", ")}';
  }
}
