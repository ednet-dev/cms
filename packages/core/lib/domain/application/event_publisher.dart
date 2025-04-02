part of ednet_core;

/// Event Publisher for distributing domain events to subscribers.
///
/// The EventPublisher manages event subscriptions and ensures that
/// events are delivered to all interested subscribers. It supports:
/// - Event type-based subscriptions
/// - Synchronous and asynchronous event handling
/// - Error handling for event subscribers
///
/// This is a key component of an event-driven architecture, enabling
/// loose coupling between domain components.
///
/// Example usage:
/// ```dart
/// final publisher = EventPublisher();
/// publisher.subscribe<OrderCreatedEvent>((event) => 
///   sendConfirmationEmail(event.orderId));
/// await publisher.publish(orderCreatedEvent);
/// ```
class EventPublisher {
  /// Map of event types to subscriber lists
  final Map<Type, List<Function>> _subscribers = {};
  
  /// Default constructor
  EventPublisher();
  
  /// Subscribes to events of a specific type.
  ///
  /// Parameters:
  /// - [handler]: The event handler function
  ///
  /// Type parameters:
  /// - [T]: The type of event to subscribe to
  ///
  /// Returns:
  /// A subscription ID that can be used to unsubscribe
  String subscribe<T extends IDomainEvent>(
    FutureOr<void> Function(T event) handler
  ) {
    final type = T;
    _subscribers.putIfAbsent(type, () => []);
    
    final subscriptionId = _generateSubscriptionId();
    _subscribers[type]!.add((event) {
      if (event is T) {
        return handler(event);
      }
    });
    
    return subscriptionId;
  }
  
  /// Subscribes to all domain events.
  ///
  /// Parameters:
  /// - [handler]: The event handler function
  ///
  /// Returns:
  /// A subscription ID that can be used to unsubscribe
  String subscribeToAll(
    FutureOr<void> Function(IDomainEvent event) handler
  ) {
    final type = IDomainEvent;
    _subscribers.putIfAbsent(type, () => []);
    
    final subscriptionId = _generateSubscriptionId();
    _subscribers[type]!.add(handler);
    
    return subscriptionId;
  }
  
  /// Unsubscribes from events.
  ///
  /// Parameters:
  /// - [subscriptionId]: The subscription ID returned by subscribe
  ///
  /// Returns:
  /// True if unsubscribe was successful, false otherwise
  bool unsubscribe(String subscriptionId) {
    // In a real implementation, you would track subscription IDs
    // and remove the specific handler. This is a simplified version.
    return false;
  }
  
  /// Publishes an event to all subscribers.
  ///
  /// Parameters:
  /// - [event]: The domain event to publish
  ///
  /// Returns:
  /// Future that completes when all subscribers have processed the event
  Future<void> publish(IDomainEvent event) async {
    final eventType = event.runtimeType;
    
    // Call specific event type handlers
    if (_subscribers.containsKey(eventType)) {
      for (final handler in _subscribers[eventType]!) {
        try {
          final result = handler(event);
          if (result is Future) {
            await result;
          }
        } catch (e, stackTrace) {
          _handleSubscriberError(e, stackTrace, event, handler);
        }
      }
    }
    
    // Call general IDomainEvent handlers
    if (_subscribers.containsKey(IDomainEvent)) {
      for (final handler in _subscribers[IDomainEvent]!) {
        try {
          final result = handler(event);
          if (result is Future) {
            await result;
          }
        } catch (e, stackTrace) {
          _handleSubscriberError(e, stackTrace, event, handler);
        }
      }
    }
  }
  
  /// Generates a unique subscription ID.
  ///
  /// Returns:
  /// A unique ID for the subscription
  String _generateSubscriptionId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
      '_' + 
      (100000 + Random().nextInt(900000)).toString();
  }
  
  /// Handles errors from event subscribers.
  ///
  /// This method logs the error but doesn't rethrow it, to prevent
  /// one subscriber's failure from affecting others.
  ///
  /// Parameters:
  /// - [error]: The error that occurred
  /// - [stackTrace]: The stack trace
  /// - [event]: The event being processed
  /// - [handler]: The handler that threw the error
  void _handleSubscriberError(
    dynamic error, 
    StackTrace stackTrace, 
    IDomainEvent event, 
    Function handler
  ) {
    // In a real implementation, you would log the error
    // and possibly notify an error reporting service.
    print('Error in event handler: $error');
    print('Event: ${event.name}');
    print('Handler: ${handler.runtimeType}');
    print('Stack trace: $stackTrace');
  }
} 