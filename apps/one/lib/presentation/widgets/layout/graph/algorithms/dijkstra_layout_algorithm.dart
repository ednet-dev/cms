import 'dart:collection';
import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';

class DijkstraLayoutAlgorithm extends LayoutAlgorithm {
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

    final dijkstraPositions = _dijkstra(graph, domains.first.code, positions);
    return dijkstraPositions;
  }

  double _distance(Offset a, Offset b) {
    return (a - b).distance;
  }

  Map<String, Offset> _dijkstra(Map<String, Map<String, double>> graph,
      String start, Map<String, Offset> positions) {
    final distances = <String, double>{};
    final previous = <String, String?>{};
    final pq = SplayTreeMap<double, List<String>>();

    for (var node in graph.keys) {
      distances[node] = double.infinity;
      previous[node] = null;
      pq.putIfAbsent(double.infinity, () => []).add(node);
    }

    distances[start] = 0;
    pq.putIfAbsent(0, () => []).add(start);

    while (pq.isNotEmpty) {
      final u = pq[pq.firstKey()]!.removeAt(0);
      if (pq[pq.firstKey()]!.isEmpty) {
        pq.remove(pq.firstKey());
      }

      for (var neighbor in graph[u]!.keys) {
        final alt = distances[u]! + graph[u]![neighbor]!;
        if (alt < distances[neighbor]!) {
          pq[distances[neighbor]!]!.remove(neighbor);
          if (pq[distances[neighbor]!]!.isEmpty) {
            pq.remove(distances[neighbor]!);
          }
          distances[neighbor] = alt;
          previous[neighbor] = u;
          pq.putIfAbsent(alt, () => []).add(neighbor);
        }
      }
    }

    final dijkstraPositions = <String, Offset>{};
    for (var node in positions.keys) {
      dijkstraPositions[node] = positions[node]!;
    }

    return dijkstraPositions;
  }
}
