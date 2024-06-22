import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'component.dart';

class PositionComponent extends Component {
  Offset position;

  PositionComponent(this.position);

  @override
  void update(double dt) {
    // Update logic for position
  }

  @override
  void render(Canvas canvas) {
    // Render logic for position (e.g., drawing a marker)
  }
}

class Artefact extends PositionComponent {
  final String label;
  final double width;
  final double height;
  final Paint _paint;

  Artefact(
    super.position, {
    required this.label,
    required this.width,
    required this.height,
    Color color = Colors.blue,
  }) : _paint = Paint()..color = color;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw rectangle
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), _paint);
    // Draw label
    TextPainter tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: width);
    tp.paint(canvas, Offset((width - tp.width) / 2, (height - tp.height) / 2));
  }
}

class LineComponent extends PositionComponent {
  final Vector2 start;
  final Vector2 end;
  final Paint _paint;

  LineComponent(
    super.position, {
    required this.start,
    required this.end,
    Color color = Colors.black,
  }) : _paint = Paint()
          ..color = color
          ..strokeWidth = 2;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawLine(start.toOffset(), end.toOffset(), _paint);
  }
}
