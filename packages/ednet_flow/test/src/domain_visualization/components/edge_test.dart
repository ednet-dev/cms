import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_flow/ednet_flow.dart';
import 'package:flutter/material.dart' as material;

void main() {
  group('Edge', () {
    late Node sourceNode;
    late Node targetNode;

    setUp(() {
      // Create test nodes to use in edge tests
      sourceNode = Node(
        id: 'source-node',
        label: 'Source',
        type: NodeType.entity,
        position: const Offset(0, 0),
        color: material.Colors.blue,
      );

      targetNode = Node(
        id: 'target-node',
        label: 'Target',
        type: NodeType.entity,
        position: const Offset(100, 100),
        color: material.Colors.red,
      );
    });

    test('should create an edge with the provided values', () {
      // ARRANGE
      const id = 'test-edge';
      const label = 'Test Edge';
      const description = 'A test edge';
      const type = EdgeType.association;
      const direction = EdgeDirection.leftToRight;
      final color = material.Colors.green;
      const width = 2.0;
      const isDashed = true;
      final properties = {'key': 'value'};

      // ACT
      final edge = Edge(
        id: id,
        label: label,
        description: description,
        source: sourceNode,
        target: targetNode,
        type: type,
        direction: direction,
        color: color,
        width: width,
        isDashed: isDashed,
        properties: properties,
      );

      // ASSERT
      expect(edge.id, equals(id));
      expect(edge.label, equals(label));
      expect(edge.description, equals(description));
      expect(edge.source, equals(sourceNode));
      expect(edge.target, equals(targetNode));
      expect(edge.type, equals(type));
      expect(edge.direction, equals(direction));
      expect(edge.color, equals(color));
      expect(edge.width, equals(width));
      expect(edge.isDashed, equals(isDashed));
      expect(edge.properties, equals(properties));
      expect(edge.relation, isNull);
    });
  });
}
