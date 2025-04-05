// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';






/// A layout algorithm that positions nodes in a grid pattern.
///
/// This algorithm:
/// - Arranges nodes in a uniform grid with configurable rows and columns
/// - Maintains consistent spacing between nodes
/// - Supports responsive grid sizing based on the number of nodes
/// - Can be configured for different grid densities and aspects
///
/// Example usage:
/// ```dart
/// final gridLayout = GridLayoutAlgorithm(
///   spacing: 100.0,
///   preferredAspectRatio: 1.5,
/// );
/// gridLayout.layout(nodes, edges, canvasSize);
/// ```
class GridLayoutAlgorithm extends LayoutAlgorithm {
  /// Creates a new grid layout algorithm.
  ///
  /// Parameters:
  /// - [spacing]: Horizontal and vertical spacing between nodes
  /// - [preferredAspectRatio]: The preferred aspect ratio (width/height) of the grid
  GridLayoutAlgorithm({this.spacing = 150.0, this.preferredAspectRatio = 1.6});

  /// The spacing between nodes in the grid.
  final double spacing;

  /// The preferred aspect ratio of the grid (width/height).
  final double preferredAspectRatio;

  @override
  void layout(List<TreeNode> nodes, List<FlowEdge> edges, Size canvasSize) {
    if (nodes.isEmpty) return;

    // Calculate optimal grid dimensions
    final int nodeCount = nodes.length;
    final int columns = _calculateOptimalColumns(nodeCount, canvasSize);
    final int rows = (nodeCount / columns).ceil();

    // Position nodes in a grid
    for (int i = 0; i < nodes.length; i++) {
      final int row = i ~/ columns;
      final int col = i % columns;

      // Calculate position in grid
      final double x = (col * spacing) + spacing;
      final double y = (row * spacing) + spacing;

      // Update node position
      nodes[i].position = Offset(x, y);
    }

    // Update edges after nodes are positioned
    _updateEdgePositions(edges);
  }

  /// Calculates the optimal number of columns for the grid based on the number
  /// of nodes and the canvas size.
  ///
  /// Parameters:
  /// - [nodeCount]: The total number of nodes to lay out
  /// - [canvasSize]: The size of the canvas
  ///
  /// Returns:
  /// The optimal number of columns for the grid
  int _calculateOptimalColumns(int nodeCount, Size canvasSize) {
    // Default calculation based on square root and aspect ratio
    int columns = max(1, sqrt(nodeCount * preferredAspectRatio).round());

    // Adjust based on canvas size if provided
    if (canvasSize.width > 0 && canvasSize.height > 0) {
      // Calculate maximum columns that fit within canvas width
      final int maxCols = max(1, (canvasSize.width / spacing).floor() - 1);

      // Ensure we don't exceed the maximum
      columns = min(columns, maxCols);

      // Ensure there are enough rows to fit all nodes
      final int rows = (nodeCount / columns).ceil();
      final int maxRows = max(1, (canvasSize.height / spacing).floor() - 1);

      // If rows exceed the height, adjust columns accordingly
      if (rows > maxRows && maxRows > 0) {
        columns = max(1, (nodeCount / maxRows).ceil());
      }
    }

    return columns;
  }

  /// Updates the positions of edges based on the current node positions.
  ///
  /// Parameters:
  /// - [edges]: The list of edges to update
  void _updateEdgePositions(List<FlowEdge> edges) {
    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        // Set the edge's position based on its source and target nodes
        edge.updatePositions();
      }
    }
  }
}
