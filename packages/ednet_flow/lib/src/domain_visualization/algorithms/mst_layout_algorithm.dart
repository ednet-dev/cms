// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';




/// A layout algorithm that positions nodes using a Minimum Spanning Tree approach.
///
/// This algorithm:
/// - Computes a minimum spanning tree of the graph
/// - Positions nodes to minimize total edge length
/// - Creates a clean, hierarchical visualization with minimal crossings
/// - Works well for tree-like domain models
///
/// Example usage:
/// ```dart
/// final layout = MSTLayoutAlgorithm();
/// layout.layout(nodes, edges, Size(800, 600));
/// ```
class MSTLayoutAlgorithm extends LayoutAlgorithm {
  /// Creates a new MST layout algorithm.
  ///
  /// Parameters:
  /// - [levelSpacing]: Vertical spacing between tree levels
  /// - [siblingSpacing]: Horizontal spacing between sibling nodes
  /// - [subtreeSpacing]: Spacing between separate subtrees
  MSTLayoutAlgorithm({
    this.levelSpacing = 120.0,
    this.siblingSpacing = 100.0,
    this.subtreeSpacing = 50.0,
  });

  /// Vertical spacing between levels in the tree.
  final double levelSpacing;

  /// Horizontal spacing between sibling nodes.
  final double siblingSpacing;

  /// Spacing between separate subtrees.
  final double subtreeSpacing;

  /// Tracks parent-child relationships in the tree
  final Map<String, String> _parent = {};

  /// Stores children for each node in the tree
  final Map<String, List<String>> _children = {};

  /// Stores the depth of each node in the tree
  final Map<String, int> _depth = {};

  /// Stores the horizontal position of each node
  final Map<String, double> _xPosition = {};

  @override
  void layout(List<TreeNode> nodes, List<FlowEdge> edges, Size canvasSize) {
    if (nodes.isEmpty) return;

    // Reset state
    _parent.clear();
    _children.clear();
    _depth.clear();
    _xPosition.clear();

    // Create adjacency list representation of the graph
    final Map<String, List<_WeightedEdge>> adjacency = _buildAdjacencyList(
      nodes,
      edges,
    );

    // Compute the MST starting from the first node
    _computeMST(nodes.first.id, adjacency);

    // Calculate depths for all nodes in the tree
    _calculateDepths(nodes.first.id, 0);

    // Calculate horizontal positions for all nodes
    _calculateHorizontalPositions(nodes);

    // Set final positions for all nodes
    for (final node in nodes) {
      final depth = _depth[node.id] ?? 0;
      final xPos = _xPosition[node.id] ?? 0.0;

      node.position = Offset(xPos, depth * levelSpacing + 50);
    }

    // Update edge positions
    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        edge.updatePositions();
      }
    }
  }

  /// Builds an adjacency list representation of the graph.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes in the graph
  /// - [edges]: The list of edges connecting the nodes
  ///
  /// Returns:
  /// A map where keys are node IDs and values are lists of weighted edges
  Map<String, List<_WeightedEdge>> _buildAdjacencyList(
    List<TreeNode> nodes,
    List<FlowEdge> edges,
  ) {
    final Map<String, List<_WeightedEdge>> adjacency = {};

    // Initialize empty adjacency lists for all nodes
    for (final node in nodes) {
      adjacency[node.id] = [];
    }

    // Add all edges (bidirectional) with weights
    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        final sourceId = edge.source!.id;
        final targetId = edge.target!.id;

        // Use a simple weight based on some property of the edge or a default
        final weight = 1.0;

        // Add edge in both directions (undirected graph)
        adjacency[sourceId]?.add(_WeightedEdge(targetId, weight));
        adjacency[targetId]?.add(_WeightedEdge(sourceId, weight));
      }
    }

    return adjacency;
  }

  /// Computes a Minimum Spanning Tree using Prim's algorithm.
  ///
  /// Parameters:
  /// - [startNodeId]: The ID of the starting node
  /// - [adjacency]: Adjacency list representation of the graph
  void _computeMST(
    String startNodeId,
    Map<String, List<_WeightedEdge>> adjacency,
  ) {
    // Set of nodes already included in the MST
    final Set<String> included = {startNodeId};

    // Priority queue to select the next edge
    final queue = PriorityQueue<_PrimEdge>(
      (a, b) => a.weight.compareTo(b.weight),
    );

    // Add all edges from the start node to the queue
    for (final edge in adjacency[startNodeId] ?? []) {
      queue.add(_PrimEdge(startNodeId, edge.targetId, edge.weight));
    }

    // Process edges until the queue is empty
    while (queue.isNotEmpty && included.length < adjacency.length) {
      final edge = queue.removeFirst();

      // Skip if the target is already in the MST
      if (included.contains(edge.targetId)) continue;

      // Add this edge to the MST
      included.add(edge.targetId);
      _parent[edge.targetId] = edge.sourceId;
      _children.putIfAbsent(edge.sourceId, () => []).add(edge.targetId);

      // Add all edges from the newly included node
      for (final nextEdge in adjacency[edge.targetId] ?? []) {
        if (!included.contains(nextEdge.targetId)) {
          queue.add(
            _PrimEdge(edge.targetId, nextEdge.targetId, nextEdge.weight),
          );
        }
      }
    }
  }

  /// Calculates the depth of each node in the tree.
  ///
  /// Parameters:
  /// - [nodeId]: The ID of the current node
  /// - [depth]: The depth of the current node
  void _calculateDepths(String nodeId, int depth) {
    _depth[nodeId] = depth;

    for (final childId in _children[nodeId] ?? []) {
      _calculateDepths(childId, depth + 1);
    }
  }

  /// Calculates optimal horizontal positions for all nodes.
  ///
  /// Parameters:
  /// - [nodes]: The list of all nodes in the graph
  void _calculateHorizontalPositions(List<TreeNode> nodes) {
    // First pass: calculate preliminary positions
    _calculateInitialXPositions(nodes.first.id, 0);

    // Find the leftmost position
    final minX = _xPosition.values.fold(
      double.infinity,
      (min, x) => min < x ? min : x,
    );

    // Normalize positions (shift all nodes to ensure minX = 0)
    for (final nodeId in _xPosition.keys) {
      _xPosition[nodeId] = _xPosition[nodeId]! - minX;
    }
  }

  /// Recursively calculates initial X positions for nodes in the tree.
  ///
  /// This uses a modified version of the Walker algorithm for positioning nodes.
  ///
  /// Parameters:
  /// - [nodeId]: The ID of the current node
  /// - [depth]: The depth of the current node
  ///
  /// Returns:
  /// The width of the subtree rooted at this node
  double _calculateInitialXPositions(String nodeId, int depth) {
    final children = _children[nodeId] ?? [];

    if (children.isEmpty) {
      // Leaf node
      _xPosition[nodeId] = 0.0;
      return 0.0;
    }

    // Calculate positions for all children first
    double totalWidth = 0.0;
    double totalChildrenWidth = 0.0;

    for (final childId in children) {
      final childWidth = _calculateInitialXPositions(childId, depth + 1);
      _xPosition[childId] = (_xPosition[childId] ?? 0.0) + totalWidth;

      totalWidth += childWidth + siblingSpacing;
      totalChildrenWidth += childWidth;
    }

    // Remove extra spacing after the last child
    if (children.isNotEmpty) {
      totalWidth -= siblingSpacing;
    }

    // Center the parent node above its children
    if (children.isNotEmpty) {
      final leftmostChild = children.first;
      final rightmostChild = children.last;
      final midpoint =
          (_xPosition[leftmostChild]! + _xPosition[rightmostChild]!) / 2;
      _xPosition[nodeId] = midpoint;
    } else {
      _xPosition[nodeId] = 0.0;
    }

    // Make sure subtrees don't overlap by ensuring minimum width
    return max(
      totalChildrenWidth + ((children.length - 1) * siblingSpacing),
      subtreeSpacing,
    );
  }
}

/// Represents a weighted edge in the graph.
class _WeightedEdge {
  final String targetId;
  final double weight;

  _WeightedEdge(this.targetId, this.weight);
}

/// Represents an edge in Prim's algorithm with source, target, and weight.
class _PrimEdge {
  final String sourceId;
  final String targetId;
  final double weight;

  _PrimEdge(this.sourceId, this.targetId, this.weight);
}
