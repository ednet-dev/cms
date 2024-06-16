import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/animation_manager.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/layout_algorithm.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/node.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/position_component.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/render_component.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/system.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/u_x_decorator.dart';
import 'package:flutter/material.dart';

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
    Offset domainPosition = positions[domain.code]!;
    Node domainNode = _createNode(domainPosition, Colors.blue);
    system.addNode(domainNode);

    for (var model in domain.models) {
      Offset modelPosition = positions[model.code]!;
      Node modelNode = _createNode(modelPosition, Colors.green);
      system.addNode(modelNode);

      for (var entity in model.concepts) {
        Offset entityPosition = positions[entity.code]!;
        Node entityNode = _createNode(entityPosition, Colors.red);
        system.addNode(entityNode);

        for (var child in entity.children) {
          Offset childPosition = positions[child.code]!;
          Node childNode = _createNode(childPosition, Colors.red);
          system.addNode(childNode);

          _drawLine(canvas, entityPosition, childPosition);
        }
      }
    }
  }

  Node _createNode(Offset position, Color color) {
    Node node = Node();
    node.addComponent(PositionComponent(position));
    node.addComponent(RenderComponent(
      Paint()..color = color,
      Rect.fromCenter(center: position, width: 100, height: 50),
    ));
    return node;
  }

  void _drawLine(Canvas canvas, Offset start, Offset end) {
    canvas.drawLine(
      start,
      end,
      Paint()..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
