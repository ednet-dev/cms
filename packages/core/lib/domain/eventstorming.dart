/// Defines the EventStorming meta-model for domain modeling.
///
/// This library provides a comprehensive set of meta-model elements that represent
/// concepts from the EventStorming methodology:
/// - Commands: Express intent to change the system
/// - Events: Facts that have occurred in the system
/// - Aggregates: Consistency boundaries for entities
/// - Policies: Business rules that react to events
/// - Roles: Actors that issue commands
/// - Hotspots: Areas of uncertainty or conflict
/// - External Systems: Systems outside the bounded context
///
/// Each element is designed to be used in interactive domain modeling workshops,
/// supporting both visual modeling and code generation capabilities.
///
/// Example usage:
/// ```dart
/// import 'package:ednet_core/domain/eventstorming.dart';
/// 
/// // Create EventStorming elements
/// final placeOrderCommand = ESCommand(name: 'PlaceOrder', role: customerRole);
/// final orderPlacedEvent = ESEvent(name: 'OrderPlaced', aggregateRoot: orderAggregate);
/// final orderAggregate = ESAggregate(name: 'Order');
/// 
/// // Connect elements
/// placeOrderCommand.triggers(orderPlacedEvent);
/// orderAggregate.handles(placeOrderCommand);
/// ```
library eventstorming;

import 'package:ednet_core/domain/model.dart' as model;
import 'package:ednet_core/domain/application.dart' as app;
import 'package:ednet_core/domain/domain_models.dart';

part 'eventstorming/es_element.dart';
part 'eventstorming/es_command.dart';
part 'eventstorming/es_event.dart';
part 'eventstorming/es_aggregate.dart';
part 'eventstorming/es_policy.dart';
part 'eventstorming/es_role.dart';
part 'eventstorming/es_hotspot.dart';
part 'eventstorming/es_external_system.dart';
part 'eventstorming/es_read_model.dart';
part 'eventstorming/es_bounded_context.dart';
part 'eventstorming/es_connection.dart';
part 'eventstorming/es_model.dart';
part 'eventstorming/es_editor.dart';

/// Base class for all EventStorming meta-model elements.
abstract class ESElement implements model.Entity {
  /// Unique identifier for this EventStorming element.
  String get id;
  
  /// Display name for this element.
  String get name;
  
  /// Description providing additional context.
  String get description;
  
  /// Position X coordinate for visual representation.
  double get positionX;
  
  /// Position Y coordinate for visual representation.
  double get positionY;
  
  /// Color for visual representation.
  String get color;
  
  /// Returns connections to other elements.
  List<ESConnection> get connections;
  
  /// Adds a connection to another element.
  void addConnection(ESConnection connection);
  
  /// Removes a connection to another element.
  void removeConnection(ESConnection connection);
  
  /// Updates the position of this element.
  void updatePosition(double x, double y);
  
  /// Converts this meta-model element to a domain model component.
  model.Entity toDomainModel();
  
  /// Converts this meta-model element to an application layer component.
  app.Entity toApplicationModel();
}

/// Represents a command in EventStorming.
/// 
/// A command expresses an intent to change the system and is
/// typically initiated by a role or external system.
class ESCommand extends ESElement {
  /// The role that initiates this command.
  ESRole? role;
  
  /// The aggregate that handles this command.
  ESAggregate? aggregate;
  
  /// The events triggered by this command.
  List<ESEvent> triggeredEvents = [];
  
  /// Creates a new command element.
  ESCommand({
    required String id,
    required String name,
    String description = '',
    this.role,
    this.aggregate,
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Connects this command to an event it triggers.
  void triggers(ESEvent event) {
    triggeredEvents.add(event);
    addConnection(ESConnection(
      source: this,
      target: event,
      type: ESConnectionType.TRIGGERS
    ));
  }
}

/// Represents an event in EventStorming.
/// 
/// An event represents a fact that has occurred in the system,
/// typically as a result of a command being executed.
class ESEvent extends ESElement {
  /// The aggregate that produces this event.
  ESAggregate? aggregate;
  
  /// The policies triggered by this event.
  List<ESPolicy> triggeredPolicies = [];
  
  /// Creates a new event element.
  ESEvent({
    required String id,
    required String name,
    String description = '',
    this.aggregate,
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Connects this event to a policy it triggers.
  void triggers(ESPolicy policy) {
    triggeredPolicies.add(policy);
    addConnection(ESConnection(
      source: this,
      target: policy,
      type: ESConnectionType.TRIGGERS
    ));
  }
}

/// Represents an aggregate in EventStorming.
/// 
/// An aggregate is a cluster of domain objects that can be treated
/// as a single unit, providing consistency boundaries for entities.
class ESAggregate extends ESElement {
  /// The commands this aggregate handles.
  List<ESCommand> commands = [];
  
  /// The events this aggregate produces.
  List<ESEvent> events = [];
  
  /// Creates a new aggregate element.
  ESAggregate({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Connects this aggregate to a command it handles.
  void handles(ESCommand command) {
    commands.add(command);
    command.aggregate = this;
    addConnection(ESConnection(
      source: this,
      target: command,
      type: ESConnectionType.HANDLES
    ));
  }
  
  /// Connects this aggregate to an event it produces.
  void produces(ESEvent event) {
    events.add(event);
    event.aggregate = this;
    addConnection(ESConnection(
      source: this,
      target: event,
      type: ESConnectionType.PRODUCES
    ));
  }
}

/// Represents a policy in EventStorming.
/// 
/// A policy is a business rule that reacts to events and
/// may issue new commands as a result.
class ESPolicy extends ESElement {
  /// The events this policy reacts to.
  List<ESEvent> triggeringEvents = [];
  
  /// The commands this policy issues.
  List<ESCommand> issuedCommands = [];
  
  /// Creates a new policy element.
  ESPolicy({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Connects this policy to a command it issues.
  void issues(ESCommand command) {
    issuedCommands.add(command);
    addConnection(ESConnection(
      source: this,
      target: command,
      type: ESConnectionType.ISSUES
    ));
  }
}

/// Represents a role in EventStorming.
/// 
/// A role is an actor that initiates commands in the system.
class ESRole extends ESElement {
  /// The commands this role initiates.
  List<ESCommand> initiatedCommands = [];
  
  /// Creates a new role element.
  ESRole({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Connects this role to a command it initiates.
  void initiates(ESCommand command) {
    initiatedCommands.add(command);
    command.role = this;
    addConnection(ESConnection(
      source: this,
      target: command,
      type: ESConnectionType.INITIATES
    ));
  }
}

/// Represents a hotspot in EventStorming.
/// 
/// A hotspot indicates an area of uncertainty, conflict,
/// or further investigation in the model.
class ESHotspot extends ESElement {
  /// The elements this hotspot is connected to.
  List<ESElement> connectedElements = [];
  
  /// Creates a new hotspot element.
  ESHotspot({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Connects this hotspot to another element.
  void connectsTo(ESElement element) {
    connectedElements.add(element);
    addConnection(ESConnection(
      source: this,
      target: element,
      type: ESConnectionType.CONNECTS_TO
    ));
  }
}

/// Represents an external system in EventStorming.
/// 
/// An external system is a system outside the bounded context
/// that interacts with the domain.
class ESExternalSystem extends ESElement {
  /// The commands this external system initiates.
  List<ESCommand> initiatedCommands = [];
  
  /// Creates a new external system element.
  ESExternalSystem({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Connects this external system to a command it initiates.
  void initiates(ESCommand command) {
    initiatedCommands.add(command);
    addConnection(ESConnection(
      source: this,
      target: command,
      type: ESConnectionType.INITIATES
    ));
  }
}

/// Represents a read model in EventStorming.
/// 
/// A read model is a projection of domain data optimized for
/// specific use cases or queries.
class ESReadModel extends ESElement {
  /// The events this read model is updated by.
  List<ESEvent> updatedByEvents = [];
  
  /// Creates a new read model element.
  ESReadModel({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Connects this read model to an event that updates it.
  void updatedBy(ESEvent event) {
    updatedByEvents.add(event);
    addConnection(ESConnection(
      source: event,
      target: this,
      type: ESConnectionType.UPDATES
    ));
  }
}

/// Represents a connection between EventStorming elements.
class ESConnection implements model.ValueObject {
  /// Source element of the connection.
  final ESElement source;
  
  /// Target element of the connection.
  final ESElement target;
  
  /// Type of connection between elements.
  final ESConnectionType type;
  
  /// Creates a new connection between elements.
  ESConnection({
    required this.source,
    required this.target,
    required this.type,
  });
}

/// Defines the type of connection between EventStorming elements.
enum ESConnectionType {
  /// A command triggers an event
  TRIGGERS,
  
  /// An aggregate handles a command
  HANDLES,
  
  /// An aggregate produces an event
  PRODUCES,
  
  /// A policy issues a command
  ISSUES,
  
  /// A role initiates a command
  INITIATES,
  
  /// A hotspot connects to another element
  CONNECTS_TO,
  
  /// An event updates a read model
  UPDATES
}

/// Represents a complete EventStorming model.
///
/// An EventStorming model contains all the elements and connections
/// created during an EventStorming workshop.
class ESModel implements model.ValueObject {
  /// Unique identifier for this model.
  final String id;
  
  /// Name of the model.
  final String name;
  
  /// Description of the model.
  final String description;
  
  /// All commands in the model.
  final List<ESCommand> commands = [];
  
  /// All events in the model.
  final List<ESEvent> events = [];
  
  /// All aggregates in the model.
  final List<ESAggregate> aggregates = [];
  
  /// All policies in the model.
  final List<ESPolicy> policies = [];
  
  /// All roles in the model.
  final List<ESRole> roles = [];
  
  /// All hotspots in the model.
  final List<ESHotspot> hotspots = [];
  
  /// All external systems in the model.
  final List<ESExternalSystem> externalSystems = [];
  
  /// All read models in the model.
  final List<ESReadModel> readModels = [];
  
  /// All bounded contexts in the model.
  final List<ESBoundedContext> boundedContexts = [];
  
  /// Creates a new EventStorming model.
  ESModel({
    required this.id,
    required this.name,
    this.description = '',
  });
  
  /// Adds a command to the model.
  void addCommand(ESCommand command) {
    commands.add(command);
  }
  
  /// Adds an event to the model.
  void addEvent(ESEvent event) {
    events.add(event);
  }
  
  /// Adds an aggregate to the model.
  void addAggregate(ESAggregate aggregate) {
    aggregates.add(aggregate);
  }
  
  /// Adds a policy to the model.
  void addPolicy(ESPolicy policy) {
    policies.add(policy);
  }
  
  /// Adds a role to the model.
  void addRole(ESRole role) {
    roles.add(role);
  }
  
  /// Adds a hotspot to the model.
  void addHotspot(ESHotspot hotspot) {
    hotspots.add(hotspot);
  }
  
  /// Adds an external system to the model.
  void addExternalSystem(ESExternalSystem externalSystem) {
    externalSystems.add(externalSystem);
  }
  
  /// Adds a read model to the model.
  void addReadModel(ESReadModel readModel) {
    readModels.add(readModel);
  }
  
  /// Adds a bounded context to the model.
  void addBoundedContext(ESBoundedContext boundedContext) {
    boundedContexts.add(boundedContext);
  }
  
  /// Exports the EventStorming model to a domain model.
  model.ModelEntries toDomainModel() {
    // Implementation would convert EventStorming elements to domain model components
    throw UnimplementedError('Conversion to domain model not yet implemented');
  }
  
  /// Exports the EventStorming model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'commands': commands.map((c) => c.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
      'aggregates': aggregates.map((a) => a.toJson()).toList(),
      'policies': policies.map((p) => p.toJson()).toList(),
      'roles': roles.map((r) => r.toJson()).toList(),
      'hotspots': hotspots.map((h) => h.toJson()).toList(),
      'externalSystems': externalSystems.map((e) => e.toJson()).toList(),
      'readModels': readModels.map((r) => r.toJson()).toList(),
      'boundedContexts': boundedContexts.map((b) => b.toJson()).toList(),
    };
  }
  
  /// Imports an EventStorming model from JSON format.
  static ESModel fromJson(Map<String, dynamic> json) {
    // Implementation would parse JSON and create EventStorming elements
    throw UnimplementedError('Import from JSON not yet implemented');
  }
}

/// Represents a bounded context in EventStorming.
///
/// An EventStorming bounded context groups related elements
/// and defines the boundaries of a specific domain model.
class ESBoundedContext extends ESElement {
  /// The elements contained in this bounded context.
  final List<ESElement> elements = [];
  
  /// Creates a new bounded context element.
  ESBoundedContext({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
  });
  
  /// Adds an element to this bounded context.
  void addElement(ESElement element) {
    elements.add(element);
  }
  
  /// Removes an element from this bounded context.
  void removeElement(ESElement element) {
    elements.remove(element);
  }
}

/// Service for managing EventStorming domain modeling workshops.
///
/// This service provides functionality for:
/// - Creating and managing EventStorming models
/// - Adding and connecting elements
/// - Persisting and loading models
/// - Converting models to domain code
class EventStormingEditorService {
  /// The current model being edited.
  ESModel? currentModel;
  
  /// Creates a new EventStorming model.
  ESModel createModel(String name, [String description = '']) {
    final model = ESModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    currentModel = model;
    return model;
  }
  
  /// Loads a model from persistent storage.
  ESModel loadModel(String id) {
    // Implementation would load model from storage
    throw UnimplementedError('Model loading not yet implemented');
  }
  
  /// Saves the current model to persistent storage.
  Future<void> saveModel() async {
    // Implementation would save model to storage
    throw UnimplementedError('Model saving not yet implemented');
  }
  
  /// Creates a new command element in the current model.
  ESCommand createCommand(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final command = ESCommand(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addCommand(command);
    return command;
  }
  
  /// Creates a new event element in the current model.
  ESEvent createEvent(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final event = ESEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addEvent(event);
    return event;
  }
  
  /// Creates a new aggregate element in the current model.
  ESAggregate createAggregate(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final aggregate = ESAggregate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addAggregate(aggregate);
    return aggregate;
  }
  
  /// Creates a new policy element in the current model.
  ESPolicy createPolicy(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final policy = ESPolicy(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addPolicy(policy);
    return policy;
  }
  
  /// Creates a new role element in the current model.
  ESRole createRole(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final role = ESRole(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addRole(role);
    return role;
  }
  
  /// Creates a new hotspot element in the current model.
  ESHotspot createHotspot(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final hotspot = ESHotspot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addHotspot(hotspot);
    return hotspot;
  }
  
  /// Creates a new external system element in the current model.
  ESExternalSystem createExternalSystem(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final externalSystem = ESExternalSystem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addExternalSystem(externalSystem);
    return externalSystem;
  }
  
  /// Creates a new read model element in the current model.
  ESReadModel createReadModel(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final readModel = ESReadModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addReadModel(readModel);
    return readModel;
  }
  
  /// Creates a new bounded context element in the current model.
  ESBoundedContext createBoundedContext(String name, [String description = '']) {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    final boundedContext = ESBoundedContext(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    currentModel!.addBoundedContext(boundedContext);
    return boundedContext;
  }
  
  /// Connects two elements in the current model.
  void connectElements(ESElement source, ESElement target, ESConnectionType connectionType) {
    final connection = ESConnection(
      source: source,
      target: target,
      type: connectionType,
    );
    
    source.addConnection(connection);
  }
  
  /// Generates domain model code from the current EventStorming model.
  String generateDomainModelCode() {
    if (currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    // Implementation would generate code from the model
    throw UnimplementedError('Code generation not yet implemented');
  }
} 