// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:ednet_core/ednet_core.dart';




/// Represents a command in an Event Storming session.
///
/// In Event Storming, commands represent the intent to perform an action
/// that might result in a domain event. They are typically represented
/// by blue sticky notes on the event storming board.
class EventStormingCommand extends EventStormingElement {
  /// The aggregate that this command targets (may be null during initial discovery).
  String? aggregateId;

  /// The ID of the domain event that this command might trigger.
  String? triggersDomainEventId;
  
  /// The ID of the role that initiates this command (may be null).
  String? roleId;

  /// Parameters expected by this command.
  final Map<String, dynamic> parameters;

  /// Creates a new command.
  EventStormingCommand({
    required String id,
    required String name,
    String description = '',
    List<String> tags = const [],
    required Position position,
    this.aggregateId,
    this.triggersDomainEventId,
    this.roleId,
    required String createdBy,
    required DateTime createdAt,
    String color = '#1E90FF', // Blue by default
    this.parameters = const {},
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
      roleId: json['roleId'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      color: json['color'] as String? ?? '#1E90FF',
      parameters: json['parameters'] as Map<String, dynamic>? ?? {},
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
      'triggersDomainEventId': triggersDomainEventId,
      'roleId': roleId,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'parameters': parameters,
      'elementType': elementType,
    };
  }

  @override
  EventStormingCommand copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tags,
    Position? position,
    String? aggregateId,
    String? triggersDomainEventId,
    String? roleId,
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
      roleId: roleId ?? this.roleId,
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
  
  @override
  ednet_core.model.Entity toCoreModelEntity() {
    final command = ednet_core.model.Command(
      name: name
    );
    
    // Add properties if needed
    // This would need to be adapted based on the EDNet Core API
    
    return command;
  }
  
  @override
  String get elementType => 'command';
} 