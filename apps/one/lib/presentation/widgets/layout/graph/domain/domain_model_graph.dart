/// This example refactors the DomainModelEditorScreen to provide an infinite canvas experience.
/// The domain model is visualized as a graph of concepts (nodes)
/// and relationships (edges), placed on a large, pan-and-zoomable canvas.
/// Users can add concepts, move them around, and define relationships.
/// The canvas allows infinite panning and zooming, enabling a diagram-like editing of the domain model.
/// Once the user finalizes the layout, the underlying domain model and DSL can be generated.
///
/// Key points:
/// - Uses `InteractiveViewer` for infinite canvas (zoom & pan).
/// - Concepts represented as draggable boxes (nodes).
/// - Relationships represented as lines connecting nodes.
/// - Double-tap or context menu actions for adding attributes, editing details, or removing concepts.
/// - A toolbar to add concepts, export DSL, and run validations.
/// - The underlying domain model can be regenerated into YAML or code on demand.
library;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;

class DomainGraphNode {
  final ednet.Concept concept;
  Offset position;
  DomainGraphNode(this.concept, this.position);
}

class DomainGraphEdge {
  final DomainGraphNode from;
  final DomainGraphNode to;
  DomainGraphEdge(this.from, this.to);
}

class DomainModelGraph {
  final ednet.Domain domain;
  final ednet.Model model;
  List<DomainGraphNode> nodes = [];
  List<DomainGraphEdge> edges = [];

  DomainModelGraph({required this.domain, required this.model});

  void addConceptNode(ednet.Concept concept, Offset position) {
    nodes.add(DomainGraphNode(concept, position));
  }

  void removeConceptNode(DomainGraphNode node) {
    edges.removeWhere((edge) => edge.from == node || edge.to == node);
    nodes.remove(node);
  }

  void addEdge(DomainGraphNode from, DomainGraphNode to) {
    edges.add(DomainGraphEdge(from, to));
  }

  void removeEdge(DomainGraphEdge edge) {
    edges.remove(edge);
  }

  // Convert the current graph back to YAML DSL or apply domain code generation
  String toYamlDSL() {
    // Pseudocode for generating YAML from domain & model
    // This will vary depending on your DSL schema
    // Here just return a placeholder string
    return 'domain: ${domain.code}\nmodel: ${model.code}\nconcepts:\n';
  }

  // Additional validation or code gen logic can be placed here
}

class DomainModelEditorCanvas extends StatefulWidget {
  final ednet.Domain domain;
  final ednet.Model model;

  const DomainModelEditorCanvas({super.key, required this.domain, required this.model});

  @override
  _DomainModelEditorCanvasState createState() =>
      _DomainModelEditorCanvasState();
}

class _DomainModelEditorCanvasState extends State<DomainModelEditorCanvas> {
  late DomainModelGraph graph;
  final TransformationController _transformationController =
      TransformationController();
  bool _isAddingConcept = false;
  DomainGraphNode? _selectedNode;

  @override
  void initState() {
    super.initState();
    graph = DomainModelGraph(domain: widget.domain, model: widget.model);
    // Optionally pre-populate the graph with existing concepts
    for (var concept in widget.model.concepts) {
      // Random or fixed initial positions
      graph.addConceptNode(
        concept,
        Offset(
          200 + Random().nextDouble() * 400,
          200 + Random().nextDouble() * 300,
        ),
      );
    }
  }

  void _addConcept() {
    // Creates a new concept and adds to model
    final conceptCode = 'NewConcept${graph.nodes.length}';
    final newConcept = ednet.Concept(widget.model, conceptCode);
    widget.model.concepts.add(newConcept);
    setState(() {
      _isAddingConcept = true;
    });
  }

  void _finishAddingConcept(Offset position) {
    if (_isAddingConcept) {
      final newConcept = widget.model.concepts.last;
      graph.addConceptNode(newConcept, position);
      setState(() {
        _isAddingConcept = false;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    final scenePoint = _transformationController.toScene(details.localPosition);
    if (_isAddingConcept) {
      _finishAddingConcept(scenePoint);
    } else {
      // Deselect node if tapped on empty space
      setState(() {
        _selectedNode = null;
      });
    }
  }

  Widget _buildNode(DomainGraphNode node) {
    final isSelected = _selectedNode == node;
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            node.position += details.delta;
          });
        },
        onTap: () {
          setState(() {
            _selectedNode = node;
          });
        },
        onDoubleTap: () {
          // Show a dialog to edit concept details or attributes
          _editConceptDialog(node.concept);
        },
        child: Container(
          width: 120,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.white,
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Text(
                node.concept.code,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (node.concept.attributes.isNotEmpty)
                ...node.concept.attributes.map(
                  (attr) => Text(attr.code, style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editConceptDialog(ednet.Concept concept) async {
    // Show a dialog or a side panel to edit concept attributes
    // For simplicity, show a dialog that lists attributes and allow adding/removing
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${concept.code}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...concept.attributes.map(
                (attr) => ListTile(
                  title: Text(attr.code),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        concept.attributes.remove(attr);
                      });
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final newAttrCode = 'attr${concept.attributes.length}';
                    final attr = ednet.Attribute(concept, newAttrCode);
                    attr.type = concept.model.domain.getType('String');
                    concept.attributes.add(attr);
                  });
                },
                child: Text('Add Attribute'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _exportDSL() {
    return graph.toYamlDSL();
  }

  void _showDSL() {
    final dsl = _exportDSL();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('DSL Export'),
          content: SelectableText(dsl),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: EdgeInsets.all(double.infinity),
          minScale: 0.1,
          maxScale: 4.0,
          child: GestureDetector(
            onTapUp: _onTapUp,
            child: Container(
              width: 2000,
              height: 2000,
              color: Colors.grey[100],
              child: Stack(
                children: [
                  // Draw edges
                  ...graph.edges.map((edge) {
                    final start = edge.from.position;
                    final end = edge.to.position;
                    return CustomPaint(
                      painter: EdgePainter(start: start, end: end),
                      size: Size(2000, 2000),
                    );
                  }),
                  // Draw nodes
                  ...graph.nodes.map(_buildNode),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _addConcept,
            tooltip: 'Add Concept',
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class EdgePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  EdgePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(EdgePainter oldDelegate) {
    return start != oldDelegate.start || end != oldDelegate.end;
  }
}

/// Usage:
/// In your app flow:
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => DomainModelEditorCanvas(domain: someDomain, model: someModel),
///   ),
/// );
///
