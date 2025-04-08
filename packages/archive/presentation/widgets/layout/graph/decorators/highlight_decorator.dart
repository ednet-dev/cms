import 'dart:ui';

import 'u_x_decorator.dart';

class HighlightDecorator implements UXDecorator {
  final Color color;
  final double thickness;

  HighlightDecorator({required this.color, this.thickness = 2.0});

  @override
  void apply(Canvas canvas, Offset position, double scale) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness / scale;
    final rect = Rect.fromCenter(
      center: position,
      width: 110 / scale,
      height: 60 / scale,
    );
    canvas.drawRect(rect, paint);
  }

  @override
  void render(Canvas canvas, Size size) {
    // No-op: HighlightDecorator only applies to specific points
    // and doesn't need canvas-wide rendering
  }
}
