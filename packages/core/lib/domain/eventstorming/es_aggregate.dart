part of eventstorming;

/// Implementation of an aggregate in EventStorming.
class ESAggregateImpl extends ESElementImpl implements ESAggregate {
  final List<ESCommand> _commands = [];
  final List<ESEvent> _events = [];
  
  ESAggregateImpl({
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
    color: '#A0C8E0', // Light blue is typical for aggregates in EventStorming
  );
  
  @override
  List<ESCommand> get commands => List.unmodifiable(_commands);
  
  @override
  List<ESEvent> get events => List.unmodifiable(_events);
  
  @override
  void handles(ESCommand command) {
    if (!_commands.contains(command)) {
      _commands.add(command);
      command.aggregate = this;
      
      addConnection(ESConnection(
        source: this,
        target: command,
        type: ESConnectionType.HANDLES
      ));
    }
  }
  
  @override
  void produces(ESEvent event) {
    if (!_events.contains(event)) {
      _events.add(event);
      event.aggregate = this;
      
      addConnection(ESConnection(
        source: this,
        target: event,
        type: ESConnectionType.PRODUCES
      ));
    }
  }
  
  @override
  model.Entity toDomainModel() {
    // Create a domain model aggregate
    final aggregate = model.AggregateRoot(
      name: name,
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect commands to the aggregate
    for (final command in commands) {
      aggregate.addCommand(command.toDomainModel() as model.Command);
    }
    
    // Connect events to the aggregate
    for (final event in events) {
      aggregate.addEvent(event.toDomainModel() as model.Event);
    }
    
    return aggregate;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer aggregate
    final aggregate = app.AggregateRoot(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect commands to the aggregate
    for (final command in commands) {
      aggregate.addCommand(command.toApplicationModel() as app.Command);
    }
    
    // Connect events to the aggregate
    for (final event in events) {
      aggregate.addEvent(event.toApplicationModel() as app.Event);
    }
    
    return aggregate;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'aggregate';
    json['commandIds'] = commands.map((c) => c.id).toList();
    json['eventIds'] = events.map((e) => e.id).toList();
    return json;
  }
} 