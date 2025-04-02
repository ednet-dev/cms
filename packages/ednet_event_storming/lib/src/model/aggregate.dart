import 'package:ednet_core/ednet_core.dart';
import 'domain_event.dart';

/// Represents an aggregate in an Event Storming session.
///
/// In Event Storming, aggregates are clusters of domain events and commands
/// that belong together. They represent consistency boundaries in the domain.
/// Aggregates are typically represented by yellow sticky notes on the event storming board.
class EventStormingAggregate {
  /// The unique identifier for this aggregate.
  final String id;

  /// The name of this aggregate (e.g., "Order", "Customer").
  final String name;

  /// A more detailed description of what this aggregate represents.
  final String description;

  /// Tags or categories to help organize and filter aggregates.
  final List<String> tags;

  /// The position of this aggregate on the event storming board.
  final Position position;

  /// IDs of domain events that belong to this aggregate.
  final List<String> domainEventIds;

  /// IDs of commands that target this aggregate.
  final List<String> commandIds;

  /// Who created this aggregate during the storming session.
  final String createdBy;

  /// When this aggregate was added to the board.
  final DateTime createdAt;

  /// The color used to represent this aggregate on the board (yellow by default).
  final String color;

  /// Properties or attributes of this aggregate.
  final Map<String, dynamic> properties;

  /// Creates a new aggregate.
  EventStormingAggregate({
    required this.id,
    required this.name,
    this.description = '',
    this.tags = const [],
    required this.position,
    this.domainEventIds = const [],
    this.commandIds = const [],
    required this.createdBy,
    required this.createdAt,
    this.color = '#FFFF00', // Yellow by default
    this.properties = const {},
  });

  /// Creates an aggregate from a map representation.
  factory EventStormingAggregate.fromJson(Map<String, dynamic> json) {
    return EventStormingAggregate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      domainEventIds: (json['domainEventIds'] as List<dynamic>?)?.cast<String>() ?? [],
      commandIds: (json['commandIds'] as List<dynamic>?)?.cast<String>() ?? [],
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#FFFF00',
      properties: json['properties'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts this aggregate to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'position': position.toJson(),
      'domainEventIds': domainEventIds,
      'commandIds': commandIds,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'properties': properties,
    };
  }

  /// Creates a copy of this aggregate with the given fields replaced with new values.
  EventStormingAggregate copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    Position? position,
    List<String>? domainEventIds,
    List<String>? commandIds,
    String? createdBy,
    DateTime? createdAt,
    String? color,
    Map<String, dynamic>? properties,
  }) {
    return EventStormingAggregate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      domainEventIds: domainEventIds ?? this.domainEventIds,
      commandIds: commandIds ?? this.commandIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      properties: properties ?? this.properties,
    );
  }

  /// Adds a domain event to this aggregate.
  EventStormingAggregate addDomainEvent(String domainEventId) {
    if (domainEventIds.contains(domainEventId)) {
      return this;
    }
    return copyWith(
      domainEventIds: [...domainEventIds, domainEventId],
    );
  }

  /// Removes a domain event from this aggregate.
  EventStormingAggregate removeDomainEvent(String domainEventId) {
    return copyWith(
      domainEventIds: domainEventIds.where((id) => id != domainEventId).toList(),
    );
  }

  /// Adds a command to this aggregate.
  EventStormingAggregate addCommand(String commandId) {
    if (commandIds.contains(commandId)) {
      return this;
    }
    return copyWith(
      commandIds: [...commandIds, commandId],
    );
  }

  /// Removes a command from this aggregate.
  EventStormingAggregate removeCommand(String commandId) {
    return copyWith(
      commandIds: commandIds.where((id) => id != commandId).toList(),
    );
  }

  /// Converts this event storming aggregate to an EDNet Core aggregate root concept.
  model.Concept toCoreAggregateConcept() {
    return model.Concept(
      name: name,
      code: name.toLowerCase().replaceAll(' ', '_'),
      description: description,
    );
  }
} 