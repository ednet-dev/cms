part of ednet_core_flutter;

/// An interface for decorating canvas visuals in the domain visualization system.
///
/// UXDecorators allow for pluggable visual enhancements that can be applied
/// to canvases during rendering. Examples include grids, backgrounds, highlights,
/// shadows, or other visual effects.
///
/// This is part of the EDNet Shell Architecture visualization system.
abstract class UXDecorator {
  /// Apply a decoration to the canvas.
  ///
  /// Parameters:
  /// - [canvas]: The canvas to decorate
  /// - [size]: The size of the canvas
  ///
  /// Returns:
  /// The decorated canvas
  Canvas decorate(Canvas canvas, Size size);
}

/// A decorator that adds a grid to the background of the canvas.
class GridDecorator implements UXDecorator {
  /// The color of the grid lines
  final Color gridColor;

  /// The spacing between grid lines
  final double gridSpacing;

  /// The stroke width of the grid lines
  final double strokeWidth;

  /// Optional disclosure level to adjust detail based on zoom
  final DisclosureLevel disclosureLevel;

  /// Creates a new grid decorator
  GridDecorator({
    this.gridColor = Colors.grey,
    this.gridSpacing = 50.0,
    this.strokeWidth = 0.5,
    this.disclosureLevel = DisclosureLevel.standard,
  });

  @override
  Canvas decorate(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..strokeWidth = strokeWidth;

    // Adjust grid density based on disclosure level
    var spacing = gridSpacing;
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        spacing = gridSpacing * 2;
        break;
      case DisclosureLevel.basic:
        spacing = gridSpacing * 1.5;
        break;
      case DisclosureLevel.standard:
        spacing = gridSpacing;
        break;
      case DisclosureLevel.intermediate:
        spacing = gridSpacing * 0.85;
        break;
      case DisclosureLevel.advanced:
        spacing = gridSpacing * 0.75;
        break;
      case DisclosureLevel.detailed:
        spacing = gridSpacing * 0.6;
        break;
      case DisclosureLevel.complete:
        spacing = gridSpacing * 0.5;
        break;
      case DisclosureLevel.debug:
        spacing = gridSpacing * 0.4;
        break;
    }

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    return canvas;
  }
}

/// A decorator that applies a background color or gradient to the canvas.
class BackgroundDecorator implements UXDecorator {
  /// The background color or the start color of the gradient
  final Color color;

  /// Optional end color for gradient
  final Color? endColor;

  /// Whether to use a gradient
  final bool useGradient;

  /// Creates a new background decorator
  BackgroundDecorator({
    required this.color,
    this.endColor,
    this.useGradient = false,
  });

  @override
  Canvas decorate(Canvas canvas, Size size) {
    final paint = Paint();

    if (useGradient && endColor != null) {
      // Use linear gradient
      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, endColor!],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    } else {
      // Use solid color
      paint.color = color;
    }

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    return canvas;
  }
}
