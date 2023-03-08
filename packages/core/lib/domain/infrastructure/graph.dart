library graph;

export 'graph/node.dart';
export 'graph/edge.dart';
export 'graph/edge_type.dart';
export 'graph/edge_direction.dart';
export 'graph/node_type.dart';
export 'graph/domain_model_graph.dart';

// import 'package:ednet_core/ednet_core.dart';
//
// class Graph {
//   const Graph(this.nodes, this.edges);
//
//   final List<Node> nodes;
//   final List<Edge> edges;
//
//   void addNode(Node node) {
//     nodes.add(node);
//   }
//
//   void addEdge(Node source, Node target) {
//     edges.add(
//         Edge(id: '${source.id}-${target.id}', source: source, target: target));
//   }
//
//   void build() {}
// }
