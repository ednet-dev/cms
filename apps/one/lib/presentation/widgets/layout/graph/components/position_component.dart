import 'dart:math';

import 'package:flutter/material.dart';

abstract class Component {
  void update(double dt);

  void render(Canvas canvas);
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

class PositionComponent extends Component {
  Offset position;

  PositionComponent(this.position);

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      position,
      100,
      Paint()
        ..color = Colors.orange
        ..blendMode = BlendMode.colorBurn,
    );
  }
}

class RenderComponent extends Component {
  final Paint paint;
  final Rect rect;
  final double glow;

  RenderComponent(this.paint, this.rect, {this.glow = 0.0});

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    if (glow > 0.0) {
      final glowPaint = Paint()
        ..color = paint.color.withOpacity(0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glow);
      canvas.drawRect(rect.inflate(glow), glowPaint);
    }
    canvas.drawRect(rect, paint);
  }
}

class LineComponent extends Component {
  final Offset start;
  final Offset end;
  final Paint paint;
  final String fromToName;
  final String toFromName;
  final TextStyle fromTextStyle;
  final TextStyle toTextStyle;
  final double margin;

  LineComponent({
    required this.start,
    required this.end,
    required this.fromToName,
    required this.toFromName,
    Color color = Colors.black,
    required this.fromTextStyle,
    required this.toTextStyle,
    this.margin = 100.0,
  }) : paint = Paint()
          ..color = color
          ..strokeWidth = 1;

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.drawLine(start, end, paint);

    // Calculate the direction vector of the line
    final direction = (end - start).direction;

    // Draw fromToName near the start of the line
    _drawText(canvas, fromToName, start, fromTextStyle, direction, margin);

    // Draw toFromName near the end of the line
    _drawText(canvas, toFromName, end, toTextStyle, direction + pi, margin);
  }

  void _drawText(Canvas canvas, String text, Offset position, TextStyle style,
      double direction, double offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Calculate the offset position based on the direction of the line
    final dx = cos(direction) * offset;
    final dy = sin(direction) * offset;

    // Adjust the position to apply the offset
    final adjustedPosition = position + Offset(dx, dy);

    textPainter.paint(
        canvas,
        Offset(adjustedPosition.dx - textPainter.width / 2,
            adjustedPosition.dy - textPainter.height / 2));
  }
}

class TextComponent extends Component {
  final String text;
  final Offset position;
  final TextStyle style;
  final double padding;
  final Color backgroundColor;

  TextComponent({
    required this.text,
    required this.position,
    required this.style,
    this.padding = 4.0,
    this.backgroundColor = Colors.black,
  });

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final backgroundRect = Rect.fromLTWH(
      position.dx - textPainter.width / 2 - padding,
      position.dy - textPainter.height / 2 - padding,
      textPainter.width + padding * 2,
      textPainter.height + padding * 2,
    );

    final paint = Paint()..color = backgroundColor;

    canvas.drawRect(backgroundRect, paint);
    textPainter.paint(
        canvas,
        Offset(position.dx - textPainter.width / 2,
            position.dy - textPainter.height / 2));
  }
}
