part of eventstorming;

/// Implementation of a command in EventStorming.
class ESCommandImpl extends ESElementImpl implements ESCommand {
  ESRole? _role;
  ESAggregate? _aggregate;
  final List<ESEvent> _triggeredEvents = [];
  
  ESCommandImpl({
    required String id,
    required String name,
    String description = '',
    ESRole? role,
    ESAggregate? aggregate,
    double positionX = 0,
    double positionY = 0,
  }) : 
    _role = role,
    _aggregate = aggregate,
    super(
      id: id,
      name: name,
      description: description,
      positionX: positionX,
      positionY: positionY,
      color: '#FFCC44', // Yellow is typical for commands in EventStorming
    );
  
  @override
  ESRole? get role => _role;
  
  @override
  set role(ESRole? value) {
    _role = value;
  }
  
  @override
  ESAggregate? get aggregate => _aggregate;
  
  @override
  set aggregate(ESAggregate? value) {
    _aggregate = value;
  }
  
  @override
  List<ESEvent> get triggeredEvents => List.unmodifiable(_triggeredEvents);
  
  @override
  void triggers(ESEvent event) {
    if (!_triggeredEvents.contains(event)) {
      _triggeredEvents.add(event);
      
      addConnection(ESConnection(
        source: this,
        target: event,
        type: ESConnectionType.TRIGGERS
      ));
    }
  }
  
  @override
  model.Entity toDomainModel() {
    // Create a domain model command
    final command = model.Command(
      name: name,
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect to events if present
    for (final event in triggeredEvents) {
      command.addEvent(event.toDomainModel() as model.Event);
    }
    
    return command;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer command
    final command = app.Command(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect to events if present
    for (final event in triggeredEvents) {
      command.addEvent(event.toApplicationModel() as app.Event);
    }
    
    return command;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'command';
    if (role != null) json['roleId'] = role!.id;
    if (aggregate != null) json['aggregateId'] = aggregate!.id;
    json['triggeredEventIds'] = triggeredEvents.map((e) => e.id).toList();
    return json;
  }
} 