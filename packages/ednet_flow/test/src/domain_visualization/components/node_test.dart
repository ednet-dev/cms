import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_flow/ednet_flow.dart';
import 'package:flutter/material.dart';

void main() {
  group('Node', () {
    test('should create a node with the provided values', () {
      // ARRANGE
      const id = 'test-node';
      const label = 'Test Node';
      const description = 'A test node';
      const type = NodeType.entity;
      final position = const Offset(10, 20);
      const size = 60.0;
      final color = Colors.blue;
      final properties = {'key': 'value'};

      // ACT
      final node = Node(
        id: id,
        label: label,
        description: description,
        type: type,
        position: position,
        size: size,
        color: color,
        properties: properties,
      );

      // ASSERT
      expect(node.id, equals(id));
      expect(node.label, equals(label));
      expect(node.description, equals(description));
      expect(node.type, equals(type));
      expect(node.position, equals(position));
      expect(node.size, equals(size));
      expect(node.color, equals(color));
      expect(node.properties, equals(properties));
      expect(node.entity, isNull);
    });
  });
}
