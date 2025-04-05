import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_flow/src/game_visualization/visualization_game.dart';
import 'package:ednet_flow/src/game_visualization/model/domain_model.dart';
import 'package:ednet_flow/src/game_visualization/util/point.dart';
import 'package:ednet_flow/src/game_visualization/components/relation_component.dart';

void main() {
  group('VisualizationGame', () {
    test(
      'should initialize with default values when created with empty domain model',
      () {
        // ARRANGE
        final domainModel = DomainModel();

        // ACT
        final game = VisualizationGame(domainModel: domainModel);

        // ASSERT
        expect(game.domainModel, equals(domainModel));
        expect(game.entities, isEmpty);
        expect(game.relations, isEmpty);
        expect(game.zoom, equals(1.0));
        expect(game.cameraOffset, equals(const Point(0, 0)));
        expect(game.editMode, isFalse);
      },
    );

    test('should create entity and relation components from domain model', () {
      // ARRANGE
      final domainModel = DomainModel();

      // Create test entities and relations
      final entityA = Entity(name: 'EntityA', concept: Concept(entry: true));
      final entityB = Entity(name: 'EntityB');

      // Add relation from A to B
      entityA.addRelation(
        Relation(name: 'relates_to', destinationEntityName: 'EntityB'),
      );

      domainModel.addEntity(entityA);
      domainModel.addEntity(entityB);

      // ACT
      final game = VisualizationGame.fromDomainModel(domainModel);

      // ASSERT
      expect(game.domainModel, equals(domainModel));
      expect(game.entities.length, equals(2));
      expect(game.relations.length, equals(1));

      // Verify entity properties
      final createdEntityA = game.entities.firstWhere((e) => e.id == 'EntityA');
      expect(createdEntityA.isAggregateRoot, isTrue);

      final createdEntityB = game.entities.firstWhere((e) => e.id == 'EntityB');
      expect(createdEntityB.isAggregateRoot, isFalse);

      // Verify relation properties
      final relation = game.relations.first;
      expect(relation.sourceId, equals('EntityA'));
      expect(relation.targetId, equals('EntityB'));
      expect(relation.name, equals('relates_to'));
      expect(relation.type, equals(RelationType.association));
    });
  });
}
