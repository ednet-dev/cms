import 'dart:collection';

import 'graph.dart';

class GraphTraversal {
  final Graph graph;

  GraphTraversal(this.graph);

  List<String> bfs(String start) {
    List<String> visited = [];
    Queue<String> queue = Queue();
    queue.add(start);

    while (queue.isNotEmpty) {
      String node = queue.removeFirst();
      if (!visited.contains(node)) {
        visited.add(node);
        graph.getNeighbors(node)?.forEach((neighbor) {
          if (!visited.contains(neighbor)) {
            queue.add(neighbor);
          }
        });
      }
    }
    return visited;
  }

  List<String> dfs(String start) {
    List<String> visited = [];
    _dfsHelper(start, visited);
    return visited;
  }

  void _dfsHelper(String node, List<String> visited) {
    if (visited.contains(node)) return;
    visited.add(node);
    graph.getNeighbors(node)?.forEach((neighbor) {
      if (!visited.contains(neighbor)) {
        _dfsHelper(neighbor, visited);
      }
    });
  }
}
