// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';




/// Abstract class for graph layout algorithms.
///
/// This class defines the interface for all graph layout algorithms
/// that can be used to position nodes in a domain model graph.
abstract class LayoutAlgorithm {
  /// Calculates node positions for the given domains.
  ///
  /// Parameters:
  /// - [domains]: The domains to visualize
  /// - [size]: The available size for the layout
  ///
  /// Returns:
  /// A map of node IDs to their calculated positions
  Map<String, Offset> calculateLayout(Domains domains, Size size);

  /// Calculates node positions for a domain model graph.
  ///
  /// This is an alternative method that works with a DomainModel instead of Domains.
  ///
  /// Parameters:
  /// - [model]: The domain model to visualize
  /// - [size]: The available size for the layout
  ///
  /// Returns:
  /// A map of node IDs to their calculated positions
  Map<String, Offset> calculateModelLayout(DomainModel model, Size size);

  /// Positions nodes and edges according to the algorithm's layout logic.
  ///
  /// This method directly updates the position properties of the provided nodes
  /// and updates edge control points based on the new node positions.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to position
  /// - [edges]: The list of edges connecting the nodes
  /// - [canvasSize]: The available size for the layout
  void layout(List<TreeNode> nodes, List<FlowEdge> edges, Size canvasSize);
}
