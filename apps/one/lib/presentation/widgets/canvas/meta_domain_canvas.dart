import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import '../layout/graph/algorithms/circular_layout_algorithm.dart';
import '../layout/graph/algorithms/force_directed_layout_algorithm.dart';
import '../layout/graph/algorithms/grid_layout_algorithm.dart';
import '../layout/graph/algorithms/master_detail_layout_algorithm.dart';
import '../layout/graph/algorithms/ranked_embedding_layout_algorithm.dart';
import '../layout/graph/animations/animation_manager.dart';
import '../layout/graph/animations/game_loop.dart';
import '../layout/graph/components/layout_algorithm_icon.dart';
import '../layout/graph/components/system.dart';
import '../layout/graph/decorators/u_x_decorator.dart';
import '../layout/graph/layout/layout_algorithm.dart';
import 'interactions/pan_handler.dart';
import 'interactions/selection_handler.dart';
import 'interactions/zoom_handler.dart';
import 'meta_domain_painter.dart';

/// A canvas widget for visualizing domain models.
///
/// This widget handles the rendering and interactions for domain model visualization,
/// allowing users to view, navigate, and interact with domain entities and relationships.
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
  late GameLoop _gameLoop;
  late System _system;
  late AnimationManager _animationManager;
  bool _isInitialLoad = true;
  String? _selectedNode;

  // Interaction handlers
  late PanHandler _panHandler;
  late ZoomHandler _zoomHandler;
  late SelectionHandler _selectionHandler;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _currentAlgorithm = widget.layoutAlgorithm;
    _system = System();
    _animationManager = AnimationManager();
    _gameLoop = GameLoop(system: _system, animationManager: _animationManager);
    _gameLoop.start();

    // Initialize interaction handlers
    _panHandler = PanHandler(
      transformationController: _transformationController,
    );

    _zoomHandler = ZoomHandler(
      transformationController: _transformationController,
      onZoomLevelChanged: (zoom) => setState(() {}),
    );

    _selectionHandler = SelectionHandler(
      transformationController: _transformationController,
      onSelectionChanged:
          (nodeId) => setState(() {
            _selectedNode = nodeId;
          }),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isInitialLoad) {
        if (widget.initialTransformation != null) {
          _transformationController.value = widget.initialTransformation!;
          setState(() {
            _zoomHandler.zoomLevel =
                _transformationController.value.getMaxScaleOnAxis();
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

  void _changeLayoutAlgorithm(LayoutAlgorithm algorithm) {
    setState(() {
      _currentAlgorithm = algorithm;
      widget.onChangeLayoutAlgorithm(algorithm);
    });
  }

  void _centerAndZoom() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size canvasSize = renderBox.size;
    final layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      canvasSize,
    );

    _zoomHandler.centerAndZoom(canvasSize, layoutPositions);
  }

  void _handleTap(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      renderBox.size,
    );

    _selectionHandler.handleTap(details, context, layoutPositions);
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
                onScaleStart: _panHandler.onPanStart,
                onScaleEnd: _panHandler.onPanEnd,
                onTapUp: _handleTap,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  onInteractionUpdate: (details) {
                    // Handle pan and zoom updates
                    _panHandler.onPanUpdate(details);
                    _zoomHandler.onZoomUpdate(details);
                  },
                  minScale: 0.1,
                  maxScale: 5.0,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: MetaDomainPainter(
                      domains: widget.domains,
                      transformationController: _transformationController,
                      layoutAlgorithm: _currentAlgorithm,
                      decorators: widget.decorators,
                      isDragging: _panHandler.isDragging,
                      system: _system,
                      context: context,
                      selectedNode: _selectedNode,
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
                onPressed: () => _zoomHandler.zoom(1.1),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(width: 16.0),
              FloatingActionButton(
                onPressed: () => _zoomHandler.zoom(0.9),
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
                  'Zoom: ${(_zoomHandler.zoomLevel * 100).toInt()}%',
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
    _transformationController.dispose();
    super.dispose();
  }
}
