part of ednet_core;

/// Defines a policy that can be triggered by domain events
///
/// Event triggered policies allow for reactive behavior in the domain model,
/// responding to events and potentially generating new commands to continue
/// the workflow.
///
/// A common pattern in DDD is:
/// 1. Command is executed on an AggregateRoot
/// 2. AggregateRoot emits Events
/// 3. Events trigger Policies
/// 4. Policies generate Commands
/// 5. Commands are executed on AggregateRoots (cycle continues)
///
/// Example usage:
/// ```dart
/// class OrderShippedNotificationPolicy implements Policy, IEventTriggeredPolicy {
///   @override
///   String get name => 'OrderShippedNotification';
///
///   @override
///   bool evaluate(Entity entity) {
///     // This policy applies to Order entities
///     return entity is Order;
///   }
///
///   @override
///   bool shouldTriggerOnEvent(Event event) {
///     // This policy triggers on the OrderShipped event
///     return event.name == 'OrderShipped';
///   }
///
///   @override
///   void executeActions(Entity entity, Event event) {
///     // Send notification logic
///     print('Notification: Order ${entity.id} has been shipped with tracking ${event.data['trackingNumber']}');
///   }
///
///   @override
///   List<dynamic> generateCommands(Entity entity, Event event) {
///     // Generate command to update shipping status in reporting system
///     return [
///       UpdateShippingStatusCommand(
///         orderId: entity.id,
///         status: 'Shipped',
///         trackingNumber: event.data['trackingNumber'],
///       )
///     ];
///   }
/// }
/// ```
abstract class IEventTriggeredPolicy {
  /// Determines if this policy should trigger in response to the given event
  ///
  /// Parameters:
  /// - [event]: The event to evaluate
  ///
  /// Returns:
  /// True if this policy should be triggered by the event, false otherwise
  bool shouldTriggerOnEvent(dynamic event);

  /// Executes actions when the policy is triggered
  ///
  /// This method contains the core business logic for the policy,
  /// and is executed when an event triggers the policy.
  ///
  /// Parameters:
  /// - [entity]: The entity associated with the event
  /// - [event]: The event that triggered the policy
  void executeActions(dynamic entity, dynamic event);

  /// Generates commands to be executed after the policy is triggered
  ///
  /// This allows policies to trigger additional actions in the system
  /// by generating commands to be executed.
  ///
  /// Parameters:
  /// - [entity]: The entity associated with the event
  /// - [event]: The event that triggered the policy
  ///
  /// Returns:
  /// A list of commands to be executed
  List<dynamic> generateCommands(dynamic entity, dynamic event);
}
