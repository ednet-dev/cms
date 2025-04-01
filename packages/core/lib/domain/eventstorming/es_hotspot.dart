part of eventstorming;

/// Implementation of a hotspot in EventStorming.
class ESHotspotImpl extends ESElementImpl implements ESHotspot {
  final List<ESElement> _connectedElements = [];
  
  ESHotspotImpl({
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
    color: '#FF6B6B', // Red is typical for hotspots in EventStorming
  );
  
  @override
  List<ESElement> get connectedElements => List.unmodifiable(_connectedElements);
  
  @override
  void connectsTo(ESElement element) {
    if (!_connectedElements.contains(element)) {
      _connectedElements.add(element);
      
      addConnection(ESConnection(
        source: this,
        target: element,
        type: ESConnectionType.CONNECTS_TO
      ));
    }
  }
  
  @override
  model.Entity toDomainModel() {
    // Hotspots don't typically have direct domain model equivalents,
    // but we create a Note entity to represent them
    final hotspot = model.Note(
      name: name,
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //  model.Attribute(name: 'type', value: 'hotspot'),
      //],
    );
    
    // Record the IDs of connected elements as references
    final connectedIds = connectedElements.map((e) => e.id).toList();
    hotspot.setAttribute('connectedElementIds', connectedIds);
    
    return hotspot;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer note
    final hotspot = app.Note(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //  app.Attribute(name: 'type', value: 'hotspot'),
      //],
    );
    
    // Record the IDs of connected elements as references
    final connectedIds = connectedElements.map((e) => e.id).toList();
    hotspot.setAttribute('connectedElementIds', connectedIds);
    
    return hotspot;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'hotspot';
    json['connectedElementIds'] = connectedElements.map((e) => e.id).toList();
    return json;
  }
} 