# EDNetFlow

A comprehensive domain visualization and modeling toolkit for Flutter applications, seamlessly integrated with the EDNet Core framework.

## Overview

EDNetFlow (formerly ednet_event_storming) is a powerful toolkit for visualizing and modeling domains in various ways. It encompasses multiple visualization techniques, including EventStorming, domain model graphs, process flows, and interactive model editing. This package provides the foundation for creating rich, interactive domain modeling experiences in Flutter applications.

> **Note:** This package is part of the EDNet monorepo. To use it locally, you may need to use path-based dependencies, as shown in the Installation section below.

## Features

### EventStorming Support
- **Domain Modeling**: Represent all Event Storming artifacts (events, commands, aggregates, etc.) in code
- **Session Management**: Create and manage Event Storming sessions with multiple participants
- **Board Visualization**: Render Event Storming boards in various formats
- **Domain Analysis**: Analyze Event Storming models to identify patterns, issues, and insights
- **Model Export**: Export Event Storming models to EDNet Core models or other formats

### Domain Model Visualization
- **Graph Layouts**: Multiple layout algorithms (Circular, Grid, Dijkstra, Network Flow, etc.)
- **Interactive Canvas**: Pan, zoom, and interact with domain model graphs
- **Custom Painters**: Rich visualization of domain entities and relationships
- **Node/Edge System**: Flexible components for graph visualization

### Process Flow Modeling
- **BPMN-inspired Modeling**: Create business process models with activities, gateways, and flows
- **Process Simulation**: Simulate process execution to validate flows
- **Process Analysis**: Identify bottlenecks and optimization opportunities

### Game-based Visualization
- **Interactive Elements**: Create game-like interactions with domain models
- **Animated Transitions**: Smooth transitions between model states
- **Engaging Experience**: Make domain modeling more engaging and intuitive

## Migration from ednet_event_storming

This package is a rebranding and expansion of the previously named `ednet_event_storming` package. The EventStorming functionality remains at the core, but it's now part of a broader visualization framework. All representational aspects from various packages have been unified under the EDNetFlow umbrella.

### Benefits of the Rebranding

- **Unified Visualization**: All domain visualization techniques in one package
- **Cleaner Architecture**: Follows Single Responsibility Principle by separating visualization from core domain logic
- **Enhanced Features**: More robust implementation with additional visualization techniques
- **Consistent API**: Unified API for all visualization techniques
- **EventStorming as a Board**: EventStorming is now just one type of "board" for domain visualization

### Migration Path

1. Update your dependencies:
   ```yaml
   dependencies:
     # Old dependency
     # ednet_event_storming: ^x.y.z
     
     # New dependency
     ednet_flow: ^0.1.0
   ```

2. Update your imports:
   ```dart
   // Old import
   // import 'package:ednet_event_storming/ednet_event_storming.dart';
   
   // New import
   import 'package:ednet_flow/ednet_flow.dart';
   ```

3. No code changes required - all the classes retain the same names and interfaces.

## Migration from EDNet Core

This package also includes visualization functionality previously in `ednet_core`. The domain model visualization in `ednet_core` is now moved to this package for better separation of concerns.

### Benefits of the Separation

- **Cleaner Architecture**: Separates visualization concerns from core EDNet functionality
- **Enhanced Features**: More robust implementation with additional visualization techniques
- **Improved Integration**: Better integration with visualization libraries
- **Focused Development**: Each package can evolve independently according to its specific needs

## Installation

Add `ednet_flow` to your `pubspec.yaml`:

```yaml
dependencies:
  ednet_flow: ^0.1.0
```

If you're using this package as part of the EDNet monorepo, you might need to use path-based dependencies:

```yaml
dependencies:
  ednet_core:
    path: ../core
  ednet_flow:
    path: ../ednet_flow
```

Then run:

```
flutter pub get
```

## Usage

### EventStorming

```dart
import 'package:ednet_flow/ednet_flow.dart';

// Create a new session
final session = StormingSession.create(
  id: 'session-123',
  name: 'Order Processing Domain',
  description: 'Modeling the order processing flow',
  createdBy: 'team@example.com',
  boardId: 'board-123',
  boardName: 'Order Processing Board',
);

// Add a domain event
final orderPlacedEvent = EventStormingDomainEvent(
  id: 'event-123',
  name: 'OrderPlaced',
  description: 'A customer has placed a new order',
  position: Position(x: 100, y: 100),
  createdBy: 'user-123',
  createdAt: DateTime.now(),
);
```

### Domain Model Visualization

```dart
import 'package:ednet_flow/ednet_flow.dart';
import 'package:flutter/material.dart';

// Create a layout algorithm
final layoutAlgorithm = CircularLayoutAlgorithm();

// Calculate positions for nodes
final positions = layoutAlgorithm.calculateLayout(domains, Size(800, 600));

// Use the positions in your UI
class DomainModelViewer extends StatelessWidget {
  final Map<String, Offset> positions;
  final Domains domains;
  
  const DomainModelViewer({
    required this.positions,
    required this.domains,
  });
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MetaDomainPainter(
        positions: positions,
        domains: domains,
      ),
    );
  }
}
```

### Process Flow Modeling

```dart
import 'package:ednet_flow/ednet_flow.dart';

// Create a process
final process = Process(
  id: 'process-123',
  name: 'Order Fulfillment',
  description: 'End-to-end order fulfillment process',
);

// Add activities to the process
final receiveOrder = Activity(
  id: 'activity-1',
  name: 'Receive Order',
  position: Position(x: 100, y: 100),
);

final processPayment = Activity(
  id: 'activity-2',
  name: 'Process Payment',
  position: Position(x: 250, y: 100),
);

// Connect activities with sequence flows
final flow = SequenceFlow(
  id: 'flow-1',
  source: receiveOrder.id,
  target: processPayment.id,
);

process.activities.addAll([receiveOrder, processPayment]);
process.sequenceFlows.add(flow);
```

## Documentation

For more detailed examples, see the `example` directory in the package source.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 