import 'package:flutter/material.dart';

/// A painter specifically responsible for painting grid backgrounds in the canvas.
///
/// This class handles drawing the background grid pattern to provide visual reference
/// for the canvas space.
class GridPainter {
  final Color gridLineColor;
  final double gridSpacing;
  final double gridLineWidth;

  GridPainter({
    this.gridLineColor = Colors.grey,
    this.gridSpacing = 50.0,
    this.gridLineWidth = 0.5,
  });

  /// Paints the grid on the canvas with the specified size
  void paintGrid(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = gridLineColor.withOpacity(0.3)
          ..strokeWidth = gridLineWidth;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
}
