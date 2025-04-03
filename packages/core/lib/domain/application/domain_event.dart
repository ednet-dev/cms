// part of ednet_core;
//
// /// Defines the interface for domain events in the EDNet Core framework.
// ///
// /// Domain events represent facts that have occurred in the domain. They:
// /// - Are immutable
// /// - Record something that happened in the past
// /// - Are named with past-tense verbs
// /// - Contain all data needed to understand what happened
// ///
// /// This interface ensures that all domain events:
// /// - Have a unique identifier
// /// - Have a timestamp
// /// - Have an event name
// /// - Have aggregate metadata (type, ID, version)
// /// - Can be serialized to JSON
// ///
// /// Example usage:
// /// ```dart
// /// class OrderCreatedEvent implements IDomainEvent {
// ///   @override
// ///   final String id = Uuid().v4();
// ///
// ///   @override
// ///   final DateTime timestamp = DateTime.now();
// ///
// ///   @override
// ///   final String name = 'OrderCreated';
// ///
// ///   @override
// ///   String aggregateId;
// ///
// ///   @override
// ///   String aggregateType = 'Order';
// ///
// ///   @override
// ///   int aggregateVersion = 0;
// ///
// ///   final String customerId;
// ///   final double amount;
// ///
// ///   OrderCreatedEvent({
// ///     required this.customerId,
// ///     required this.amount,
// ///     this.aggregateId = '',
// ///   });
// ///
// ///   @override
// ///   Map<String, dynamic> toJson() {
// ///     return {
// ///       'id': id,
// ///       'timestamp': timestamp.toIso8601String(),
// ///       'name': name,
// ///       'aggregateId': aggregateId,
// ///       'aggregateType': aggregateType,
// ///       'aggregateVersion': aggregateVersion,
// ///       'customerId': customerId,
// ///       'amount': amount,
// ///     };
// ///   }
// ///
// ///   factory OrderCreatedEvent.fromJson(Map<String, dynamic> json) {
// ///     return OrderCreatedEvent(
// ///       customerId: json['customerId'],
// ///       amount: json['amount'],
// ///       aggregateId: json['aggregateId'],
// ///     )
// ///       ..aggregateType = json['aggregateType']
// ///       ..aggregateVersion = json['aggregateVersion'];
// ///   }
// /// }
// /// ```
// abstract class IDomainEvent {
//   /// The unique identifier for this event.
//   String get id;
//
//   /// The timestamp when this event occurred.
//   DateTime get timestamp;
//
//   /// The name of this event.
//   String get name;
//
//   /// The entity that emitted this event.
//   Entity? get entity;
//
//   /// The ID of the aggregate that emitted this event.
//   String get aggregateId;
//
//   /// The type of the aggregate that emitted this event.
//   String get aggregateType;
//
//   /// The version of the aggregate when this event was emitted.
//   int get aggregateVersion;
//
//   /// Sets the ID of the aggregate that emitted this event.
//   set aggregateId(String value);
//
//   /// Sets the type of the aggregate that emitted this event.
//   set aggregateType(String value);
//
//   /// Sets the version of the aggregate when this event was emitted.
//   set aggregateVersion(int value);
//
//   /// Converts this event to a JSON representation.
//   Map<String, dynamic> toJson();
//
//   /// Converts this domain event to the base Event type.
//   ///
//   /// This method provides compatibility with the domain model layer.
//   ///
//   /// Returns:
//   /// An [Event] representation of this domain event
//   Event toBaseEvent();
// }
//
// /// Base implementation of a domain event.
// ///
// /// The [DomainEvent] class provides a standard implementation of [IDomainEvent]:
// /// - Automatically generates a unique identifier
// /// - Records the current timestamp
// /// - Requires a name and optional entity
// /// - Tracks aggregate metadata
// /// - Provides basic JSON serialization
// ///
// /// Example usage:
// /// ```dart
// /// class OrderShippedEvent extends DomainEvent {
// ///   final String trackingNumber;
// ///
// ///   OrderShippedEvent({
// ///     required String orderId,
// ///     required this.trackingNumber,
// ///     Entity? entity,
// ///   }) : super(
// ///          name: 'OrderShipped',
// ///          entity: entity,
// ///          aggregateId: orderId,
// ///          aggregateType: 'Order',
// ///        );
// ///
// ///   @override
// ///   Map<String, dynamic> toJson() {
// ///     final json = super.toJson();
// ///     json.addAll({
// ///       'trackingNumber': trackingNumber,
// ///     });
// ///     return json;
// ///   }
// ///
// ///   factory OrderShippedEvent.fromJson(Map<String, dynamic> json) {
// ///     return OrderShippedEvent(
// ///       orderId: json['aggregateId'],
// ///       trackingNumber: json['trackingNumber'],
// ///     )
// ///       ..aggregateVersion = json['aggregateVersion'];
// ///   }
// /// }
// /// ```
// class DomainEvent implements IDomainEvent {
//   @override
//   final String id;
//
//   @override
//   final DateTime timestamp;
//
//   @override
//   final String name;
//
//   @override
//   final Entity? entity;
//
//   @override
//   String aggregateId;
//
//   @override
//   String aggregateType;
//
//   @override
//   int aggregateVersion;
//
//   /// Creates a new domain event.
//   ///
//   /// Parameters:
//   /// - [name]: The name of the event
//   /// - [entity]: The entity that emitted the event
//   /// - [aggregateId]: The ID of the aggregate (defaults to empty string)
//   /// - [aggregateType]: The type of the aggregate (defaults to empty string)
//   /// - [aggregateVersion]: The version of the aggregate (defaults to 0)
//   /// - [id]: Optional custom identifier (defaults to a UUID)
//   /// - [timestamp]: Optional custom timestamp (defaults to now)
//   DomainEvent({
//     required this.name,
//     this.entity,
//     String? aggregateId,
//     String? aggregateType,
//     int? aggregateVersion,
//     String? id,
//     DateTime? timestamp,
//   })  : id = id ?? Oid().toString(),
//         timestamp = timestamp ?? DateTime.now(),
//         aggregateId = aggregateId ?? '',
//         aggregateType = aggregateType ?? '',
//         aggregateVersion = aggregateVersion ?? 0;
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'timestamp': timestamp.toIso8601String(),
//       'name': name,
//       'entity': entity?.toJson(),
//       'aggregateId': aggregateId,
//       'aggregateType': aggregateType,
//       'aggregateVersion': aggregateVersion,
//     };
//   }
//
//   @override
//   Event toBaseEvent() {
//     final data = <String, String>{};
//     final jsonMap = toJson();
//
//     // Convert all values to strings for the Event
//     jsonMap.forEach((key, value) {
//       if (key != 'entity') { // Skip entity which is handled specially
//         data[key] = value.toString();
//       }
//     });
//
//     return Event(
//       name: name,
//       timestamp: timestamp,
//       id: id,
//       data: data,
//       entityId: entity?.id?.toString(),
//       entityOid: entity?.oid.toString(),
//     );
//   }
// }
//
// /// Creates a domain event from a base Event.
// ///
// /// This function provides a way to convert from the domain model Event
// /// to an application layer DomainEvent.
// ///
// /// Parameters:
// /// - [baseEvent]: The base Event to convert
// /// - [entity]: Optional entity associated with the event
// ///
// /// Returns:
// /// A [DomainEvent] created from the base Event
// IDomainEvent domainEventFromBaseEvent(Event baseEvent, {Entity? entity}) {
//   return DomainEvent(
//     name: baseEvent.name,
//     id: baseEvent.id,
//     timestamp: baseEvent.timestamp,
//     entity: entity,
//     aggregateId: baseEvent.data['aggregateId'] ?? '',
//     aggregateType: baseEvent.data['aggregateType'] ?? '',
//     aggregateVersion: int.tryParse(baseEvent.data['aggregateVersion'] ?? '0') ?? 0,
//   );
// }