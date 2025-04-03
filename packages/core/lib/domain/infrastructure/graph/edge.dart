// part of ednet_core;
//
// /// Represents an edge in a domain model graph.
// ///
// /// An [Edge] represents a relationship between two nodes in the graph:
// /// - A [source] node where the edge originates
// /// - A [target] node where the edge terminates
// /// - A [type] defining the edge's characteristics
// /// - A [direction] specifying the edge's orientation
// ///
// /// This class extends [EntityIdentity] to provide:
// /// - Unique identification
// /// - Semantic attributes
// /// - Tagging support
// /// - JSON serialization
// ///
// /// Example usage:
// /// ```dart
// /// final sourceNode = Node(id: 'source');
// /// final targetNode = Node(id: 'target');
// ///
// /// final edge = Edge(
// ///   id: 'edge-1',
// ///   source: sourceNode,
// ///   target: targetNode,
// ///   type: EdgeType.Directed,
// ///   direction: EdgeDirection.LeftToRight,
// /// );
// /// ```
// class Edge extends EntityIdentity {
//   /// Creates a new edge with the given parameters.
//   ///
//   /// Parameters:
//   /// - [id]: Unique identifier for the edge
//   /// - [name]: Display name (defaults to 'Edge')
//   /// - [source]: Source node of the edge
//   /// - [target]: Target node of the edge
//   /// - [type]: Type of edge (defaults to Directed)
//   /// - [direction]: Direction of edge (defaults to LeftToRight)
//   /// - [tags]: List of tags for categorization
//   Edge({
//     required this.id,
//     this.name = 'Edge',
//     required this.source,
//     this.tags = const [],
//     required this.target,
//     this.type = EdgeType.Directed,
//     this.direction = EdgeDirection.LeftToRight,
//   });
//
//   /// The source node where this edge originates.
//   final Node source;
//
//   /// The target node where this edge terminates.
//   final Node target;
//
//   /// The type of this edge (e.g., directed, undirected).
//   final EdgeType type;
//
//   /// The direction of this edge (e.g., left-to-right, right-to-left).
//   final EdgeDirection direction;
//
//   /// List of semantic attributes for this edge.
//   @override
//   List<SemanticAttribute> attributes = [];
//
//   /// Description of this edge.
//   @override
//   String description = 'Edge';
//
//   /// Unique identifier for this edge.
//   @override
//   String id;
//
//   /// Display name for this edge.
//   @override
//   String name;
//
//   /// List of tags for categorizing this edge.
//   @override
//   List<String> tags;
//
//   /// Converts this edge to a JSON string.
//   ///
//   /// Returns:
//   /// A JSON string representation of this edge
//   @override
//   String get toJson => throw UnimplementedError();
// }
