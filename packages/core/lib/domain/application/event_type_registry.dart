part of ednet_core;

/// Event Type Registry for mapping event names to types and factory functions.
///
/// This registry provides a central place to register event types,
/// enabling serialization and deserialization of domain events. It supports:
/// - Event type registration
/// - Event instantiation from serialized data
/// - Type-safe event creation
///
/// This is essential for event sourcing to reconstruct events from stored data.
///
/// Example usage:
/// ```dart
/// EventTypeRegistry.register<OrderCreatedEvent>(
///   'OrderCreated',
///   (data) => OrderCreatedEvent.fromJson(data)
/// );
/// 
/// final event = EventTypeRegistry.createEvent('OrderCreated', jsonData);
/// ```
class EventTypeRegistry {
  /// Private constructor to prevent instantiation
  EventTypeRegistry._();
  
  /// Map of event type names to factory functions
  static final Map<String, Function> _factories = {};
  
  /// Map of event types to type names
  static final Map<Type, String> _typeNames = {};
  
  /// Registers an event type with its factory function.
  ///
  /// Parameters:
  /// - [typeName]: The name of the event type (e.g., 'OrderCreated')
  /// - [factory]: Factory function that creates an event from JSON data
  ///
  /// Type parameters:
  /// - [T]: The event type to register
  static void register<T extends IDomainEvent>(
    String typeName,
    T Function(Map<String, dynamic> data) factory
  ) {
    _factories[typeName] = factory;
    _typeNames[T] = typeName;
  }
  
  /// Creates an event instance from a type name and data.
  ///
  /// This method uses the registered factory function to create
  /// the appropriate event instance from serialized data.
  ///
  /// Parameters:
  /// - [typeName]: The name of the event type
  /// - [data]: The event data (usually deserialized from JSON)
  ///
  /// Returns:
  /// A domain event instance
  ///
  /// Throws:
  /// ArgumentError if the event type is not registered
  static IDomainEvent createEvent(
    String typeName,
    Map<String, dynamic> data
  ) {
    final factory = _factories[typeName];
    
    if (factory == null) {
      throw ArgumentError('No factory registered for event type: $typeName');
    }
    
    return factory(data);
  }
  
  /// Gets the type name for an event type.
  ///
  /// Parameters:
  /// - [type]: The event type
  ///
  /// Returns:
  /// The name of the event type, or null if not registered
  static String? getTypeName(Type type) {
    return _typeNames[type];
  }
  
  /// Gets the type name for an event instance.
  ///
  /// Parameters:
  /// - [event]: The event instance
  ///
  /// Returns:
  /// The name of the event type, or null if not registered
  static String? getTypeNameForInstance(IDomainEvent event) {
    return _typeNames[event.runtimeType];
  }
  
  /// Checks if an event type is registered.
  ///
  /// Parameters:
  /// - [typeName]: The name of the event type
  ///
  /// Returns:
  /// True if the event type is registered, false otherwise
  static bool isRegistered(String typeName) {
    return _factories.containsKey(typeName);
  }
  
  /// Clears all registered event types.
  ///
  /// This is primarily useful for testing.
  static void clear() {
    _factories.clear();
    _typeNames.clear();
  }
} 