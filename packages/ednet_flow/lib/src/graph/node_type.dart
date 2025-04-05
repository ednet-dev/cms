// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

import 'package:ednet_flow/ednet_flow.dart';

// This file is part of the EDNetFlow library.
// Restored imports for source file organization.





/// Defines the types of nodes that can exist in a domain model graph.
///
/// This class represents different categories of nodes in the graph:
/// - [Event]: Represents domain events that have occurred
/// - [Command]: Represents actions that can be taken on the domain
/// - [AggregateRoot]: Represents aggregate root entities
/// - [Role]: Represents roles or responsibilities in the domain
///
/// This is particularly useful for:
/// - Categorizing nodes in the domain model
/// - Visualizing different types of domain concepts
/// - Organizing the graph structure
///
/// Example usage:
/// ```dart
/// final node = Node(
///   id: 'order-1',
///   type: NodeType.AggregateRoot,
///   position: Offset(100, 100),
///   size: 40.0,
///   paint: Paint()..color = Colors.blue,
/// );
/// ```
/// Enumeration of node types in a domain model graph.
///
/// This enum represents different types of nodes in a graph visualization,
/// corresponding to different domain model concepts.
enum NodeType {
  /// Represents an entity in the domain model.
  entity,

  /// Represents a value object in the domain model.
  valueObject,

  /// Represents an aggregate root in the domain model.
  aggregateRoot,

  /// Represents a domain event in the domain model.
  domainEvent,

  /// Represents a command in the domain model.
  command,

  /// Represents a policy in the domain model.
  policy,

  /// Represents a service in the domain model.
  service,

  /// Represents an external system interacting with the domain.
  externalSystem,

  /// Represents a read model (projection) in the domain.
  readModel,

  /// Represents a generic node with no specific domain meaning.
  generic;

  /// Returns a string representation of the node type.
  @override
  String toString() => name;

  /// Converts a string to the corresponding node type.
  ///
  /// Parameters:
  /// - [typeString]: The string representation of the node type
  ///
  /// Returns:
  /// - The corresponding NodeType, or NodeType.generic if not found
  static NodeType fromString(String typeString) {
    return NodeType.values.firstWhere(
      (type) => type.toString() == typeString,
      orElse: () => NodeType.generic,
    );
  }
}
