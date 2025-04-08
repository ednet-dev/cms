part of ednet_core_flutter;

/// A painter specifically responsible for painting relationship lines in the canvas.
///
/// This class handles the creation and rendering of relationships between domain entities,
/// including the visual representation of connections and their labels.
///
/// Part of the EDNet Shell Architecture visualization system.
class RelationPainter {
  /// The current build context (for theme access)
  final BuildContext context;

  /// The current disclosure level (for detail control)
  final DisclosureLevel disclosureLevel;

  /// Whether to show arrow heads on relationships
  final bool showArrows;

  /// The ID of the currently selected relationship
  final String? selectedRelationship;

  /// Create a new relation painter
  RelationPainter({
    required this.context,
    this.disclosureLevel = DisclosureLevel.standard,
    this.showArrows = true,
    this.selectedRelationship,
  });

  /// Creates a visual line node connecting two domain entities
  LineNode createLineNode(Offset start, Offset end, String sourceToTargetLabel,
      String targetToSourceLabel,
      {Color color = Colors.grey, double thickness = 1.0}) {
    return LineNode(
      start: start,
      end: end,
      sourceToTargetLabel: sourceToTargetLabel,
      targetToSourceLabel: targetToSourceLabel,
      color: color,
      thickness: _getThicknessForDisclosureLevel(thickness),
    );
  }

  /// Creates a visual line node representing a relationship between domain model properties
  LineNode createRelationshipNode(Property source, Property target,
      Offset sourcePosition, Offset targetPosition,
      {Color? color}) {
    final relationColor = color ?? _getRelationshipColor(source, target);

    // Determine if this is an inheritance relationship
    final bool isInheritance = source is Parent && target is Child;

    // Set appropriate labels based on relationship type
    String sourceToTargetLabel = source.code;
    String targetToSourceLabel = target.code;

    // Custom labels for specific relationship types
    if (isInheritance) {
      sourceToTargetLabel = 'inherits';
      targetToSourceLabel = 'parent';
    } else if (source is Parent &&
        (source.internal ?? false) &&
        target is Child &&
        (target.internal ?? false)) {
      sourceToTargetLabel = 'references';
      targetToSourceLabel = 'referenced by';
    } else if (source is Parent &&
        (source.external ?? false) &&
        target is Child &&
        (target.external ?? false)) {
      sourceToTargetLabel = 'connects to';
      targetToSourceLabel = 'connected from';
    }

    // Create the line node
    return LineNode(
      start: sourcePosition,
      end: targetPosition,
      sourceToTargetLabel: _getLabelForDisclosureLevel(sourceToTargetLabel),
      targetToSourceLabel: _getLabelForDisclosureLevel(targetToSourceLabel),
      color: relationColor,
      thickness: _getThicknessForDisclosureLevel(1.5),
    );
  }

  /// Get color for a relationship based on its type
  Color _getRelationshipColor(Property source, Property target) {
    final theme = Theme.of(context);

    // Try to use semantic colors from theme
    try {
      final semanticColors = theme.extension<SemanticColorsExtension>();
      if (semanticColors != null) {
        // Inheritance relationships
        if (source is Parent && target is Child) {
          return Colors.purpleAccent; // Use a fallback inheritance color
        }
        // Association relationships
        if ((source is Parent && (source.internal ?? false)) ||
            (target is Child && (target.internal ?? false))) {
          return Colors.blueAccent; // Use a fallback association color
        }
        // Default relationship color
        return semanticColors.relationship;
      }
    } catch (_) {
      // Continue with default colors if theme extension not available
    }

    // Default colors if theme doesn't provide them
    if (source is Parent && target is Child) {
      return Colors.purpleAccent;
    }
    if ((source is Parent && (source.internal ?? false)) ||
        (target is Child && (target.internal ?? false))) {
      return Colors.blueAccent;
    }

    return Colors.grey;
  }

  /// Paint a relationship directly on a canvas
  void paintRelationship(Canvas canvas, Offset start, Offset end,
      String sourceToTargetLabel, String targetToSourceLabel,
      {Color color = Colors.grey,
      double thickness = 1.0,
      bool isSelected = false}) {
    // Create paints
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = isSelected ? thickness * 2 : thickness
      ..style = PaintingStyle.stroke;

    // Draw main line
    canvas.drawLine(start, end, linePaint);

    // Draw direction arrow if enabled
    if (showArrows) {
      _drawArrow(canvas, start, end, linePaint);
    }

    // Draw labels based on disclosure level
    if (disclosureLevel.index >= DisclosureLevel.standard.index) {
      // Calculate midpoint for label placement
      final midpoint = Offset(
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2,
      );

      // Draw the source-to-target label
      _drawLabel(
        canvas,
        sourceToTargetLabel,
        midpoint,
        offset: const Offset(0, -10),
      );

      // Draw the target-to-source label if disclosure level is high enough
      // and if the labels are different
      if (disclosureLevel.index >= DisclosureLevel.advanced.index &&
          sourceToTargetLabel != targetToSourceLabel) {
        _drawLabel(
          canvas,
          targetToSourceLabel,
          midpoint,
          offset: const Offset(0, 10),
        );
      }
    }
  }

  /// Draw an arrow at the end point
  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint linePaint) {
    // Calculate direction vector
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    // Skip if too close
    if (distance < 10) return;

    // Normalize direction vector
    final dirX = dx / distance;
    final dirY = dy / distance;

    // Calculate perpendicular vector
    final perpX = -dirY;
    final perpY = dirX;

    // Calculate arrow points
    final arrowSize = _getArrowSizeForDisclosureLevel();
    final tipX = end.dx - dirX * arrowSize;
    final tipY = end.dy - dirY * arrowSize;

    final side1X = tipX + perpX * arrowSize * 0.5;
    final side1Y = tipY + perpY * arrowSize * 0.5;

    final side2X = tipX - perpX * arrowSize * 0.5;
    final side2Y = tipY - perpY * arrowSize * 0.5;

    // Draw arrow
    final path = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(side1X, side1Y)
      ..lineTo(side2X, side2Y)
      ..close();

    canvas.drawPath(path, Paint()..color = linePaint.color);
  }

  /// Draw label text
  void _drawLabel(Canvas canvas, String label, Offset position,
      {Offset offset = Offset.zero}) {
    // Skip if empty label
    if (label.isEmpty) return;

    // Only show abbreviated labels at lower disclosure levels
    final String displayLabel = _getLabelForDisclosureLevel(label);

    // Create text painter
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: _getFontSizeForDisclosureLevel(),
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.white.withOpacity(0.7),
    );

    final textSpan = TextSpan(
      text: displayLabel,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2 + offset.dx,
        position.dy - textPainter.height / 2 + offset.dy,
      ),
    );
  }

  /// Get appropriate line thickness based on disclosure level
  double _getThicknessForDisclosureLevel(double baseThickness) {
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        return baseThickness * 0.7;
      case DisclosureLevel.basic:
        return baseThickness * 0.85;
      case DisclosureLevel.standard:
        return baseThickness;
      case DisclosureLevel.intermediate:
        return baseThickness * 1.1;
      case DisclosureLevel.advanced:
        return baseThickness * 1.2;
      case DisclosureLevel.detailed:
        return baseThickness * 1.3;
      case DisclosureLevel.complete:
        return baseThickness * 1.5;
      case DisclosureLevel.debug:
        return baseThickness * 1.6;
    }
  }

  /// Get appropriate font size based on disclosure level
  double _getFontSizeForDisclosureLevel() {
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        return 8.0;
      case DisclosureLevel.basic:
        return 9.0;
      case DisclosureLevel.standard:
        return 10.0;
      case DisclosureLevel.intermediate:
        return 10.5;
      case DisclosureLevel.advanced:
        return 11.0;
      case DisclosureLevel.detailed:
        return 11.5;
      case DisclosureLevel.complete:
        return 12.0;
      case DisclosureLevel.debug:
        return 12.5;
    }
  }

  /// Get appropriate arrow size based on disclosure level
  double _getArrowSizeForDisclosureLevel() {
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        return 8.0;
      case DisclosureLevel.basic:
        return 9.0;
      case DisclosureLevel.standard:
        return 10.0;
      case DisclosureLevel.intermediate:
        return 11.0;
      case DisclosureLevel.advanced:
        return 12.0;
      case DisclosureLevel.detailed:
        return 13.5;
      case DisclosureLevel.complete:
        return 15.0;
      case DisclosureLevel.debug:
        return 16.0;
    }
  }

  /// Adapt label for different disclosure levels
  String _getLabelForDisclosureLevel(String label) {
    if (label.isEmpty) return '';

    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        // Just show first letter or truncated label
        return label.length <= 1 ? label : label.substring(0, 1);
      case DisclosureLevel.basic:
        // Show abbreviated label
        return label.length <= 3 ? label : '${label.substring(0, 3)}...';
      case DisclosureLevel.standard:
        // Show moderate length
        return label.length <= 10 ? label : '${label.substring(0, 10)}...';
      case DisclosureLevel.intermediate:
        // Show a bit more detail
        return label.length <= 15 ? label : '${label.substring(0, 15)}...';
      case DisclosureLevel.advanced:
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
      case DisclosureLevel.debug:
        // Show full label
        return label;
    }
  }
}
