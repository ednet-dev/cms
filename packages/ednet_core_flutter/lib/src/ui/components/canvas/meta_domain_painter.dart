part of ednet_core_flutter;

/// A custom painter for rendering domain models on a canvas.
///
/// This painter coordinates the rendering of domain models using the
/// visualization system, applying layout algorithms and visual decorations.
///
/// This is part of the EDNet Shell Architecture visualization system.
class MetaDomainPainter extends CustomPainter {
  /// The domain model to visualize
  final Domains domains;

  /// Controller for interactive transformations
  final TransformationController transformationController;

  /// The layout algorithm for positioning
  final LayoutAlgorithm layoutAlgorithm;

  /// Visual decorators to apply
  final List<UXDecorator> decorators;

  /// Whether user is currently dragging
  final bool isDragging;

  /// The visualization system for nodes and rendering
  final VisualizationSystem visualizationSystem;

  /// Current build context (for theming)
  final BuildContext context;

  /// ID of the selected node
  final String? selectedNode;

  /// Construct a domain model painter
  MetaDomainPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutAlgorithm,
    required this.decorators,
    required this.isDragging,
    required this.visualizationSystem,
    required this.context,
    this.selectedNode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Apply decorators before rendering
    final decoratedCanvas = _applyDecorators(canvas, size);

    // Render the visualization using the visualization system
    visualizationSystem.render(decoratedCanvas);
    visualizationSystem.renderText(decoratedCanvas);
  }

  /// Apply all decorators to the canvas
  Canvas _applyDecorators(Canvas canvas, Size size) {
    Canvas resultCanvas = canvas;

    // Apply each decorator in sequence
    for (final decorator in decorators) {
      resultCanvas = decorator.decorate(resultCanvas, size);
    }

    return resultCanvas;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Always repaint if the delegate changed
    if (oldDelegate is! MetaDomainPainter) return true;

    final oldPainter = oldDelegate as MetaDomainPainter;

    // Repaint if any core property changed
    return oldPainter.isDragging != isDragging ||
        oldPainter.selectedNode != selectedNode ||
        oldPainter.domains != domains ||
        oldPainter.layoutAlgorithm != layoutAlgorithm ||
        oldPainter.transformationController != transformationController ||
        oldPainter.decorators.length != decorators.length ||
        oldPainter.visualizationSystem != visualizationSystem;
  }
}
