part of eventstorming;

/// Service for managing EventStorming domain modeling workshops.
class EventStormingEditorServiceImpl implements EventStormingEditorService {
  /// The current model being edited.
  ESModel? _currentModel;
  
  /// Storage provider for models.
  final EventStormingModelStorage _storage;
  
  /// Creates a new EventStorming editor service.
  EventStormingEditorServiceImpl({
    required EventStormingModelStorage storage,
    ESModel? initialModel,
  }) : 
    _storage = storage,
    _currentModel = initialModel;
  
  @override
  ESModel? get currentModel => _currentModel;
  
  @override
  ESModel createModel(String name, [String description = '']) {
    final model = ESModelImpl(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    
    _currentModel = model;
    return model;
  }
  
  @override
  Future<ESModel> loadModel(String id) async {
    final model = await _storage.loadModel(id);
    _currentModel = model;
    return model;
  }
  
  @override
  Future<void> saveModel() async {
    if (_currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
    
    await _storage.saveModel(_currentModel!);
  }
  
  @override
  ESCommand createCommand(String name, [String description = '']) {
    _ensureModelExists();
    
    final command = ESCommandImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addCommand(command);
    return command;
  }
  
  @override
  ESEvent createEvent(String name, [String description = '']) {
    _ensureModelExists();
    
    final event = ESEventImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addEvent(event);
    return event;
  }
  
  @override
  ESAggregate createAggregate(String name, [String description = '']) {
    _ensureModelExists();
    
    final aggregate = ESAggregateImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addAggregate(aggregate);
    return aggregate;
  }
  
  @override
  ESPolicy createPolicy(String name, [String description = '']) {
    _ensureModelExists();
    
    final policy = ESPolicyImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addPolicy(policy);
    return policy;
  }
  
  @override
  ESRole createRole(String name, [String description = '']) {
    _ensureModelExists();
    
    final role = ESRoleImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addRole(role);
    return role;
  }
  
  @override
  ESHotspot createHotspot(String name, [String description = '']) {
    _ensureModelExists();
    
    final hotspot = ESHotspotImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addHotspot(hotspot);
    return hotspot;
  }
  
  @override
  ESExternalSystem createExternalSystem(String name, [String description = '']) {
    _ensureModelExists();
    
    final externalSystem = ESExternalSystemImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addExternalSystem(externalSystem);
    return externalSystem;
  }
  
  @override
  ESReadModel createReadModel(String name, [String description = '']) {
    _ensureModelExists();
    
    final readModel = ESReadModelImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addReadModel(readModel);
    return readModel;
  }
  
  @override
  ESBoundedContext createBoundedContext(String name, [String description = '']) {
    _ensureModelExists();
    
    final boundedContext = ESBoundedContextImpl(
      id: _generateId(),
      name: name,
      description: description,
    );
    
    _currentModel!.addBoundedContext(boundedContext);
    return boundedContext;
  }
  
  @override
  void connectElements(ESElement source, ESElement target, ESConnectionType connectionType) {
    _ensureModelExists();
    
    final connection = ESConnectionImpl(
      source: source,
      target: target,
      type: connectionType,
    );
    
    source.addConnection(connection);
  }
  
  @override
  String generateDomainModelCode() {
    _ensureModelExists();
    
    // Basic implementation that generates Dart code
    final buffer = StringBuffer();
    
    buffer.writeln('// Generated domain model code');
    buffer.writeln('// Model: ${_currentModel!.name}');
    buffer.writeln('// Generated on: ${DateTime.now()}');
    buffer.writeln();
    
    // Generate code for aggregates
    for (final aggregate in _currentModel!.aggregates) {
      buffer.writeln('class ${aggregate.name} extends AggregateRoot {');
      buffer.writeln('  // Properties');
      buffer.writeln('  // TODO: Add properties based on domain model');
      buffer.writeln();
      
      // Generate code for commands
      for (final command in aggregate.commands) {
        buffer.writeln('  // Command: ${command.name}');
        buffer.writeln('  void ${_camelCase(command.name)}(/* TODO: Add parameters */) {');
        buffer.writeln('    // TODO: Implement command logic');
        buffer.writeln('    // Apply event');
        
        // Generate event application
        for (final event in command.triggeredEvents) {
          buffer.writeln('    apply${event.name}(/* TODO: Add parameters */);');
        }
        
        buffer.writeln('  }');
        buffer.writeln();
      }
      
      // Generate code for events
      for (final event in aggregate.events) {
        buffer.writeln('  // Event: ${event.name}');
        buffer.writeln('  void apply${event.name}(/* TODO: Add parameters */) {');
        buffer.writeln('    // TODO: Implement event application logic');
        buffer.writeln('  }');
        buffer.writeln();
      }
      
      buffer.writeln('}');
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  /// Ensures that a model exists before performing operations.
  void _ensureModelExists() {
    if (_currentModel == null) {
      throw Exception('No active model. Create or load a model first.');
    }
  }
  
  /// Generates a unique ID for an element.
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  /// Converts a string to camel case.
  String _camelCase(String text) {
    if (text.isEmpty) return '';
    
    // Split by spaces, underscores, or hyphens
    final parts = text.split(RegExp(r'[\s_-]+'));
    
    // First part is lowercase, rest have uppercase first letters
    final firstPart = parts.first.toLowerCase();
    final remainingParts = parts.skip(1).map((part) {
      if (part.isEmpty) return '';
      return part[0].toUpperCase() + part.substring(1).toLowerCase();
    });
    
    return [firstPart, ...remainingParts].join('');
  }
}

/// Storage provider for EventStorming models.
abstract class EventStormingModelStorage {
  /// Loads a model by ID.
  Future<ESModel> loadModel(String id);
  
  /// Saves a model.
  Future<void> saveModel(ESModel model);
  
  /// Lists all available models.
  Future<List<ESModelInfo>> listModels();
  
  /// Deletes a model by ID.
  Future<void> deleteModel(String id);
}

/// Basic information about an EventStorming model.
class ESModelInfo {
  /// The unique identifier of the model.
  final String id;
  
  /// The name of the model.
  final String name;
  
  /// The description of the model.
  final String description;
  
  /// The date and time when the model was last modified.
  final DateTime lastModified;
  
  /// Creates a new model info object.
  ESModelInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.lastModified,
  });
  
  /// Creates a model info object from JSON.
  factory ESModelInfo.fromJson(Map<String, dynamic> json) {
    return ESModelInfo(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
  
  /// Converts the model info to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lastModified': lastModified.toIso8601String(),
    };
  }
} 