import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class VisualizationGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load and add your game components here
    add(DomainComponent(label: 'Domain 1', position: Vector2(100, 100)));
    add(DomainComponent(label: 'Domain 2', position: Vector2(300, 100)));
    add(RelationComponent(start: Vector2(150, 150), end: Vector2(350, 150)));
  }
}

class DomainComponent extends PositionComponent {
  final String label;

  DomainComponent({required this.label, required Vector2 position}) {
    this.position = position;
    size = Vector2(200, 100);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(size.toRect(), paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter
      ..layout(maxWidth: size.x)
      ..paint(
        canvas,
        Offset((size.x - textPainter.width) / 2,
            (size.y - textPainter.height) / 2),
      );
  }
}

class RelationComponent extends Component {
  final Vector2 start;
  final Vector2 end;

  RelationComponent({required this.start, required this.end});

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;
    canvas.drawLine(start.toOffset(), end.toOffset(), paint);
  }

  @override
  void update(double dt) {}
}
