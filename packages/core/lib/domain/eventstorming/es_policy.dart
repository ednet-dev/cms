part of eventstorming;

/// Implementation of a policy in EventStorming.
class ESPolicyImpl extends ESElementImpl implements ESPolicy {
  final List<ESEvent> _triggeringEvents = [];
  final List<ESCommand> _issuedCommands = [];
  
  ESPolicyImpl({
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
    color: '#B19CD9', // Light purple is typical for policies in EventStorming
  );
  
  @override
  List<ESEvent> get triggeringEvents => List.unmodifiable(_triggeringEvents);
  
  @override
  List<ESCommand> get issuedCommands => List.unmodifiable(_issuedCommands);
  
  @override
  void issues(ESCommand command) {
    if (!_issuedCommands.contains(command)) {
      _issuedCommands.add(command);
      
      addConnection(ESConnection(
        source: this,
        target: command,
        type: ESConnectionType.ISSUES
      ));
    }
  }
  
  /// Adds a triggering event for this policy.
  void addTriggeringEvent(ESEvent event) {
    if (!_triggeringEvents.contains(event)) {
      _triggeringEvents.add(event);
      
      // This is the reverse of event.triggers(policy)
      // We don't create a connection here, as it should be
      // created by the event
    }
  }
  
  @override
  model.Entity toDomainModel() {
    // Create a domain model policy
    final policy = model.Policy(
      name: name,
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect triggering events to the policy
    for (final event in triggeringEvents) {
      policy.addTriggeringEvent(event.toDomainModel() as model.Event);
    }
    
    // Connect issued commands to the policy
    for (final command in issuedCommands) {
      policy.addIssuedCommand(command.toDomainModel() as model.Command);
    }
    
    return policy;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer policy
    final policy = app.Policy(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect triggering events to the policy
    for (final event in triggeringEvents) {
      policy.addTriggeringEvent(event.toApplicationModel() as app.Event);
    }
    
    // Connect issued commands to the policy
    for (final command in issuedCommands) {
      policy.addIssuedCommand(command.toApplicationModel() as app.Command);
    }
    
    return policy;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'policy';
    json['triggeringEventIds'] = triggeringEvents.map((e) => e.id).toList();
    json['issuedCommandIds'] = issuedCommands.map((c) => c.id).toList();
    return json;
  }
} 