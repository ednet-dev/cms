import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('EDNet Core Domain Model Tests', () {
    test('Domain and Model creation', () {
      // Create a domain
      var domain = Domain('TestDomain');
      expect(domain.code, equals('TestDomain'));

      // Create a model in the domain
      var model = Model(domain, 'TestModel');
      expect(model.code, equals('TestModel'));
      expect(domain.models.length, equals(1));
    });
  });
}
