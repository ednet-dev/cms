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

  MetaDomainPainter({required this.domains, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    double domainX = offset.dx + 20;
    double domainY = offset.dy + 20;

    for (var domain in domains) {
      final domainRect = Rect.fromLTWH(domainX, domainY, 200, 50);
      canvas.drawRect(domainRect, paint);
      _drawText(canvas, domain.code, domainRect.center, Colors.white);

      double modelY = domainY + 60;
      for (var model in domain.models) {
        final modelRect = Rect.fromLTWH(domainX + 20, modelY, 160, 40);
        canvas.drawRect(modelRect, paint..color = Colors.green);
        _drawText(canvas, model.code, modelRect.center, Colors.white);

        modelY += 50;

        // Draw relationships
        for (var entity in model.concepts) {
          final entityPosition = Offset(domainX + 220, modelY);
          _drawText(canvas, entity.code, entityPosition, Colors.red);

          for (var child in entity.children) {
            final childPosition = Offset(domainX + 420, modelY + 40);
            _drawText(canvas, child.code, childPosition, Colors.red);

            // Draw lines
            canvas.drawLine(entityPosition, childPosition, paint);
          }

          modelY += 50;
        }
      }

      domainY = modelY + 20;
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
