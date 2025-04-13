// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;






class RankedEmbeddingLayoutAlgorithm extends LayoutAlgorithm {
  /// Creates a new ranked embedding layout algorithm.
  ///
  /// Parameters:
  /// - [rankSpacing]: Vertical spacing between ranks
  /// - [nodeSpacing]: Minimum horizontal spacing between nodes in the same rank
  /// - [iterations]: Number of optimization iterations
  RankedEmbeddingLayoutAlgorithm({
    this.rankSpacing = 120.0,
    this.nodeSpacing = 150.0,
    this.iterations = 30,
  });

  /// Vertical spacing between ranks.
  final double rankSpacing;

  /// Minimum horizontal spacing between nodes in the same rank.
  final double nodeSpacing;

  /// Number of optimization iterations.
  final int iterations;

  /// Map of node IDs to their assigned ranks
  final Map<String, int> _ranks = {};

  /// Map of node IDs to their position indices within their rank
  final Map<String, int> _positions = {};

  @override
  void layout(List<TreeNode> nodes, List<FlowEdge> edges, Size canvasSize) {
    if (nodes.isEmpty) return;

    // Reset state
    _ranks.clear();
    _positions.clear();

    // Step 1: Compute a layered ranking of nodes
    _assignRanks(nodes, edges);

    // Step 2: Assign positions within ranks to minimize crossings
    _assignPositionsWithinRanks(nodes, edges);

    // Step 3: Apply force-directed adjustments within each rank
    _optimizePositions(nodes, edges, iterations);

    // Step 4: Calculate final positions
    _calculateFinalPositions(nodes, canvasSize);

    // Step 5: Update edge positions
    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        edge.updatePositions();
      }
    }
  }

  /// Assigns rank values to nodes based on their connections.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to assign ranks to
  /// - [edges]: The list of edges connecting the nodes
  void _assignRanks(List<TreeNode> nodes, List<FlowEdge> edges) {
    // Build a directed graph representation
    final Map<String, List<String>> outgoing = {};
    final Map<String, List<String>> incoming = {};
    final Map<String, int> inDegree = {};

    for (final node in nodes) {
      outgoing[node.id] = [];
      incoming[node.id] = [];
      inDegree[node.id] = 0;
    }

    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        final sourceId = edge.source!.id;
        final targetId = edge.target!.id;
        outgoing[sourceId]?.add(targetId);
        incoming[targetId]?.add(sourceId);
        inDegree[targetId] = (inDegree[targetId] ?? 0) + 1;
      }
    }

    // Find source nodes (nodes with no incoming edges)
    final queue = <String>[];
    for (final node in nodes) {
      if (inDegree[node.id] == 0) {
        queue.add(node.id);
        _ranks[node.id] = 0; // Assign rank 0 to source nodes
      }
    }

    // If no source nodes found, use the first node
    if (queue.isEmpty && nodes.isNotEmpty) {
      final firstId = nodes.first.id;
      queue.add(firstId);
      _ranks[firstId] = 0;
    }

    // Process the queue (topological sort)
    while (queue.isNotEmpty) {
      final nodeId = queue.removeAt(0);
      final rank = _ranks[nodeId] ?? 0;

      // Process all children
      for (final childId in outgoing[nodeId] ?? []) {
        // Assign rank to child (at least one more than current node)
        final existingRank = _ranks[childId] ?? -1;
        _ranks[childId] = max(existingRank, rank + 1);

        // Reduce in-degree and add to queue if all parents processed
        inDegree[childId] = (inDegree[childId] ?? 0) - 1;
        if (inDegree[childId] == 0) {
          queue.add(childId);
        }
      }
    }

    // Handle any remaining nodes (for cyclic graphs)
    for (final node in nodes) {
      if (!_ranks.containsKey(node.id)) {
        // Find the maximum rank of any predecessor
        int maxPredRank = -1;
        for (final predId in incoming[node.id] ?? []) {
          if (_ranks.containsKey(predId)) {
            maxPredRank = max(maxPredRank, _ranks[predId]!);
          }
        }
        // Assign rank one higher than max predecessor
        _ranks[node.id] = maxPredRank + 1;
      }
    }
  }

  /// Assigns horizontal positions to nodes within their ranks.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to assign positions to
  /// - [edges]: The list of edges connecting the nodes
  void _assignPositionsWithinRanks(List<TreeNode> nodes, List<FlowEdge> edges) {
    // Group nodes by rank
    final Map<int, List<TreeNode>> nodesByRank = {};
    for (final node in nodes) {
      final rank = _ranks[node.id] ?? 0;
      nodesByRank.putIfAbsent(rank, () => []).add(node);
    }

    // Sort ranks
    final ranks = nodesByRank.keys.toList()..sort();

    // Initialize with arbitrary positions
    for (final rank in ranks) {
      final nodesInRank = nodesByRank[rank]!;
      for (int i = 0; i < nodesInRank.length; i++) {
        _positions[nodesInRank[i].id] = i;
      }
    }

    // Apply a median heuristic for ordering nodes within ranks
    for (int iteration = 0; iteration < 3; iteration++) {
      // Process ranks from top to bottom, then bottom to top
      final processOrder = iteration % 2 == 0 ? ranks : ranks.reversed.toList();

      for (final rank in processOrder) {
        final nodesInRank = nodesByRank[rank]!;
        if (nodesInRank.length <= 1) continue;

        // Calculate median positions for each node
        final List<_NodeWithMedian> nodesWithMedians = [];

        for (final node in nodesInRank) {
          // Get connected nodes in adjacent ranks
          final connectedPositions = _getConnectedPositions(node.id, edges);

          _NodeWithMedian nodeWithMedian;
          if (connectedPositions.isEmpty) {
            // Keep current position if no connections
            nodeWithMedian = _NodeWithMedian(node, _positions[node.id] ?? 0);
          } else {
            // Sort positions and take median
            connectedPositions.sort();
            final middleIndex = connectedPositions.length ~/ 2;
            final median =
                connectedPositions.length % 2 == 1
                    ? connectedPositions[middleIndex].toDouble()
                    : (connectedPositions[middleIndex - 1] +
                            connectedPositions[middleIndex]) /
                        2.0;
            nodeWithMedian = _NodeWithMedian(node, median);
          }
          nodesWithMedians.add(nodeWithMedian);
        }

        // Sort nodes by their median values
        nodesWithMedians.sort((a, b) => a.median.compareTo(b.median));

        // Reassign positions based on the sorted order
        for (int i = 0; i < nodesWithMedians.length; i++) {
          _positions[nodesWithMedians[i].node.id] = i;
        }
      }
    }
  }

  /// Gets the positions of nodes connected to the specified node.
  ///
  /// Parameters:
  /// - [nodeId]: The ID of the node to find connections for
  /// - [edges]: The list of edges connecting nodes
  ///
  /// Returns:
  /// List of position indices of connected nodes
  List<int> _getConnectedPositions(String nodeId, List<FlowEdge> edges) {
    final positions = <int>[];

    for (final edge in edges) {
      if (edge.source != null && edge.target != null) {
        if (edge.source!.id == nodeId &&
            _positions.containsKey(edge.target!.id)) {
          positions.add(_positions[edge.target!.id]!);
        } else if (edge.target!.id == nodeId &&
            _positions.containsKey(edge.source!.id)) {
          positions.add(_positions[edge.source!.id]!);
        }
      }
    }

    return positions;
  }

  /// Optimizes node positions using a force-directed approach within ranks.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to optimize
  /// - [edges]: The list of edges connecting the nodes
  /// - [iterations]: Number of optimization iterations to perform
  void _optimizePositions(
    List<TreeNode> nodes,
    List<FlowEdge> edges,
    int iterations,
  ) {
    // Group nodes by rank
    final Map<int, List<TreeNode>> nodesByRank = {};
    for (final node in nodes) {
      final rank = _ranks[node.id] ?? 0;
      nodesByRank.putIfAbsent(rank, () => []).add(node);
    }

    // Apply force-directed adjustments within each rank
    for (int i = 0; i < iterations; i++) {
      bool changed = false;

      for (final rankNodes in nodesByRank.values) {
        if (rankNodes.length <= 1) continue;

        // Calculate repulsive forces between nodes in the same rank
        for (int j = 0; j < rankNodes.length; j++) {
          final node = rankNodes[j];
          final position = _positions[node.id] ?? 0;
          int newPosition = position;

          // Apply repulsive force from neighbors
          for (int k = 0; k < rankNodes.length; k++) {
            if (j == k) continue;

            final neighbor = rankNodes[k];
            final neighborPos = _positions[neighbor.id] ?? 0;

            // Simple repulsive force
            if ((position - neighborPos).abs() < 1) {
              if (position < neighborPos) {
                newPosition = max(0, position - 1);
              } else {
                newPosition = position + 1;
              }
            }
          }

          // Apply attractive force from connected nodes
          final connectedPositions = _getConnectedPositions(node.id, edges);
          if (connectedPositions.isNotEmpty) {
            final avgPos =
                connectedPositions.reduce((a, b) => a + b) /
                connectedPositions.length;
            if ((avgPos - position).abs() > 1) {
              if (avgPos > position) {
                newPosition = position + 1;
              } else {
                newPosition = max(0, position - 1);
              }
            }
          }

          // Update position if changed
          if (newPosition != position) {
            _positions[node.id] = newPosition;
            changed = true;
          }
        }
      }

      // Stop if no changes in this iteration
      if (!changed) break;
    }
  }

  /// Calculates the final positions for all nodes based on their rank and position.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to position
  /// - [canvasSize]: The size of the canvas for layout
  void _calculateFinalPositions(List<TreeNode> nodes, Size canvasSize) {
    // Find maximum position index in each rank
    final Map<int, int> maxPositionByRank = {};
    for (final node in nodes) {
      final rank = _ranks[node.id] ?? 0;
      final position = _positions[node.id] ?? 0;
      maxPositionByRank[rank] = max(maxPositionByRank[rank] ?? 0, position);
    }

    // Calculate vertical position for each rank
    for (final node in nodes) {
      final rank = _ranks[node.id] ?? 0;
      final position = _positions[node.id] ?? 0;
      final maxPosition = maxPositionByRank[rank] ?? 0;

      // Calculate coordinates
      final y = 50.0 + (rank * rankSpacing);

      double x;
      if (maxPosition == 0) {
        // Single node in this rank, center it
        x = canvasSize.width / 2;
      } else {
        // Multiple nodes, spread them evenly
        final totalWidth = maxPosition * nodeSpacing;
        final startX = max(50.0, (canvasSize.width - totalWidth) / 2);
        x = startX + (position * nodeSpacing);
      }

      // Set the node position
      node.position = Offset(x, y);
    }
  }
}

class _NodeWithMedian {
  final TreeNode node;
  final double median;

  _NodeWithMedian(this.node, this.median);
}
