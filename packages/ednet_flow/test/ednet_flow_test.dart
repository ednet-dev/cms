import 'package:flutter_test/flutter_test.dart';

import 'src/domain_visualization/components/node_test.dart' as node_test;
import 'src/domain_visualization/components/edge_test.dart' as edge_test;
import 'src/game_visualization/visualization_game_test.dart'
    as visualization_game_test;
import 'src/game_visualization/util/point_test.dart' as point_test;
import 'src/game_visualization/components/relation_component_test.dart'
    as relation_component_test;

void main() {
  group('ednet_flow', () {
    // Domain visualization tests
    group('domain_visualization', () {
      node_test.main();
      edge_test.main();
    });

    // Game visualization tests
    group('game_visualization', () {
      visualization_game_test.main();
      point_test.main();
      relation_component_test.main();
    });
  });
}
