part of ednet_core;

/// Exception thrown when one or more domain policies are violated.
///
/// The [PolicyViolationException] class represents a collection of policy violations
/// that occurred during policy evaluation. It provides a way to aggregate multiple
/// violations and present them in a human-readable format.
///
/// Example usage:
/// ```dart
/// try {
///   final result = policy.evaluateWithDetails(entity);
///   if (!result.isValid) {
///     throw PolicyViolationException(result.violations);
///   }
/// } on PolicyViolationException catch (e) {
///   print('Policy violations found: ${e.toString()}');
/// }
/// ```
class PolicyViolationException implements Exception {
  /// The list of policy violations that occurred.
  final List<PolicyViolation> violations;

  /// Creates a new [PolicyViolationException] instance.
  ///
  /// [violations] is the list of policy violations that occurred.
  PolicyViolationException(this.violations);

  /// Returns a string representation of this exception.
  ///
  /// The string includes all policy violations, separated by commas.
  @override
  String toString() {
    return 'Policy violations: ${violations.map((v) => v.toString()).join(", ")}';
  }
}
