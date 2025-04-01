part of eventstorming;

/// Implementation of a role in EventStorming.
class ESRoleImpl extends ESElementImpl implements ESRole {
  final List<ESCommand> _initiatedCommands = [];
  
  ESRoleImpl({
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
    color: '#90EE90', // Light green is typical for roles in EventStorming
  );
  
  @override
  List<ESCommand> get initiatedCommands => List.unmodifiable(_initiatedCommands);
  
  @override
  void initiates(ESCommand command) {
    if (!_initiatedCommands.contains(command)) {
      _initiatedCommands.add(command);
      command.role = this;
      
      addConnection(ESConnection(
        source: this,
        target: command,
        type: ESConnectionType.INITIATES
      ));
    }
  }
  
  @override
  model.Entity toDomainModel() {
    // Create a domain model role
    final role = model.Role(
      name: name,
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect initiated commands to the role
    for (final command in initiatedCommands) {
      role.addInitiatedCommand(command.toDomainModel() as model.Command);
    }
    
    return role;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer role
    final role = app.Role(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect initiated commands to the role
    for (final command in initiatedCommands) {
      role.addInitiatedCommand(command.toApplicationModel() as app.Command);
    }
    
    return role;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'role';
    json['initiatedCommandIds'] = initiatedCommands.map((c) => c.id).toList();
    return json;
  }
} 