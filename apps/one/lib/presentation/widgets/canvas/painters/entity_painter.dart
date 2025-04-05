import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import '../../layout/graph/components/node.dart';
import '../../layout/graph/components/position_component.dart';
import '../../layout/graph/components/system.dart';

/// A painter specifically responsible for painting entity nodes in the canvas.
///
/// This class handles the creation and rendering of entity visual elements,
/// including their color calculations and appearance.
class EntityPainter {
  final BuildContext context;
  final String? selectedNode;

  EntityPainter({required this.context, this.selectedNode});

  /// Creates a node at the specified position with the given color and label
  Node createNode(Offset position, Color color, String label) {
    bool isSelected = label == selectedNode;
    Node node = Node();
    node.addComponent(
      RenderComponent(
        Paint()..color = color,
        Rect.fromCenter(center: position, width: 100, height: 50),
        glow: isSelected ? 10.0 : 0.0,
      ),
    );
    node.addComponent(
      TextComponent(
        text: label,
        position: position,
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(color: Colors.white),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
    );
    return node;
  }

  /// Calculate a color for a domain based on its level in the hierarchy
  Color getColorForDomain(Domain domain, int level, double maxLevel) {
    double hue = (domain.hashCode % 360).toDouble();
    double saturation = 0.7;
    double brightness = (0.9 - (level / maxLevel) * 0.5).clamp(0.0, 1.0);
    return HSVColor.fromAHSV(1.0, hue, saturation, brightness).toColor();
  }
}
