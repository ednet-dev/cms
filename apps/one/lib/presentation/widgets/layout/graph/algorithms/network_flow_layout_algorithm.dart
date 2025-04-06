import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';

class NetworkFlowLayoutAlgorithm extends LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final graph = <String, Map<String, double>>{};

    // Initial position calculation
    for (var domain in domains) {
      positions[domain.code] = Offset(size.width / 2, size.height / 2);
      graph[domain.code] = {};

      for (var model in domain.models) {
        final modelPosition = Offset(size.width * 0.25, size.height * 0.25);
        positions[model.code] = modelPosition;
        graph[domain.code]![model.code] = _distance(
          positions[domain.code]!,
          modelPosition,
        );

        for (var entity in model.concepts) {
          final entityPosition = Offset(size.width * 0.75, size.height * 0.75);
          positions[entity.code] = entityPosition;
          graph[model.code]![entity.code] = _distance(
            modelPosition,
            entityPosition,
          );

          for (var child in entity.children) {
            final childPosition = Offset(size.width * 0.5, size.height * 0.5);
            positions[child.code] = childPosition;
            graph[entity.code]![child.code] = _distance(
              entityPosition,
              childPosition,
            );
          }
        }
      }
    }

    // Calculate maxFlow for layout optimization
    final maxFlow = _edmondsKarp(graph, domains.first.code, domains.last.code);

    // 1. Scale distances between nodes based on flow
    final scaleFactor = 1.0 + (maxFlow / 1000.0); // Normalize flow value
    _scaleNodeDistances(positions, scaleFactor);

    // 2. Adjust positions to minimize edge crossings
    _minimizeEdgeCrossings(positions, graph);

    // 3. Optimize layout based on flow capacity
    _optimizeLayoutForFlow(positions, graph, maxFlow);

    return positions;
  }

  double _distance(Offset a, Offset b) {
    return (a - b).distance;
  }

  double _edmondsKarp(
    Map<String, Map<String, double>> graph,
    String source,
    String sink,
  ) {
    final residualGraph = <String, Map<String, double>>{};
    for (var u in graph.keys) {
      residualGraph[u] = {};
      for (var v in graph[u]!.keys) {
        residualGraph[u]![v] = graph[u]![v]!;
      }
    }

    final parent = <String?, String?>{};
    double maxFlow = 0;

    bool bfs(String source, String sink) {
      final visited = <String>{};
      final queue = Queue<String>();
      queue.add(source);
      visited.add(source);
      parent[source] = null;

      while (queue.isNotEmpty) {
        final u = queue.removeFirst();
        for (var v in residualGraph[u]!.keys) {
          if (!visited.contains(v) && residualGraph[u]![v]! > 0) {
            queue.add(v);
            visited.add(v);
            parent[v] = u;
            if (v == sink) return true;
          }
        }
      }
      return false;
    }

    while (bfs(source, sink)) {
      double pathFlow = double.infinity;
      for (var v = sink; v != source; v = parent[v]!) {
        final u = parent[v]!;
        pathFlow = min(pathFlow, residualGraph[u]![v]!);
      }

      for (var v = sink; v != source; v = parent[v]!) {
        final u = parent[v]!;
        residualGraph[u]![v] = residualGraph[u]![v]! - pathFlow;
        residualGraph[v]!.putIfAbsent(u, () => 0);
        residualGraph[v]![u] = residualGraph[v]![u]! + pathFlow;
      }

      maxFlow += pathFlow;
    }

    return maxFlow;
  }

  /// Scale the distances between nodes
  void _scaleNodeDistances(Map<String, Offset> positions, double scaleFactor) {
    final center = Offset(0, 0);
    positions.forEach((key, position) {
      // Calculate distance from center and scale it
      final distance = position - center;
      positions[key] = center + (distance * scaleFactor);
    });
  }

  /// Helper method to normalize an Offset vector
  Offset _normalizeOffset(Offset offset) {
    final distance = offset.distance;
    if (distance == 0) return Offset.zero;
    return Offset(offset.dx / distance, offset.dy / distance);
  }

  /// Minimize edge crossings using a simple force-directed approach
  void _minimizeEdgeCrossings(
    Map<String, Offset> positions,
    Map<String, Map<String, double>> graph,
  ) {
    const iterations = 10;
    const repulsionForce = 50.0;

    for (var i = 0; i < iterations; i++) {
      final forces = <String, Offset>{};

      // Initialize forces
      for (var node in positions.keys) {
        forces[node] = Offset.zero;
      }

      // Calculate repulsion forces between all nodes
      for (var node1 in positions.keys) {
        for (var node2 in positions.keys) {
          if (node1 != node2) {
            final delta = positions[node2]! - positions[node1]!;
            final distance = delta.distance;
            if (distance < repulsionForce) {
              final normalizedDelta = _normalizeOffset(delta);
              final force = normalizedDelta * (repulsionForce - distance) / 2;
              forces[node1] = forces[node1]! - force;
              forces[node2] = forces[node2]! + force;
            }
          }
        }
      }

      // Apply forces to update positions
      for (var node in positions.keys) {
        positions[node] = positions[node]! + forces[node]! * 0.1;
      }
    }
  }

  /// Optimize layout based on flow capacity
  void _optimizeLayoutForFlow(
    Map<String, Offset> positions,
    Map<String, Map<String, double>> graph,
    double maxFlow,
  ) {
    // Adjust node positions based on their flow capacity
    graph.forEach((from, edges) {
      edges.forEach((to, capacity) {
        final flowRatio = capacity / maxFlow;
        final idealDistance = 100.0 + (200.0 * flowRatio); // Scale with flow

        final currentDistance = _distance(positions[from]!, positions[to]!);
        final delta = positions[to]! - positions[from]!;
        final adjustment =
            delta * ((idealDistance - currentDistance) / currentDistance);

        // Apply adjustment with weight based on flow ratio
        positions[to] = positions[to]! + (adjustment * flowRatio);
      });
    });
  }
}
