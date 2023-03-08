import 'dart:math';
import 'package:ednet_one/src/ui/cms_graph/model/edge.dart';
import 'package:ednet_one/src/ui/cms_graph/model/node.dart';
import 'package:flutter/material.dart';

class CMSCanvas extends StatelessWidget {
  final List<Node> nodes;
  final List<Edge> edges;

  CMSCanvas({
    super.key,
    required this.nodes,
    required this.edges,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CMSGraphPainter(nodes, edges),
      child: Container(),
    );
  }
}

class CMSGraphPainter extends CustomPainter {
  final List<Node> nodes;
  final List<Edge> edges;

  CMSGraphPainter(
    this.nodes,
    this.edges,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Render nodes and edges
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    for (var i = 0; i < nodes.length; i++) {
      final angle = 2 * pi * i / nodes.length;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      final node = nodes[i];
      // Render node
      canvas.drawCircle(Offset(x, y), node.size, node.paint);
      // Render node label
      final textSpan = TextSpan(text: node.label, style: node.textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    for (var edge in edges) {
      final sourceNode =
          nodes[nodes.indexWhere((node) => node.id == edge.source?.id)];
      final targetNode =
          nodes[nodes.indexWhere((node) => node.id == edge.target.id)];
      final sourceX = center.dx + radius * cos(sourceNode.angle);
      final sourceY = center.dy + radius * sin(sourceNode.angle);
      final targetX = center.dx + radius * cos(targetNode.angle);
      final targetY = center.dx + radius * sin(targetNode.angle);
      // Render edge.dart
      canvas.drawLine(
          Offset(sourceX, sourceY), Offset(targetX, targetY), edge.paint);
      // Render edge.dart label
      final textSpan = TextSpan(
        text: edge.label,
        style: edge.textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final x = (sourceX + targetX) / 2;
      final y = (sourceY + targetY) / 2;
      textPainter.paint(canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
