import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('Policy Tests', () {
    final Domain domain = Domain();
    late Model model;
    late PolicyRegistry registry;
    late PolicyEvaluator evaluator;
    late Entity testEntity;

    setUp(() {
      registry = PolicyRegistry();
      evaluator = PolicyEvaluator(registry);
      model = Model(domain, 'Test');
      // Create a test concept and entity
      var concept = Concept(model, 'TestConcept');
      concept.attributes.add(Attribute(concept, 'age')
        ..type = AttributeType(Domain('Test'), 'int'));
      testEntity = Entity<Concept>()..concept = concept;
    });

    test('Basic Policy Evaluation', () {
      var policy = Policy(
          'AgePolicy',
          'Age must be greater than or equal to 18',
          (Entity e) => (e.getAttribute('age') as int? ?? 0) >= 18);
      registry.registerPolicy('agePolicy', policy);

      testEntity.setAttribute('age', 20);
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      testEntity.setAttribute('age', 15);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'agePolicy');
    });

    test('Multiple Policy Evaluation', () {
      registry.registerPolicy(
          'agePolicy',
          Policy('AgePolicy', 'Age must be greater than or equal to 18',
              (Entity e) => (e.getAttribute('age') as int? ?? 0) >= 18));

      registry.registerPolicy(
          'evenAgePolicy',
          Policy('EvenAgePolicy', 'Age must be an even number',
              (Entity e) => ((e.getAttribute('age') as int? ?? 0) % 2) == 0));

      testEntity.setAttribute('age', 20);
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      testEntity.setAttribute('age', 19);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'evenAgePolicy');

      testEntity.setAttribute('age', 17);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 2);
    });

    test('Policy Evaluation in Entity', () {
      registry.registerPolicy(
          'agePolicy',
          Policy('AgePolicy', 'Age must be greater than or equal to 18',
              (Entity e) => (e.getAttribute('age') as int? ?? 0) >= 18));

      testEntity = Entity<Concept>()
        ..policyEvaluator = evaluator
        ..concept = testEntity.concept;

      expect(() => testEntity.setAttribute('age', 15),
          throwsA(isA<PolicyViolationException>()));

      testEntity.setAttribute('age', 20);
      expect(testEntity.getAttribute('age'), 20);
    });
  });
}
