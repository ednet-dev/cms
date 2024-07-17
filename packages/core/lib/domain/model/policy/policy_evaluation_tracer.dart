part of ednet_core;

class PolicyEvaluationTracer {
  final List<TraceEntry> _traceEntries = [];
  int _depth = 0;

  void startEvaluation(String policyName, Entity entity) {
    _traceEntries.add(TraceEntry(
      type: TraceEntryType.start,
      policyName: policyName,
      entityInfo: '${entity.concept.code}(${entity.oid})',
      depth: _depth,
    ));
    _depth++;
  }

  void endEvaluation(String policyName, bool result) {
    _depth--;
    _traceEntries.add(TraceEntry(
      type: TraceEntryType.end,
      policyName: policyName,
      result: result,
      depth: _depth,
    ));
  }

  void addAttributeCheck(String attributeName, dynamic value, bool result) {
    _traceEntries.add(TraceEntry(
      type: TraceEntryType.attributeCheck,
      attributeName: attributeName,
      attributeValue: value,
      result: result,
      depth: _depth,
    ));
  }

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

  String getTrace() {
    StringBuffer buffer = StringBuffer();
    for (var entry in _traceEntries) {
      buffer.writeln(entry.toString());
    }
    return buffer.toString();
  }

  void clear() {
    _traceEntries.clear();
    _depth = 0;
  }
}

enum TraceEntryType { start, end, attributeCheck, relationshipCheck }

class TraceEntry {
  final TraceEntryType type;
  final String? policyName;
  final String? entityInfo;
  final String? attributeName;
  final dynamic attributeValue;
  final String? relationshipName;
  final dynamic relationshipValue;
  final bool? result;
  final int depth;

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
