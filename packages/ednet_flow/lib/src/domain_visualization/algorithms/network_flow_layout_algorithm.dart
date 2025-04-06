// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';




/// A layout algorithm that positions nodes using network flow principles.
///
/// This algorithm:
/// - Treats the graph as a network with source and sink nodes
/// - Computes flow directions through the network
/// - Positions nodes based on their role in the network flow
/// - Creates a visual representation of data flow through a system
///
/// Example usage:
/// ```dart
/// final layout = NetworkFlowLayoutAlgorithm();
/// layout.layout(nodes, edges, Size(800, 600));
/// ```
class NetworkFlowLayoutAlgorithm extends LayoutAlgorithm {
  /// Creates a new network flow layout algorithm.
  ///
  /// Parameters:
  /// - [horizontalSpacing]: Spacing between nodes in the horizontal direction
  /// - [verticalSpacing]: Spacing between layers in the vertical direction
  /// - [maxIterations]: Maximum number of iterations for the layout algorithm
  NetworkFlowLayoutAlgorithm({
    this.horizontalSpacing = 180.0,
    this.verticalSpacing = 150.0,
    this.maxIterations = 50,
  });

  /// The horizontal spacing between nodes.
  final double horizontalSpacing;

  /// The vertical spacing between layers.
  final double verticalSpacing;

  /// Maximum number of iterations for layout optimization.
  final int maxIterations;

  /// Graph adjacency representation
  final Map<String, List<String>> _adjacencyList = {};

  /// Map tracking the assigned layer for each node
  final Map<String, int> _nodeLayers = {};

  /// Map tracking in-degree (number of incoming edges) for each node
  final Map<String, int> _inDegree = {};

  /// Map tracking out-degree (number of outgoing edges) for each node
  final Map<String, int> _outDegree = {};

  @override
  void layout(List<TreeNode> nodes, List<FlowEdge> edges, Size canvasSize) {
    if (nodes.isEmpty) return;

    // Reset all data structures
    _adjacencyList.clear();
    _nodeLayers.clear();
    _inDegree.clear();
    _outDegree.clear();

    // Build graph representation
    _buildGraph(nodes, edges);

    // Assign layers to nodes based on network flow (sources → intermediaries → sinks)
    _assignLayers(nodes);

    // Optimize node positions within layers to minimize edge crossings
    _optimizeNodePositions(nodes, edges);

    // Calculate final positions for each node
    _positionNodes(nodes, canvasSize);

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
    // Initialize adjacency lists and degree counters
    for (final node in nodes) {
      _adjacencyList[node.id] = [];
      _inDegree[node.id] = 0;
      _outDegree[node.id] = 0;
    }

    // Populate adjacency lists and count degrees
    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        final sourceId = edge.source!.id;
        final targetId = edge.target!.id;

        // Add directed edge
        _adjacencyList[sourceId]?.add(targetId);

        // Update degree counters
        _outDegree[sourceId] = (_outDegree[sourceId] ?? 0) + 1;
        _inDegree[targetId] = (_inDegree[targetId] ?? 0) + 1;
      }
    }
  }

  /// Assigns nodes to layers based on their position in the network flow.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to assign to layers
  void _assignLayers(List<TreeNode> nodes) {
    // Create a queue for topological sorting
    final List<String> queue = [];

    // Find source nodes (in-degree = 0) to start with
    for (final node in nodes) {
      if (_inDegree[node.id] == 0) {
        queue.add(node.id);
        _nodeLayers[node.id] = 0; // Layer 0 for source nodes
      }
    }

    // If no source nodes found, just use the first node
    if (queue.isEmpty && nodes.isNotEmpty) {
      queue.add(nodes.first.id);
      _nodeLayers[nodes.first.id] = 0;
    }

    // Process the queue (simplified topological sort)
    while (queue.isNotEmpty) {
      final nodeId = queue.removeAt(0);
      final currentLayer = _nodeLayers[nodeId] ?? 0;

      // Process all adjacent nodes
      for (final adjacentId in _adjacencyList[nodeId] ?? []) {
        // Assign layer to adjacent node (one layer deeper)
        final existingLayer = _nodeLayers[adjacentId] ?? -1;
        _nodeLayers[adjacentId] = max(existingLayer, currentLayer + 1);

        // Reduce in-degree and add to queue if it becomes a new source
        _inDegree[adjacentId] = (_inDegree[adjacentId] ?? 0) - 1;
        if (_inDegree[adjacentId] == 0) {
          queue.add(adjacentId);
        }
      }
    }

    // Handle any remaining nodes (for disconnected or cyclic graphs)
    for (final node in nodes) {
      if (!_nodeLayers.containsKey(node.id)) {
        // Assign a default layer
        _nodeLayers[node.id] = _nodeLayers.values.fold(0, max) + 1;
      }
    }
  }

  /// Optimizes node positions within layers to minimize edge crossings.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to optimize
  /// - [edges]: The list of edges connecting the nodes
  void _optimizeNodePositions(List<TreeNode> nodes, List<FlowEdge> edges) {
    // Group nodes by layer
    final Map<int, List<TreeNode>> nodesByLayer = {};
    for (final node in nodes) {
      final layer = _nodeLayers[node.id] ?? 0;
      nodesByLayer.putIfAbsent(layer, () => []).add(node);
    }

    // Run a simple optimization to minimize edge crossings
    for (int i = 0; i < maxIterations; i++) {
      bool changed = false;

      // For each layer, try to reposition nodes to minimize crossings
      for (final layer in nodesByLayer.keys) {
        final nodesInLayer = nodesByLayer[layer]!;
        if (nodesInLayer.length <= 1) continue;

        // Calculate a basic "barycenter" position for each node
        // based on the positions of connected nodes
        for (int j = 0; j < nodesInLayer.length; j++) {
          final node = nodesInLayer[j];
          final connectedNodes = _getConnectedNodes(node.id, nodes);
          if (connectedNodes.isEmpty) continue;

          // Average position of connected nodes
          final avgPosition =
              connectedNodes.fold(
                0,
                (sum, n) => sum + nodesInLayer.indexOf(n),
              ) /
              connectedNodes.length;
          final currentPosition = j.toDouble();

          // If the node would be better positioned elsewhere, move it
          if ((avgPosition - currentPosition).abs() > 0.5) {
            final newPos = avgPosition.round().clamp(
              0,
              nodesInLayer.length - 1,
            );
            if (newPos != j) {
              // Swap nodes to move toward optimal position
              final temp = nodesInLayer[j];
              nodesInLayer[j] = nodesInLayer[newPos];
              nodesInLayer[newPos] = temp;
              changed = true;
            }
          }
        }
      }

      // Stop if no changes were made in this iteration
      if (!changed) break;
    }
  }

  /// Gets the list of nodes connected to the specified node.
  ///
  /// Parameters:
  /// - [nodeId]: The ID of the node to find connections for
  /// - [nodes]: The complete list of nodes
  ///
  /// Returns:
  /// List of nodes connected to the specified node
  List<TreeNode> _getConnectedNodes(String nodeId, List<TreeNode> nodes) {
    final result = <TreeNode>[];
    final connectedIds = <String>{};

    // Add IDs of nodes this node points to
    connectedIds.addAll(_adjacencyList[nodeId] ?? []);

    // Add IDs of nodes that point to this node
    for (final id in _adjacencyList.keys) {
      if (_adjacencyList[id]?.contains(nodeId) ?? false) {
        connectedIds.add(id);
      }
    }

    // Find the actual node objects
    for (final node in nodes) {
      if (connectedIds.contains(node.id)) {
        result.add(node);
      }
    }

    return result;
  }

  /// Positions nodes based on their assigned layers.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to position
  /// - [canvasSize]: The size of the canvas for layout
  void _positionNodes(List<TreeNode> nodes, Size canvasSize) {
    // Group nodes by layer
    final Map<int, List<TreeNode>> nodesByLayer = {};
    for (final node in nodes) {
      final layer = _nodeLayers[node.id] ?? 0;
      nodesByLayer.putIfAbsent(layer, () => []).add(node);
    }

    // Get the sequence of layers
    final layers = nodesByLayer.keys.toList()..sort();
    final layerCount = layers.length;

    // Position nodes in each layer
    for (final layer in layers) {
      final nodesInLayer = nodesByLayer[layer]!;
      final nodeCount = nodesInLayer.length;

      // Calculate horizontal position for this layer
      final y = verticalSpacing + (layer * verticalSpacing);

      // Calculate width of this layer
      final layerWidth = (nodeCount - 1) * horizontalSpacing;
      final startX = max(50, (canvasSize.width - layerWidth) / 2);

      // Position each node in the layer
      for (int i = 0; i < nodeCount; i++) {
        final x = startX + (i * horizontalSpacing);
        nodesInLayer[i].position = Offset(x, y);
      }
    }
  }
}
