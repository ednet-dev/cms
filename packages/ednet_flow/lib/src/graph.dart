// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

part of ednet_flow;



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
