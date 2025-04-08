class Graph {
  Map<String, List<String>> adjacencyList = {};

  void addEdge(String u, String v) {
    adjacencyList.putIfAbsent(u, () => []).add(v);
    adjacencyList.putIfAbsent(v, () => []).add(u);
  }

  List<String>? getNeighbors(String u) {
    return adjacencyList[u];
  }
}
