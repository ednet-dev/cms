part of ednet_core_flutter;

/// A painter specifically responsible for painting entity nodes in the canvas.
///
/// This class handles the creation and rendering of entity visual elements,
/// including their color calculations and appearance based on domain model entities.
///
/// Part of the EDNet Shell Architecture visualization system.
class EntityPainter {
  /// The current build context (for theme access)
  final BuildContext context;

  /// The ID of the currently selected node
  final String? selectedNode;

  /// The current disclosure level (for detail control)
  final DisclosureLevel disclosureLevel;

  /// Create a new entity painter
  EntityPainter({
    required this.context,
    this.selectedNode,
    this.disclosureLevel = DisclosureLevel.standard,
  });

  /// Creates a visual node for an entity in the domain model
  VisualNode createVisualNode(Entity entity, Offset position, Color color,
      {double size = 50.0}) {
    return VisualNode(
      position: position,
      color: color,
      type: _getEntityType(entity),
      label: entity.code,
      size: _getSizeForEntity(entity),
      isSelected: entity.code == selectedNode,
    );
  }

  /// Get the type string for an entity based on its class
  String _getEntityType(Entity entity) {
    if (entity is Domain) return 'domain';
    if (entity is Model) return 'model';
    if (entity is Concept) return 'concept';
    if (entity is Property) return 'property';
    return 'entity';
  }

  /// Get appropriate size for an entity based on its type and disclosure level
  double _getSizeForEntity(Entity entity) {
    // Base sizes for each entity type
    double baseSize;

    if (entity is Domain) {
      baseSize = 60.0;
    } else if (entity is Model) {
      baseSize = 50.0;
    } else if (entity is Concept) {
      baseSize = 40.0;
    } else if (entity is Property) {
      baseSize = 30.0;
    } else {
      baseSize = 35.0;
    }

    // Adjust size based on disclosure level
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        return baseSize * 0.8;
      case DisclosureLevel.basic:
        return baseSize * 0.9;
      case DisclosureLevel.standard:
        return baseSize;
      case DisclosureLevel.intermediate:
        return baseSize * 1.05;
      case DisclosureLevel.advanced:
        return baseSize * 1.1;
      case DisclosureLevel.detailed:
        return baseSize * 1.15;
      case DisclosureLevel.complete:
        return baseSize * 1.2;
      case DisclosureLevel.debug:
        return baseSize * 1.25;
    }
  }

  /// Calculate a color for a domain based on its level in the hierarchy
  /// and semantic meaning
  Color getColorForEntity(Entity entity, int level, double maxLevel) {
    // Base color calculation from hierarchy position
    double baseSaturation = 0.7;
    double baseBrightness = (0.9 - (level / maxLevel) * 0.3).clamp(0.0, 1.0);

    // Calculate hue based on entity type
    double hue;
    if (entity is Domain) {
      hue = 210.0; // Blue-ish
    } else if (entity is Model) {
      hue = 120.0; // Green-ish
    } else if (entity is Concept) {
      hue = 30.0; // Orange-ish
    } else if (entity is Property) {
      if (entity is Child) {
        hue = 280.0; // Purple-ish for relationships
      } else {
        hue = 0.0; // Red-ish for attributes
      }
    } else {
      // Default - use hash for consistent but varied colors
      hue = (entity.hashCode % 360).toDouble();
    }

    // If semantic colors are available in theme, use those instead
    final theme = Theme.of(context);
    try {
      final semanticColors = theme.extension<SemanticColorsExtension>();
      if (semanticColors != null) {
        if (entity is Domain) return semanticColors.domain;
        if (entity is Model) return semanticColors.model;
        if (entity is Concept) return semanticColors.concept;
        if (entity is Property) {
          if (entity is Child) return semanticColors.relationship;
          return semanticColors.attribute;
        }
      }
    } catch (_) {
      // Continue with HSV color if theme extension not available
    }

    // Apply disclosure level adjustments
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        // Less saturated, higher brightness
        baseSaturation = 0.6;
        baseBrightness = math.min(1.0, baseBrightness + 0.1);
        break;
      case DisclosureLevel.basic:
        // Slightly less saturated
        baseSaturation = 0.65;
        break;
      case DisclosureLevel.standard:
        // Default values
        break;
      case DisclosureLevel.intermediate:
        // Slightly more saturated
        baseSaturation = 0.7;
        break;
      case DisclosureLevel.advanced:
        // More saturated
        baseSaturation = 0.75;
        break;
      case DisclosureLevel.detailed:
        // More saturated, slightly darker
        baseSaturation = 0.77;
        baseBrightness = math.max(0.0, baseBrightness - 0.02);
        break;
      case DisclosureLevel.complete:
        // Most saturated, slightly darker
        baseSaturation = 0.8;
        baseBrightness = math.max(0.0, baseBrightness - 0.05);
        break;
      case DisclosureLevel.debug:
        // Most saturated, slightly darker with a hint of difference
        baseSaturation = 0.82;
        baseBrightness = math.max(0.0, baseBrightness - 0.07);
        break;
    }

    return HSVColor.fromAHSV(1.0, hue, baseSaturation, baseBrightness)
        .toColor();
  }

  /// Paint an entity directly on a canvas
  void paintEntity(Canvas canvas, Entity entity, Offset position,
      {double size = 50.0, Color? color, bool isSelected = false}) {
    // Use provided color or calculate one
    final entityColor =
        color ?? getColorForEntity(entity, _getEntityLevel(entity), 4.0);

    // Create paints
    final fillPaint = Paint()
      ..color = entityColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 3.0 : 1.0;

    // Draw shape based on entity type
    if (entity is Domain) {
      // Domains are hexagons
      _drawPolygon(canvas, position, size / 2, 6, fillPaint);
      _drawPolygon(canvas, position, size / 2, 6, strokePaint);
    } else if (entity is Model) {
      // Models are squares
      final rect = Rect.fromCenter(center: position, width: size, height: size);
      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, strokePaint);
    } else if (entity is Concept) {
      // Concepts are circles
      canvas.drawCircle(position, size / 2, fillPaint);
      canvas.drawCircle(position, size / 2, strokePaint);
    } else if (entity is Property) {
      if (entity is Child) {
        // Relationships are diamonds
        _drawPolygon(canvas, position, size / 2, 4, fillPaint, startAngle: 45);
        _drawPolygon(canvas, position, size / 2, 4, strokePaint,
            startAngle: 45);
      } else {
        // Attributes are small circles
        canvas.drawCircle(position, size / 2, fillPaint);
        canvas.drawCircle(position, size / 2, strokePaint);
      }
    } else {
      // Default - rounded rectangle
      final rect =
          Rect.fromCenter(center: position, width: size, height: size * 0.7);
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(size / 5)), fillPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(size / 5)),
          strokePaint);
    }

    // Draw label
    _drawEntityLabel(canvas, entity.code, position);
  }

  /// Draw a polygon with the given number of sides
  void _drawPolygon(
      Canvas canvas, Offset center, double radius, int sides, Paint paint,
      {double startAngle = 0.0}) {
    final path = Path();
    final double angle = (math.pi * 2) / sides;

    final double radian = startAngle * math.pi / 180.0;

    path.moveTo(
      center.dx + radius * math.cos(radian),
      center.dy + radius * math.sin(radian),
    );

    for (int i = 1; i < sides; i++) {
      final double x = center.dx + radius * math.cos(radian + angle * i);
      final double y = center.dy + radius * math.sin(radian + angle * i);
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  /// Draw a label for an entity
  void _drawEntityLabel(Canvas canvas, String label, Offset position) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 3.0,
          color: Colors.black.withOpacity(0.7),
          offset: const Offset(1.0, 1.0),
        ),
      ],
    );

    final textSpan = TextSpan(
      text: label,
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
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  /// Get the hierarchy level of an entity
  int _getEntityLevel(Entity entity) {
    if (entity is Domain) return 1;
    if (entity is Model) return 2;
    if (entity is Concept) return 3;
    if (entity is Property) return 4;
    return 3; // Default
  }
}
