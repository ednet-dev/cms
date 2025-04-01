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