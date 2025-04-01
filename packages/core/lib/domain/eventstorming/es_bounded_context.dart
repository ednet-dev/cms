part of eventstorming;

/// Implementation of a bounded context in EventStorming.
class ESBoundedContextImpl extends ESElementImpl implements ESBoundedContext {
  final List<ESElement> _elements = [];
  
  ESBoundedContextImpl({
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
    color: '#EEEEEE', // Light gray border for bounded contexts
  );
  
  @override
  List<ESElement> get elements => List.unmodifiable(_elements);
  
  @override
  void addElement(ESElement element) {
    if (!_elements.contains(element)) {
      _elements.add(element);
    }
  }
  
  @override
  void removeElement(ESElement element) {
    _elements.remove(element);
  }
  
  @override
  model.Entity toDomainModel() {
    // Create a domain model bounded context
    final boundedContext = model.BoundedContext(
      name: name,
      description: description,
    );
    
    // Add elements to the bounded context
    for (final element in elements) {
      boundedContext.addElement(element.toDomainModel());
    }
    
    return boundedContext;
  }
  
  @override
  app.Entity toApplicationModel() {
    // Create an application layer bounded context
    final boundedContext = app.BoundedContext(
      name: name,
      description: description,
    );
    
    // Add elements to the bounded context
    for (final element in elements) {
      boundedContext.addElement(element.toApplicationModel());
    }
    
    return boundedContext;
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['type'] = 'boundedContext';
    json['elementIds'] = elements.map((e) => e.id).toList();
    return json;
  }
} 