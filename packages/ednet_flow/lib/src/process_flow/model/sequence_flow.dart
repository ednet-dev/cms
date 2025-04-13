// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;





class SequenceFlow {
  /// The unique identifier for this sequence flow.
  final String id;

  /// The name of this sequence flow.
  final String name;

  /// A more detailed description of this sequence flow.
  final String description;

  /// The ID of the source element (activity or gateway).
  final String sourceId;

  /// The ID of the target element (activity or gateway).
  final String targetId;

  /// A condition expression determining whether this flow is followed.
  final String? condition;

  /// Properties associated with this sequence flow.
  final Map<String, dynamic> properties;

  /// Visual waypoints for this sequence flow.
  final List<FlowWaypoint> waypoints;

  /// Creates a new sequence flow.
  const SequenceFlow({
    required this.id,
    required this.name,
    this.description = '',
    required this.sourceId,
    required this.targetId,
    this.condition,
    this.properties = const {},
    this.waypoints = const [],
  });

  /// Converts this sequence flow to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sourceId': sourceId,
      'targetId': targetId,
      'condition': condition,
      'properties': properties,
      'waypoints': waypoints.map((w) => w.toJson()).toList(),
    };
  }

  /// Creates a SequenceFlow from a JSON map.
  factory SequenceFlow.fromJson(Map<String, dynamic> json) {
    return SequenceFlow(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      sourceId: json['sourceId'] as String,
      targetId: json['targetId'] as String,
      condition: json['condition'] as String?,
      properties: (json['properties'] as Map<String, dynamic>?) ?? {},
      waypoints:
          (json['waypoints'] as List?)
              ?.map((w) => FlowWaypoint.fromJson(w as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class FlowWaypoint {
  /// The x-coordinate.
  final double x;

  /// The y-coordinate.
  final double y;

  /// Creates a new flow waypoint.
  const FlowWaypoint(this.x, this.y);

  /// Converts this waypoint to a JSON map.
  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }

  /// Creates a FlowWaypoint from a JSON map.
  factory FlowWaypoint.fromJson(Map<String, dynamic> json) {
    return FlowWaypoint(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );
  }
}
