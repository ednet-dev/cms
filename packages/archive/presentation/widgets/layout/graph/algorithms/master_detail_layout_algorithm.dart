import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';

class MasterDetailLayoutAlgorithm extends LayoutAlgorithm {
  final double nodeWidth;
  final double nodeHeight;
  final double levelGap;

  MasterDetailLayoutAlgorithm({
    this.nodeWidth = 200.0,
    this.nodeHeight = 100.0,
    this.levelGap = 50.0,
  });

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    double currentX = levelGap;
    double currentY = levelGap;

    for (var domain in domains) {
      positions[domain.code] = Offset(currentX, currentY);

      for (var model in domain.models) {
        currentY += nodeHeight + levelGap;
        positions[model.code] = Offset(currentX, currentY);

        for (var entity in model.concepts) {
          currentY += nodeHeight + levelGap;
          positions[entity.code] = Offset(
            currentX + nodeWidth + levelGap,
            currentY,
          );

          for (var child in entity.children) {
            currentY += nodeHeight + levelGap;
            positions[child.code] = Offset(
              currentX + 2 * (nodeWidth + levelGap),
              currentY,
            );
          }
        }
      }
      currentX += 3 * (nodeWidth + levelGap);
      currentY = levelGap;
    }

    return positions;
  }
}
