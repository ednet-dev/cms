// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

import 'package:ednet_flow/ednet_flow.dart';

/// Graph-based data structures for domain relationships.
///
/// This library provides graph implementations for modeling domain relationships:
/// - Domain model graphs for visualizing model structure
/// - Edge and node types for relationship classification
/// - Graph traversal and manipulation utilities
/// - Domain-specific graph operations
///
/// The graph system supports:
/// - Directed and undirected relationships
/// - Different edge and node types
/// - Graph traversal algorithms
/// - Domain model visualization
///
/// Example usage:
/// ```dart
/// import 'package:ednet_core/domain/infrastructure/graph.dart';
///
/// // Create a domain model graph
/// final graph = DomainModelGraph();
///
/// // Add nodes and edges
/// final sourceNode = Node(id: 'source', type: NodeType.ENTITY);
/// final targetNode = Node(id: 'target', type: NodeType.ENTITY);
/// graph.addEdge(sourceNode, targetNode, EdgeType.RELATIONSHIP);
/// ```
/// Base graph implementation for domain relationships.
///
/// This class provides:
/// - Node and edge management
/// - Graph construction utilities
/// - Basic graph operations
///
/// Example usage:
/// ```dart
/// final graph = Graph();
///
/// // Add nodes
/// final sourceNode = Node(id: 'source');
/// final targetNode = Node(id: 'target');
/// graph.addNode(sourceNode);
/// graph.addNode(targetNode);
///
/// // Add edge
/// graph.addEdge(sourceNode, targetNode);
/// ```
///
/// TODO-WIP: Needs redesign to be state of the art graph implementation integrated as backbone of edneT_flow
class Graph {
  /// Creates a new graph with the given [nodes] and [edges].
  const Graph(this.nodes, this.edges);

  /// The list of nodes in this graph.
  final List<Node> nodes;

  /// The list of edges in this graph.
  final List<Edge> edges;

  /// Adds a node to this graph.
  ///
  /// Parameters:
  /// - [node]: The node to add
  void addNode(Node node) {
    nodes.add(node);
  }

  /// Adds an edge between two nodes.
  ///
  /// Parameters:
  /// - [source]: The source node
  /// - [target]: The target node
  void addEdge(Node source, Node target) {
    edges.add(
      Edge(id: '${source.id}-${target.id}', source: source, target: target),
    );
  }

  /// Builds the graph structure.
  /// This method can be overridden to implement custom graph construction logic.
  void build() {}
}
