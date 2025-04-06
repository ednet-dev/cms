import 'package:flutter/material.dart';

import '../../layout/graph/algorithms/enhanced_quadtree.dart';

/// An enhanced handler for selection gestures on the canvas.
///
/// This class encapsulates the logic for handling selection interactions
/// with nearest-neighbor search for improved user experience.
class EnhancedSelectionHandler {
  String? _selectedNode;
  final TransformationController transformationController;
  final ValueChanged<String?> onSelectionChanged;
  final Duration _selectionAnimationDuration = const Duration(
    milliseconds: 300,
  );
  final Curve _selectionAnimationCurve = Curves.easeInOut;
  final double _hitTestMargin;

  // For animation
  Animation<double>? _selectionAnimation;
  AnimationController? _animationController;

  // Max distance for nearest neighbor search
  final double _maxNeighborDistance;

  EnhancedSelectionHandler({
    required this.transformationController,
    required this.onSelectionChanged,
    String? initialSelection,
    double hitTestMargin = 15.0,
    double maxNeighborDistance = 50.0,
  }) : _selectedNode = initialSelection,
       _hitTestMargin = hitTestMargin,
       _maxNeighborDistance = maxNeighborDistance;

  /// Sets the animation controller for selection animations
  void setAnimationController(AnimationController controller) {
    _animationController = controller;
  }

  /// Handles a tap on the canvas, determining if a node was hit
  /// Uses nearest-neighbor search for improved selection UX
  void handleTap(
    TapUpDetails details,
    BuildContext context,
    Map<String, Offset> layoutPositions,
  ) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = transformationController.toScene(
      renderBox.globalToLocal(details.globalPosition),
    );

    // Build quadtree for efficient spatial lookup
    final quadtree = _buildQuadtree(layoutPositions, renderBox.size);

    // Find the nearest node to tap position
    final nearestNode = quadtree.findNearestNeighbor(
      tapPosition,
      maxDistance: _maxNeighborDistance,
    );

    String? tappedNode;

    if (nearestNode != null) {
      tappedNode = nearestNode.data;

      // Animate selection if we have an animation controller
      if (_animationController != null) {
        _animateSelection(tapPosition, nearestNode.position);
      }
    }

    // Update selection state if a node was hit
    if (tappedNode != null) {
      // Toggle selection if the same node is tapped again
      final newSelection = tappedNode == _selectedNode ? null : tappedNode;

      if (newSelection != _selectedNode) {
        _selectedNode = newSelection;
        onSelectionChanged(_selectedNode);
      }
    }
  }

  /// Builds a quadtree from layout positions for efficient spatial queries
  EnhancedQuadtree<String> _buildQuadtree(
    Map<String, Offset> layoutPositions,
    Size size,
  ) {
    final quadtree = EnhancedQuadtree<String>(
      bounds: Rect.fromLTWH(0, 0, size.width, size.height),
      capacity: 4,
    );

    layoutPositions.forEach((key, position) {
      quadtree.insert(key, position);
    });

    return quadtree;
  }

  /// Animates selection from tap position to node position
  void _animateSelection(Offset tapPosition, Offset nodePosition) {
    if (_animationController == null) return;

    _animationController!.reset();

    _selectionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: _selectionAnimationCurve,
      ),
    );

    _animationController!.duration = _selectionAnimationDuration;
    _animationController!.forward();
  }

  /// Handles hover interactions on nodes
  void handleHover(
    Offset hoverPosition,
    BuildContext context,
    Map<String, Offset> layoutPositions,
    Function(String?) onHover,
  ) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final transformedPosition = transformationController.toScene(
      renderBox.globalToLocal(hoverPosition),
    );

    // Build quadtree for efficient spatial lookup
    final quadtree = _buildQuadtree(layoutPositions, renderBox.size);

    // Find the nearest node to hover position
    final nearestNode = quadtree.findNearestNeighbor(
      transformedPosition,
      maxDistance: _hitTestMargin * 2,
    );

    if (nearestNode != null) {
      onHover(nearestNode.data);
    } else {
      onHover(null);
    }
  }

  /// Handles range selection (when user drags to select multiple nodes)
  void handleRangeSelection(
    Rect selectionRect,
    BuildContext context,
    Map<String, Offset> layoutPositions,
    Function(List<String>) onRangeSelected,
  ) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    // Transform the selection rectangle to scene coordinates
    final transformedRect = Rect.fromPoints(
      transformationController.toScene(
        renderBox.globalToLocal(selectionRect.topLeft),
      ),
      transformationController.toScene(
        renderBox.globalToLocal(selectionRect.bottomRight),
      ),
    );

    // Build quadtree for efficient spatial lookup
    final quadtree = _buildQuadtree(layoutPositions, renderBox.size);

    // Find all nodes within the selection rectangle
    final selectedNodes = <QuadPoint<String>>[];
    quadtree.queryRect(transformedRect, selectedNodes);

    if (selectedNodes.isNotEmpty) {
      onRangeSelected(selectedNodes.map((node) => node.data).toList());
    } else {
      onRangeSelected([]);
    }
  }

  /// Get the currently selected node
  String? get selectedNode => _selectedNode;

  /// Set the selected node
  set selectedNode(String? value) {
    if (value != _selectedNode) {
      _selectedNode = value;
      onSelectionChanged(_selectedNode);
    }
  }

  /// Current selection animation value (0.0 to 1.0)
  double get selectionAnimationValue => _selectionAnimation?.value ?? 0.0;

  /// Whether a selection animation is currently in progress
  bool get isAnimating => _animationController?.isAnimating ?? false;
}
