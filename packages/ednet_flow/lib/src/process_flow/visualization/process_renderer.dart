// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

part of ednet_flow;

/// A renderer for process flow diagrams.
///
/// This class is responsible for rendering a Process model
/// as a visual diagram. It handles the layout and drawing of
/// activities, gateways, and sequence flows.
class ProcessRenderer {
  /// The process to render.
  final Process process;

  /// The canvas size.
  final Size size;

  /// The padding around the diagram.
  final EdgeInsets padding;

  /// The scale factor for rendering.
  final double scale;

  /// Creates a new process renderer.
  const ProcessRenderer({
    required this.process,
    required this.size,
    this.padding = const EdgeInsets.all(20),
    this.scale = 1.0,
  });

  /// Renders the process to a canvas.
  void render(Canvas canvas) {
    // Calculate the available space
    final availableWidth = size.width - padding.left - padding.right;
    final availableHeight = size.height - padding.top - padding.bottom;

    // Calculate positions for all elements if they don't have explicit positions
    final positions = _calculatePositions(availableWidth, availableHeight);

    // Draw sequence flows first (so they appear under nodes)
    for (final flow in process.sequenceFlows) {
      _drawSequenceFlow(canvas, flow, positions);
    }

    // Draw activities
    for (final activity in process.activities) {
      _drawActivity(
        canvas,
        activity,
        positions[activity.id] ?? const Offset(0, 0),
      );
    }

    // Draw gateways
    for (final gateway in process.gateways) {
      _drawGateway(
        canvas,
        gateway,
        positions[gateway.id] ?? const Offset(0, 0),
      );
    }
  }

  /// Calculates positions for all elements in the process.
  Map<String, Offset> _calculatePositions(double width, double height) {
    final positions = <String, Offset>{};

    // If elements have explicit positions, use those
    for (final activity in process.activities) {
      final pos = activity.position;
      positions[activity.id] = Offset(
        padding.left + (pos.x * width),
        padding.top + (pos.y * height),
      );
    }

    for (final gateway in process.gateways) {
      final pos = gateway.position;
      positions[gateway.id] = Offset(
        padding.left + (pos.x * width),
        padding.top + (pos.y * height),
      );
    }

    // For elements without explicit positions, calculate automatically
    // This is a simplified automatic layout algorithm
    // A more sophisticated algorithm would be needed for complex processes

    return positions;
  }

  /// Draws an activity on the canvas.
  void _drawActivity(Canvas canvas, Activity activity, Offset position) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Choose color based on activity type
    switch (activity.type) {
      case ActivityType.start:
        paint.color = const Color(0xFF4CAF50); // Green
        break;
      case ActivityType.end:
        paint.color = const Color(0xFFF44336); // Red
        break;
      case ActivityType.task:
        paint.color = const Color(0xFF2196F3); // Blue
        break;
      case ActivityType.subprocess:
        paint.color = const Color(0xFF9C27B0); // Purple
        break;
    }

    // Draw the activity shape
    final size = 50.0 * scale;

    if (activity.type == ActivityType.start ||
        activity.type == ActivityType.end) {
      // Draw circle for start/end events
      canvas.drawCircle(position, size / 2, paint);

      // Draw border
      final borderPaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..color = const Color(0xFF000000)
            ..strokeWidth = 1.0 * scale;

      canvas.drawCircle(position, size / 2, borderPaint);
    } else {
      // Draw rounded rectangle for tasks
      final rect = Rect.fromCenter(
        center: position,
        width: size * 1.5,
        height: size,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(10.0 * scale)),
        paint,
      );

      // Draw border
      final borderPaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..color = const Color(0xFF000000)
            ..strokeWidth = 1.0 * scale;

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(10.0 * scale)),
        borderPaint,
      );

      // Draw text label
      final textStyle = TextStyle(
        fontSize: 12 * scale,
        color: const Color(0xFF000000),
      );

      _drawCenteredText(canvas, activity.name, position, textStyle);
    }
  }

  /// Draws a gateway on the canvas.
  void _drawGateway(Canvas canvas, Gateway gateway, Offset position) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Choose color based on gateway type
    switch (gateway.type) {
      case GatewayType.exclusive:
        paint.color = const Color(0xFFFFEB3B); // Yellow
        break;
      case GatewayType.inclusive:
        paint.color = const Color(0xFFFFA726); // Orange
        break;
      case GatewayType.parallel:
        paint.color = const Color(0xFF42A5F5); // Light Blue
        break;
      case GatewayType.eventBased:
        paint.color = const Color(0xFF26A69A); // Teal
        break;
      case GatewayType.complex:
        paint.color = const Color(0xFF7E57C2); // Deep Purple
        break;
    }

    // Draw diamond shape
    final size = 50.0 * scale;
    final path = Path();

    path.moveTo(position.dx, position.dy - size / 2); // Top
    path.lineTo(position.dx + size / 2, position.dy); // Right
    path.lineTo(position.dx, position.dy + size / 2); // Bottom
    path.lineTo(position.dx - size / 2, position.dy); // Left
    path.close();

    canvas.drawPath(path, paint);

    // Draw border
    final borderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = const Color(0xFF000000)
          ..strokeWidth = 1.0 * scale;

    canvas.drawPath(path, borderPaint);

    // Draw gateway symbol based on type
    // (simplified - would add symbols like X, O, +, etc. based on gateway type)

    // Draw text label
    final textStyle = TextStyle(
      fontSize: 12 * scale,
      color: const Color(0xFF000000),
    );

    final labelPosition = Offset(position.dx, position.dy + size * 0.7);
    _drawCenteredText(canvas, gateway.name, labelPosition, textStyle);
  }

  /// Draws a sequence flow on the canvas.
  void _drawSequenceFlow(
    Canvas canvas,
    SequenceFlow flow,
    Map<String, Offset> positions,
  ) {
    final sourcePosition = positions[flow.sourceId];
    final targetPosition = positions[flow.targetId];

    if (sourcePosition == null || targetPosition == null) {
      return; // Skip if we don't have positions for both ends
    }

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = const Color(0xFF000000)
          ..strokeWidth = 1.0 * scale;

    if (flow.waypoints.isEmpty) {
      // Draw direct line if no waypoints
      canvas.drawLine(sourcePosition, targetPosition, paint);

      // Draw arrow
      _drawArrow(canvas, sourcePosition, targetPosition, paint);
    } else {
      // Draw line through waypoints
      final path = Path();
      path.moveTo(sourcePosition.dx, sourcePosition.dy);

      for (final waypoint in flow.waypoints) {
        final waypointPosition = Offset(
          padding.left +
              (waypoint.x * (size.width - padding.left - padding.right)),
          padding.top +
              (waypoint.y * (size.height - padding.top - padding.bottom)),
        );

        path.lineTo(waypointPosition.dx, waypointPosition.dy);
      }

      path.lineTo(targetPosition.dx, targetPosition.dy);
      canvas.drawPath(path, paint);

      // Draw arrow at the end
      final lastPoint =
          flow.waypoints.isNotEmpty
              ? Offset(
                padding.left +
                    (flow.waypoints.last.x *
                        (size.width - padding.left - padding.right)),
                padding.top +
                    (flow.waypoints.last.y *
                        (size.height - padding.top - padding.bottom)),
              )
              : sourcePosition;

      _drawArrow(canvas, lastPoint, targetPosition, paint);
    }

    // Draw condition label if present
    if (flow.condition != null) {
      final midpoint = Offset(
        (sourcePosition.dx + targetPosition.dx) / 2,
        (sourcePosition.dy + targetPosition.dy) / 2,
      );

      final textStyle = TextStyle(
        fontSize: 10 * scale,
        color: const Color(0xFF000000),
      );

      _drawCenteredText(canvas, flow.condition!, midpoint, textStyle);
    }
  }

  /// Draws an arrow at the end of a line.
  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    final direction = (end - start).normalized();
    final arrowSize = 10.0 * scale;

    // Calculate arrow tip position (slightly before the actual end)
    final tipPosition = end - direction * 5.0 * scale;

    // Draw arrow head
    final arrowPath = Path();
    arrowPath.moveTo(
      tipPosition.dx + direction.dy * arrowSize,
      tipPosition.dy - direction.dx * arrowSize,
    );
    arrowPath.lineTo(end.dx, end.dy);
    arrowPath.lineTo(
      tipPosition.dx - direction.dy * arrowSize,
      tipPosition.dy + direction.dx * arrowSize,
    );

    canvas.drawPath(arrowPath, paint);
  }

  /// Draws centered text on the canvas.
  void _drawCenteredText(
    Canvas canvas,
    String text,
    Offset position,
    TextStyle style,
  ) {
    // In a real implementation, this would use TextPainter to draw text
    // For this stub, we'll just leave it as a placeholder
  }
}
