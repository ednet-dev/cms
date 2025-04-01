part of ednet_core;

/// Defines the interface for domain events in the EDNet Core framework.
///
/// Domain events represent facts that have occurred in the domain. They:
/// - Are immutable
/// - Record something that happened in the past
/// - Are named with past-tense verbs
/// - Contain all data needed to understand what happened
///
/// This interface ensures that all domain events:
/// - Have a unique identifier
/// - Have a timestamp
/// - Have an event name
/// - Can be serialized to JSON
///
/// Example usage:
/// ```dart
/// class OrderCreatedEvent implements IDomainEvent {
///   @override
///   final String id = Uuid().v4();
///
///   @override
///   final DateTime timestamp = DateTime.now();
///
///   @override
///   final String name = 'OrderCreated';
///
///   final String orderId;
///   final String customerId;
///   final double amount;
///
///   OrderCreatedEvent({
///     required this.orderId,
///     required this.customerId,
///     required this.amount,
///   });
///
///   @override
///   Map<String, dynamic> toJson() {
///     return {
///       'id': id,
///       'timestamp': timestamp.toIso8601String(),
///       'name': name,
///       'orderId': orderId,
///       'customerId': customerId,
///       'amount': amount,
///     };
///   }
/// }
/// ```
abstract class IDomainEvent {
  /// The unique identifier for this event.
  String get id;

  /// The timestamp when this event occurred.
  DateTime get timestamp;

  /// The name of this event.
  String get name;

  /// The aggregate that emitted this event.
  Entity? get entity;

  /// Converts this event to a JSON representation.
  Map<String, dynamic> toJson();
}

/// Base implementation of a domain event.
///
/// The [DomainEvent] class provides a standard implementation of [IDomainEvent]:
/// - Automatically generates a unique identifier
/// - Records the current timestamp
/// - Requires a name and optional entity
/// - Provides basic JSON serialization
///
/// Example usage:
/// ```dart
/// class OrderShippedEvent extends DomainEvent {
///   final String orderId;
///   final String trackingNumber;
///
///   OrderShippedEvent({
///     required this.orderId,
///     required this.trackingNumber,
///     Entity? entity,
///   }) : super(name: 'OrderShipped', entity: entity);
///
///   @override
///   Map<String, dynamic> toJson() {
///     final json = super.toJson();
///     json.addAll({
///       'orderId': orderId,
///       'trackingNumber': trackingNumber,
///     });
///     return json;
///   }
/// }
/// ```
class DomainEvent implements IDomainEvent {
  @override
  final String id;

  @override
  final DateTime timestamp;

  @override
  final String name;

  @override
  final Entity? entity;

  /// Creates a new domain event.
  ///
  /// Parameters:
  /// - [name]: The name of the event
  /// - [entity]: The entity that emitted the event
  /// - [id]: Optional custom identifier (defaults to a UUID)
  /// - [timestamp]: Optional custom timestamp (defaults to now)
  DomainEvent({
    required this.name,
    this.entity,
    String? id,
    DateTime? timestamp,
  })  : id = id ?? Oid().toString(),
        timestamp = timestamp ?? DateTime.now();

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'name': name,
      'entity': entity?.toJson(),
    };
  }
} 