part of eventstorming;

/// Implementation of an event in EventStorming.
class ESEventImpl extends ESElementImpl implements ESEvent {
  ESAggregate? _aggregate;
  final List<ESPolicy> _triggeredPolicies = [];
  
  ESEventImpl({
    required String id,
    required String name, 
    String description = '',
    ESAggregate? aggregate,
    double positionX = 0,
    double positionY = 0,
  }) : 
    _aggregate = aggregate,
    super(
      id: id,
      name: name,
      description: description,
      positionX: positionX,
      positionY: positionY,
      color: '#FF7F50', // Orange is typical for events in EventStorming
    );
  
  @override
  ESAggregate? get aggregate => _aggregate;
  
  @override
  set aggregate(ESAggregate? value) {
    _aggregate = value;
  }
  
  @override
  List<ESPolicy> get triggeredPolicies => List.unmodifiable(_triggeredPolicies);
  
  @override
  void triggers(ESPolicy policy) {
    if (!_triggeredPolicies.contains(policy)) {
      _triggeredPolicies.add(policy);
      
      addConnection(ESConnection(
        source: this,
        target: policy,
        type: ESConnectionType.TRIGGERS
      ));
    }
  }
  
  @override
  model.Entity toDomainModel() {
    // Create a domain model event
    final event = model.Event(
      name: name,
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect to aggregate if present
    if (aggregate != null) {
      event.setAggregate(aggregate!.toDomainModel() as model.Aggregate);
    }
    
    return event;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer event
    final event = app.Event(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect to aggregate if present
    if (aggregate != null) {
      event.setAggregate(aggregate!.toApplicationModel() as app.Aggregate);
    }
    
    return event;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'event';
    if (aggregate != null) json['aggregateId'] = aggregate!.id;
    json['triggeredPolicyIds'] = triggeredPolicies.map((p) => p.id).toList();
    return json;
  }
} 