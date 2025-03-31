part of ednet_core;

/// A tracer for tracking the evaluation of policies and their checks.
///
/// The [PolicyEvaluationTracer] class provides detailed tracing of:
/// - Policy evaluation start and end
/// - Attribute value checks
/// - Relationship value checks
/// - Nested policy evaluations through depth tracking
///
/// Example usage:
/// ```dart
/// final tracer = PolicyEvaluationTracer();
///
/// // Start policy evaluation
/// tracer.startEvaluation('pricePolicy', product);
///
/// // Add attribute check
/// tracer.addAttributeCheck('price', 100.0, true);
///
/// // Add relationship check
/// tracer.addRelationshipCheck('category', electronics, true);
///
/// // End policy evaluation
/// tracer.endEvaluation('pricePolicy', true);
///
/// // Get trace output
/// print(tracer.getTrace());
/// ```
class PolicyEvaluationTracer {
  /// The list of trace entries recording the evaluation process.
  final List<TraceEntry> _traceEntries = [];

  /// The current nesting depth of policy evaluations.
  int _depth = 0;

  /// Records the start of a policy evaluation.
  ///
  /// [policyName] is the name of the policy being evaluated.
  /// [entity] is the entity being evaluated.
  void startEvaluation(String policyName, Entity entity) {
    _traceEntries.add(TraceEntry(
      type: TraceEntryType.start,
      policyName: policyName,
      entityInfo: '${entity.concept.code}(${entity.oid})',
      depth: _depth,
    ));
    _depth++;
  }

  /// Records the end of a policy evaluation.
  ///
  /// [policyName] is the name of the policy being evaluated.
  /// [result] indicates whether the policy evaluation passed.
  void endEvaluation(String policyName, bool result) {
    _depth--;
    _traceEntries.add(TraceEntry(
      type: TraceEntryType.end,
      policyName: policyName,
      result: result,
      depth: _depth,
    ));
  }

  /// Records an attribute value check.
  ///
  /// [attributeName] is the name of the attribute being checked.
  /// [value] is the value being checked.
  /// [result] indicates whether the check passed.
  void addAttributeCheck(String attributeName, dynamic value, bool result) {
    _traceEntries.add(TraceEntry(
      type: TraceEntryType.attributeCheck,
      attributeName: attributeName,
      attributeValue: value,
      result: result,
      depth: _depth,
    ));
  }

  /// Records a relationship value check.
  ///
  /// [relationshipName] is the name of the relationship being checked.
  /// [value] is the value being checked.
  /// [result] indicates whether the check passed.
  void addRelationshipCheck(
      String relationshipName, dynamic value, bool result) {
    _traceEntries.add(TraceEntry(
      type: TraceEntryType.relationshipCheck,
      relationshipName: relationshipName,
      relationshipValue: value,
      result: result,
      depth: _depth,
    ));
  }

  /// Gets the formatted trace output as a string.
  ///
  /// Returns a string containing all trace entries with proper indentation.
  String getTrace() {
    StringBuffer buffer = StringBuffer();
    for (var entry in _traceEntries) {
      buffer.writeln(entry.toString());
    }
    return buffer.toString();
  }

  /// Clears all trace entries and resets the depth counter.
  void clear() {
    _traceEntries.clear();
    _depth = 0;
  }
}

/// Types of entries that can be recorded in the policy evaluation trace.
///
/// The [TraceEntryType] enum defines the different types of events that can be
/// traced during policy evaluation:
/// - [start]: Beginning of a policy evaluation
/// - [end]: End of a policy evaluation
/// - [attributeCheck]: Check of an attribute value
/// - [relationshipCheck]: Check of a relationship value
enum TraceEntryType { start, end, attributeCheck, relationshipCheck }

/// Represents a single entry in the policy evaluation trace.
///
/// The [TraceEntry] class captures all information about a traced event:
/// - The type of event
/// - Policy name (for start/end events)
/// - Entity information (for start events)
/// - Attribute/relationship details (for check events)
/// - Evaluation results
/// - Nesting depth
///
/// Example usage:
/// ```dart
/// final entry = TraceEntry(
///   type: TraceEntryType.attributeCheck,
///   attributeName: 'price',
///   attributeValue: 100.0,
///   result: true,
///   depth: 1,
/// );
/// print(entry.toString()); // "  • Attribute check: price = 100.0 (Passed)"
/// ```
class TraceEntry {
  /// The type of trace entry.
  final TraceEntryType type;

  /// The name of the policy being evaluated (for start/end events).
  final String? policyName;

  /// Information about the entity being evaluated (for start events).
  final String? entityInfo;

  /// The name of the attribute being checked (for attribute check events).
  final String? attributeName;

  /// The value of the attribute being checked (for attribute check events).
  final dynamic attributeValue;

  /// The name of the relationship being checked (for relationship check events).
  final String? relationshipName;

  /// The value of the relationship being checked (for relationship check events).
  final dynamic relationshipValue;

  /// The result of the check or evaluation (for end/check events).
  final bool? result;

  /// The nesting depth of this entry in the trace.
  final int depth;

  /// Creates a new [TraceEntry] instance.
  ///
  /// [type] is the type of trace entry.
  /// [policyName] is the name of the policy (for start/end events).
  /// [entityInfo] is information about the entity (for start events).
  /// [attributeName] is the name of the attribute (for attribute check events).
  /// [attributeValue] is the value of the attribute (for attribute check events).
  /// [relationshipName] is the name of the relationship (for relationship check events).
  /// [relationshipValue] is the value of the relationship (for relationship check events).
  /// [result] is the result of the check/evaluation (for end/check events).
  /// [depth] is the nesting depth of this entry.
  TraceEntry({
    required this.type,
    this.policyName,
    this.entityInfo,
    this.attributeName,
    this.attributeValue,
    this.relationshipName,
    this.relationshipValue,
    this.result,
    required this.depth,
  });

  /// Returns a formatted string representation of this trace entry.
  ///
  /// The output is indented based on the depth and includes all relevant
  /// information in a human-readable format.
  @override
  String toString() {
    String indent = '  ' * depth;
    switch (type) {
      case TraceEntryType.start:
        return '$indent► Starting evaluation of $policyName for $entityInfo';
      case TraceEntryType.end:
        return '$indent◄ Ending evaluation of $policyName: ${result! ? 'Passed' : 'Failed'}';
      case TraceEntryType.attributeCheck:
        return '$indent• Attribute check: $attributeName = $attributeValue (${result! ? 'Passed' : 'Failed'})';
      case TraceEntryType.relationshipCheck:
        return '$indent• Relationship check: $relationshipName = $relationshipValue (${result! ? 'Passed' : 'Failed'})';
    }
  }
}
