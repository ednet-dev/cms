import 'package:ednet_core/ednet_core.dart';

/// Represents a domain event in an Event Storming session.
///
/// In Event Storming, domain events are the core elements that represent
/// something that happened in the domain. They are typically represented
/// by orange sticky notes on the event storming board.
class EventStormingDomainEvent {
  /// The unique identifier for this event.
  final String id;

  /// The name of the event (e.g., "OrderPlaced", "PaymentReceived").
  final String name;

  /// A more detailed description of what this event represents.
  final String description;

  /// Tags or categories to help organize and filter events.
  final List<String> tags;

  /// The position of this event on the event storming board.
  final Position position;

  /// The aggregate that this event belongs to (may be null during initial discovery).
  String? aggregateId;

  /// Who created this event during the storming session.
  final String createdBy;

  /// When this event was added to the board.
  final DateTime createdAt;

  /// The color used to represent this event on the board (orange by default).
  final String color;

  /// Data that gets captured by this event.
  final Map<String, dynamic> properties;

  /// Creates a new domain event.
  EventStormingDomainEvent({
    required this.id,
    required this.name,
    this.description = '',
    this.tags = const [],
    required this.position,
    this.aggregateId,
    required this.createdBy,
    required this.createdAt,
    this.color = '#FFA500', // Orange by default
    this.properties = const {},
  });

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

  /// Converts this domain event to a map representation.
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
    };
  }

  /// Creates a copy of this domain event with the given fields replaced with new values.
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
} 