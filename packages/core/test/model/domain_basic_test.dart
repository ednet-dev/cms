import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart'; // Import the main library

void main() {
  group('Basic Domain Model Tests', () {
    test('Domain creation', () {
      final domain = Domain('TestDomain');
      expect(domain, isNotNull);
      expect(domain.code, equals('TestDomain'));
    });

    test('Model creation in domain', () {
      final domain = Domain('TestDomain');
      final model = Model(domain, 'TestModel');
      expect(model, isNotNull);
      expect(model.code, equals('TestModel'));
      expect(domain.models.contains(model), isTrue);
    });
  });
} 