// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

import 'package:ednet_flow/ednet_flow.dart';

// This file is part of the EDNetFlow library.
// Restored imports for source file organization.





/// Enumeration of edge types in a domain model graph.
///
/// This enum represents different types of relationships between nodes in a graph
/// visualization, corresponding to different domain model relationships.
///
/// This is particularly useful for:
/// - Modeling different types of relationships in domain models
/// - Determining traversal behavior in graph algorithms
/// - Representing various types of associations between entities
///
/// Example usage:
/// ```dart
/// final edge = Edge(
///   id: 'edge-1',
///   source: sourceNode,
///   target: targetNode,
///   type: EdgeType.Directed,  // One-way relationship
/// );
/// ```
enum EdgeType {
  /// Represents a basic association between entities.
  association,

  /// Represents a composition relationship (strong ownership).
  composition,

  /// Represents an aggregation relationship (weak ownership).
  aggregation,

  /// Represents an inheritance relationship.
  inheritance,

  /// Represents an implementation relationship.
  implementation,

  /// Represents a dependency relationship.
  dependency,

  /// Represents a causation relationship (e.g., event causing another event).
  causation,

  /// Represents a trigger relationship (e.g., command triggering an event).
  trigger,

  /// Represents a fulfillment relationship (e.g., policy fulfilling a requirement).
  fulfillment,

  /// Represents a generic relationship with no specific domain meaning.
  generic;

  /// Returns a string representation of the edge type.
  @override
  String toString() => name;

  /// Converts a string to the corresponding edge type.
  ///
  /// Parameters:
  /// - [typeString]: The string representation of the edge type
  ///
  /// Returns:
  /// - The corresponding EdgeType, or EdgeType.generic if not found
  static EdgeType fromString(String typeString) {
    return EdgeType.values.firstWhere(
      (type) => type.toString() == typeString,
      orElse: () => EdgeType.generic,
    );
  }
}
