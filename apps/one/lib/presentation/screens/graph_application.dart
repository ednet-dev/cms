import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../../generated/one_application.dart';
import '../pages/graph_page.dart';

void main() {
  // runApp(GraphApp());
}

/// @deprecated Use GraphPage instead
/// This class is being phased out as part of the screens to pages migration.
/// It will be removed in a future release.
@Deprecated('Use GraphPage instead')
class GraphApp extends StatelessWidget {
  const GraphApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GraphPage instead, keeping the same interface for backward compatibility
    return MaterialApp(home: const GraphPage());
  }
}

/// @deprecated Use GraphWidget from GraphPage instead
/// This class is being phased out as part of the screens to pages migration.
/// It will be removed in a future release.
@Deprecated('Use GraphWidget from GraphPage instead')
class GraphWidget extends StatelessWidget {
  final Graph graph = Graph();

  GraphWidget({super.key}) {
    OneApplication app = OneApplication();
    _buildGraph(app.groupedDomains);
  }

  void _buildGraph(Domains domains) {
    for (var domain in domains) {
      Node domainNode = Node.Id(domain.code);
      graph.addNode(domainNode);

      for (var model in domain.models) {
        Node modelNode = Node.Id(model.code);
        graph.addNode(modelNode);
        graph.addEdge(domainNode, modelNode);

        for (var concept in model.concepts) {
          Node conceptNode = Node.Id(concept.code);
          graph.addNode(conceptNode);
          graph.addEdge(modelNode, conceptNode);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use original implementation for now - will be replaced with GraphPage component in future
    final BuchheimWalkerConfiguration builder =
        BuchheimWalkerConfiguration()
          ..siblingSeparation = (100)
          ..levelSeparation = (150)
          ..subtreeSeparation = (150)
          ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: EdgeInsets.all(100),
      minScale: 0.01,
      maxScale: 5.6,
      child: GraphView(
        graph: graph,
        algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
        builder: (Node node) {
          // Render your node based on the data
          var nodeText = node.key!.value as String;
          return rectangleWidget(nodeText);
        },
      ),
    );
  }

  Widget rectangleWidget(String text) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text),
    );
  }
}
