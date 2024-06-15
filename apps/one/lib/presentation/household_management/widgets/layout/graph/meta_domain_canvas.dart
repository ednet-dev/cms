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
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _currentAlgorithm = widget.layoutAlgorithm;
  }

  void _onInteractionStart(ScaleStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onInteractionStart,
      onScaleEnd: _onInteractionEnd,
      child: InteractiveViewer(
        transformationController: _transformationController,
        onInteractionUpdate: (details) {
          setState(() {
            _transformationController.value = _transformationController.value
              ..translate(
                  details.focalPointDelta.dx, details.focalPointDelta.dy)
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
            isDragging: _isDragging,
          ),
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
  final bool isDragging;

  MetaDomainPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutAlgorithm,
    required this.decorators,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isDragging) {
      // Skip layout recalculation during drag
      canvas.save();
      canvas.transform(transformationController.value.storage);
      _drawNodes(canvas, size);
      canvas.restore();
    } else {
      // Normal painting process
      final positions = layoutAlgorithm.calculateLayout(domains, size);

      canvas.save();
      canvas.transform(transformationController.value.storage);

      for (var domain in domains) {
        Offset domainPosition = positions[domain.code]!;
        _drawNode(
            canvas, domain.code, domainPosition, Colors.blue, NodeType.domain);

        for (var model in domain.models) {
          Offset modelPosition = positions[model.code]!;
          _drawNode(
              canvas, model.code, modelPosition, Colors.green, NodeType.model);

          for (var entity in model.concepts) {
            Offset entityPosition = positions[entity.code]!;
            _drawNode(canvas, entity.code, entityPosition, Colors.red,
                NodeType.entity);

            for (var child in entity.children) {
              Offset childPosition = positions[child.code]!;
              _drawNode(canvas, child.code, childPosition, Colors.red,
                  NodeType.entity);
              canvas.drawLine(
                  entityPosition, childPosition, Paint()..color = Colors.black);
            }
          }
        }
      }

      canvas.restore();
    }
  }

  void _drawNodes(Canvas canvas, Size size) {
    for (var domain in domains) {
      final domainPosition = _calculatePosition(domain.code, size);
      _drawNode(
          canvas, domain.code, domainPosition, Colors.blue, NodeType.domain);

      for (var model in domain.models) {
        final modelPosition = _calculatePosition(model.code, size);
        _drawNode(
            canvas, model.code, modelPosition, Colors.green, NodeType.model);

        for (var entity in model.concepts) {
          final entityPosition = _calculatePosition(entity.code, size);
          _drawNode(
              canvas, entity.code, entityPosition, Colors.red, NodeType.entity);

          for (var child in entity.children) {
            final childPosition = _calculatePosition(child.code, size);
            _drawNode(
                canvas, child.code, childPosition, Colors.red, NodeType.entity);
            canvas.drawLine(
                entityPosition, childPosition, Paint()..color = Colors.black);
          }
        }
      }
    }
  }

  Offset _calculatePosition(String code, Size size) {
    // Calculate position for the given code (placeholder implementation)
    return Offset(size.width / 2, size.height / 2);
  }

  void _drawNode(
      Canvas canvas, String text, Offset position, Color color, NodeType type) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (type) {
      case NodeType.domain:
        _drawRectangleNode(canvas, text, position, paint);
        break;
      case NodeType.model:
        _drawEllipseNode(canvas, text, position, paint);
        break;
      case NodeType.entity:
        _drawDiamondNode(canvas, text, position, paint);
        break;
    }

    for (var decorator in decorators) {
      decorator.apply(canvas, position, 1.0);
    }
  }

  void _drawRectangleNode(
      Canvas canvas, String text, Offset position, Paint paint) {
    final rect = Rect.fromCenter(center: position, width: 100, height: 50);
    canvas.drawRect(rect, paint);
    _drawText(canvas, text, position, Colors.white);
  }

  void _drawEllipseNode(
      Canvas canvas, String text, Offset position, Paint paint) {
    final rect = Rect.fromCenter(center: position, width: 100, height: 50);
    canvas.drawOval(rect, paint);
    _drawText(canvas, text, position, Colors.white);
  }

  void _drawDiamondNode(
      Canvas canvas, String text, Offset position, Paint paint) {
    final path = Path()
      ..moveTo(position.dx, position.dy - 50)
      ..lineTo(position.dx + 50, position.dy)
      ..lineTo(position.dx, position.dy + 50)
      ..lineTo(position.dx - 50, position.dy)
      ..close();
    canvas.drawPath(path, paint);
    _drawText(canvas, text, position, Colors.white);
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
