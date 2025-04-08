part of ednet_core_flutter;

/// A painter specifically responsible for painting grid backgrounds in the canvas.
///
/// This class handles drawing the background grid pattern to provide visual reference
/// for the canvas space.
///
/// Part of the EDNet Shell Architecture visualization system.
class GridPainter {
  /// The color of the grid lines
  final Color gridLineColor;

  /// The spacing between grid lines
  final double gridSpacing;

  /// The width of the grid lines
  final double gridLineWidth;

  /// The current disclosure level (for detail control)
  final DisclosureLevel disclosureLevel;

  /// Create a new grid painter
  GridPainter({
    this.gridLineColor = Colors.grey,
    this.gridSpacing = 50.0,
    this.gridLineWidth = 0.5,
    this.disclosureLevel = DisclosureLevel.standard,
  });

  /// Paints the grid on the canvas with the specified size
  void paintGrid(Canvas canvas, Size size) {
    // Adjust spacing based on disclosure level
    final adjustedSpacing = _getSpacingForDisclosureLevel();

    final paint = Paint()
      ..color = gridLineColor.withOpacity(0.3)
      ..strokeWidth = gridLineWidth;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += adjustedSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += adjustedSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw major grid lines at increased intervals if using higher disclosure levels
    if (disclosureLevel.index >= DisclosureLevel.advanced.index) {
      final majorPaint = Paint()
        ..color = gridLineColor.withOpacity(0.5)
        ..strokeWidth = gridLineWidth * 2;

      final majorSpacing = adjustedSpacing * 5;

      // Draw major vertical lines
      for (double x = 0; x <= size.width; x += majorSpacing) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), majorPaint);
      }

      // Draw major horizontal lines
      for (double y = 0; y <= size.height; y += majorSpacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), majorPaint);
      }
    }
  }

  /// Adjust grid spacing based on disclosure level
  double _getSpacingForDisclosureLevel() {
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        return gridSpacing * 2; // Wider spacing (less detail)
      case DisclosureLevel.basic:
        return gridSpacing * 1.5;
      case DisclosureLevel.standard:
        return gridSpacing;
      case DisclosureLevel.advanced:
        return gridSpacing * 0.75; // Tighter spacing (more detail)
      case DisclosureLevel.complete:
        return gridSpacing * 0.5; // Finest grid
      default:
        return gridSpacing;
    }
  }

  /// Create a grid decorator from this painter
  GridDecorator toDecorator() {
    return GridDecorator(
      gridColor: gridLineColor,
      gridSpacing: gridSpacing,
      strokeWidth: gridLineWidth,
      disclosureLevel: disclosureLevel,
    );
  }
}
