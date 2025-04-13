// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;

class MetaDomainPainter extends CustomPainter {
  /// The list of nodes to render.
  final List<VisualNode> nodes;

  /// The list of edges to render.
  final List<VisualEdge> edges;

  /// A map of node positions.
  final Map<String, Offset> nodePositions;

  /// The scale factor for rendering.
  final double scale;

  /// Creates a new meta domain painter.
  ///
  /// Parameters:
  /// - [nodes]: The list of nodes to render
  /// - [edges]: The list of edges to render
  /// - [nodePositions]: A map of node IDs to their positions
  /// - [scale]: The scale factor for rendering (defaults to 1.0)
  MetaDomainPainter({
    required this.nodes,
    required this.edges,
    required this.nodePositions,
    this.scale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw edges first (so they appear under nodes)
    for (final edge in edges) {
      _drawEdge(canvas, edge);
    }

    // Then draw nodes
    for (final node in nodes) {
      _drawNode(canvas, node);
    }
  }

  /// Draws a single node on the canvas.
  void _drawNode(Canvas canvas, VisualNode node) {
    final position = nodePositions[node.id];
    if (position == null) return;

    // Node styling based on type
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Determine color based on node type
    switch (node.type) {
      case VisualNodeType.entity:
        paint.color = Colors.blue.shade200;
        break;
      case VisualNodeType.attribute:
        paint.color = Colors.green.shade200;
        break;
      case VisualNodeType.aggregateRoot:
        paint.color = Colors.red.shade200;
        break;
      case VisualNodeType.event:
        paint.color = Colors.orange.shade200;
        break;
      case VisualNodeType.command:
        paint.color = Colors.purple.shade200;
        break;
      case VisualNodeType.policy:
        paint.color = Colors.yellow.shade200;
        break;
      default:
        paint.color = Colors.grey.shade200;
    }

    // Draw node
    final nodeSize = 50.0 * scale;
    final rect = Rect.fromCenter(
      center: position,
      width: nodeSize,
      height: nodeSize,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(10.0 * scale)),
      paint,
    );

    // Draw node border
    final borderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.black.withValues(alpha: 138)
          ..strokeWidth = 1.0 * scale;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(10.0 * scale)),
      borderPaint,
    );

    // Draw node label
    final textSpan = TextSpan(
      text: node.label,
      style: TextStyle(
        color: Colors.black.withValues(alpha: 222),
        fontSize: 12.0 * scale,
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: nodeSize - 10.0 * scale);

    final textPosition = Offset(
      position.dx - textPainter.width / 2,
      position.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textPosition);
  }

  /// Draws a single edge on the canvas.
  void _drawEdge(Canvas canvas, VisualEdge edge) {
    final sourcePosition = nodePositions[edge.source.id];
    final targetPosition = nodePositions[edge.target.id];

    if (sourcePosition == null || targetPosition == null) return;

    // Edge styling
    final linePaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 115)
          ..strokeWidth = 1.0 * scale
          ..style = PaintingStyle.stroke;

    // Draw line
    canvas.drawLine(sourcePosition, targetPosition, linePaint);

    // Calculate arrow position (for directed edges)
    final direction = (targetPosition - sourcePosition).normalized();
    final arrowSize = 8.0 * scale;
    final arrowPosition = targetPosition - direction * 25.0 * scale;

    // Draw arrow
    final arrowPath = Path();
    arrowPath.moveTo(
      arrowPosition.dx + direction.dy * arrowSize,
      arrowPosition.dy - direction.dx * arrowSize,
    );
    arrowPath.lineTo(arrowPosition.dx, arrowPosition.dy);
    arrowPath.lineTo(
      arrowPosition.dx - direction.dy * arrowSize,
      arrowPosition.dy + direction.dx * arrowSize,
    );

    canvas.drawPath(arrowPath, linePaint);

    // Draw edge label if present
    if (edge.label != null) {
      final midpoint = Offset(
        (sourcePosition.dx + targetPosition.dx) / 2,
        (sourcePosition.dy + targetPosition.dy) / 2,
      );

      final textSpan = TextSpan(
        text: edge.label,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 138),
          fontSize: 10.0 * scale,
          fontWeight: FontWeight.w300,
          backgroundColor: Colors.white.withValues(alpha: 179),
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();

      final textPosition = Offset(
        midpoint.dx - textPainter.width / 2,
        midpoint.dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, textPosition);
    }
  }

  @override
  bool shouldRepaint(MetaDomainPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges ||
        oldDelegate.nodePositions != nodePositions ||
        oldDelegate.scale != scale;
  }
}

extension OffsetExtension on Offset {
  /// Returns a normalized vector (length of 1).
  Offset normalized() {
    final magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return Offset(dx / magnitude, dy / magnitude);
  }
}
