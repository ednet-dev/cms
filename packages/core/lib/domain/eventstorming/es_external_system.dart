part of eventstorming;

/// Implementation of an external system in EventStorming.
class ESExternalSystemImpl extends ESElementImpl implements ESExternalSystem {
  final List<ESCommand> _initiatedCommands = [];
  
  ESExternalSystemImpl({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
  }) : super(
    id: id,
    name: name,
    description: description,
    positionX: positionX,
    positionY: positionY,
    color: '#FFC0CB', // Pink is typical for external systems in EventStorming
  );
  
  @override
  List<ESCommand> get initiatedCommands => List.unmodifiable(_initiatedCommands);
  
  @override
  void initiates(ESCommand command) {
    if (!_initiatedCommands.contains(command)) {
      _initiatedCommands.add(command);
      
      addConnection(ESConnection(
        source: this,
        target: command,
        type: ESConnectionType.INITIATES
      ));
    }
  }
  
  @override
  model.Entity toDomainModel() {
    // Create a domain model external system
    final externalSystem = model.ExternalSystem(
      name: name,
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect initiated commands to the external system
    for (final command in initiatedCommands) {
      externalSystem.addInitiatedCommand(command.toDomainModel() as model.Command);
    }
    
    return externalSystem;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer external system
    final externalSystem = app.ExternalSystem(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect initiated commands to the external system
    for (final command in initiatedCommands) {
      externalSystem.addInitiatedCommand(command.toApplicationModel() as app.Command);
    }
    
    return externalSystem;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'externalSystem';
    json['initiatedCommandIds'] = initiatedCommands.map((c) => c.id).toList();
    return json;
  }
} 