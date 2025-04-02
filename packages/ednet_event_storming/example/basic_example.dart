import 'package:ednet_event_storming/ednet_event_storming.dart';

void main() {
  // Create a new storming session
  final session = StormingSession.create(
    id: 'session-001',
    name: 'E-Commerce Domain',
    description: 'Modeling the e-commerce domain with Event Storming',
    createdBy: 'facilitator@example.com',
    boardId: 'board-001',
    boardName: 'E-Commerce Board',
  );
  
  print('Created new session: ${session.name}');
  
  // Add participants
  var updatedSession = session.addParticipant(
    StormingParticipant(
      id: 'user-001',
      name: 'Alice',
      email: 'alice@example.com',
      role: 'Domain Expert',
      color: '#FF5733',
      joinedAt: DateTime.now(),
    ),
  );
  
  updatedSession = updatedSession.addParticipant(
    StormingParticipant(
      id: 'user-002',
      name: 'Bob',
      email: 'bob@example.com',
      role: 'Developer',
      color: '#33FF57',
      joinedAt: DateTime.now(),
    ),
  );
  
  print('Added ${updatedSession.participants.length} participants');
  
  // Add elements to the board
  var board = updatedSession.board;
  
  // Add domain events
  final orderPlacedEvent = EventStormingDomainEvent(
    id: 'event-001',
    name: 'OrderPlaced',
    description: 'A customer has placed a new order',
    position: Position(x: 100, y: 100),
    createdBy: 'user-001',
    createdAt: DateTime.now(),
    properties: {
      'orderId': 'String',
      'customerId': 'String',
      'amount': 'Decimal',
    },
  );
  board = board.addDomainEvent(orderPlacedEvent);
  
  final paymentReceivedEvent = EventStormingDomainEvent(
    id: 'event-002',
    name: 'PaymentReceived',
    description: 'Payment has been received for an order',
    position: Position(x: 300, y: 100),
    createdBy: 'user-002',
    createdAt: DateTime.now(),
    properties: {
      'orderId': 'String',
      'amount': 'Decimal',
      'paymentMethod': 'String',
    },
  );
  board = board.addDomainEvent(paymentReceivedEvent);
  
  // Add commands
  final placeOrderCommand = EventStormingCommand(
    id: 'command-001',
    name: 'PlaceOrder',
    description: 'Command to place a new order',
    position: Position(x: 50, y: 100),
    createdBy: 'user-001',
    createdAt: DateTime.now(),
    triggersDomainEventId: 'event-001',
    parameters: {
      'customerId': 'String',
      'items': 'List<OrderItem>',
    },
  );
  board = board.addCommand(placeOrderCommand);
  
  // Add aggregates
  final orderAggregate = EventStormingAggregate(
    id: 'aggregate-001',
    name: 'Order',
    description: 'Manages the order lifecycle',
    position: Position(x: 200, y: 200),
    createdBy: 'user-001',
    createdAt: DateTime.now(),
    domainEventIds: ['event-001', 'event-002'],
    commandIds: ['command-001'],
  );
  board = board.addAggregate(orderAggregate);
  
  // Update events with aggregate
  board = board.updateDomainEvent(
    orderPlacedEvent.copyWith(aggregateId: 'aggregate-001')
  );
  board = board.updateDomainEvent(
    paymentReceivedEvent.copyWith(aggregateId: 'aggregate-001')
  );
  
  // Update session with updated board
  updatedSession = updatedSession.updateBoard(board);
  
  print('Added elements to the board:');
  print('- Domain Events: ${updatedSession.board.domainEvents.length}');
  print('- Commands: ${updatedSession.board.commands.length}');
  print('- Aggregates: ${updatedSession.board.aggregates.length}');
  
  // Analyze the domain model
  final analyzer = DomainAnalyzer();
  final report = analyzer.analyze(updatedSession.board);
  
  print('\nDomain Analysis Results:');
  
  if (report.issues.isEmpty) {
    print('No issues found');
  } else {
    print('Issues:');
    for (final issue in report.issues) {
      print('- $issue');
    }
  }
  
  print('\nIdentified Patterns:');
  if (report.patterns.isEmpty) {
    print('No patterns identified yet');
  } else {
    for (final pattern in report.patterns) {
      print('- ${pattern.name} (${pattern.strength}): ${pattern.description}');
    }
  }
  
  // Export to JSON
  final jsonExporter = ModelExporterFactory.createExporter('json');
  final jsonModel = jsonExporter.export(updatedSession.board);
  
  print('\nJSON Export Example (Domain Name):');
  print('Name: ${jsonModel['name']}');
  print('Aggregates: ${(jsonModel['domain']['aggregates'] as List).length}');
  
  // Render the board
  final renderer = BoardRendererFactory.createRenderer('svg');
  final svgContent = renderer.render(updatedSession.board);
  
  print('\nSVG Rendering Created (first 50 chars):');
  print('${svgContent.substring(0, 50)}...');
  
  print('\nExample completed successfully!');
} 