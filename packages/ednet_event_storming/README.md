# EDNet Event Storming

A Dart package for supporting Event Storming in Domain-Driven Design projects, seamlessly integrated with the EDNet Core framework.

## Overview

Event Storming is a collaborative modeling technique that helps teams explore and understand complex business domains. This package provides tools for capturing and working with the artifacts generated during Event Storming sessions, including domain events, commands, aggregates, policies, and more.

## Features

- **Domain Modeling**: Represent all Event Storming artifacts (events, commands, aggregates, etc.) in code
- **Session Management**: Create and manage Event Storming sessions with multiple participants
- **Board Visualization**: Render Event Storming boards in various formats (SVG, HTML)
- **Domain Analysis**: Analyze Event Storming models to identify patterns, issues, and insights
- **Model Export**: Export Event Storming models to EDNet Core models or other formats

## Installation

Add `ednet_event_storming` to your `pubspec.yaml`:

```yaml
dependencies:
  ednet_event_storming: ^0.1.0
```

Then run:

```
dart pub get
```

## Usage

### Creating an Event Storming Session

```dart
import 'package:ednet_event_storming/ednet_event_storming.dart';

// Create a new session
final session = StormingSession.create(
  id: 'session-123',
  name: 'Order Processing Domain',
  description: 'Modeling the order processing flow',
  createdBy: 'team@example.com',
  boardId: 'board-123',
  boardName: 'Order Processing Board',
);

// Add participants
final participant = StormingParticipant(
  id: 'user-123',
  name: 'John Doe',
  email: 'john@example.com',
  role: 'Domain Expert',
  color: '#FF5733',
  joinedAt: DateTime.now(),
);
session = session.addParticipant(participant);
```

### Adding Elements to the Board

```dart
// Add a domain event
final orderPlacedEvent = EventStormingDomainEvent(
  id: 'event-123',
  name: 'OrderPlaced',
  description: 'A customer has placed a new order',
  position: Position(x: 100, y: 100),
  createdBy: 'user-123',
  createdAt: DateTime.now(),
  properties: {
    'orderId': 'String',
    'customerId': 'String',
    'amount': 'Decimal',
  },
);
session = session.updateBoard(
  session.board.addDomainEvent(orderPlacedEvent)
);

// Add an aggregate
final orderAggregate = EventStormingAggregate(
  id: 'aggregate-123',
  name: 'Order',
  description: 'Manages the order lifecycle',
  position: Position(x: 300, y: 100),
  createdBy: 'user-123',
  createdAt: DateTime.now(),
);
session = session.updateBoard(
  session.board.addAggregate(orderAggregate)
);

// Associate event with aggregate
final updatedEvent = orderPlacedEvent.copyWith(
  aggregateId: 'aggregate-123',
);
session = session.updateBoard(
  session.board.updateDomainEvent(updatedEvent)
);
```

### Analyzing the Domain Model

```dart
final analyzer = DomainAnalyzer();
final report = analyzer.analyze(session.board);

// Process analysis results
for (final issue in report.issues) {
  print('Issue: $issue');
}

for (final pattern in report.patterns) {
  print('Pattern: ${pattern.name} (${pattern.strength})');
}

for (final recommendation in report.recommendations) {
  print('Recommendation: $recommendation');
}
```

### Exporting to EDNet Core

```dart
final exporter = ModelExporterFactory.createExporter('ednet_core');
final coreModel = exporter.export(session.board);

// Use the core model
print('Model: ${coreModel.name}');
print('Domains: ${coreModel.domains.length}');
print('Concepts: ${coreModel.domains.first.concepts.length}');
```

## Documentation

For more information, see the [API documentation](https://pub.dev/documentation/ednet_event_storming/latest/).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 