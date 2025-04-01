/// Application layer for the EDNet Core framework.
///
/// This library provides application-level components that coordinate the domain layer:
/// - Application services for orchestrating use cases
/// - Commands for expressing intentions to change the domain
/// - Domain events for recording facts that have occurred
/// - Value objects for encapsulating domain concepts
/// - Aggregate roots for enforcing consistency boundaries
///
/// The application layer is responsible for:
/// - Use case orchestration
/// - Transaction management
/// - Command handling
/// - Event processing
/// - External system integration
///
/// Integration with Domain Model Layer:
/// The application layer extends and enhances the domain model layer (model.*),
/// maintaining compatibility through inheritance and adapter patterns. When using
/// the application layer components, they will integrate seamlessly with the
/// underlying domain model components.
///
/// Example usage:
/// ```dart
/// import 'package:ednet_core/domain/application.dart';
/// 
/// // Use application services
/// final orderService = OrderApplicationService(orderRepository);
/// 
/// // Execute commands
/// final result = await orderService.executeCommand(
///   CreateOrderCommand(customerId: '123', items: []),
/// );
/// 
/// // Process results
/// if (result.isSuccess) {
///   print('Order created successfully');
/// } else {
///   print('Error: ${result.errorMessage}');
/// }
/// ```
library application;

// Domain model imports with aliases to clarify relationships
import 'package:ednet_core/domain/model.dart' as model;
import 'package:ednet_core/domain/model/commands/interfaces/i_command.dart' as commands;
import 'package:ednet_core/domain/model/event/interfaces/i_past.dart';
import 'package:ednet_core/domain/model/event/event.dart';
import 'package:ednet_core/domain/session.dart';

// Export application services
part 'application/application_service/application_service.dart';

// Export command-related components
part 'application/command.dart';
part 'application/command_result.dart';

// Export domain events
part 'application/domain_event.dart';

// Export value objects
part 'application/value_object.dart';

// Export aggregate roots
part 'application/aggregate_root.dart';

// Export authorization capabilities
part 'application/i_authorizable_entity.dart';

/// Utility class that provides conversion methods between application layer
/// and domain model layer components.
///
/// This class helps bridge the gap between the two layers, ensuring seamless
/// integration when components from both layers need to interoperate.
class ApplicationModelIntegration {
  /// Converts application layer commands to domain model commands.
  /// 
  /// This is useful when passing commands from the application layer
  /// to components that expect domain model commands.
  static commands.ICommand toDomainCommand(ICommand command) {
    // If the command already implements the domain model interface, return it
    if (command is commands.ICommand) {
      return command;
    }
    
    // Otherwise, create an adapter
    throw UnimplementedError(
      'Direct conversion from application ICommand to domain ICommand ' +
      'not yet implemented. Use an application command that extends the ' +
      'domain command interface.'
    );
  }
  
  /// Converts domain events from the application layer to model events.
  /// 
  /// This is useful when dealing with event systems that expect model events.
  static List<Event> toDomainEvents(List<IDomainEvent> events) {
    return events.map((e) => Event(
      name: e.name,
      timestamp: e.timestamp,
      id: e.id
    )).toList();
  }
} 