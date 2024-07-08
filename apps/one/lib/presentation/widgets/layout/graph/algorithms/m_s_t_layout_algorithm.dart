import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';

import '../components/edge.dart';
import '../layout/layout_algorithm.dart';

class MSTLayoutAlgorithm extends LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final edges = <Edge>[];

    for (var domain in domains) {
      final domainPosition = Offset(size.width / 2, size.height / 2);
      positions[domain.code] = domainPosition;

      for (var model in domain.models) {
        final modelPosition = Offset(size.width * 0.25, size.height * 0.25);
        positions[model.code] = modelPosition;
        edges.add(Edge(
            domain.code, model.code, _distance(domainPosition, modelPosition)));

        for (var entity in model.concepts) {
          final entityPosition = Offset(size.width * 0.75, size.height * 0.75);
          positions[entity.code] = entityPosition;
          edges.add(Edge(model.code, entity.code,
              _distance(modelPosition, entityPosition)));

          for (var child in entity.children) {
            final childPosition = Offset(size.width * 0.5, size.height * 0.5);
            positions[child.code] = childPosition;
            edges.add(Edge(entity.code, child.code,
                _distance(entityPosition, childPosition)));
          }
        }
      }
    }

    final mst = _kruskalMST(edges, positions);
    return mst;
  }

  double _distance(Offset a, Offset b) {
    return (a - b).distance;
  }

  Map<String, Offset> _kruskalMST(
      List<Edge> edges, Map<String, Offset> positions) {
    edges.sort((a, b) => a.weight.compareTo(b.weight));
    final parent = <String, String>{};
    final rank = <String, int>{};

    String find(String u) {
      if (parent[u] != u) {
        parent[u] = find(parent[u]!);
      }
      return parent[u]!;
    }

    void union(String u, String v) {
      final rootU = find(u);
      final rootV = find(v);
      if (rootU != rootV) {
        if (rank[rootU]! > rank[rootV]!) {
          parent[rootV] = rootU;
        } else if (rank[rootU]! < rank[rootV]!) {
          parent[rootU] = rootV;
        } else {
          parent[rootV] = rootU;
          rank[rootU] = rank[rootU]! + 1;
        }
      }
    }

    for (var key in positions.keys) {
      parent[key] = key;
      rank[key] = 0;
    }

    final mst = <Edge>[];
    for (var edge in edges) {
      if (find(edge.u) != find(edge.v)) {
        mst.add(edge);
        union(edge.u, edge.v);
      }
    }

    final mstPositions = <String, Offset>{};
    for (var edge in mst) {
      mstPositions[edge.u] = positions[edge.u]!;
      mstPositions[edge.v] = positions[edge.v]!;
    }

    return mstPositions;
  }
}
