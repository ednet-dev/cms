import 'package:ednet_core/ednet_core.dart';
import 'domain_event.dart';

/// Represents a command in an Event Storming session.
///
/// In Event Storming, commands represent the intent to perform an action
/// that might result in a domain event. They are typically represented
/// by blue sticky notes on the event storming board.
class EventStormingCommand {
  /// The unique identifier for this command.
  final String id;

  /// The name of the command (e.g., "PlaceOrder", "ProcessPayment").
  final String name;

  /// A more detailed description of what this command does.
  final String description;

  /// Tags or categories to help organize and filter commands.
  final List<String> tags;

  /// The position of this command on the event storming board.
  final Position position;

  /// The aggregate that this command targets (may be null during initial discovery).
  String? aggregateId;

  /// The ID of the domain event that this command might trigger.
  String? triggersDomainEventId;

  /// Who created this command during the storming session.
  final String createdBy;

  /// When this command was added to the board.
  final DateTime createdAt;

  /// The color used to represent this command on the board (blue by default).
  final String color;

  /// Parameters expected by this command.
  final Map<String, dynamic> parameters;

  /// Creates a new command.
  EventStormingCommand({
    required this.id,
    required this.name,
    this.description = '',
    this.tags = const [],
    required this.position,
    this.aggregateId,
    this.triggersDomainEventId,
    required this.createdBy,
    required this.createdAt,
    this.color = '#1E90FF', // Blue by default
    this.parameters = const {},
  });

  /// Creates a command from a map representation.
  factory EventStormingCommand.fromJson(Map<String, dynamic> json) {
    return EventStormingCommand(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      aggregateId: json['aggregateId'] as String?,
      triggersDomainEventId: json['triggersDomainEventId'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#1E90FF',
      parameters: json['parameters'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts this command to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'position': position.toJson(),
      'aggregateId': aggregateId,
      'triggersDomainEventId': triggersDomainEventId,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'parameters': parameters,
    };
  }

  /// Creates a copy of this command with the given fields replaced with new values.
  EventStormingCommand copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    Position? position,
    String? aggregateId,
    String? triggersDomainEventId,
    String? createdBy,
    DateTime? createdAt,
    String? color,
    Map<String, dynamic>? parameters,
  }) {
    return EventStormingCommand(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      aggregateId: aggregateId ?? this.aggregateId,
      triggersDomainEventId: triggersDomainEventId ?? this.triggersDomainEventId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      parameters: parameters ?? this.parameters,
    );
  }

  /// Converts this event storming command to an EDNet Core command.
  ICommand toCoreCommand() {
    return Command(
      name: name,
      description: description,
    );
  }
} 