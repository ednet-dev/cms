import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  late PolicyRegistry registry;
  late PolicyEvaluator evaluator;
  late Entity testEntity;
  late Domain domain;
  late Model model;
  late Concept testConcept;

  setUp(() {
    domain = Domain('Test');
    model = Model(domain, 'TestModel');
    registry = PolicyRegistry();
    evaluator = PolicyEvaluator(registry);

    testConcept = Concept(model, 'TestConcept');
    testConcept.attributes.add(Attribute(testConcept, 'age')
      ..type = AttributeType(Domain('Test'), 'int'));
    testConcept.attributes.add(Attribute(testConcept, 'name')
      ..type = AttributeType(Domain('Test'), 'String'));
    testEntity = Entity<Concept>()..concept = testConcept;
  });

  group('AttributePolicy Tests', () {
    test('Age Policy', () {
      var agePolicy = AttributePolicy(
          name: 'Age Policy',
          description: 'Age must be between 18 and 100',
          attributeName: 'age',
          validator: AttributeValidators.isBetween(18, 100));
      registry.registeruditPolicy('agePolicy', agePolicy);

      testEntity.setAttribute('age', 25);
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      testEntity.setAttribute('age', 15);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Age Policy');

      testEntity.setAttribute('age', 105);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Age Policy');
    });

    test('Name Policy', () {
      var namePolicy = AttributePolicy(
          name: 'Name Policy',
          description: 'Name must not be empty',
          attributeName: 'name',
          validator: AttributeValidators.isNotNull);
      registry.registerPolicy('namePolicy', namePolicy);

      testEntity.setAttribute('name', 'John Doe');
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      testEntity.setAttribute('name', null);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Name Policy');
    });
  });

  group('RelationshipPolicy Tests', () {
    late Concept parentConcept;
    late Concept childConcept;
    late Entity parentEntity;
    late Entities childEntities;

    setUp(() {
      parentConcept = Concept(model, 'ParentConcept');
      childConcept = Concept(model, 'ChildConcept');
      parentConcept.children
          .add(Child(parentConcept, childConcept, 'children'));

      parentEntity = Entity<Concept>()..concept = parentConcept;
      childEntities = Entities<Concept>()..concept = childConcept;
      parentEntity.setChild('children', childEntities);
    });

    test('Child Count Policy', () {
      var childCountPolicy = RelationshipPolicy(
          name: 'Child Count Policy',
          description: 'Entity must have at least 2 children',
          relationshipName: 'children',
          relationshipType: RelationshipType.child,
          validator: RelationshipValidators.hasMinimumChildren(2));
      registry.registerPolicy('childCountPolicy', childCountPolicy);

      var result = evaluator.evaluate(parentEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Child Count Policy');

      childEntities.add(Entity<Concept>()..concept = childConcept);
      childEntities.add(Entity<Concept>()..concept = childConcept);

      result = evaluator.evaluate(parentEntity);
      expect(result.success, isTrue);
    });
  });

  group('CompositePolicy Tests', () {
    test('All Policies', () {
      var agePolicy = AttributePolicy(
          name: 'Age Policy',
          description: 'Age must be between 18 and 100',
          attributeName: 'age',
          validator: AttributeValidators.isBetween(18, 100));

      var namePolicy = AttributePolicy(
          name: 'Name Policy',
          description: 'Name must not be empty',
          attributeName: 'name',
          validator: AttributeValidators.isNotNull);

      var compositePolicy = CompositePolicy(
          name: 'User Validation Policy',
          description: 'Composite policy for user validation',
          policies: [agePolicy, namePolicy],
          type: CompositePolicyType.all);

      registry.registerPolicy('userValidationPolicy', compositePolicy);

      testEntity.setAttribute('age', 25);
      testEntity.setAttribute('name', 'John Doe');
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      testEntity.setAttribute('age', 15);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Age Policy');

      testEntity.setAttribute('age', 25);
      testEntity.setAttribute('name', null);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Name Policy');

      testEntity.setAttribute('age', 15);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 2);
    });
  });

  group('TimeBasedPolicy Tests', () {
    late TestClock clock;

    setUp(() {
      clock = TestClock(DateTime(2023, 1, 1));
    });

    test('Expiration Policy', () {
      var expirationPolicy = TimeBasedPolicy(
          name: 'Expiration Policy',
          description: 'Entity must not be expired',
          timeAttributeName: 'expirationDate',
          validator: TimeValidators.isAfter(Duration.zero),
          clock: clock);

      registry.registerPolicy('expirationPolicy', expirationPolicy);

      testEntity.setAttribute('expirationDate', DateTime(2023, 1, 2));
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      clock.advance(Duration(days: 2));
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Expiration Policy');
    });

    test('Within Last Week Policy', () {
      var withinLastWeekPolicy = TimeBasedPolicy(
          name: 'Within Last Week Policy',
          description: 'Entity must have been created within the last week',
          timeAttributeName: 'creationDate',
          validator: TimeValidators.isWithinLast(Duration(days: 7)),
          clock: clock);

      registry.registerPolicy('withinLastWeekPolicy', withinLastWeekPolicy);

      testEntity.setAttribute(
          'creationDate', clock.now().subtract(Duration(days: 3)));
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      clock.advance(Duration(days: 5));
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Within Last Week Policy');
    });
  });
}

class TestClock implements Clock {
  DateTime _now;

  TestClock(this._now);

  @override
  DateTime now() => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}
