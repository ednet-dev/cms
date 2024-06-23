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
          ..blendMode = BlendMode.colorBurn);
  }
}

class RenderComponent extends Component {
  final Paint paint;
  final Rect rect;

  RenderComponent(this.paint, this.rect);

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect, paint);
  }
}

class LineComponent extends Component {
  final Offset start;
  final Offset end;
  final Paint paint;

  LineComponent({
    required this.start,
    required this.end,
    Color color = Colors.black,
  }) : paint = Paint()
          ..color = color
          ..strokeWidth = 2;

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.drawLine(start, end, paint);
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
