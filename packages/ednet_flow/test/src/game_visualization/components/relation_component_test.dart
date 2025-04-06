import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_flow/src/game_visualization/components/relation_component.dart';
import 'package:ednet_flow/src/game_visualization/model/domain_model.dart';
import 'package:ednet_flow/src/game_visualization/util/point.dart';

void main() {
  group('RelationComponent', () {
    test('should create a relation component with the provided values', () {
      // ARRANGE
      const id = 'test-relation';
      const name = 'Test Relation';
      const description = 'A test relation';
      const sourceId = 'source-entity';
      const targetId = 'target-entity';
      const type = RelationType.association;
      const color = 0xFF0000FF; // Blue
      const isBidirectional = true;
      final labels = {'source': 'Source Label', 'target': 'Target Label'};
      final waypoints = [const Point(10, 10), const Point(20, 20)];

      // ACT
      final relation = RelationComponent(
        id: id,
        name: name,
        description: description,
        sourceId: sourceId,
        targetId: targetId,
        type: type,
        color: color,
        isBidirectional: isBidirectional,
        labels: labels,
        waypoints: waypoints,
      );

      // ASSERT
      expect(relation.id, equals(id));
      expect(relation.name, equals(name));
      expect(relation.description, equals(description));
      expect(relation.sourceId, equals(sourceId));
      expect(relation.targetId, equals(targetId));
      expect(relation.type, equals(type));
      expect(relation.color, equals(color));
      expect(relation.isBidirectional, equals(isBidirectional));
      expect(relation.labels, equals(labels));
      expect(relation.waypoints, equals(waypoints));
    });

    test('should convert relation component to JSON and back', () {
      // ARRANGE
      final relation = RelationComponent(
        id: 'test-relation',
        name: 'Test Relation',
        description: 'A test relation',
        sourceId: 'source-entity',
        targetId: 'target-entity',
        type: RelationType.composition,
        color: 0xFFFF0000, // Red
        isBidirectional: true,
        labels: {'source': 'Source Label', 'target': 'Target Label'},
        waypoints: [const Point(10, 10), const Point(20, 20)],
      );

      // ACT
      final json = relation.toJson();
      final recreatedRelation = RelationComponent.fromJson(json);

      // ASSERT
      expect(recreatedRelation.id, equals(relation.id));
      expect(recreatedRelation.name, equals(relation.name));
      expect(recreatedRelation.description, equals(relation.description));
      expect(recreatedRelation.sourceId, equals(relation.sourceId));
      expect(recreatedRelation.targetId, equals(relation.targetId));
      expect(recreatedRelation.type, equals(relation.type));
      expect(recreatedRelation.color, equals(relation.color));
      expect(
        recreatedRelation.isBidirectional,
        equals(relation.isBidirectional),
      );
      expect(recreatedRelation.labels, equals(relation.labels));
      expect(
        recreatedRelation.waypoints.length,
        equals(relation.waypoints.length),
      );
      for (var i = 0; i < relation.waypoints.length; i++) {
        expect(
          recreatedRelation.waypoints[i].x,
          equals(relation.waypoints[i].x),
        );
        expect(
          recreatedRelation.waypoints[i].y,
          equals(relation.waypoints[i].y),
        );
      }
    });

    test('should convert relation component to domain relation', () {
      // ARRANGE
      final relation = RelationComponent(
        id: 'test-relation',
        name: 'Test Relation',
        sourceId: 'source-entity',
        targetId: 'target-entity',
        type: RelationType.association,
        color: 0xFF0000FF,
      );

      // ACT
      final domainRelation = relation.toDomainRelation();

      // ASSERT
      expect(domainRelation.name, equals(relation.name));
      expect(domainRelation.destinationEntityName, equals(relation.targetId));
    });
  });
}
