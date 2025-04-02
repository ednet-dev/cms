import 'package:ednet_core/ednet_core.dart';
import 'domain_event.dart';

/// Represents a policy in an Event Storming session.
///
/// In Event Storming, policies represent business rules that react to
/// domain events and might trigger new commands. They are typically
/// represented by purple or lilac sticky notes on the event storming board.
class EventStormingPolicy {
  /// The unique identifier for this policy.
  final String id;

  /// The name of this policy (e.g., "Order Approval Policy").
  final String name;

  /// A more detailed description of what this policy does.
  final String description;

  /// Tags or categories to help organize and filter policies.
  final List<String> tags;

  /// The position of this policy on the event storming board.
  final Position position;

  /// IDs of domain events that trigger this policy.
  final List<String> triggeringEventIds;

  /// IDs of commands that this policy might initiate.
  final List<String> resultingCommandIds;

  /// Who created this policy during the storming session.
  final String createdBy;

  /// When this policy was added to the board.
  final DateTime createdAt;

  /// The color used to represent this policy on the board (purple by default).
  final String color;

  /// The condition or rule that defines when this policy is triggered.
  final String condition;

  /// Creates a new policy.
  EventStormingPolicy({
    required this.id,
    required this.name,
    this.description = '',
    this.tags = const [],
    required this.position,
    this.triggeringEventIds = const [],
    this.resultingCommandIds = const [],
    required this.createdBy,
    required this.createdAt,
    this.color = '#DDA0DD', // Plum by default
    this.condition = '',
  });

  /// Creates a policy from a map representation.
  factory EventStormingPolicy.fromJson(Map<String, dynamic> json) {
    return EventStormingPolicy(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      triggeringEventIds: (json['triggeringEventIds'] as List<dynamic>?)?.cast<String>() ?? [],
      resultingCommandIds: (json['resultingCommandIds'] as List<dynamic>?)?.cast<String>() ?? [],
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#DDA0DD',
      condition: json['condition'] as String? ?? '',
    );
  }

  /// Converts this policy to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'position': position.toJson(),
      'triggeringEventIds': triggeringEventIds,
      'resultingCommandIds': resultingCommandIds,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'condition': condition,
    };
  }

  /// Creates a copy of this policy with the given fields replaced with new values.
  EventStormingPolicy copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    Position? position,
    List<String>? triggeringEventIds,
    List<String>? resultingCommandIds,
    String? createdBy,
    DateTime? createdAt,
    String? color,
    String? condition,
  }) {
    return EventStormingPolicy(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      triggeringEventIds: triggeringEventIds ?? this.triggeringEventIds,
      resultingCommandIds: resultingCommandIds ?? this.resultingCommandIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      condition: condition ?? this.condition,
    );
  }

  /// Adds a triggering event to this policy.
  EventStormingPolicy addTriggeringEvent(String eventId) {
    if (triggeringEventIds.contains(eventId)) {
      return this;
    }
    return copyWith(
      triggeringEventIds: [...triggeringEventIds, eventId],
    );
  }

  /// Removes a triggering event from this policy.
  EventStormingPolicy removeTriggeringEvent(String eventId) {
    return copyWith(
      triggeringEventIds: triggeringEventIds.where((id) => id != eventId).toList(),
    );
  }

  /// Adds a resulting command to this policy.
  EventStormingPolicy addResultingCommand(String commandId) {
    if (resultingCommandIds.contains(commandId)) {
      return this;
    }
    return copyWith(
      resultingCommandIds: [...resultingCommandIds, commandId],
    );
  }

  /// Removes a resulting command from this policy.
  EventStormingPolicy removeResultingCommand(String commandId) {
    return copyWith(
      resultingCommandIds: resultingCommandIds.where((id) => id != commandId).toList(),
    );
  }

  /// Converts this event storming policy to an EDNet Core policy.
  model.Policy toCorePolicy() {
    // This is a simplified conversion, as EDNet Core might have
    // a more complex policy structure.
    return model.CompositePolicy(
      name: name,
      description: description,
      policies: [],
    );
  }
} 