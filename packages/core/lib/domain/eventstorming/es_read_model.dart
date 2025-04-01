part of eventstorming;

/// Implementation of a read model in EventStorming.
class ESReadModelImpl extends ESElementImpl implements ESReadModel {
  final List<ESEvent> _updatedByEvents = [];
  
  ESReadModelImpl({
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
    color: '#87CEFA', // Light sky blue is typical for read models in EventStorming
  );
  
  @override
  List<ESEvent> get updatedByEvents => List.unmodifiable(_updatedByEvents);
  
  @override
  void updatedBy(ESEvent event) {
    if (!_updatedByEvents.contains(event)) {
      _updatedByEvents.add(event);
      
      addConnection(ESConnection(
        source: event,
        target: this,
        type: ESConnectionType.UPDATES
      ));
    }
  }
  
  @override
  model.Entity toDomainModel() {
    // Create a domain model read model
    final readModel = model.ReadModel(
      name: name,
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect updating events to the read model
    for (final event in updatedByEvents) {
      readModel.addUpdatingEvent(event.toDomainModel() as model.Event);
    }
    
    return readModel;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer read model
    final readModel = app.ReadModel(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //],
    );
    
    // Connect updating events to the read model
    for (final event in updatedByEvents) {
      readModel.addUpdatingEvent(event.toApplicationModel() as app.Event);
    }
    
    return readModel;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'readModel';
    json['updatedByEventIds'] = updatedByEvents.map((e) => e.id).toList();
    return json;
  }
} 