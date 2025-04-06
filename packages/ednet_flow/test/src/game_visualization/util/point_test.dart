import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_flow/src/game_visualization/util/point.dart';

void main() {
  group('Point', () {
    test('should create a point with the provided coordinates', () {
      // ARRANGE & ACT
      const point = Point(10.0, 20.0);

      // ASSERT
      expect(point.x, equals(10.0));
      expect(point.y, equals(20.0));
    });

    test('should create a point from JSON', () {
      // ARRANGE
      final json = {'x': 10.0, 'y': 20.0};

      // ACT
      final point = Point.fromJson(json);

      // ASSERT
      expect(point.x, equals(10.0));
      expect(point.y, equals(20.0));
    });

    test('should convert a point to JSON', () {
      // ARRANGE
      const point = Point(10.0, 20.0);

      // ACT
      final json = point.toJson();

      // ASSERT
      expect(json, equals({'x': 10.0, 'y': 20.0}));
    });

    test('should correctly compare two points for equality', () {
      // ARRANGE
      const point1 = Point(10.0, 20.0);
      const point2 = Point(10.0, 20.0);
      const point3 = Point(30.0, 40.0);

      // ASSERT
      expect(point1, equals(point2));
      expect(point1, isNot(equals(point3)));
    });
  });
}
