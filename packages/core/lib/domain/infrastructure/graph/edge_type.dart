part of ednet_core;

/// Defines the type of an edge in a domain model graph.
///
/// This enum specifies the nature of the relationship between connected nodes:
/// - [Directed]: Represents a one-way relationship where the edge has a clear
///   direction from source to target node
/// - [Undirected]: Represents a bidirectional relationship where the edge can be
///   traversed in either direction
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
  /// The edge represents a one-way relationship.
  Directed,

  /// The edge represents a bidirectional relationship.
  Undirected,
}
