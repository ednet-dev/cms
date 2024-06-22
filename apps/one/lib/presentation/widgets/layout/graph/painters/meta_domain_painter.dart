import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/animations/animation_manager.dart';
import 'package:flutter/material.dart';

import '../components/node.dart';
import '../components/position_component.dart';
import '../components/render_component.dart';
import '../components/system.dart';
import '../decorators/u_x_decorator.dart';
import '../layout/layout_algorithm.dart';

Node _createNode(Offset position, Color color) {
  Node node = Node();
  node.addComponent(PositionComponent(position));
  node.addComponent(RenderComponent(
    Paint()..color = color,
    Rect.fromCenter(center: position, width: 100, height: 50),
  ));
  return node;
}

class MetaDomainPainter extends CustomPainter {
  final Domains domains;
  final TransformationController transformationController;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;
  final bool isDragging;
  final System system;
  final AnimationManager animationManager;

  MetaDomainPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutAlgorithm,
    required this.decorators,
    required this.isDragging,
    required this.system,
    required this.animationManager,
  });

  void _drawLine(Canvas canvas, Offset start, Offset end) {
    canvas.drawLine(
      start,
      end,
      Paint()..color = Colors.black,
    );
  }

  void _drawText(Canvas canvas, String text, Offset position) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 100,
    );
    final offset = Offset(position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final positions = layoutAlgorithm.calculateLayout(domains, size);
    system.nodes.clear();

    for (var domain in domains) {
      _paintDomain(canvas, domain, positions);
    }

    system.render(canvas);
  }

  void _paintDomain(
      Canvas canvas, Domain domain, Map<String, Offset> positions) {
    final domainPosition = positions[domain.code];
    if (domainPosition == null) return;

    Node domainNode = _createNode(domainPosition, Colors.orange);
    system.addNode(domainNode);
    _drawText(canvas, domain.code, domainPosition);

    for (var model in domain.models) {
      final modelPosition = positions[model.code];
      if (modelPosition == null) continue;

      Node modelNode = _createNode(modelPosition, Colors.lightBlue);
      system.addNode(modelNode);
      _drawText(canvas, model.code, modelPosition);

      for (var concept in model.concepts) {
        final entityPosition = positions[concept.code];
        if (entityPosition == null) continue;

        Node entityNode = _createNode(entityPosition, Colors.red);
        system.addNode(entityNode);
        _drawText(canvas, concept.code, entityPosition);

        for (var child in concept.children) {
          final childPosition = positions[child.code];
          if (childPosition == null) continue;

          Node childNode = _createNode(childPosition, Colors.black);
          system.addNode(childNode);
          _drawText(canvas, child.code, childPosition);

          _drawLine(canvas, entityPosition, childPosition);
        }

        _drawLine(canvas, modelPosition, entityPosition);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
