import 'dart:math';

import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class MetaDomainCanvas extends StatefulWidget {
  final Domains domains;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;

  MetaDomainCanvas({
    required this.domains,
    required this.layoutAlgorithm,
    required this.decorators,
  });

  @override
  _MetaDomainCanvasState createState() => _MetaDomainCanvasState();
}

class _MetaDomainCanvasState extends State<MetaDomainCanvas> {
  late TransformationController _transformationController;
  late LayoutAlgorithm _currentAlgorithm;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _currentAlgorithm = widget.layoutAlgorithm;
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      onInteractionUpdate: (details) {
        setState(() {
          _transformationController.value = _transformationController.value
            ..translate(details.focalPointDelta.dx, details.focalPointDelta.dy)
            ..scale(details.scale);
        });
      },
      minScale: 0.1,
      maxScale: 5.0,
      child: CustomPaint(
        size: Size.infinite,
        painter: MetaDomainPainter(
          domains: widget.domains,
          transformationController: _transformationController,
          layoutAlgorithm: _currentAlgorithm,
          decorators: widget.decorators,
        ),
      ),
    );
  }
}

class MetaDomainPainter extends CustomPainter {
  final Domains domains;
  final TransformationController transformationController;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;

  MetaDomainPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutAlgorithm,
    required this.decorators,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final scale = transformationController.value.getMaxScaleOnAxis();
    final positions = layoutAlgorithm.calculateLayout(domains, size);

    canvas.save();
    canvas.transform(transformationController.value.storage);

    for (var domain in domains) {
      Offset domainPosition = positions[domain.code]!;
      _drawNode(canvas, domain.code, domainPosition, Colors.blue,
          NodeType.domain, scale);

      for (var model in domain.models) {
        Offset modelPosition = positions[model.code]!;
        _drawNode(canvas, model.code, modelPosition, Colors.green,
            NodeType.model, scale);

        for (var entity in model.concepts) {
          Offset entityPosition = positions[entity.code]!;
          _drawNode(canvas, entity.code, entityPosition, Colors.red,
              NodeType.entity, scale);

          for (var child in entity.children) {
            Offset childPosition = positions[child.code]!;
            _drawNode(canvas, child.code, childPosition, Colors.red,
                NodeType.entity, scale);
            canvas.drawLine(entityPosition, childPosition, paint);
          }
        }
      }
    }

    canvas.restore();
  }

  void _drawNode(Canvas canvas, String text, Offset position, Color color,
      NodeType type, double scale) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (type) {
      case NodeType.domain:
        _drawRectangleNode(canvas, text, position, paint, scale);
        break;
      case NodeType.model:
        _drawEllipseNode(canvas, text, position, paint, scale);
        break;
      case NodeType.entity:
        _drawDiamondNode(canvas, text, position, paint, scale);
        break;
    }

    // Apply decorators
    for (var decorator in decorators) {
      decorator.apply(canvas, position, scale);
    }
  }

  void _drawRectangleNode(
      Canvas canvas, String text, Offset position, Paint paint, double scale) {
    final rect = Rect.fromCenter(
        center: position, width: 100 / scale, height: 50 / scale);
    canvas.drawRect(rect, paint);
    _drawText(canvas, text, position, Colors.white, scale);
  }

  void _drawEllipseNode(
      Canvas canvas, String text, Offset position, Paint paint, double scale) {
    final rect = Rect.fromCenter(
        center: position, width: 100 / scale, height: 50 / scale);
    canvas.drawOval(rect, paint);
    _drawText(canvas, text, position, Colors.white, scale);
  }

  void _drawDiamondNode(
      Canvas canvas, String text, Offset position, Paint paint, double scale) {
    final path = Path()
      ..moveTo(position.dx, position.dy - 50 / scale)
      ..lineTo(position.dx + 50 / scale, position.dy)
      ..lineTo(position.dx, position.dy + 50 / scale)
      ..lineTo(position.dx - 50 / scale, position.dy)
      ..close();
    canvas.drawPath(path, paint);
    _drawText(canvas, text, position, Colors.white, scale);
  }

  void _drawText(
      Canvas canvas, String text, Offset position, Color color, double scale) {
    final textStyle = TextStyle(color: color, fontSize: 16 / scale);
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

enum NodeType {
  domain,
  model,
  entity,
}

abstract class LayoutAlgorithm {
  Map<String, Offset> calculateLayout(Domains domains, Size size);
}

class ForceDirectedLayoutAlgorithm extends LayoutAlgorithm {
  final Map<String, Offset> velocity = {};

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
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
}

class GridLayoutAlgorithm extends LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};

    double x = 50;
    double y = 50;
    const double stepX = 200;
    const double stepY = 100;

    for (var domain in domains) {
      positions[domain.code] = Offset(x, y);
      y += stepY;

      for (var model in domain.models) {
        positions[model.code] = Offset(x + stepX, y);
        y += stepY;

        for (var entity in model.concepts) {
          positions[entity.code] = Offset(x + 2 * stepX, y);
          y += stepY;
        }

        y += stepY;
      }

      x += 3 * stepX;
      y = 50;
    }

    return positions;
  }
}

abstract class UXDecorator {
  void apply(Canvas canvas, Offset position, double scale);
}

class HighlightDecorator implements UXDecorator {
  final Color color;
  final double thickness;

  HighlightDecorator({required this.color, this.thickness = 2.0});

  @override
  void apply(Canvas canvas, Offset position, double scale) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness / scale;
    final rect = Rect.fromCenter(
        center: position, width: 110 / scale, height: 60 / scale);
    canvas.drawRect(rect, paint);
  }
}

class TooltipDecorator implements UXDecorator {
  final String tooltip;
  final TextStyle textStyle;

  TooltipDecorator({required this.tooltip, required this.textStyle});

  @override
  void apply(Canvas canvas, Offset position, double scale) {
    final textSpan = TextSpan(text: tooltip, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position + Offset(0, -50 / scale));
  }
}
