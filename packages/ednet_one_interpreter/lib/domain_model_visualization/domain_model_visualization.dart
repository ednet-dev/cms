import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_flow/ednet_flow.dart';
import 'package:graphview/graphview.dart';

/// A widget that visualizes a domain model using ednet_flow.
///
/// This widget creates a visual representation of a domain model with concepts
/// as nodes and their relationships as edges. It uses the graphview package
/// to layout and render the graph.
class DomainModelVisualization extends StatefulWidget {
  /// The domain containing the model to visualize.
  final Domain domain;

  /// The model to visualize.
  final Model model;

  /// Creates a new domain model visualization.
  const DomainModelVisualization({
    Key? key,
    required this.domain,
    required this.model,
  }) : super(key: key);

  @override
  State<DomainModelVisualization> createState() =>
      _DomainModelVisualizationState();
}

class _DomainModelVisualizationState extends State<DomainModelVisualization> {
  late Graph graph;
  late Algorithm algorithm;
  final Map<String, Node> nodeMap = {};

  @override
  void initState() {
    super.initState();

    // Initialize the graph
    graph = Graph()..isTree = false;
    algorithm = FruchtermanReingoldAlgorithm(iterations: 1000);

    // Build the graph from the model
    _buildGraph();
  }

  @override
  void didUpdateWidget(DomainModelVisualization oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Rebuild the graph if the model or domain changed
    if (oldWidget.model != widget.model || oldWidget.domain != widget.domain) {
      nodeMap.clear();
      graph = Graph()..isTree = false;
      _buildGraph();
    }
  }

  void _buildGraph() {
    // Create nodes for each concept in the model
    for (final concept in widget.model.concepts) {
      final node = Node.Id(concept.code);
      nodeMap[concept.code] = node;
      graph.addNode(node);
    }

    // Create edges for parent-child relationships
    for (final concept in widget.model.concepts) {
      final sourceNode = nodeMap[concept.code];
      if (sourceNode == null) continue;

      // Add edges for child references
      for (final child in concept.children) {
        final childConcept = child.concept;
        if (childConcept == null) continue;

        final targetNode = nodeMap[childConcept.code];
        if (targetNode == null) continue;

        graph.addEdge(
          sourceNode,
          targetNode,
          paint:
              Paint()
                ..color = Colors.green
                ..strokeWidth = 2,
        );
      }

      // Add edges for parent references
      for (final parent in concept.parents) {
        final parentConcept = parent.concept;
        if (parentConcept == null) continue;

        final targetNode = nodeMap[parentConcept.code];
        if (targetNode == null) continue;

        graph.addEdge(
          targetNode,
          sourceNode,
          paint:
              Paint()
                ..color = Colors.blue
                ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.1,
      maxScale: 2.5,
      child: GraphView(
        graph: graph,
        algorithm: algorithm,
        paint:
            Paint()
              ..color = Colors.black
              ..strokeWidth = 1.5
              ..style = PaintingStyle.stroke,
        builder: (Node node) {
          final conceptCode = node.key!.value as String;
          Concept? concept;
          try {
            concept = widget.model.concepts.firstWhere(
              (c) => c.code == conceptCode,
            );
          } catch (_) {
            concept = null;
          }
          final isEntry = concept?.entry ?? false;

          return _buildNodeWidget(conceptCode, isEntry: isEntry);
        },
      ),
    );
  }

  Widget _buildNodeWidget(String name, {bool isEntry = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEntry ? Colors.amber.shade100 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isEntry ? Colors.amber.shade700 : Colors.blue.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isEntry) const Icon(Icons.star, color: Colors.amber, size: 16),
          Text(
            name,
            style: TextStyle(
              fontWeight: isEntry ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
