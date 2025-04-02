import 'package:ednet_core/ednet_core.dart' as ednet_core;
import '../model/element.dart';
import '../model/domain_event.dart';
import '../model/command.dart';
import '../model/aggregate.dart';
import '../model/policy.dart';
import '../model/external_system.dart';
import '../model/hot_spot.dart';
import '../model/read_model.dart';
import '../session/event_storming_board.dart';

/// Provides compatibility adapters for the EventStorming implementation in EDNet Core.
///
/// This class contains methods to convert between the new EventStormingElement-based
/// structures and the legacy ES* classes from EDNet Core. This ensures that
/// existing code using the EDNet Core EventStorming can be gradually migrated.
class ESAdapter {
  /// Converts a new EventStormingDomainEvent to an EDNet Core ESEvent.
  static ednet_core.ESEvent toESEvent(EventStormingDomainEvent event) {
    // Create an ESEvent with the matching properties
    // Note: This assumes the ES* classes from ednet_core are available
    // and have compatible constructors.
    return ednet_core.ESEvent(
      id: event.id,
      name: event.name,
      description: event.description,
      positionX: event.position.x,
      positionY: event.position.y,
    );
  }

  /// Converts an EDNet Core ESEvent to a new EventStormingDomainEvent.
  static EventStormingDomainEvent fromESEvent(ednet_core.ESEvent esEvent) {
    return EventStormingDomainEvent(
      id: esEvent.id,
      name: esEvent.name,
      description: esEvent.description,
      position: Position(x: esEvent.positionX, y: esEvent.positionY),
      createdBy: 'converted', // We don't have this info in the original
      createdAt: DateTime.now(), // We don't have this info in the original
    );
  }

  /// Converts a new EventStormingCommand to an EDNet Core ESCommand.
  static ednet_core.ESCommand toESCommand(EventStormingCommand command) {
    return ednet_core.ESCommand(
      id: command.id,
      name: command.name,
      description: command.description,
      positionX: command.position.x,
      positionY: command.position.y,
    );
  }

  /// Converts an EDNet Core ESCommand to a new EventStormingCommand.
  static EventStormingCommand fromESCommand(ednet_core.ESCommand esCommand) {
    return EventStormingCommand(
      id: esCommand.id,
      name: esCommand.name,
      description: esCommand.description,
      position: Position(x: esCommand.positionX, y: esCommand.positionY),
      createdBy: 'converted',
      createdAt: DateTime.now(),
    );
  }

  /// Converts a new EventStormingAggregate to an EDNet Core ESAggregate.
  static ednet_core.ESAggregate toESAggregate(EventStormingAggregate aggregate) {
    return ednet_core.ESAggregate(
      id: aggregate.id,
      name: aggregate.name,
      description: aggregate.description,
      positionX: aggregate.position.x,
      positionY: aggregate.position.y,
    );
  }

  /// Converts an EDNet Core ESAggregate to a new EventStormingAggregate.
  static EventStormingAggregate fromESAggregate(ednet_core.ESAggregate esAggregate) {
    return EventStormingAggregate(
      id: esAggregate.id,
      name: esAggregate.name,
      description: esAggregate.description,
      position: Position(x: esAggregate.positionX, y: esAggregate.positionY),
      createdBy: 'converted',
      createdAt: DateTime.now(),
    );
  }

  /// Converts a new EventStormingPolicy to an EDNet Core ESPolicy.
  static ednet_core.ESPolicy toESPolicy(EventStormingPolicy policy) {
    return ednet_core.ESPolicy(
      id: policy.id,
      name: policy.name,
      description: policy.description,
      positionX: policy.position.x,
      positionY: policy.position.y,
    );
  }

  /// Converts an EDNet Core ESPolicy to a new EventStormingPolicy.
  static EventStormingPolicy fromESPolicy(ednet_core.ESPolicy esPolicy) {
    return EventStormingPolicy(
      id: esPolicy.id,
      name: esPolicy.name,
      description: esPolicy.description,
      position: Position(x: esPolicy.positionX, y: esPolicy.positionY),
      createdBy: 'converted',
      createdAt: DateTime.now(),
    );
  }

  /// Converts a new EventStormingExternalSystem to an EDNet Core ESExternalSystem.
  static ednet_core.ESExternalSystem toESExternalSystem(EventStormingExternalSystem externalSystem) {
    return ednet_core.ESExternalSystem(
      id: externalSystem.id,
      name: externalSystem.name,
      description: externalSystem.description,
      positionX: externalSystem.position.x,
      positionY: externalSystem.position.y,
    );
  }

  /// Converts an EDNet Core ESExternalSystem to a new EventStormingExternalSystem.
  static EventStormingExternalSystem fromESExternalSystem(ednet_core.ESExternalSystem esExternalSystem) {
    return EventStormingExternalSystem(
      id: esExternalSystem.id,
      name: esExternalSystem.name,
      description: esExternalSystem.description,
      position: Position(x: esExternalSystem.positionX, y: esExternalSystem.positionY),
      createdBy: 'converted',
      createdAt: DateTime.now(),
    );
  }

  /// Converts a new EventStormingReadModel to an EDNet Core ESReadModel.
  static ednet_core.ESReadModel toESReadModel(EventStormingReadModel readModel) {
    return ednet_core.ESReadModel(
      id: readModel.id,
      name: readModel.name,
      description: readModel.description,
      positionX: readModel.position.x,
      positionY: readModel.position.y,
    );
  }

  /// Converts an EDNet Core ESReadModel to a new EventStormingReadModel.
  static EventStormingReadModel fromESReadModel(ednet_core.ESReadModel esReadModel) {
    return EventStormingReadModel(
      id: esReadModel.id,
      name: esReadModel.name,
      description: esReadModel.description,
      position: Position(x: esReadModel.positionX, y: esReadModel.positionY),
      createdBy: 'converted',
      createdAt: DateTime.now(),
    );
  }

  /// Converts a new EventStormingHotSpot to an EDNet Core ESHotspot.
  static ednet_core.ESHotspot toESHotspot(EventStormingHotSpot hotSpot) {
    return ednet_core.ESHotspot(
      id: hotSpot.id,
      name: hotSpot.title,
      description: hotSpot.description,
      positionX: hotSpot.position.x,
      positionY: hotSpot.position.y,
    );
  }

  /// Converts an EDNet Core ESHotspot to a new EventStormingHotSpot.
  static EventStormingHotSpot fromESHotspot(ednet_core.ESHotspot esHotspot) {
    return EventStormingHotSpot(
      id: esHotspot.id,
      title: esHotspot.name,
      description: esHotspot.description,
      position: Position(x: esHotspot.positionX, y: esHotspot.positionY),
      createdBy: 'converted',
      createdAt: DateTime.now(),
    );
  }

  /// Converts a new EventStormingBoard to an EDNet Core ESModel.
  static ednet_core.ESModel toESModel(EventStormingBoard board) {
    final esModel = ednet_core.ESModel(
      id: board.id,
      name: board.name,
      description: board.description,
    );

    // Add all elements to the ES model
    for (final event in board.domainEvents.values) {
      esModel.addEvent(toESEvent(event));
    }

    for (final command in board.commands.values) {
      esModel.addCommand(toESCommand(command));
    }

    for (final aggregate in board.aggregates.values) {
      esModel.addAggregate(toESAggregate(aggregate));
    }

    for (final policy in board.policies.values) {
      esModel.addPolicy(toESPolicy(policy));
    }

    for (final externalSystem in board.externalSystems.values) {
      esModel.addExternalSystem(toESExternalSystem(externalSystem));
    }

    for (final readModel in board.readModels.values) {
      esModel.addReadModel(toESReadModel(readModel));
    }

    for (final hotSpot in board.hotSpots.values) {
      esModel.addHotspot(toESHotspot(hotSpot));
    }

    // Connections would need to be handled separately...

    return esModel;
  }

  // More conversion methods as needed...
} 