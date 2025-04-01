part of eventstorming;

/// Implementation of a complete EventStorming model.
class ESModelImpl implements ESModel {
  @override
  final String id;
  
  @override
  final String name;
  
  @override
  final String description;
  
  /// The map of element IDs to elements.
  final Map<String, ESElement> _elementsById = {};
  
  /// The list of commands in the model.
  final List<ESCommand> _commands = [];
  
  /// The list of events in the model.
  final List<ESEvent> _events = [];
  
  /// The list of aggregates in the model.
  final List<ESAggregate> _aggregates = [];
  
  /// The list of policies in the model.
  final List<ESPolicy> _policies = [];
  
  /// The list of roles in the model.
  final List<ESRole> _roles = [];
  
  /// The list of hotspots in the model.
  final List<ESHotspot> _hotspots = [];
  
  /// The list of external systems in the model.
  final List<ESExternalSystem> _externalSystems = [];
  
  /// The list of read models in the model.
  final List<ESReadModel> _readModels = [];
  
  /// The list of bounded contexts in the model.
  final List<ESBoundedContext> _boundedContexts = [];
  
  /// Creates a new EventStorming model.
  ESModelImpl({
    required this.id,
    required this.name,
    this.description = '',
  });
  
  @override
  List<ESCommand> get commands => List.unmodifiable(_commands);
  
  @override
  List<ESEvent> get events => List.unmodifiable(_events);
  
  @override
  List<ESAggregate> get aggregates => List.unmodifiable(_aggregates);
  
  @override
  List<ESPolicy> get policies => List.unmodifiable(_policies);
  
  @override
  List<ESRole> get roles => List.unmodifiable(_roles);
  
  @override
  List<ESHotspot> get hotspots => List.unmodifiable(_hotspots);
  
  @override
  List<ESExternalSystem> get externalSystems => List.unmodifiable(_externalSystems);
  
  @override
  List<ESReadModel> get readModels => List.unmodifiable(_readModels);
  
  @override
  List<ESBoundedContext> get boundedContexts => List.unmodifiable(_boundedContexts);
  
  /// Gets an element by its ID.
  ESElement? getElementById(String id) => _elementsById[id];
  
  /// Adds an element to the model and registers it by ID.
  void _addElement(ESElement element) {
    _elementsById[element.id] = element;
  }
  
  @override
  void addCommand(ESCommand command) {
    _commands.add(command);
    _addElement(command);
  }
  
  @override
  void addEvent(ESEvent event) {
    _events.add(event);
    _addElement(event);
  }
  
  @override
  void addAggregate(ESAggregate aggregate) {
    _aggregates.add(aggregate);
    _addElement(aggregate);
  }
  
  @override
  void addPolicy(ESPolicy policy) {
    _policies.add(policy);
    _addElement(policy);
  }
  
  @override
  void addRole(ESRole role) {
    _roles.add(role);
    _addElement(role);
  }
  
  @override
  void addHotspot(ESHotspot hotspot) {
    _hotspots.add(hotspot);
    _addElement(hotspot);
  }
  
  @override
  void addExternalSystem(ESExternalSystem externalSystem) {
    _externalSystems.add(externalSystem);
    _addElement(externalSystem);
  }
  
  @override
  void addReadModel(ESReadModel readModel) {
    _readModels.add(readModel);
    _addElement(readModel);
  }
  
  @override
  void addBoundedContext(ESBoundedContext boundedContext) {
    _boundedContexts.add(boundedContext);
    _addElement(boundedContext);
  }
  
  @override
  model.ModelEntries toDomainModel() {
    // Create a domain model entries collection
    final modelEntries = model.ModelEntries();
    
    // Add all elements to the model entries
    for (final aggregate in aggregates) {
      modelEntries.addAggregateRoot(aggregate.toDomainModel() as model.AggregateRoot);
    }
    
    for (final boundedContext in boundedContexts) {
      modelEntries.addBoundedContext(boundedContext.toDomainModel() as model.BoundedContext);
    }
    
    return modelEntries;
  }
  
  @override
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
  
  /// Creates a model from a JSON representation.
  static ESModel fromJson(Map<String, dynamic> json) {
    // Create the model
    final model = ESModelImpl(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
    );
    
    // Helper function to create elements with position
    ESElement createElement(Map<String, dynamic> elementJson, Function factory) {
      return factory(
        id: elementJson['id'],
        name: elementJson['name'],
        description: elementJson['description'] ?? '',
        positionX: elementJson['positionX'] ?? 0.0,
        positionY: elementJson['positionY'] ?? 0.0,
      );
    }
    
    // Create all elements first
    // This ensures they exist when we create connections
    
    // Create aggregates
    for (var aggregateJson in json['aggregates'] ?? []) {
      model.addAggregate(createElement(aggregateJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESAggregateImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESAggregate);
    }
    
    // Create commands
    for (var commandJson in json['commands'] ?? []) {
      model.addCommand(createElement(commandJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESCommandImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESCommand);
    }
    
    // Create events
    for (var eventJson in json['events'] ?? []) {
      model.addEvent(createElement(eventJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESEventImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESEvent);
    }
    
    // Create policies
    for (var policyJson in json['policies'] ?? []) {
      model.addPolicy(createElement(policyJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESPolicyImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESPolicy);
    }
    
    // Create roles
    for (var roleJson in json['roles'] ?? []) {
      model.addRole(createElement(roleJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESRoleImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESRole);
    }
    
    // Create hotspots
    for (var hotspotJson in json['hotspots'] ?? []) {
      model.addHotspot(createElement(hotspotJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESHotspotImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESHotspot);
    }
    
    // Create external systems
    for (var externalSystemJson in json['externalSystems'] ?? []) {
      model.addExternalSystem(createElement(externalSystemJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESExternalSystemImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESExternalSystem);
    }
    
    // Create read models
    for (var readModelJson in json['readModels'] ?? []) {
      model.addReadModel(createElement(readModelJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESReadModelImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESReadModel);
    }
    
    // Create bounded contexts
    for (var boundedContextJson in json['boundedContexts'] ?? []) {
      model.addBoundedContext(createElement(boundedContextJson, (
        {required id, required name, description, positionX, positionY}) => 
        ESBoundedContextImpl(
          id: id,
          name: name,
          description: description,
          positionX: positionX,
          positionY: positionY,
        )) as ESBoundedContext);
    }
    
    // Now connect all elements based on their relationships
    
    // Connect commands to aggregates
    for (var commandJson in json['commands'] ?? []) {
      if (commandJson.containsKey('aggregateId')) {
        final command = model.getElementById(commandJson['id']) as ESCommand?;
        final aggregate = model.getElementById(commandJson['aggregateId']) as ESAggregate?;
        
        if (command != null && aggregate != null) {
          aggregate.handles(command);
        }
      }
    }
    
    // Connect commands to roles
    for (var commandJson in json['commands'] ?? []) {
      if (commandJson.containsKey('roleId')) {
        final command = model.getElementById(commandJson['id']) as ESCommand?;
        final role = model.getElementById(commandJson['roleId']) as ESRole?;
        
        if (command != null && role != null) {
          role.initiates(command);
        }
      }
    }
    
    // Connect commands to events
    for (var commandJson in json['commands'] ?? []) {
      if (commandJson.containsKey('triggeredEventIds')) {
        final command = model.getElementById(commandJson['id']) as ESCommand?;
        
        if (command != null) {
          for (var eventId in commandJson['triggeredEventIds']) {
            final event = model.getElementById(eventId) as ESEvent?;
            
            if (event != null) {
              command.triggers(event);
            }
          }
        }
      }
    }
    
    // Connect events to aggregates
    for (var eventJson in json['events'] ?? []) {
      if (eventJson.containsKey('aggregateId')) {
        final event = model.getElementById(eventJson['id']) as ESEvent?;
        final aggregate = model.getElementById(eventJson['aggregateId']) as ESAggregate?;
        
        if (event != null && aggregate != null) {
          aggregate.produces(event);
        }
      }
    }
    
    // Connect events to policies
    for (var eventJson in json['events'] ?? []) {
      if (eventJson.containsKey('triggeredPolicyIds')) {
        final event = model.getElementById(eventJson['id']) as ESEvent?;
        
        if (event != null) {
          for (var policyId in eventJson['triggeredPolicyIds']) {
            final policy = model.getElementById(policyId) as ESPolicy?;
            
            if (policy != null) {
              event.triggers(policy);
            }
          }
        }
      }
    }
    
    // Connect policies to commands
    for (var policyJson in json['policies'] ?? []) {
      if (policyJson.containsKey('issuedCommandIds')) {
        final policy = model.getElementById(policyJson['id']) as ESPolicy?;
        
        if (policy != null) {
          for (var commandId in policyJson['issuedCommandIds']) {
            final command = model.getElementById(commandId) as ESCommand?;
            
            if (command != null) {
              policy.issues(command);
            }
          }
        }
      }
    }
    
    // Connect external systems to commands
    for (var externalSystemJson in json['externalSystems'] ?? []) {
      if (externalSystemJson.containsKey('initiatedCommandIds')) {
        final externalSystem = model.getElementById(externalSystemJson['id']) as ESExternalSystem?;
        
        if (externalSystem != null) {
          for (var commandId in externalSystemJson['initiatedCommandIds']) {
            final command = model.getElementById(commandId) as ESCommand?;
            
            if (command != null) {
              externalSystem.initiates(command);
            }
          }
        }
      }
    }
    
    // Connect read models to events
    for (var readModelJson in json['readModels'] ?? []) {
      if (readModelJson.containsKey('updatedByEventIds')) {
        final readModel = model.getElementById(readModelJson['id']) as ESReadModel?;
        
        if (readModel != null) {
          for (var eventId in readModelJson['updatedByEventIds']) {
            final event = model.getElementById(eventId) as ESEvent?;
            
            if (event != null) {
              readModel.updatedBy(event);
            }
          }
        }
      }
    }
    
    // Connect hotspots to elements
    for (var hotspotJson in json['hotspots'] ?? []) {
      if (hotspotJson.containsKey('connectedElementIds')) {
        final hotspot = model.getElementById(hotspotJson['id']) as ESHotspot?;
        
        if (hotspot != null) {
          for (var elementId in hotspotJson['connectedElementIds']) {
            final element = model.getElementById(elementId);
            
            if (element != null) {
              hotspot.connectsTo(element);
            }
          }
        }
      }
    }
    
    // Add elements to bounded contexts
    for (var boundedContextJson in json['boundedContexts'] ?? []) {
      if (boundedContextJson.containsKey('elementIds')) {
        final boundedContext = model.getElementById(boundedContextJson['id']) as ESBoundedContext?;
        
        if (boundedContext != null) {
          for (var elementId in boundedContextJson['elementIds']) {
            final element = model.getElementById(elementId);
            
            if (element != null) {
              boundedContext.addElement(element);
            }
          }
        }
      }
    }
    
    return model;
  }
} 