import 'dart:math' as math;
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../layout/graph/algorithms/bin_packing.dart';
import '../layout/graph/algorithms/enhanced_quadtree.dart';
import '../layout/graph/algorithms/optimized_force_directed.dart';
import '../layout/graph/animations/animation_manager.dart';
import '../layout/graph/animations/game_loop.dart';
import '../layout/graph/components/system.dart';
import '../layout/graph/decorators/u_x_decorator.dart';
import '../layout/graph/layout/layout_algorithm.dart';
import 'interactions/enhanced_selection_handler.dart';
import 'interactions/pan_handler.dart';
import 'interactions/zoom_handler.dart';

/// A unified visualization canvas for domain model visualization.
///
/// This canvas integrates optimized algorithms for layout, rendering, and interaction,
/// providing a premium user experience for domain modeling.
class UnifiedVisualizationCanvas extends StatefulWidget {
  /// The domain models to visualize
  final Domains domains;

  /// The initial layout algorithm to use
  final LayoutAlgorithm layoutAlgorithm;

  /// Optional decorators for enhanced visualization
  final List<UXDecorator> decorators;

  /// Initial transformation matrix
  final Matrix4? initialTransformation;

  /// Callback when transformation changes
  final ValueChanged<Matrix4> onTransformationChanged;

  /// Callback when layout algorithm changes
  final ValueChanged<LayoutAlgorithm> onChangeLayoutAlgorithm;

  /// Debug mode flag
  final bool debugMode;

  /// Creates a new unified visualization canvas
  const UnifiedVisualizationCanvas({
    super.key,
    required this.domains,
    required this.layoutAlgorithm,
    this.decorators = const [],
    this.initialTransformation,
    required this.onTransformationChanged,
    required this.onChangeLayoutAlgorithm,
    this.debugMode = false,
  });

  @override
  UnifiedVisualizationCanvasState createState() =>
      UnifiedVisualizationCanvasState();
}

class UnifiedVisualizationCanvasState extends State<UnifiedVisualizationCanvas>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late LayoutAlgorithm _currentAlgorithm;
  late GameLoop _gameLoop;
  late System _system;
  late AnimationManager _animationManager;
  late AnimationController _animationController;

  bool _isInitialLoad = true;
  String? _selectedNode;
  String? _hoveredNode;
  bool _isAnimating = false;

  // Visualization state
  late Map<String, Offset> _layoutPositions;
  final Map<String, EntityState> _entityStates = {};

  // Spatial index
  EnhancedQuadtree<String>? _spatialIndex;

  // Cached label positions
  final Map<String, Offset> _labelPositions = {};

  // Performance metrics
  int _lastFrameTime = 0;
  int _frameCount = 0;
  double _fps = 0;

  // Interaction handlers
  late PanHandler _panHandler;
  late ZoomHandler _zoomHandler;
  late EnhancedSelectionHandler _selectionHandler;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _transformationController = TransformationController();
    _currentAlgorithm = widget.layoutAlgorithm;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize rendering system
    _system = System();
    _animationManager = AnimationManager();
    _gameLoop = GameLoop(system: _system, animationManager: _animationManager);
    _gameLoop.start();

    // Calculate initial layout
    _layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      Size(1000, 1000), // Default size, will be updated in layout
    );

    // Initialize interaction handlers
    _panHandler = PanHandler(
      transformationController: _transformationController,
    );

    _zoomHandler = ZoomHandler(
      transformationController: _transformationController,
      onZoomLevelChanged: (zoom) => setState(() {}),
    );

    _selectionHandler = EnhancedSelectionHandler(
      transformationController: _transformationController,
      onSelectionChanged:
          (nodeId) => setState(() {
            _selectedNode = nodeId;
            _triggerSelectionAnimation();
          }),
    );

    // Set animation controller for selection handler
    _selectionHandler.setAnimationController(_animationController);

    // Listen for animation status
    _animationController.addStatusListener(_handleAnimationStatus);

    // Apply initial transformation if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isInitialLoad) {
        if (widget.initialTransformation != null) {
          _transformationController.value = widget.initialTransformation!;
          _zoomHandler.zoomLevel =
              _transformationController.value.getMaxScaleOnAxis();
        } else {
          _centerAndZoom();
        }
        _isInitialLoad = false;
      }
    });

    // Listen for transformation changes
    _transformationController.addListener(() {
      widget.onTransformationChanged(_transformationController.value);
      _updateVisibleNodes();
    });
  }

  @override
  void didUpdateWidget(UnifiedVisualizationCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle changes to domains
    if (widget.domains != oldWidget.domains) {
      _recalculateLayout();
    }

    // Handle changes to layout algorithm
    if (widget.layoutAlgorithm != oldWidget.layoutAlgorithm) {
      _currentAlgorithm = widget.layoutAlgorithm;
      _recalculateLayout();
    }
  }

  /// Recalculates the layout with the current algorithm
  void _recalculateLayout() {
    _layoutPositions = _currentAlgorithm.calculateLayout(
      widget.domains,
      context.size ?? const Size(1000, 1000),
    );
    _updateSpatialIndex();
    _optimizeLabelPositions();
    _updateVisibleNodes();
    setState(() {});
  }

  /// Changes the current layout algorithm
  void _changeLayoutAlgorithm(LayoutAlgorithm algorithm) {
    setState(() {
      _currentAlgorithm = algorithm;
      widget.onChangeLayoutAlgorithm(algorithm);
      _recalculateLayout();
      _animateLayoutTransition();
    });
  }

  /// Centers and zooms the view to fit all entities
  void _centerAndZoom() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size canvasSize = renderBox.size;

    _zoomHandler.centerAndZoom(canvasSize, _layoutPositions);
  }

  /// Updates the spatial index for efficient spatial queries
  void _updateSpatialIndex() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _spatialIndex = EnhancedQuadtree<String>(
      bounds: Rect.fromLTWH(0, 0, size.width, size.height),
      capacity: 4,
    );

    for (var entry in _layoutPositions.entries) {
      _spatialIndex!.insert(entry.key, entry.value);
    }
  }

  /// Updates the entity states for nodes in the visible area
  void _updateVisibleNodes() {
    if (_spatialIndex == null || context.size == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    // Calculate the visible area in scene coordinates
    final topLeft = _transformationController.toScene(Offset.zero);
    final bottomRight = _transformationController.toScene(
      Offset(size.width, size.height),
    );
    final visibleRect = Rect.fromPoints(topLeft, bottomRight);

    // Query nodes in the visible area
    final visibleNodes = <QuadPoint<String>>[];
    _spatialIndex!.queryRect(visibleRect.inflate(100), visibleNodes);

    // Update entity states for visible nodes
    for (var node in visibleNodes) {
      final nodeId = node.data;
      if (!_entityStates.containsKey(nodeId)) {
        _entityStates[nodeId] = EntityState(
          position: node.position,
          visible: true,
          selected: nodeId == _selectedNode,
          hovered: nodeId == _hoveredNode,
        );
      } else {
        _entityStates[nodeId]!.visible = true;
        _entityStates[nodeId]!.position = node.position;
        _entityStates[nodeId]!.selected = nodeId == _selectedNode;
        _entityStates[nodeId]!.hovered = nodeId == _hoveredNode;
      }
    }

    // Mark non-visible nodes
    for (var entry in _entityStates.entries) {
      if (!visibleNodes.any((node) => node.data == entry.key)) {
        entry.value.visible = false;
      }
    }
  }

  /// Optimizes the placement of labels to avoid overlaps
  void _optimizeLabelPositions() {
    if (context.size == null) return;

    final Size canvasSize = context.size!;
    final requests = <LabelPlacementRequest>[];

    // Create label placement requests for entities
    for (var entry in _layoutPositions.entries) {
      requests.add(
        LabelPlacementRequest(
          anchorPoint: entry.value,
          size: const Size(100, 40), // Approximate label size
          priority: _getEntityPriority(entry.key),
        ),
      );
    }

    // Optimize label positions
    final optimizedPositions = BinPacking.optimizeLabelPlacements(
      requests,
      canvasSize,
    );

    // Update label positions
    _labelPositions.clear();
    for (var i = 0; i < requests.length; i++) {
      final nodeId = _layoutPositions.keys.elementAt(i);
      _labelPositions[nodeId] = optimizedPositions[i];
    }
  }

  /// Gets the priority for an entity (influences label placement)
  double _getEntityPriority(String entityId) {
    // Prioritize domains > models > concepts > properties
    if (entityId.startsWith('Domain')) return 3.0;
    if (entityId.startsWith('Model')) return 2.0;
    if (entityId.startsWith('Concept')) return 1.5;
    return 1.0;
  }

  /// Handles tap events on the canvas
  void _handleTap(TapUpDetails details) {
    _selectionHandler.handleTap(details, context, _layoutPositions);
  }

  /// Handles hover events on the canvas
  void _handleHover(PointerHoverEvent event) {
    _selectionHandler.handleHover(event.position, context, _layoutPositions, (
      nodeId,
    ) {
      setState(() => _hoveredNode = nodeId);
    });
  }

  /// Triggers the selection animation
  void _triggerSelectionAnimation() {
    setState(() => _isAnimating = true);
    _animationController.forward(from: 0.0);
  }

  /// Handles animation status changes
  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() => _isAnimating = false);
    }
  }

  /// Animates the transition between layout algorithms
  void _animateLayoutTransition() {
    setState(() => _isAnimating = true);
    _animationController.forward(from: 0.0);
  }

  /// Updates performance metrics
  void _updatePerformanceMetrics() {
    if (!widget.debugMode) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    _frameCount++;

    if (now - _lastFrameTime > 1000) {
      setState(() {
        _fps = _frameCount * 1000 / (now - _lastFrameTime);
        _frameCount = 0;
        _lastFrameTime = now;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update performance metrics
    _updatePerformanceMetrics();

    return Stack(
      children: [
        // Main canvas area
        Expanded(
          child: Listener(
            onPointerHover: _handleHover,
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
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: UnifiedVisualizationPainter(
                        domains: widget.domains,
                        transformationController: _transformationController,
                        layoutPositions: _layoutPositions,
                        entityStates: _entityStates,
                        labelPositions: _labelPositions,
                        selectedNode: _selectedNode,
                        hoveredNode: _hoveredNode,
                        isAnimating: _isAnimating,
                        animationValue: _animationController.value,
                        decorators: widget.decorators,
                        debugMode: widget.debugMode,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Layout control buttons
        Positioned(
          top: 16.0,
          left: 16.0,
          child: LayoutControlPanel(
            currentAlgorithm: _currentAlgorithm,
            onChangeAlgorithm: _changeLayoutAlgorithm,
          ),
        ),

        // Zoom controls
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: ZoomControlPanel(
            zoomLevel: _zoomHandler.zoomLevel,
            onZoomIn: () => _zoomHandler.zoom(1.1),
            onZoomOut: () => _zoomHandler.zoom(0.9),
            onResetView: _centerAndZoom,
          ),
        ),

        // Debug info (if in debug mode)
        if (widget.debugMode)
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'FPS: ${_fps.toStringAsFixed(1)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Nodes: ${_entityStates.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Visible: ${_entityStates.values.where((e) => e.visible).length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _gameLoop.stop();
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

/// Custom painter for the unified visualization canvas.
class UnifiedVisualizationPainter extends CustomPainter {
  final Domains domains;
  final TransformationController transformationController;
  final Map<String, Offset> layoutPositions;
  final Map<String, EntityState> entityStates;
  final Map<String, Offset> labelPositions;
  final String? selectedNode;
  final String? hoveredNode;
  final bool isAnimating;
  final double animationValue;
  final List<UXDecorator> decorators;
  final bool debugMode;

  UnifiedVisualizationPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutPositions,
    required this.entityStates,
    required this.labelPositions,
    this.selectedNode,
    this.hoveredNode,
    this.isAnimating = false,
    this.animationValue = 0.0,
    this.decorators = const [],
    this.debugMode = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Set up paint objects
    final nodeStrokePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final nodeFillPaint = Paint()..style = PaintingStyle.fill;

    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = Colors.grey.withOpacity(0.7);

    final selectedPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..color = Colors.blue;

    final hoveredPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Colors.cyan;

    // Apply decorators first
    for (var decorator in decorators) {
      decorator.render(canvas, size); // Pre-render phase
    }

    // Draw connections between nodes
    _drawConnections(canvas, linePaint);

    // Draw all nodes
    for (var entry in entityStates.entries) {
      final nodeId = entry.key;
      final state = entry.value;

      // Skip non-visible nodes
      if (!state.visible) continue;

      // Get color based on node type
      final color = _getNodeColor(nodeId);
      nodeFillPaint.color = color.withOpacity(0.8);
      nodeStrokePaint.color = color.darker();

      // Draw node
      final nodeRect = _getNodeRect(nodeId, state.position);

      // Apply animation if needed
      if (isAnimating && nodeId == selectedNode) {
        final scale = 1.0 + 0.2 * math.sin(animationValue * math.pi);
        canvas.save();
        canvas.translate(nodeRect.center.dx, nodeRect.center.dy);
        canvas.scale(scale, scale);
        canvas.translate(-nodeRect.center.dx, -nodeRect.center.dy);
      }

      // Draw the node
      canvas.drawRRect(
        RRect.fromRectAndRadius(nodeRect, const Radius.circular(8)),
        nodeFillPaint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(nodeRect, const Radius.circular(8)),
        nodeStrokePaint,
      );

      // Draw selection highlight if needed
      if (nodeId == selectedNode) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            nodeRect.inflate(2),
            const Radius.circular(10),
          ),
          selectedPaint,
        );
      }

      // Draw hover highlight if needed
      if (nodeId == hoveredNode) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            nodeRect.inflate(1),
            const Radius.circular(9),
          ),
          hoveredPaint,
        );
      }

      // Draw label
      _drawLabel(canvas, nodeId, nodeRect);

      // Restore canvas if animated
      if (isAnimating && nodeId == selectedNode) {
        canvas.restore();
      }
    }

    // Apply decorators last
    for (var decorator in decorators) {
      decorator.render(canvas, size); // Post-render phase
    }

    // Draw spatial index bounds if in debug mode
    if (debugMode) {
      _drawSpatialIndexBounds(canvas);
    }
  }

  /// Draws connections between nodes
  void _drawConnections(Canvas canvas, Paint paint) {
    // Draw domain-model connections
    for (var domain in domains) {
      final domainPos = layoutPositions[domain.code];
      if (domainPos == null) continue;

      for (var model in domain.models) {
        final modelPos = layoutPositions[model.code];
        if (modelPos == null) continue;

        _drawConnection(canvas, domainPos, modelPos, paint);

        // Draw model-concept connections
        for (var concept in model.concepts) {
          final conceptPos = layoutPositions[concept.code];
          if (conceptPos == null) continue;

          _drawConnection(canvas, modelPos, conceptPos, paint);

          // Draw concept-child connections
          for (var child in concept.children) {
            final childPos = layoutPositions[child.code];
            if (childPos == null) continue;

            _drawConnection(canvas, conceptPos, childPos, paint);
          }

          // Draw concept-parent connections
          for (var parent in concept.parents) {
            final parentPos = layoutPositions[parent.code];
            if (parentPos == null) continue;

            _drawConnection(canvas, parentPos, conceptPos, paint);
          }
        }
      }
    }
  }

  /// Draws a single connection between nodes
  void _drawConnection(Canvas canvas, Offset start, Offset end, Paint paint) {
    // Calculate control points for a curved line
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    final controlPoint = Offset(
      mid.dx + (end.dy - start.dy) * 0.2,
      mid.dy - (end.dx - start.dx) * 0.2,
    );

    final path =
        Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, end.dx, end.dy);

    canvas.drawPath(path, paint);
  }

  /// Draws a node label
  void _drawLabel(Canvas canvas, String nodeId, Rect nodeRect) {
    final labelPosition = labelPositions[nodeId] ?? nodeRect.topLeft;

    final textSpan = TextSpan(
      text: _formatNodeName(nodeId),
      style: TextStyle(
        color: Colors.black87,
        fontSize: 12,
        fontWeight:
            nodeId == selectedNode ? FontWeight.bold : FontWeight.normal,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: 100);
    textPainter.paint(canvas, labelPosition);
  }

  /// Draws the spatial index bounds (for debugging)
  void _drawSpatialIndexBounds(Canvas canvas) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = Colors.red.withOpacity(0.5);
  }

  /// Gets the color for a node based on its type
  Color _getNodeColor(String nodeId) {
    // Example color scheme based on node type
    if (nodeId.startsWith('Domain')) return Colors.blue[300]!;
    if (nodeId.startsWith('Model')) return Colors.green[300]!;
    if (nodeId.startsWith('Concept')) return Colors.orange[300]!;
    return Colors.grey[300]!;
  }

  /// Gets the rectangle for a node
  Rect _getNodeRect(String nodeId, Offset position) {
    // Size based on node type
    double width = 100;
    double height = 40;

    if (nodeId.startsWith('Domain')) {
      width = 120;
      height = 50;
    } else if (nodeId.startsWith('Model')) {
      width = 100;
      height = 45;
    }

    return Rect.fromCenter(center: position, width: width, height: height);
  }

  /// Formats a node name for display
  String _formatNodeName(String nodeId) {
    return nodeId;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// Represents the state of an entity in the visualization
class EntityState {
  Offset position;
  bool visible;
  bool selected;
  bool hovered;

  EntityState({
    required this.position,
    this.visible = true,
    this.selected = false,
    this.hovered = false,
  });
}

/// Control panel for layout algorithm selection
class LayoutControlPanel extends StatelessWidget {
  final LayoutAlgorithm currentAlgorithm;
  final ValueChanged<LayoutAlgorithm> onChangeAlgorithm;

  const LayoutControlPanel({
    super.key,
    required this.currentAlgorithm,
    required this.onChangeAlgorithm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLayoutButton(
            'Force Directed',
            Icons.auto_fix_high,
            () => onChangeAlgorithm(OptimizedForceDirectedLayout()),
            currentAlgorithm is OptimizedForceDirectedLayout,
          ),
          const SizedBox(width: 8),
          _buildLayoutButton(
            'Grid',
            Icons.grid_on,
            () => onChangeAlgorithm(OptimizedForceDirectedLayout()),
            false,
          ),
          const SizedBox(width: 8),
          _buildLayoutButton(
            'Circular',
            Icons.circle,
            () => onChangeAlgorithm(OptimizedForceDirectedLayout()),
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    bool isActive,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
          onPressed: onPressed,
          tooltip: label,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Control panel for zoom operations
class ZoomControlPanel extends StatelessWidget {
  final double zoomLevel;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetView;

  const ZoomControlPanel({
    super.key,
    required this.zoomLevel,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onZoomIn,
            tooltip: 'Zoom In',
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              '${(zoomLevel * 100).toInt()}%',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: onZoomOut,
            tooltip: 'Zoom Out',
          ),
          const Divider(height: 8),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: onResetView,
            tooltip: 'Reset View',
          ),
        ],
      ),
    );
  }
}

/// Extension method to darken colors
extension ColorExt on Color {
  Color darker([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
