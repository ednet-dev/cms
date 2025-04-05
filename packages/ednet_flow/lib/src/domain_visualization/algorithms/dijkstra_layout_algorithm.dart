// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';





/// A layout algorithm that positions nodes using Dijkstra's shortest path algorithm.
///
/// This algorithm:
/// - Computes shortest paths between nodes
/// - Positions nodes based on their path distances
/// - Creates a layout where related nodes are closer to each other
/// - Optimizes for minimal edge crossings in the visualization
///
/// Example usage:
/// ```dart
/// final layout = DijkstraLayoutAlgorithm(
///   nodeSpacing: 120.0,
///   levelSpacing: 200.0,
/// );
/// layout.layout(nodes, edges, Size(800, 600));
/// ```
class DijkstraLayoutAlgorithm extends LayoutAlgorithm {
  /// Creates a new Dijkstra-based layout algorithm.
  ///
  /// Parameters:
  /// - [nodeSpacing]: Horizontal spacing between nodes at the same level
  /// - [levelSpacing]: Vertical spacing between levels
  DijkstraLayoutAlgorithm({
    this.nodeSpacing = 150.0,
    this.levelSpacing = 180.0,
  });

  /// The horizontal spacing between nodes.
  final double nodeSpacing;

  /// The vertical spacing between levels.
  final double levelSpacing;

  /// Map to store shortest path distances from the root node
  final Map<String, int> _distances = {};

  /// Map to store the graph as adjacency lists
  final Map<String, List<String>> _graph = {};

  @override
  void layout(List<TreeNode> nodes, List<FlowEdge> edges, Size canvasSize) {
    if (nodes.isEmpty) return;

    // Build the graph from edges
    _buildGraph(nodes, edges);

    // Calculate shortest paths from the first node
    final startNode = nodes.first;
    _calculateShortestPaths(startNode.id);

    // Group nodes by their distance from the start node
    final Map<int, List<TreeNode>> nodesByLevel = {};
    for (final node in nodes) {
      final level = _distances[node.id] ?? 0;
      nodesByLevel.putIfAbsent(level, () => []).add(node);
    }

    // Position nodes by level
    final levels = nodesByLevel.keys.toList()..sort();
    for (final level in levels) {
      final nodesInLevel = nodesByLevel[level]!;
      final levelWidth = (nodesInLevel.length - 1) * nodeSpacing;
      final startX = max(50, (canvasSize.width - levelWidth) / 2);

      // Position nodes in this level
      for (int i = 0; i < nodesInLevel.length; i++) {
        final x = startX + (i * nodeSpacing);
        final y = 50 + (level * levelSpacing);
        nodesInLevel[i].position = Offset(x, y);
      }
    }

    // Update edge positions
    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        edge.updatePositions();
      }
    }
  }

  /// Builds the graph representation from nodes and edges.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes in the graph
  /// - [edges]: The list of edges connecting the nodes
  void _buildGraph(List<TreeNode> nodes, List<FlowEdge> edges) {
    _graph.clear();

    // Initialize empty adjacency lists for all nodes
    for (final node in nodes) {
      _graph[node.id] = [];
    }

    // Add edges to adjacency lists (bidirectional)
    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        final sourceId = edge.source!.id;
        final targetId = edge.target!.id;

        // Add bidirectional connections
        _graph[sourceId]?.add(targetId);
        _graph[targetId]?.add(sourceId);
      }
    }
  }

  /// Calculates shortest paths from a starting node using Dijkstra's algorithm.
  ///
  /// Parameters:
  /// - [startNodeId]: The ID of the node to start from
  void _calculateShortestPaths(String startNodeId) {
    _distances.clear();
    final priorityQueue = PriorityQueue<_NodeDistance>(
      (a, b) => a.distance.compareTo(b.distance),
    );

    // Initialize all distances to infinity except the start node
    _distances[startNodeId] = 0;
    priorityQueue.add(_NodeDistance(startNodeId, 0));

    // Process queue until empty
    while (priorityQueue.isNotEmpty) {
      final current = priorityQueue.removeFirst();
      final nodeId = current.nodeId;
      final distance = current.distance;

      // Skip if we've found a better path already
      if (distance > (_distances[nodeId] ?? double.infinity)) continue;

      // Process all neighbors
      for (final neighborId in _graph[nodeId] ?? []) {
        final newDistance = distance + 1; // Edge weight is 1

        // If we found a better path, update the distance
        if (newDistance < (_distances[neighborId] ?? double.infinity)) {
          _distances[neighborId] = newDistance;
          priorityQueue.add(_NodeDistance(neighborId, newDistance));
        }
      }
    }
  }
}

/// Helper class for Dijkstra priority queue
class _NodeDistance {
  final String nodeId;
  final int distance;

  _NodeDistance(this.nodeId, this.distance);
}
