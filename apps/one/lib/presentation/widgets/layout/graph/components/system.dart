import 'dart:ui';

import 'node.dart';

class System {
  final List<Node> nodes = [];

  void addNode(Node node) {
    nodes.add(node);
  }

  void update(double dt) {
    for (var node in nodes) {
      node.update(dt);
    }
  }

  void render(Canvas canvas) {
    for (var node in nodes) {
      node.render(canvas);
    }
  }
}
