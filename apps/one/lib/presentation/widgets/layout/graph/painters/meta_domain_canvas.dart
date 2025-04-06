import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import '../algorithms/circular_layout_algorithm.dart';
import '../algorithms/force_directed_layout_algorithm.dart';
import '../algorithms/grid_layout_algorithm.dart';
import '../algorithms/master_detail_layout_algorithm.dart';
import '../algorithms/ranked_embedding_layout_algorithm.dart';
import '../animations/animation_manager.dart';
import '../animations/game_loop.dart';
import '../components/layout_algorithm_icon.dart';
import '../components/system.dart';
import '../decorators/u_x_decorator.dart';
import '../layout/layout_algorithm.dart';
import 'meta_domain_painter.dart';

class MetaDomainCanvas extends StatefulWidget {
  final Domains domains;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;
  final Matrix4? initialTransformation;
  final ValueChanged<Matrix4> onTransformationChanged;
  final ValueChanged<LayoutAlgorithm> onChangeLayoutAlgorithm;

  const MetaDomainCanvas({
    super.key,
    required this.domains,
    required this.layoutAlgorithm,
    required this.decorators,
    this.initialTransformation,
    required this.onTransformationChanged,
    required this.onChangeLayoutAlgorithm,
  });

  @override
  MetaDomainCanvasState createState() => MetaDomainCanvasState();
}

class MetaDomainCanvasState extends State<MetaDomainCanvas> {
  late TransformationController _transformationController;
  late LayoutAlgorithm _currentAlgorithm;
  bool _isDragging = false;
  late GameLoop _gameLoop;
  late System _system;
  late AnimationManager _animationManager;
  double _zoomLevel = 1.0;
  bool _isInitialLoad = true;
  String? _selectedNode;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _currentAlgorithm = widget.layoutAlgorithm;
    _system = System();
    _animationManager = AnimationManager();
    _gameLoop = GameLoop(system: _system, animationManager: _animationManager);
    _gameLoop.start();

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
  }

  void _onInteractionStart(ScaleStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  void _changeLayoutAlgorithm(LayoutAlgorithm algorithm) {
    setState(() {
      _currentAlgorithm = algorithm;
      widget.onChangeLayoutAlgorithm(algorithm);
    });
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

    final layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      canvasSize,
    );
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
        canvasSize.width / (graphWidth + 2 * 400); // Add some padding
    final double scaleY =
        canvasSize.height / (graphHeight + 2 * 400); // Add some padding
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double offsetX =
        (canvasSize.width - graphWidth * scale) / 2 - minX * scale;
    final double offsetY =
        (canvasSize.height - graphHeight * scale) / 2 - minY * scale;

    _transformationController.value =
        Matrix4.identity()
          ..translate(offsetX, offsetY)
          ..scale(scale);

    setState(() {
      _zoomLevel = scale;
    });
  }

  void _onNodeTap(String nodeCode) {
    setState(() {
      _selectedNode = nodeCode;
    });
  }

  void _handleTap(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = _transformationController.toScene(
      renderBox.globalToLocal(details.globalPosition),
    );

    final layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      renderBox.size,
    );

    const double margin = 10.0; // Adjust the margin size as needed

    for (var entry in layoutPositions.entries) {
      final nodeRect = Rect.fromCenter(
        center: entry.value,
        width: 100 + margin * 2,
        height: 50 + margin * 2,
      );
      if (nodeRect.contains(tapPosition)) {
        _onNodeTap(entry.key);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LayoutAlgorithmIcon(
                  icon: Icons.auto_fix_high,
                  name: 'Force Directed',
                  onTap:
                      () => _changeLayoutAlgorithm(
                        ForceDirectedLayoutAlgorithm(),
                      ),
                  isActive: _currentAlgorithm is ForceDirectedLayoutAlgorithm,
                ),
                LayoutAlgorithmIcon(
                  icon: Icons.grid_on,
                  name: 'Grid',
                  onTap: () => _changeLayoutAlgorithm(GridLayoutAlgorithm()),
                  isActive: _currentAlgorithm is GridLayoutAlgorithm,
                ),
                LayoutAlgorithmIcon(
                  icon: Icons.circle,
                  name: 'Circular',
                  onTap:
                      () => _changeLayoutAlgorithm(CircularLayoutAlgorithm()),
                  isActive: _currentAlgorithm is CircularLayoutAlgorithm,
                ),
                LayoutAlgorithmIcon(
                  icon: Icons.format_indent_increase,
                  name: 'Master Detail',
                  onTap:
                      () =>
                          _changeLayoutAlgorithm(MasterDetailLayoutAlgorithm()),
                  isActive: _currentAlgorithm is MasterDetailLayoutAlgorithm,
                ),
                LayoutAlgorithmIcon(
                  icon: Icons.account_tree,
                  name: 'Ranked Tree',
                  onTap:
                      () => _changeLayoutAlgorithm(
                        RankedEmbeddingLayoutAlgorithm(),
                      ),
                  isActive: _currentAlgorithm is RankedEmbeddingLayoutAlgorithm,
                ),
              ],
            ),
            Expanded(
              child: GestureDetector(
                onScaleStart: _onInteractionStart,
                onScaleEnd: _onInteractionEnd,
                onTapUp: _handleTap,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  onInteractionUpdate: (details) {
                    setState(() {
                      _transformationController.value =
                          _transformationController.value
                            ..translate(
                              details.focalPointDelta.dx,
                              details.focalPointDelta.dy,
                            )
                            ..scale(details.scale);
                    });
                  },
                  minScale: 0.1,
                  maxScale: 5.0,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: MetaDomainPainter(
                      domains: widget.domains,
                      transformationController: _transformationController,
                      layoutAlgorithm: _currentAlgorithm,
                      decorators: [],
                      isDragging: _isDragging,
                      system: _system,
                      context: context,
                      selectedNode: _selectedNode,
                      onNodeTap: _onNodeTap,
                    ),
                  ),
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
                child: const Icon(
                  Icons.center_focus_strong,
                  color: Colors.white,
                ),
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

  @override
  void dispose() {
    _gameLoop.stop();
    super.dispose();
  }
}
