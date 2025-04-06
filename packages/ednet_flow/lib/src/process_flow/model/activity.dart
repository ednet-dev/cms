// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:ednet_core/ednet_core.dart';



/// Defines the type of activity in a process flow.
enum ActivityType {
  /// Start event - beginning of a process
  start,

  /// End event - conclusion of a process
  end,

  /// Task - atomic unit of work
  task,

  /// Subprocess - composite activity containing other activities
  subprocess,
}

/// Represents an activity (task, event, etc.) in a process flow.
///
/// Activities are the building blocks of process flows, representing
/// individual steps in a process that either perform work (tasks),
/// mark significant points (events), or contain sub-processes.
class Activity {
  /// The unique identifier for this activity.
  final String id;

  /// The name of this activity.
  final String name;

  /// A more detailed description of this activity.
  final String description;

  /// The type of this activity.
  final ActivityType type;

  /// Properties associated with this activity.
  final Map<String, dynamic> properties;

  /// The position of this activity in the visual representation.
  final ActivityPosition position;

  /// Creates a new activity.
  const Activity({
    required this.id,
    required this.name,
    this.description = '',
    required this.type,
    this.properties = const {},
    this.position = const ActivityPosition(0, 0),
  });

  /// Converts this activity to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'properties': properties,
      'position': position.toJson(),
    };
  }

  /// Creates an Activity from a JSON map.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      type: _parseActivityType(json['type'] as String? ?? 'task'),
      properties: (json['properties'] as Map<String, dynamic>?) ?? {},
      position: ActivityPosition.fromJson(
        (json['position'] as Map<String, dynamic>?) ?? {'x': 0, 'y': 0},
      ),
    );
  }

  /// Parses an activity type string to an ActivityType enum.
  static ActivityType _parseActivityType(String type) {
    switch (type.toLowerCase()) {
      case 'start':
        return ActivityType.start;
      case 'end':
        return ActivityType.end;
      case 'subprocess':
        return ActivityType.subprocess;
      case 'task':
      default:
        return ActivityType.task;
    }
  }
}

/// Represents the position of an activity in a visual process diagram.
class ActivityPosition {
  /// The x-coordinate.
  final double x;

  /// The y-coordinate.
  final double y;

  /// Creates a new activity position.
  const ActivityPosition(this.x, this.y);

  /// Converts this position to a JSON map.
  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }

  /// Creates an ActivityPosition from a JSON map.
  factory ActivityPosition.fromJson(Map<String, dynamic> json) {
    return ActivityPosition(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );
  }
}
