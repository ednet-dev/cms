import 'package:flutter/material.dart';

import 'node.dart';
import 'position_component.dart';

class System {
  final List<Node> nodes = [];

  void addNode(Node node) {
    nodes.add(node);
  }

  void render(Canvas canvas) {
    for (var node in nodes) {
      for (var component in node.components.where(
        (component) => component is! TextComponent,
      )) {
        component.render(canvas);
      }
    }
  }

  void renderText(Canvas canvas) {
    for (var node in nodes) {
      for (var component in node.components.whereType<TextComponent>()) {
        component.render(canvas);
      }
    }
  }

  void update(double dt) {
    for (var node in nodes) {
      node.update(dt);
    }
  }
}
