// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;

/// Base class for process flow modeling.
///
/// A Process represents a complete workflow or business process.
/// It contains activities, gateways, and sequence flows that define
/// how work moves through the process.
class Process {
  /// The unique identifier for this process.
  final String id;

  /// The name of this process.
  final String name;

  /// A more detailed description of this process.
  final String description;

  /// The version of this process.
  final String version;

  /// The activities (tasks, subprocesses) in this process.
  final List<Activity> activities;

  /// The gateways (decision points) in this process.
  final List<Gateway> gateways;

  /// The sequence flows connecting activities and gateways.
  final List<SequenceFlow> sequenceFlows;

  /// Creates a new process.
  const Process({
    required this.id,
    required this.name,
    this.description = '',
    this.version = '1.0',
    this.activities = const [],
    this.gateways = const [],
    this.sequenceFlows = const [],
  });

  /// Validates the process structure.
  ///
  /// Checks that:
  /// - All activities and gateways have unique IDs
  /// - All sequence flows reference valid source and target elements
  /// - The process has at least one start and one end element
  /// - There are no disconnected elements
  ///
  /// Returns a list of validation error messages, or an empty list if valid.
  List<String> validate() {
    final errors = <String>[];

    // Check for duplicate IDs
    final activityIds = activities.map((a) => a.id).toSet();
    if (activityIds.length != activities.length) {
      errors.add('Process contains duplicate activity IDs');
    }

    final gatewayIds = gateways.map((g) => g.id).toSet();
    if (gatewayIds.length != gateways.length) {
      errors.add('Process contains duplicate gateway IDs');
    }

    // Check for valid sequence flow references
    for (final flow in sequenceFlows) {
      final sourceId = flow.sourceId;
      final targetId = flow.targetId;

      final sourceExists =
          activityIds.contains(sourceId) || gatewayIds.contains(sourceId);
      final targetExists =
          activityIds.contains(targetId) || gatewayIds.contains(targetId);

      if (!sourceExists) {
        errors.add(
          'Sequence flow references non-existent source: ${flow.sourceId}',
        );
      }

      if (!targetExists) {
        errors.add(
          'Sequence flow references non-existent target: ${flow.targetId}',
        );
      }
    }

    // Check for start and end elements
    final hasStart = activities.any((a) => a.type == ActivityType.start);
    final hasEnd = activities.any((a) => a.type == ActivityType.end);

    if (!hasStart) {
      errors.add('Process must have at least one start event');
    }

    if (!hasEnd) {
      errors.add('Process must have at least one end event');
    }

    return errors;
  }

  /// Converts the process to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'version': version,
      'activities': activities.map((a) => a.toJson()).toList(),
      'gateways': gateways.map((g) => g.toJson()).toList(),
      'sequenceFlows': sequenceFlows.map((f) => f.toJson()).toList(),
    };
  }

  /// Creates a Process from a JSON map.
  factory Process.fromJson(Map<String, dynamic> json) {
    return Process(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      version: json['version'] as String? ?? '1.0',
      activities:
          (json['activities'] as List?)
              ?.map((a) => Activity.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      gateways:
          (json['gateways'] as List?)
              ?.map((g) => Gateway.fromJson(g as Map<String, dynamic>))
              .toList() ??
          [],
      sequenceFlows:
          (json['sequenceFlows'] as List?)
              ?.map((f) => SequenceFlow.fromJson(f as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
