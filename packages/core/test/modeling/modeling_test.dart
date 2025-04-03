import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Model Testing', () {
    late Model model;
    late Domain domain;

    setUp(() {
      // Initialize domain and model before each test
      domain = Domain('TestDomain');
      model = Model(domain, 'TestModel');
    });

    test('Model should be initialized with empty concepts', () {
      expect(model.concepts, isEmpty);
    });

    test('Model should have correct domain and code', () {
      expect(model.domain, equals(domain));
      expect(model.code, equals('TestModel'));
    });

    test('Model should have policy registry and evaluator initialized', () {
      expect(model.policyRegistry, isNotNull);
      expect(model.policyEvaluator, isNotNull);
    });

    test('Model should be added to domain models', () {
      expect(domain.models.contains(model), isTrue);
    });
  });
}
