// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

import 'package:ednet_flow/ednet_flow.dart';
import 'package:ednet_flow/src/event_storming/model/element.dart';

// This file is part of the EDNetFlow library.
// Restored imports for source file organization.





/// Represents the event storming board where all elements are placed.
///
/// The board is the central object in an event storming session,
/// containing all the elements (events, commands, aggregates, etc.)
/// and their relationships.
class EventStormingBoard {
  /// The unique identifier for this board.
  final String id;

  /// The name of this board (e.g., "Order Processing Domain").
  final String name;

  /// A more detailed description of this board.
  final String description;

  /// When this board was created.
  final DateTime createdAt;

  /// Who created this board.
  final String createdBy;

  /// The current zoom level of the board.
  final double zoomLevel;

  /// The domain events on this board.
  final Map<String, EventStormingDomainEvent> domainEvents;

  /// The commands on this board.
  final Map<String, EventStormingCommand> commands;

  /// The aggregates on this board.
  final Map<String, EventStormingAggregate> aggregates;

  /// The policies on this board.
  final Map<String, EventStormingPolicy> policies;

  /// The external systems on this board.
  final Map<String, EventStormingExternalSystem> externalSystems;

  /// The hot spots on this board.
  final Map<String, EventStormingHotSpot> hotSpots;

  /// The read models on this board.
  final Map<String, EventStormingReadModel> readModels;

  /// Creates a new event storming board.
  EventStormingBoard({
    required this.id,
    required this.name,
    this.description = '',
    required this.createdAt,
    required this.createdBy,
    this.zoomLevel = 1.0,
    this.domainEvents = const {},
    this.commands = const {},
    this.aggregates = const {},
    this.policies = const {},
    this.externalSystems = const {},
    this.hotSpots = const {},
    this.readModels = const {},
  });

  /// Creates a board from a map representation.
  factory EventStormingBoard.fromJson(Map<String, dynamic> json) {
    return EventStormingBoard(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      zoomLevel: (json['zoomLevel'] as num?)?.toDouble() ?? 1.0,
      domainEvents: (json['domainEvents'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, EventStormingDomainEvent.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      commands: (json['commands'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, EventStormingCommand.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      aggregates: (json['aggregates'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, EventStormingAggregate.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      policies: (json['policies'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, EventStormingPolicy.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      externalSystems: (json['externalSystems'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, EventStormingExternalSystem.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      hotSpots: (json['hotSpots'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, EventStormingHotSpot.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      readModels: (json['readModels'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, EventStormingReadModel.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
    );
  }

  /// Converts this board to a map representation.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'zoomLevel': zoomLevel,
      'domainEvents': domainEvents.map((k, v) => MapEntry(k, v.toJson())),
      'commands': commands.map((k, v) => MapEntry(k, v.toJson())),
      'aggregates': aggregates.map((k, v) => MapEntry(k, v.toJson())),
      'policies': policies.map((k, v) => MapEntry(k, v.toJson())),
      'externalSystems': externalSystems.map((k, v) => MapEntry(k, v.toJson())),
      'hotSpots': hotSpots.map((k, v) => MapEntry(k, v.toJson())),
      'readModels': readModels.map((k, v) => MapEntry(k, v.toJson())),
    };
  }

  /// Creates a copy of this board with the given fields replaced with new values.
  EventStormingBoard copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    String? createdBy,
    double? zoomLevel,
    Map<String, EventStormingDomainEvent>? domainEvents,
    Map<String, EventStormingCommand>? commands,
    Map<String, EventStormingAggregate>? aggregates,
    Map<String, EventStormingPolicy>? policies,
    Map<String, EventStormingExternalSystem>? externalSystems,
    Map<String, EventStormingHotSpot>? hotSpots,
    Map<String, EventStormingReadModel>? readModels,
  }) {
    return EventStormingBoard(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      domainEvents: domainEvents ?? this.domainEvents,
      commands: commands ?? this.commands,
      aggregates: aggregates ?? this.aggregates,
      policies: policies ?? this.policies,
      externalSystems: externalSystems ?? this.externalSystems,
      hotSpots: hotSpots ?? this.hotSpots,
      readModels: readModels ?? this.readModels,
    );
  }

  /// Adds a domain event to this board.
  EventStormingBoard addDomainEvent(EventStormingDomainEvent event) {
    return copyWith(
      domainEvents: {...domainEvents, event.id: event},
    );
  }

  /// Removes a domain event from this board.
  EventStormingBoard removeDomainEvent(String eventId) {
    final newDomainEvents = Map<String, EventStormingDomainEvent>.from(domainEvents);
    newDomainEvents.remove(eventId);
    return copyWith(
      domainEvents: newDomainEvents,
    );
  }

  /// Updates a domain event on this board.
  EventStormingBoard updateDomainEvent(EventStormingDomainEvent event) {
    return copyWith(
      domainEvents: {...domainEvents, event.id: event},
    );
  }

  /// Adds a command to this board.
  EventStormingBoard addCommand(EventStormingCommand command) {
    return copyWith(
      commands: {...commands, command.id: command},
    );
  }

  /// Removes a command from this board.
  EventStormingBoard removeCommand(String commandId) {
    final newCommands = Map<String, EventStormingCommand>.from(commands);
    newCommands.remove(commandId);
    return copyWith(
      commands: newCommands,
    );
  }

  /// Updates a command on this board.
  EventStormingBoard updateCommand(EventStormingCommand command) {
    return copyWith(
      commands: {...commands, command.id: command},
    );
  }

  /// Adds an aggregate to this board.
  EventStormingBoard addAggregate(EventStormingAggregate aggregate) {
    return copyWith(
      aggregates: {...aggregates, aggregate.id: aggregate},
    );
  }

  /// Removes an aggregate from this board.
  EventStormingBoard removeAggregate(String aggregateId) {
    final newAggregates = Map<String, EventStormingAggregate>.from(aggregates);
    newAggregates.remove(aggregateId);
    return copyWith(
      aggregates: newAggregates,
    );
  }

  /// Updates an aggregate on this board.
  EventStormingBoard updateAggregate(EventStormingAggregate aggregate) {
    return copyWith(
      aggregates: {...aggregates, aggregate.id: aggregate},
    );
  }

  /// Adds a policy to this board.
  EventStormingBoard addPolicy(EventStormingPolicy policy) {
    return copyWith(
      policies: {...policies, policy.id: policy},
    );
  }

  /// Removes a policy from this board.
  EventStormingBoard removePolicy(String policyId) {
    final newPolicies = Map<String, EventStormingPolicy>.from(policies);
    newPolicies.remove(policyId);
    return copyWith(
      policies: newPolicies,
    );
  }

  /// Updates a policy on this board.
  EventStormingBoard updatePolicy(EventStormingPolicy policy) {
    return copyWith(
      policies: {...policies, policy.id: policy},
    );
  }

  /// Adds an external system to this board.
  EventStormingBoard addExternalSystem(EventStormingExternalSystem system) {
    return copyWith(
      externalSystems: {...externalSystems, system.id: system},
    );
  }

  /// Removes an external system from this board.
  EventStormingBoard removeExternalSystem(String systemId) {
    final newExternalSystems = Map<String, EventStormingExternalSystem>.from(externalSystems);
    newExternalSystems.remove(systemId);
    return copyWith(
      externalSystems: newExternalSystems,
    );
  }

  /// Updates an external system on this board.
  EventStormingBoard updateExternalSystem(EventStormingExternalSystem system) {
    return copyWith(
      externalSystems: {...externalSystems, system.id: system},
    );
  }

  /// Adds a hot spot to this board.
  EventStormingBoard addHotSpot(EventStormingHotSpot hotSpot) {
    return copyWith(
      hotSpots: {...hotSpots, hotSpot.id: hotSpot},
    );
  }

  /// Removes a hot spot from this board.
  EventStormingBoard removeHotSpot(String hotSpotId) {
    final newHotSpots = Map<String, EventStormingHotSpot>.from(hotSpots);
    newHotSpots.remove(hotSpotId);
    return copyWith(
      hotSpots: newHotSpots,
    );
  }

  /// Updates a hot spot on this board.
  EventStormingBoard updateHotSpot(EventStormingHotSpot hotSpot) {
    return copyWith(
      hotSpots: {...hotSpots, hotSpot.id: hotSpot},
    );
  }

  /// Adds a read model to this board.
  EventStormingBoard addReadModel(EventStormingReadModel readModel) {
    return copyWith(
      readModels: {...readModels, readModel.id: readModel},
    );
  }

  /// Removes a read model from this board.
  EventStormingBoard removeReadModel(String readModelId) {
    final newReadModels = Map<String, EventStormingReadModel>.from(readModels);
    newReadModels.remove(readModelId);
    return copyWith(
      readModels: newReadModels,
    );
  }

  /// Updates a read model on this board.
  EventStormingBoard updateReadModel(EventStormingReadModel readModel) {
    return copyWith(
      readModels: {...readModels, readModel.id: readModel},
    );
  }
} 