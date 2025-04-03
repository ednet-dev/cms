import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Domain Model Tests', () {
    test('Domain creation', () {
      final domain = Domain('TestDomain');
      expect(domain, isNotNull);
      expect(domain.code, equals('TestDomain'));
    });

    test('Model creation', () {
      final domain = Domain('TestDomain');
      final model = Model(domain, 'TestModel');
      expect(model, isNotNull);
      expect(model.code, equals('TestModel'));
      expect(domain.models.length, equals(1));
      expect(domain.models.first, equals(model));
    });
  });
}
