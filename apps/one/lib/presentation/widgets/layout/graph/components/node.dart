import 'package:flutter/material.dart';

import 'position_component.dart';

class Node {
  final List<Component> components = [];

  void addComponent(Component component) {
    components.add(component);
  }

  void update(double dt) {
    for (var component in components) {
      component.update(dt);
    }
  }

  void render(Canvas canvas) {
    for (var component in components) {
      component.render(canvas);
    }
  }
}
