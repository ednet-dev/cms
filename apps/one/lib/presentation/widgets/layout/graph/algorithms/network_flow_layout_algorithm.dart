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

    for (var domain in domains) {
      positions[domain.code] = Offset(size.width / 2, size.height / 2);
      graph[domain.code] = {};

      for (var model in domain.models) {
        final modelPosition = Offset(size.width * 0.25, size.height * 0.25);
        positions[model.code] = modelPosition;
        graph[domain.code]![model.code] =
            _distance(positions[domain.code]!, modelPosition);

        for (var entity in model.concepts) {
          final entityPosition = Offset(size.width * 0.75, size.height * 0.75);
          positions[entity.code] = entityPosition;
          graph[model.code]![entity.code] =
              _distance(modelPosition, entityPosition);

          for (var child in entity.children) {
            final childPosition = Offset(size.width * 0.5, size.height * 0.5);
            positions[child.code] = childPosition;
            graph[entity.code]![child.code] =
                _distance(entityPosition, childPosition);
          }
        }
      }
    }

    final maxFlow = _edmondsKarp(graph, domains.first.code, domains.last.code);
    // You can use the maxFlow result to adjust positions if needed

    return positions;
  }

  double _distance(Offset a, Offset b) {
    return (a - b).distance;
  }

  double _edmondsKarp(
      Map<String, Map<String, double>> graph, String source, String sink) {
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
}
