import 'dart:ui';
import 'package:ednet_core/ednet_core.dart';

import '../layout/layout_algorithm.dart';

class GridLayoutAlgorithm extends LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};

    double x = 50;
    double y = 50;
    const double stepX = 200;
    const double stepY = 100;

    for (var domain in domains) {
      positions[domain.code] = Offset(x, y);
      y += stepY;

      for (var model in domain.models) {
        positions[model.code] = Offset(x + stepX, y);
        y += stepY;

        for (var entity in model.concepts) {
          positions[entity.code] = Offset(x + 2 * stepX, y);
          y += stepY;
        }

        y += stepY;
      }

      x += 3 * stepX;
      y = 50;
    }

    return positions;
  }
}
