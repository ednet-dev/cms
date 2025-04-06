// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:ednet_core/ednet_core.dart';




/// Represents an external system in an Event Storming session.
///
/// In Event Storming, external systems represent third-party systems or services
/// that interact with the domain. They are typically represented by
/// pink sticky notes on the event storming board.
class EventStormingExternalSystem extends EventStormingElement {
  /// IDs of domain events that this external system might receive.
  final List<String> receivedEventIds;

  /// IDs of domain events that this external system might produce.
  final List<String> producedEventIds;

  /// Additional information about this external system.
  final Map<String, dynamic> properties;

  /// Creates a new external system.
  EventStormingExternalSystem({
    required String id,
    required String name,
    String description = '',
    List<String> tags = const [],
    required Position position,
    this.receivedEventIds = const [],
    this.producedEventIds = const [],
    required String createdBy,
    required DateTime createdAt,
    String color = '#FFC0CB', // Pink by default
    this.properties = const {},
  }) : super(
          id: id,
          name: name,
          description: description,
          tags: tags,
          position: position,
          createdBy: createdBy,
          createdAt: createdAt,
          color: color,
        );

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

  @override
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
      'elementType': elementType,
    };
  }

  @override
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
  
  @override
  ednet_core.model.Entity toCoreModelEntity() {
    // External systems might be represented as a special type in EDNet Core
    // For now, we'll use a generic entity
    final entity = ednet_core.model.Entity(
      name: name,
    );
    return entity;
  }
  
  @override
  String get elementType => 'external_system';
} 