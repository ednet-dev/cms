// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:ednet_core/ednet_core.dart';




/// Represents a domain event in an Event Storming session.
///
/// In Event Storming, domain events are the core elements that represent
/// something that happened in the domain. They are typically represented
/// by orange sticky notes on the event storming board.
class EventStormingDomainEvent extends EventStormingElement {
  /// The aggregate that this event belongs to (may be null during initial discovery).
  String? aggregateId;

  /// Data that gets captured by this event.
  final Map<String, dynamic> properties;

  /// Creates a new domain event.
  EventStormingDomainEvent({
    required String id,
    required String name,
    String description = '',
    List<String> tags = const [],
    required Position position,
    this.aggregateId,
    required String createdBy,
    required DateTime createdAt,
    String color = '#FFA500', // Orange by default
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

  /// Creates a domain event from a map representation.
  factory EventStormingDomainEvent.fromJson(Map<String, dynamic> json) {
    return EventStormingDomainEvent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      aggregateId: json['aggregateId'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#FFA500',
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
      'aggregateId': aggregateId,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'properties': properties,
      'elementType': elementType,
    };
  }

  @override
  EventStormingDomainEvent copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    Position? position,
    String? aggregateId,
    String? createdBy,
    DateTime? createdAt,
    String? color,
    Map<String, dynamic>? properties,
  }) {
    return EventStormingDomainEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      aggregateId: aggregateId ?? this.aggregateId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      properties: properties ?? this.properties,
    );
  }

  /// Converts this event storming domain event to an EDNet Core domain event.
  IDomainEvent toCoreDomainEvent() {
    return DomainEvent(
      name: name,
      aggregateId: aggregateId,
      aggregateType: aggregateId != null ? 'Unknown' : null,
    );
  }
  
  @override
  ednet_core.model.Entity toCoreModelEntity() {
    final event = ednet_core.model.Event(
      name: name,
    );
    
    // Add properties if needed
    // This would need to be adapted based on the EDNet Core API
    
    return event;
  }
  
  @override
  String get elementType => 'event';
}

/// Represents a position on the event storming board.
class Position {
  /// X coordinate (horizontal position).
  final double x;

  /// Y coordinate (vertical position).
  final double y;

  /// Creates a new position.
  Position({
    required this.x,
    required this.y,
  });

  /// Creates a position from a map representation.
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  /// Converts this position to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
  
  /// Creates a copy of this position with new coordinates.
  Position copyWith({double? x, double? y}) {
    return Position(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
} 