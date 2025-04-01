/// Defines the direction of an edge in a domain model graph.
///
/// This enum specifies how an edge is oriented between its source and target nodes:
/// - [LeftToRight]: The edge flows from left to right, with the source node on the left
///   and the target node on the right
/// - [RightToLeft]: The edge flows from right to left, with the source node on the right
///   and the target node on the left
///
/// This is particularly useful for:
/// - Visualizing relationships in a graph
/// - Determining the layout of connected nodes
/// - Representing directional flows in domain models
///
/// Example usage:
/// ```dart
/// final edge = Edge(
///   id: 'edge-1',
///   source: sourceNode,
///   target: targetNode,
///   direction: EdgeDirection.LeftToRight,
/// );
/// ```
enum EdgeDirection {
  /// The edge flows from left to right.
  LeftToRight,

  /// The edge flows from right to left.
  RightToLeft,
}
