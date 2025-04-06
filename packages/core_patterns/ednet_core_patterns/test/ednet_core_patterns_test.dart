import 'package:ednet_core_patterns/ednet_core_patterns.dart';
import 'package:test/test.dart';

void main() {
  group('Core Patterns Tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('EDNet Core Patterns initialized correctly', () {
      expect(awesome.isAwesome, isTrue);
    });
  });
}
