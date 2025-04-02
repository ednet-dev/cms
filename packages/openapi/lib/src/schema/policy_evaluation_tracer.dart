part of openapi;

/// Tracer for policy evaluation in EDNet models.
///
/// This utility class helps with debugging and understanding how
/// policies are evaluated in EDNet domain models, by tracing
/// the evaluation process.
class PolicyEvaluationTracer {
  /// List of trace entries.
  final List<PolicyTraceEntry> _traces = [];
  
  /// Whether to print traces immediately.
  final bool _printImmediately;
  
  /// Creates a new policy evaluation tracer.
  ///
  /// Parameters:
  /// - [printImmediately]: Whether to print traces as they occur
  PolicyEvaluationTracer({bool printImmediately = false})
      : _printImmediately = printImmediately;
  
  /// Traces a policy evaluation.
  ///
  /// Parameters:
  /// - [entity]: The entity being evaluated
  /// - [policy]: The policy being evaluated
  /// - [result]: The result of the evaluation
  /// - [details]: Optional additional details
  void traceEvaluation(
    Entity entity,
    IPolicy policy,
    bool result,
    [String? details]
  ) {
    final entry = PolicyTraceEntry(
      timestamp: DateTime.now(),
      entityType: entity.concept.name,
      entityId: entity.id?.toString() ?? entity.oid.toString(),
      policyName: policy.runtimeType.toString(),
      result: result,
      details: details,
    );
    
    _traces.add(entry);
    
    if (_printImmediately) {
      print(entry);
    }
  }
  
  /// Traces a domain model structure.
  ///
  /// This method logs the structure of a domain model, including
  /// concepts, attributes, relationships, and policies.
  ///
  /// Parameters:
  /// - [domain]: The domain to trace
  void traceDomainModel(Domain domain) {
    final buffer = StringBuffer();
    
    buffer.writeln('Domain Model: ${domain.name}');
    buffer.writeln('='.padRight(60, '='));
    buffer.writeln();
    
    // Trace each concept
    for (final concept in domain.concepts) {
      buffer.writeln('Concept: ${concept.name}');
      buffer.writeln('-'.padRight(40, '-'));
      
      if (concept.description != null) {
        buffer.writeln('Description: ${concept.description}');
      }
      
      // Attributes
      if (concept.attributes.isNotEmpty) {
        buffer.writeln('Attributes:');
        for (final attr in concept.attributes) {
          buffer.write('  - ${attr.name}: ${attr.type}');
          if (attr.required) buffer.write(' (required)');
          if (attr.isPrimaryKey) buffer.write(' (PK)');
          buffer.writeln();
          
          if (attr.description != null) {
            buffer.writeln('    Description: ${attr.description}');
          }
        }
      }
      
      // Parents
      if (concept.parents.isNotEmpty) {
        buffer.writeln('Parents:');
        for (final parent in concept.parents) {
          buffer.writeln('  - ${parent.name}: ${parent.destination.name}');
        }
      }
      
      // Children
      if (concept.children.isNotEmpty) {
        buffer.writeln('Children:');
        for (final child in concept.children) {
          buffer.writeln('  - ${child.name}: ${child.destination.name}');
        }
      }
      
      // Policies (if available)
      final policies = PolicyRegistry.instance.getPolicies(concept.code);
      if (policies != null && policies.isNotEmpty) {
        buffer.writeln('Policies:');
        for (final policy in policies) {
          buffer.writeln('  - ${policy.runtimeType}');
        }
      }
      
      buffer.writeln();
    }
    
    final trace = buffer.toString();
    print(trace);
  }
  
  /// Gets all trace entries.
  ///
  /// Returns:
  /// A list of trace entries
  List<PolicyTraceEntry> getTraces() {
    return List.unmodifiable(_traces);
  }
  
  /// Clears all trace entries.
  void clearTraces() {
    _traces.clear();
  }
  
  /// Prints all trace entries.
  void printTraces() {
    for (final trace in _traces) {
      print(trace);
    }
  }
  
  /// Gets a summary of policy evaluations.
  ///
  /// Returns:
  /// A map of policy names to success rates
  Map<String, double> getSummary() {
    final summary = <String, Map<String, int>>{};
    
    // Count successes and failures for each policy
    for (final trace in _traces) {
      final policyName = trace.policyName;
      summary.putIfAbsent(policyName, () => {'success': 0, 'failure': 0});
      
      if (trace.result) {
        summary[policyName]!['success'] = (summary[policyName]!['success'] ?? 0) + 1;
      } else {
        summary[policyName]!['failure'] = (summary[policyName]!['failure'] ?? 0) + 1;
      }
    }
    
    // Calculate success rates
    final rates = <String, double>{};
    summary.forEach((policy, counts) {
      final total = counts['success']! + counts['failure']!;
      rates[policy] = total > 0 ? counts['success']! / total : 0;
    });
    
    return rates;
  }
  
  /// Prints a summary of policy evaluations.
  void printSummary() {
    final summary = getSummary();
    
    print('Policy Evaluation Summary');
    print('='.padRight(60, '='));
    
    summary.forEach((policy, rate) {
      final percentage = (rate * 100).toStringAsFixed(2);
      print('$policy: $percentage% success rate');
    });
  }
  
  /// Converts to a PolicyEvaluatorListener that can be attached to a
  /// PolicyEvaluator.
  ///
  /// Parameters:
  /// - [domain]: The domain to trace
  ///
  /// Returns:
  /// A function that can be used as a listener
  Function getPolicyEvaluatorListener(Domain domain) {
    return (Entity entity, IPolicy policy, bool result, [String? details]) {
      traceEvaluation(entity, policy, result, details);
    };
  }
}

/// Entry in a policy evaluation trace.
class PolicyTraceEntry {
  /// When the evaluation occurred.
  final DateTime timestamp;
  
  /// The type of entity being evaluated.
  final String entityType;
  
  /// The ID of the entity being evaluated.
  final String entityId;
  
  /// The name of the policy being evaluated.
  final String policyName;
  
  /// The result of the evaluation.
  final bool result;
  
  /// Additional details about the evaluation.
  final String? details;
  
  /// Creates a new policy trace entry.
  ///
  /// Parameters:
  /// - [timestamp]: When the evaluation occurred
  /// - [entityType]: The type of entity being evaluated
  /// - [entityId]: The ID of the entity being evaluated
  /// - [policyName]: The name of the policy being evaluated
  /// - [result]: The result of the evaluation
  /// - [details]: Additional details about the evaluation
  PolicyTraceEntry({
    required this.timestamp,
    required this.entityType,
    required this.entityId,
    required this.policyName,
    required this.result,
    this.details,
  });
  
  @override
  String toString() {
    final resultStr = result ? 'PASS' : 'FAIL';
    final time = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
    
    return '[${resultStr.padRight(4)}] $time | $entityType:$entityId | $policyName${details != null ? ' | $details' : ''}';
  }
} 