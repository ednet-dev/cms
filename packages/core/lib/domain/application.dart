// part of ednet_core;
//
// /// Application layer for the EDNet Core framework.
// ///
// /// This library provides application-level components that coordinate the domain layer:
// /// - Application services for orchestrating use cases
// /// - Commands for expressing intentions to change the domain
// /// - Domain events for recording facts that have occurred
// /// - Value objects for encapsulating domain concepts
// /// - Aggregate roots for enforcing consistency boundaries
// /// - Entitlement system for authorization and permissions
// ///
// /// The application layer is responsible for:
// /// - Use case orchestration
// /// - Transaction management
// /// - Command handling
// /// - Query handling (CQRS)
// /// - Event processing
// /// - External system integration
// /// - Authorization and access control
// ///
// /// Integration with Domain Model Layer:
// /// The application layer extends and enhances the domain model layer (model.*),
// /// maintaining compatibility through inheritance and adapter patterns. When using
// /// the application layer components, they will integrate seamlessly with the
// /// underlying domain model components.
// ///
// /// Example usage:
// /// ```dart
// /// import 'package:ednet_core/ednet_core.dart';
// ///
// /// // Use application services
// /// final orderService = OrderApplicationService(orderRepository);
// ///
// /// // Execute commands (write operations)
// /// final result = await orderService.executeCommand(
// ///   CreateOrderCommand(customerId: '123', items: []),
// /// );
// ///
// /// // Execute queries (read operations)
// /// final orders = await orderService.executeQuery(
// ///   FindOrdersByCustomerQuery(customerId: '123'),
// /// );
// ///
// /// // Process results
// /// if (result.isSuccess) {
// ///   print('Order created successfully');
// /// } else {
// ///   print('Error: ${result.errorMessage}');
// /// }
// /// ```
//
// /// Utility class that provides conversion methods between application layer
// /// and domain model layer components.
// ///
// /// This class helps bridge the gap between the two layers, ensuring seamless
// /// integration when components from both layers need to interoperate.
// class ApplicationModelIntegration {
//   /// Converts an application layer command to a domain model command.
//   ///
//   /// Parameters:
//   /// - [command]: The application layer command to convert
//   ///
//   /// Returns:
//   /// A domain model command
//   static commands.ICommand toDomainCommand(ICommand command) {
//     // Create a wrapper command that delegates to the application command
//     return _DomainCommandAdapter(command);
//   }
//
//   /// Converts a domain model command to an application layer command.
//   ///
//   /// Parameters:
//   /// - [command]: The domain model command to convert
//   ///
//   /// Returns:
//   /// An application layer command
//   static ICommand toApplicationCommand(commands.ICommand command) {
//     // Create a wrapper command that delegates to the domain command
//     return _ApplicationCommandAdapter(command);
//   }
//
//   /// Converts application layer queries to domain model queries.
//   ///
//   /// This is useful when passing queries from the application layer
//   /// to components that expect domain model queries.
//   static model.IQuery toDomainQuery(IQuery query) {
//     // If the query already implements the domain model interface, return it
//     if (query is model.IQuery) {
//       return query;
//     }
//
//     // Otherwise, create an adapter
//     throw UnimplementedError(
//       'Direct conversion from application IQuery to domain IQuery ' +
//       'not yet implemented. Use an application query that extends the ' +
//       'domain query interface.'
//     );
//   }
//
//   /// Converts domain events from the application layer to model events.
//   ///
//   /// This is useful when dealing with event systems that expect model events.
//   static List<Event> toDomainEvents(List<IDomainEvent> events) {
//     return events.map((e) => Event(
//       name: e.name,
//       timestamp: e.timestamp,
//       id: e.id
//     )).toList();
//   }
// }
//
// /// Adapter that wraps an application layer command as a domain model command.
// class _DomainCommandAdapter implements commands.ICommand {
//   final ICommand _wrapped;
//
//   _DomainCommandAdapter(this._wrapped);
//
//   @override
//   String get category => _wrapped.category;
//
//   @override
//   String get description => _wrapped.description;
//
//   @override
//   bool get done => _wrapped.done;
//
//   @override
//   Event? get failureEvent => _wrapped.failureEvent;
//
//   @override
//   String get name => _wrapped.name;
//
//   @override
//   bool get redone => _wrapped.redone;
//
//   @override
//   Event? get successEvent => _wrapped.successEvent;
//
//   @override
//   bool get undone => _wrapped.undone;
//
//   @override
//   bool doIt() => _wrapped.doIt();
//
//   @override
//   bool redo() => _wrapped.redo();
//
//   @override
//   bool undo() => _wrapped.undo();
//
//   @override
//   List<Event> getEvents() => _wrapped.getEvents()
//       .map((e) => e.toBaseEvent())
//       .toList();
// }
//
// /// Adapter that wraps a domain model command as an application layer command.
// class _ApplicationCommandAdapter implements ICommand {
//   final commands.ICommand _wrapped;
//
//   _ApplicationCommandAdapter(this._wrapped);
//
//   @override
//   String get category => _wrapped.category;
//
//   @override
//   String get description => _wrapped.description;
//
//   @override
//   bool get done => _wrapped.done;
//
//   @override
//   Event? get failureEvent => _wrapped.failureEvent;
//
//   @override
//   String get id => 'app_${_wrapped.hashCode}';
//
//   @override
//   String get name => _wrapped.name;
//
//   @override
//   bool get redone => _wrapped.redone;
//
//   @override
//   Event? get successEvent => _wrapped.successEvent;
//
//   @override
//   DateTime get timestamp => DateTime.now();
//
//   @override
//   bool get undone => _wrapped.undone;
//
//   @override
//   bool doIt() => _wrapped.doIt();
//
//   @override
//   List<IDomainEvent> getEvents() => _wrapped.getEvents()
//       .map((e) => domainEventFromBaseEvent(e))
//       .toList();
//
//   @override
//   bool redo() => _wrapped.redo();
//
//   @override
//   bool undo() => _wrapped.undo();
//
//   @override
//   bool undoIt() => _wrapped.undo();
// }