import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../layout/graph_layout.dart';

class MetaDomainCanvas extends StatefulWidget {
  final Domains domains;
  final BuchheimWalkerConfiguration configuration;
  final Matrix4? initialTransformation;
  final ValueChanged<Matrix4> onTransformationChanged;
  final void Function(BuchheimWalkerConfiguration algorithm)
      onChangeLayoutAlgorithm;

  const MetaDomainCanvas({
    Key? key,
    required this.domains,
    required this.configuration,
    this.initialTransformation,
    required this.onTransformationChanged,
    required this.onChangeLayoutAlgorithm,
  }) : super(key: key);

  @override
  _MetaDomainCanvasState createState() => _MetaDomainCanvasState();
}

class _MetaDomainCanvasState extends State<MetaDomainCanvas> {
  late TransformationController _transformationController;
  late BuchheimWalkerAlgorithm _currentAlgorithm;
  double _zoomLevel = 1.0;
  bool _isInitialLoad = true;
  bool _isGraphAcyclic = true;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _currentAlgorithm = BuchheimWalkerAlgorithm(
        widget.configuration, TreeEdgeRenderer(widget.configuration));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isInitialLoad) {
        if (widget.initialTransformation != null) {
          _transformationController.value = widget.initialTransformation!;
          setState(() {
            _zoomLevel = _transformationController.value.getMaxScaleOnAxis();
          });
        } else {
          _centerAndZoom();
        }
        _isInitialLoad = false;
      }
    });

    _transformationController.addListener(() {
      widget.onTransformationChanged(_transformationController.value);
    });

    _checkForCycles();
  }

  void _checkForCycles() {
    final graph = GraphLayout(domains: widget.domains).buildGraph();
    final visited = <Node>{};
    final stack = <Node>{};

    bool hasCycle(Node node) {
      if (stack.contains(node)) return true;
      if (visited.contains(node)) return false;
      visited.add(node);
      stack.add(node);

      for (final neighbor in graph.successorsOf(node)) {
        if (hasCycle(neighbor)) return true;
      }
      stack.remove(node);
      return false;
    }

    for (final node in graph.nodes) {
      if (hasCycle(node)) {
        setState(() {
          _isGraphAcyclic = false;
        });
        return;
      }
    }
  }

  void _zoom(double scaleFactor) {
    setState(() {
      _zoomLevel *= scaleFactor;
      _transformationController.value = Matrix4.identity()..scale(_zoomLevel);
    });
  }

  void _centerAndZoom() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size canvasSize = renderBox.size;

    final layoutPositions =
        GraphLayout(domains: widget.domains).calculateLayout(canvasSize);
    final double minX = layoutPositions.values
        .map((offset) => offset.dx)
        .reduce((a, b) => a < b ? a : b);
    final double maxX = layoutPositions.values
        .map((offset) => offset.dx)
        .reduce((a, b) => a > b ? a : b);
    final double minY = layoutPositions.values
        .map((offset) => offset.dy)
        .reduce((a, b) => a < b ? a : b);
    final double maxY = layoutPositions.values
        .map((offset) => offset.dy)
        .reduce((a, b) => a > b ? a : b);

    final double graphWidth = maxX - minX;
    final double graphHeight = maxY - minY;

    final double scaleX =
        canvasSize.width / (graphWidth + 2 * 100); // Add some padding
    final double scaleY =
        canvasSize.height / (graphHeight + 2 * 100); // Add some padding

    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double offsetX =
        (canvasSize.width - graphWidth * scale) / 2 - minX * scale;
    final double offsetY =
        (canvasSize.height - graphHeight * scale) / 2 - minY * scale;

    _transformationController.value = Matrix4.identity()
      ..translate(offsetX, offsetY)
      ..scale(scale);

    setState(() {
      _zoomLevel = scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isGraphAcyclic) {
      return Center(
        child:
            Text('Error: The graph contains cycles and cannot be displayed.'),
      );
    }

    final graph = GraphLayout(domains: widget.domains).buildGraph();
    final builder = _currentAlgorithm;

    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.auto_fix_high),
                  onPressed: () => widget
                      .onChangeLayoutAlgorithm(BuchheimWalkerConfiguration()),
                ),
                IconButton(
                  icon: Icon(Icons.grid_on),
                  onPressed: () => widget
                      .onChangeLayoutAlgorithm(BuchheimWalkerConfiguration()),
                ),
                IconButton(
                  icon: Icon(Icons.circle),
                  onPressed: () => widget
                      .onChangeLayoutAlgorithm(BuchheimWalkerConfiguration()),
                ),
                IconButton(
                  icon: Icon(Icons.format_indent_increase),
                  onPressed: () => widget
                      .onChangeLayoutAlgorithm(BuchheimWalkerConfiguration()),
                ),
              ],
            ),
            Expanded(
              child: InteractiveViewer(
                transformationController: _transformationController,
                onInteractionUpdate: (details) {
                  setState(() {
                    _transformationController.value =
                        _transformationController.value
                          ..translate(details.focalPointDelta.dx,
                              details.focalPointDelta.dy)
                          ..scale(details.scale);
                  });
                },
                minScale: 0.1,
                maxScale: 5.0,
                child: GraphView(
                  graph: graph,
                  algorithm: builder,
                  builder: (Node node) {
                    final id = node.key?.value;
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.blue,
                      child: Text('$id', style: TextStyle(color: Colors.white)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Row(
            children: [
              FloatingActionButton(
                onPressed: () => _zoom(1.1),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(width: 16.0),
              FloatingActionButton(
                onPressed: () => _zoom(0.9),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.remove, color: Colors.white),
              ),
              const SizedBox(width: 16.0),
              FloatingActionButton(
                onPressed: _centerAndZoom,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child:
                    const Icon(Icons.center_focus_strong, color: Colors.white),
              ),
              const SizedBox(width: 16.0),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Zoom: ${(_zoomLevel * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
