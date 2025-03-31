part of ednet_core;

/// Represents a domain event that can be triggered within the system.
///
/// An event is a record of something significant that happened in the domain.
/// It contains information about what happened, who it happened to, and any
/// additional data associated with the event.
///
/// Example usage:
/// ```dart
/// final event = Event(
///   'UserCreated',
///   'A new user has been created in the system',
///   ['SendWelcomeEmail', 'UpdateUserCount'],
///   userEntity,
///   {'email': 'user@example.com'},
/// );
/// ```
class Event {
  /// The name of the event (e.g., 'UserCreated', 'OrderPlaced').
  final String name;

  /// A human-readable description of what the event represents.
  final String description;

  /// List of handler names that should process this event when triggered.
  final List<String> handlers;

  /// The entity associated with this event, if any.
  final Entity? entity;

  /// Additional data associated with the event.
  final Map<String, dynamic> data;

  /// Creates a new [Event] instance.
  ///
  /// [name] is the identifier for the event.
  /// [description] provides context about what happened.
  /// [handlers] are the names of handlers that should process this event.
  /// [entity] is the related domain entity, if any.
  /// [data] is an optional map of additional event data.
  Event(this.name, this.description, this.handlers, this.entity,
      [this.data = const {}]);

  /// Creates a new success [Event] instance.
  ///
  /// This constructor is specifically for events that represent successful operations.
  /// It has the same parameters as the default constructor.
  Event.SuccessEvent(this.name, this.description, this.handlers, this.entity,
      [this.data = const {}]);

  /// Creates a new failure [Event] instance.
  ///
  /// This constructor is specifically for events that represent failed operations.
  /// It has the same parameters as the default constructor.
  Event.FailureEvent(this.name, this.description, this.handlers, this.entity,
      [this.data = const {}]);

  /// Triggers the event handlers associated with this event.
  ///
  /// [session] is the domain session in which the event is being triggered.
  /// This method will execute all registered handlers for this event.
  ///
  /// Note: Currently, the actual handler execution is commented out and only
  /// prints a debug message. This should be implemented based on the specific
  /// requirements of the system.
  void trigger(DomainSession session) {
    // for (var handler in handlers) {
    // session.executeCommand(handler, entity, data);
    print('session handler');
    // }
  }
}
