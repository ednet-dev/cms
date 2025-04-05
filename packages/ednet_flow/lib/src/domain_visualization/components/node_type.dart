// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';



/// Defines the type of node in a domain model graph.
///
/// Node types represent the different kinds of elements in a domain model,
/// such as entities, value objects, aggregates, etc.
enum NodeType {
  /// A fundamental domain entity.
  entity,

  /// The root entity of an aggregate.
  aggregateRoot,

  /// A value object (immutable and without identity).
  valueObject,

  /// A domain event.
  domainEvent,

  /// A command that triggers behavior.
  command,

  /// A policy that coordinates responses to events.
  policy,

  /// An external system that interacts with the domain.
  externalSystem,

  /// A bounded context boundary.
  boundedContext,

  /// A service that provides domain operations.
  service,

  /// A repository for entity persistence.
  repository,

  /// A factory for creating complex entities.
  factory,

  /// A projection or read model of domain data.
  readModel,

  /// A process that coordinates multiple aggregates.
  process,

  /// A saga that manages long-lived transactions.
  saga,

  /// An input port for use cases.
  inputPort,

  /// An output port for external adapters.
  outputPort;

  /// Returns a user-friendly string representation of this node type.
  String get displayName {
    switch (this) {
      case NodeType.entity:
        return 'Entity';
      case NodeType.aggregateRoot:
        return 'Aggregate Root';
      case NodeType.valueObject:
        return 'Value Object';
      case NodeType.domainEvent:
        return 'Domain Event';
      case NodeType.command:
        return 'Command';
      case NodeType.policy:
        return 'Policy';
      case NodeType.externalSystem:
        return 'External System';
      case NodeType.boundedContext:
        return 'Bounded Context';
      case NodeType.service:
        return 'Service';
      case NodeType.repository:
        return 'Repository';
      case NodeType.factory:
        return 'Factory';
      case NodeType.readModel:
        return 'Read Model';
      case NodeType.process:
        return 'Process';
      case NodeType.saga:
        return 'Saga';
      case NodeType.inputPort:
        return 'Input Port';
      case NodeType.outputPort:
        return 'Output Port';
    }
  }

  /// Creates a NodeType from a string representation.
  static NodeType fromString(String value) {
    final lowerValue = value.toLowerCase();

    // Handle full enum paths (e.g., "NodeType.entity")
    final parts = lowerValue.split('.');
    final name = parts.length > 1 ? parts[1] : lowerValue;

    return NodeType.values.firstWhere(
      (type) => type.toString().split('.').last == name,
      orElse: () => NodeType.entity,
    );
  }
}
