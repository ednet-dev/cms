import 'package:flutter/material.dart';

import '../../layout/graph/components/node.dart';
import '../../layout/graph/components/position_component.dart';

/// A painter specifically responsible for painting relation lines in the canvas.
///
/// This class handles the creation and rendering of relationships between entities,
/// including the visual representation of connections and their labels.
class RelationPainter {
  final BuildContext context;

  RelationPainter({required this.context});

  /// Creates a line node connecting two points with bidirectional labels
  Node createLineNode(
    Offset start,
    Offset end,
    String fromToName,
    String toFromName,
  ) {
    Node node = Node();
    node.addComponent(
      LineComponent(
        start: start,
        end: end,
        fromToName: fromToName,
        toFromName: toFromName,
        fromTextStyle: Theme.of(context).textTheme.labelSmall!,
        toTextStyle: Theme.of(context).textTheme.labelSmall!,
      ),
    );
    return node;
  }
}
