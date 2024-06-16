import 'dart:math';
import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/layout_algorithm.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/tree_node.dart';

class RankedEmbeddingLayoutAlgorithm extends LayoutAlgorithm {
  final double nodeWidth = 100.0;
  final double nodeHeight = 50.0;
  final double verticalGap = 80.0;
  final double horizontalGap = 30.0;

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};

    for (var domain in domains) {
      final root = TreeNode(domain.code, Offset(size.width / 2, verticalGap));
      positions[domain.code] = root.position;
      _calculatePositions(
          root, domain.models.toList(), 0, size.width, positions);
    }

    return positions;
  }

  void _calculatePositions(TreeNode parent, List<Entity> collection,
      double xMin, double xMax, Map<String, Offset> positions) {
    if (collection.isEmpty) return;

    final y = parent.position.dy + verticalGap;
    final width = (xMax - xMin) / max(1, collection.length);

    for (var i = 0; i < collection.length; i++) {
      final item = collection[i];
      final x = xMin + i * width + width / 2;
      final childNode = TreeNode(item.code, Offset(x, y));
      parent.children.add(childNode);
      positions[childNode.key] = childNode.position;
      _calculatePositions(childNode, item.concept.children.toList(),
          xMin + i * width, xMin + (i + 1) * width, positions);
    }
  }
}
