import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart'
    as header;

import '../../generated/one_application.dart';
import '../widgets/layout/web/header_widget.dart';

/// Graph visualization page for domain models
///
/// This page provides a visual representation of domains, models, and their concepts
/// using an interactive graph view that allows zooming and panning.
class GraphPage extends StatelessWidget {
  /// Route name for this page
  static const String routeName = '/graph';

  /// Creates a graph page
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: const ['Home', 'Graph Visualization'],
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }
          },
          filters: [],
          onAddFilter: (header.FilterCriteria filter) {},
          onBookmark: () {},
        ),
      ),
      body: GraphWidget(),
    );
  }
}

/// Graph widget for visualizing domain models and their relationships
///
/// This widget creates an interactive graph representation of the domain model structure,
/// allowing users to explore the relationships between domains, models, and concepts.
class GraphWidget extends StatelessWidget {
  /// The graph data structure
  final Graph graph = Graph();

  /// Creates a graph widget
  GraphWidget({super.key}) {
    OneApplication app = OneApplication();
    _buildGraph(app.groupedDomains);
  }

  /// Builds the graph structure from domains
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final BuchheimWalkerConfiguration builder =
        BuchheimWalkerConfiguration()
          ..siblingSeparation = (100)
          ..levelSeparation = (150)
          ..subtreeSeparation = (150)
          ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.01,
      maxScale: 5.6,
      child: GraphView(
        graph: graph,
        algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
        builder: (Node node) {
          // Render your node based on the data
          var nodeText = node.key!.value as String;
          return _buildNodeWidget(nodeText, colorScheme);
        },
      ),
    );
  }

  /// Builds a node widget with consistent styling
  Widget _buildNodeWidget(String text, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(50),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(text, style: TextStyle(color: colorScheme.onSurface)),
    );
  }
}
