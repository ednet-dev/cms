import 'dart:math';

import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class MetaDomainCanvas extends StatefulWidget {
  final Domains domains;

  MetaDomainCanvas({required this.domains});

  @override
  _MetaDomainCanvasState createState() => _MetaDomainCanvasState();
}

class _MetaDomainCanvasState extends State<MetaDomainCanvas> {
  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta;
        });
      },
      child: CustomPaint(
        size: Size.infinite,
        painter:
            MetaDomainPainter(domains: widget.domains, offset: _dragOffset),
      ),
    );
  }
}

class MetaDomainPainter extends CustomPainter {
  final Domains domains;
  final Offset offset;
  final Map<String, Offset> velocity = {};

  MetaDomainPainter({required this.domains, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    Map<String, Offset> positions = _applyForceDirectedLayout(size);

    for (var domain in domains) {
      Offset domainPosition = positions[domain.code]!;
      _drawText(canvas, domain.code, domainPosition, Colors.blue);

      for (var model in domain.models) {
        Offset modelPosition = positions[model.code]!;
        _drawText(canvas, model.code, modelPosition, Colors.green);

        for (var entity in model.concepts) {
          Offset entityPosition = positions[entity.code]!;
          _drawText(canvas, entity.code, entityPosition, Colors.red);

          // Draw relationships
          for (var child in entity.children) {
            Offset childPosition = positions[child.code]!;
            _drawText(canvas, child.code, childPosition, Colors.red);

            // Draw lines
            canvas.drawLine(
                entityPosition, childPosition, paint..color = Colors.black);
          }
        }
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, Color color) {
    final textStyle = TextStyle(color: color, fontSize: 16);
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  Map<String, Offset> _applyForceDirectedLayout(Size size) {
    final positions = <String, Offset>{};
    final forces = <String, Offset>{};

    final random = Random();
    const int iterations = 1000;
    const double repulsionForce = 10000.0;
    const double springForce = 0.1;

    for (var domain in domains) {
      positions[domain.code] = Offset(
          random.nextDouble() * size.width, random.nextDouble() * size.height);

      for (var model in domain.models) {
        positions[model.code] = Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height);

        for (var entity in model.concepts) {
          positions[entity.code] = Offset(random.nextDouble() * size.width,
              random.nextDouble() * size.height);

          for (var child in entity.children) {
            positions[child.code] = Offset(random.nextDouble() * size.width,
                random.nextDouble() * size.height);
          }
        }
      }
    }

    for (var i = 0; i < iterations; i++) {
      for (var entry in positions.entries) {
        final position = entry.value;
        var force = Offset.zero;

        for (var otherEntry in positions.entries) {
          if (entry.key == otherEntry.key) continue;

          final direction = position - otherEntry.value;
          final distance = max(direction.distance, 1.0);
          final repulsion =
              direction / distance * repulsionForce / (distance * distance);

          force += repulsion;
        }

        forces[entry.key] = force;
      }

      for (var entry in positions.entries) {
        final force = forces[entry.key]!;
        final velocity =
            (this.velocity[entry.key] ?? Offset.zero) + force * springForce;

        positions[entry.key] = entry.value + velocity;
        this.velocity[entry.key] = velocity * 0.95;
      }
    }

    return positions;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
