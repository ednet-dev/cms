part of eventstorming;

/// Implementation of the base class for all EventStorming meta-model elements.
class ESElementImpl implements ESElement {
  final String _id;
  final String _name;
  String _description;
  double _positionX;
  double _positionY;
  String _color;
  final List<ESConnection> _connections = [];
  
  ESElementImpl({
    required String id,
    required String name,
    String description = '',
    double positionX = 0,
    double positionY = 0,
    String color = '#FFFFFF',
  }) : 
    _id = id,
    _name = name,
    _description = description,
    _positionX = positionX,
    _positionY = positionY,
    _color = color;
  
  @override
  String get id => _id;
  
  @override
  String get name => _name;
  
  @override
  String get description => _description;
  set description(String value) => _description = value;
  
  @override
  double get positionX => _positionX;
  
  @override
  double get positionY => _positionY;
  
  @override
  String get color => _color;
  set color(String value) => _color = value;
  
  @override
  List<ESConnection> get connections => List.unmodifiable(_connections);
  
  @override
  void addConnection(ESConnection connection) {
    _connections.add(connection);
  }
  
  @override
  void removeConnection(ESConnection connection) {
    _connections.remove(connection);
  }
  
  @override
  void updatePosition(double x, double y) {
    _positionX = x;
    _positionY = y;
  }
  
  @override
  model.Entity toDomainModel() {
    // Default implementation creates a basic entity
    // Subclasses should override with specific implementations
    return model.Entity(
      name: name,
      // Include minimal properties for the domain model
      //attributes: [
      //  model.Attribute(name: 'name', value: name),
      //  model.Attribute(name: 'description', value: description),
      //],
    );
  }
  
  @override
  app.Entity toApplicationModel() {
    // Default implementation creates a basic application entity
    // Subclasses should override with specific implementations
    return app.Entity(
      name: name,
      //attributes: [
      //  app.Attribute(name: 'name', value: name),
      //  app.Attribute(name: 'description', value: description),
      //],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'positionX': positionX,
      'positionY': positionY,
      'color': color,
      'connections': connections.map((c) => c.toJson()).toList(),
    };
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ESElementImpl && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
} 