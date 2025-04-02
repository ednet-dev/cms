# EDNet Event Storming

A Dart package for supporting Event Storming in Domain-Driven Design projects, seamlessly integrated with the EDNet Core framework.

## Overview

Event Storming is a collaborative modeling technique that helps teams explore and understand complex business domains. This package provides tools for capturing and working with the artifacts generated during Event Storming sessions, including domain events, commands, aggregates, policies, and more.

> **Note:** This package is part of the EDNet monorepo. To use it locally, you may need to use path-based dependencies, as shown in the Installation section below.

## Features

- **Domain Modeling**: Represent all Event Storming artifacts (events, commands, aggregates, etc.) in code
- **Session Management**: Create and manage Event Storming sessions with multiple participants
- **Board Visualization**: Render Event Storming boards in various formats (SVG, HTML)
- **Domain Analysis**: Analyze Event Storming models to identify patterns, issues, and insights
- **Model Export**: Export Event Storming models to EDNet Core models or other formats
- **Compatibility Layer**: Maintains backward compatibility with `ednet_core` EventStorming classes

## Migration from EDNet Core

This package is the new home for EventStorming functionality, which was previously part of `ednet_core`. The EventStorming code in `ednet_core` is now deprecated and will redirect to this package.

### Benefits of the Dedicated Package

- **Cleaner Architecture**: Separates the EventStorming domain from core EDNet functionality
- **Enhanced Features**: More robust implementation with additional features not in the original
- **Improved Integration**: Better integration with EDNet Core while maintaining independence
- **Backward Compatibility**: Existing code using ES* classes from EDNet Core will continue to work

### Migration Path

1. Update your imports:
   ```dart
   // Old import
   import 'package:ednet_core/domain/eventstorming.dart';
   
   // New import
   import 'package:ednet_event_storming/ednet_event_storming.dart';
   ```

2. Use the new class names (optional, but recommended):
   ```dart
   // Old code
   final event = ESEvent(id: 'evt1', name: 'OrderPlaced');
   
   // New code
   final event = EventStormingDomainEvent(
     id: 'evt1',
     name: 'OrderPlaced',
     position: Position(x: 100, y: 100),
     createdBy: 'user',
     createdAt: DateTime.now(),
   );
   ```

3. For gradual migration, use the adapter:
   ```dart
   // Convert from new to old
   final esEvent = ESAdapter.toESEvent(eventStormingEvent);
   
   // Convert from old to new
   final eventStormingEvent = ESAdapter.fromESEvent(esEvent);
   ```

## Installation

Add `ednet_event_storming` to your `pubspec.yaml`:

```yaml
dependencies:
  ednet_event_storming: ^0.1.0
```

If you're using this package as part of the EDNet monorepo, you might need to use path-based dependencies:

```yaml
dependencies:
  ednet_core:
    path: ../core
  ednet_event_storming:
    path: ../ednet_event_storming
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

## Integration with EDNet Core

This package is designed to work seamlessly with EDNet Core. You can easily convert between EventStorming models and EDNet Core domain models:

```dart
// Convert an aggregate to an EDNet Core concept
final concept = eventStormingAggregate.toCoreAggregateConcept();

// Use the EDNet Core model functionality
concept.attributes.add(
  model.Attribute(
    concept: concept,
    name: 'id',
    code: 'id',
    type: 'String',
  )
);
```

## Documentation

For more detailed examples, see the `example` directory in the package source.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 