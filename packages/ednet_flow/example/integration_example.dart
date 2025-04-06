import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_flow/ednet_flow.dart';

void main() {
  print('Event Storming Integration Example');
  print('==================================');

  // First, demonstrate the direct use of the new eventstroming package
  useNewEventStormingPackage();

  // Then, demonstrate backward compatibility with EDNet Core eventstroming
  demonstrateBackwardCompatibility();

  // Finally, show integration between the two models
  demonstrateIntegration();
}

void useNewEventStormingPackage() {
  print('\n1. Using the new ednet_flow package directly:');

  // Create a session with a board
  final session = StormingSession.create(
    id: 'session-001',
    name: 'Order Management Domain',
    description: 'Modeling the order management domain',
    createdBy: 'user@example.com',
    boardId: 'board-001',
    boardName: 'Order Management Board',
  );

  // Create a domain event
  final orderPlacedEvent = EventStormingDomainEvent(
    id: 'event-001',
    name: 'OrderPlaced',
    description: 'Indicates that a new order has been placed',
    position: Position(x: 200, y: 100),
    createdBy: 'user@example.com',
    createdAt: DateTime.now(),
    properties: {
      'orderId': 'String',
      'customerId': 'String',
      'totalAmount': 'Decimal',
    },
  );

  // Create a command that leads to this event
  final placeOrderCommand = EventStormingCommand(
    id: 'command-001',
    name: 'PlaceOrder',
    description: 'Command to place a new order',
    position: Position(x: 100, y: 100),
    triggersDomainEventId: 'event-001',
    createdBy: 'user@example.com',
    createdAt: DateTime.now(),
    parameters: {'customerId': 'String', 'items': 'List<OrderItem>'},
  );

  // Create an aggregate that handles the command and produces the event
  final orderAggregate = EventStormingAggregate(
    id: 'aggregate-001',
    name: 'Order',
    description: 'Represents an order in the system',
    position: Position(x: 150, y: 200),
    domainEventIds: ['event-001'],
    commandIds: ['command-001'],
    createdBy: 'user@example.com',
    createdAt: DateTime.now(),
  );

  // Add elements to the board
  var board = session.board;
  board = board.addDomainEvent(orderPlacedEvent);
  board = board.addCommand(placeOrderCommand);
  board = board.addAggregate(orderAggregate);

  // Update the session with the modified board
  final updatedSession = session.updateBoard(board);

  // Print the session details
  print('  Created session: ${updatedSession.name}');
  print('  Board elements:');
  print('    - Events: ${updatedSession.board.domainEvents.length}');
  print('    - Commands: ${updatedSession.board.commands.length}');
  print('    - Aggregates: ${updatedSession.board.aggregates.length}');

  // Convert to EDNet Core model
  final concept = orderAggregate.toCoreAggregateConcept();
  print('  Converted to EDNet Core concept: ${concept.name}');
}

void demonstrateBackwardCompatibility() {
  print('\n2. Using the backward compatibility with EDNet Core:');

  // Create EDNet Core EventStorming elements
  // The ES* classes are still available through the compatibility layer
  final esEvent = ESEvent(
    id: 'es-event-001',
    name: 'PaymentProcessed',
    description: 'Payment for an order has been processed',
  );

  final esCommand = ESCommand(
    id: 'es-command-001',
    name: 'ProcessPayment',
    description: 'Process payment for an order',
  );

  final esAggregate = ESAggregate(
    id: 'es-aggregate-001',
    name: 'Payment',
    description: 'Handles payment processing',
  );

  // Connect them using the original API
  esCommand.triggers(esEvent);
  esAggregate.handles(esCommand);
  esAggregate.produces(esEvent);

  print('  Created EDNet Core elements:');
  print('    - ESEvent: ${esEvent.name}');
  print('    - ESCommand: ${esCommand.name}');
  print('    - ESAggregate: ${esAggregate.name}');
  print('  Connections established:');
  print(
    '    - Command triggers Event: ${esCommand.triggeredEvents.contains(esEvent)}',
  );
  print(
    '    - Aggregate handles Command: ${esAggregate.commands.contains(esCommand)}',
  );
  print(
    '    - Aggregate produces Event: ${esAggregate.events.contains(esEvent)}',
  );
}

void demonstrateIntegration() {
  print('\n3. Integration between EDNet Core and ednet_flow:');

  // Create an element in the new format
  final orderShippedEvent = EventStormingDomainEvent(
    id: 'event-002',
    name: 'OrderShipped',
    description: 'Order has been shipped to the customer',
    position: Position(x: 300, y: 100),
    createdBy: 'user@example.com',
    createdAt: DateTime.now(),
  );

  // Convert to EDNet Core format using the adapter
  final esEvent = ESAdapter.toESEvent(orderShippedEvent);
  print('  Converted new event to ESEvent:');
  print('    - Original event: ${orderShippedEvent.name}');
  print('    - Converted ESEvent: ${esEvent.name}');

  // Now create an EDNet Core element and convert to the new format
  final esPolicy = ESPolicy(
    id: 'es-policy-001',
    name: 'ShippingNotification',
    description: 'Send notification when order is shipped',
  );

  // Convert to new format using the adapter
  final policy = ESAdapter.fromESPolicy(esPolicy);
  print('  Converted ESPolicy to new policy:');
  print('    - Original ESPolicy: ${esPolicy.name}');
  print('    - Converted policy: ${policy.name}');

  // Create an EDNet Core model and convert it
  final esModel = ESModel(
    id: 'model-001',
    name: 'Shipping Model',
    description: 'Model for shipping domain',
  );

  // Add some elements to the model
  esModel.addEvent(esEvent);

  // Create a board to hold these elements
  final board = EventStormingBoard(
    id: 'board-002',
    name: 'Shipping Board',
    description: 'Board for shipping domain',
    createdAt: DateTime.now(),
    createdBy: 'user@example.com',
    domainEvents: {orderShippedEvent.id: orderShippedEvent},
    policies: {policy.id: policy},
  );

  // Analyze the model using the domain analyzer
  final analyzer = DomainAnalyzer();
  final report = analyzer.analyze(board);

  print('  Analysis of integrated model:');
  print('    - Events: ${report.eventInsights.totalCount}');
  print('    - Policies: ${report.policyInsights.totalCount}');
  print('    - Issues found: ${report.issues.length}');

  if (report.issues.isNotEmpty) {
    print('    - First issue: ${report.issues.first}');
  }

  // Export model to different formats
  final jsonExporter = ModelExporterFactory.createExporter('json');
  final jsonOutput = jsonExporter.export(board);

  print('  Exported model to JSON:');
  print('    - Name: ${jsonOutput['name']}');
  print(
    '    - Events count: ${(jsonOutput['domain']['events'] as List).length}',
  );
}
