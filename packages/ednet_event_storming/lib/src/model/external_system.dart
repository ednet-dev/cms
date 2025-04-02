import 'domain_event.dart';

/// Represents an external system in an Event Storming session.
///
/// In Event Storming, external systems represent third-party systems or services
/// that interact with the domain. They are typically represented by
/// pink sticky notes on the event storming board.
class EventStormingExternalSystem {
  /// The unique identifier for this external system.
  final String id;

  /// The name of this external system (e.g., "Payment Gateway").
  final String name;

  /// A more detailed description of what this external system does.
  final String description;

  /// Tags or categories to help organize and filter external systems.
  final List<String> tags;

  /// The position of this external system on the event storming board.
  final Position position;

  /// IDs of domain events that this external system might receive.
  final List<String> receivedEventIds;

  /// IDs of domain events that this external system might produce.
  final List<String> producedEventIds;

  /// Who created this external system during the storming session.
  final String createdBy;

  /// When this external system was added to the board.
  final DateTime createdAt;

  /// The color used to represent this external system on the board (pink by default).
  final String color;

  /// Additional information about this external system.
  final Map<String, dynamic> properties;

  /// Creates a new external system.
  EventStormingExternalSystem({
    required this.id,
    required this.name,
    this.description = '',
    this.tags = const [],
    required this.position,
    this.receivedEventIds = const [],
    this.producedEventIds = const [],
    required this.createdBy,
    required this.createdAt,
    this.color = '#FFC0CB', // Pink by default
    this.properties = const {},
  });

  /// Creates an external system from a map representation.
  factory EventStormingExternalSystem.fromJson(Map<String, dynamic> json) {
    return EventStormingExternalSystem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      receivedEventIds: (json['receivedEventIds'] as List<dynamic>?)?.cast<String>() ?? [],
      producedEventIds: (json['producedEventIds'] as List<dynamic>?)?.cast<String>() ?? [],
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#FFC0CB',
      properties: json['properties'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts this external system to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'position': position.toJson(),
      'receivedEventIds': receivedEventIds,
      'producedEventIds': producedEventIds,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'properties': properties,
    };
  }

  /// Creates a copy of this external system with the given fields replaced with new values.
  EventStormingExternalSystem copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    Position? position,
    List<String>? receivedEventIds,
    List<String>? producedEventIds,
    String? createdBy,
    DateTime? createdAt,
    String? color,
    Map<String, dynamic>? properties,
  }) {
    return EventStormingExternalSystem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      receivedEventIds: receivedEventIds ?? this.receivedEventIds,
      producedEventIds: producedEventIds ?? this.producedEventIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      properties: properties ?? this.properties,
    );
  }

  /// Adds a received event to this external system.
  EventStormingExternalSystem addReceivedEvent(String eventId) {
    if (receivedEventIds.contains(eventId)) {
      return this;
    }
    return copyWith(
      receivedEventIds: [...receivedEventIds, eventId],
    );
  }

  /// Removes a received event from this external system.
  EventStormingExternalSystem removeReceivedEvent(String eventId) {
    return copyWith(
      receivedEventIds: receivedEventIds.where((id) => id != eventId).toList(),
    );
  }

  /// Adds a produced event to this external system.
  EventStormingExternalSystem addProducedEvent(String eventId) {
    if (producedEventIds.contains(eventId)) {
      return this;
    }
    return copyWith(
      producedEventIds: [...producedEventIds, eventId],
    );
  }

  /// Removes a produced event from this external system.
  EventStormingExternalSystem removeProducedEvent(String eventId) {
    return copyWith(
      producedEventIds: producedEventIds.where((id) => id != eventId).toList(),
    );
  }
} 