import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

import 'mock/concrete_entity.dart';

void main() {
  group('Policy Tests', () {
    final Domain domain = Domain();
    late Model model;
    late PolicyRegistry registry;
    late PolicyEvaluator evaluator;
    late Entity testEntity;
    late Concept testConcept;
    late Concept parentConcept;
    late Concept childConcept;

    setUp(() {
      registry = PolicyRegistry();
      evaluator = PolicyEvaluator(registry);
      model = Model(domain, 'Test');

      // Create concepts and their attributes
      parentConcept = Concept(model, 'ParentConcept');
      parentConcept.attributes.add(Attribute(parentConcept, 'parentType')
        ..type = AttributeType(Domain('Test'), 'String'));

      testConcept = Concept(model, 'TestConcept');
      testConcept.attributes.add(Attribute(testConcept, 'age')
        ..type = AttributeType(Domain('Test'), 'int'));
      testConcept.attributes.add(Attribute(testConcept, 'name')
        ..type = AttributeType(
            Domain('Test'), 'String'));

      childConcept = Concept(model, 'ChildConcept');
      childConcept.attributes.add(Attribute(childConcept, 'childAttr')
        ..type = AttributeType(Domain('Test'), 'String'));

      // Set parent and child relationships
      testConcept.parents.add(Parent(testConcept, parentConcept, 'parentType'));
      testConcept.children.add(Child(testConcept, childConcept, 'children'));

      // Create the test entity / ConcreteEntity
      testEntity = ConcreteEntity(testConcept);
    });

    test('Basic Policy Evaluation', () {
      var policy = Policy(
          'AgePolicy',
          'Age must be greater than or equal to 18',
          (Entity e) => (e.getAttribute('age') as int? ?? 0) >= 18);
      registry.registerPolicy('AgePolicy', policy);

      testEntity.setAttribute('age', 20);
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      testEntity.setAttribute('age', 15);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');
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
      expect(result.violations[0].policyKey, 'EvenAgePolicy');

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

    test('AttributePolicy Evaluation', () {
      var agePolicy = AttributePolicy(
          name: 'AgePolicy',
          description: 'Age must be between 18 and 100',
          attributeName: 'age',
          validator: AttributeValidators.isBetween(18, 100));
      registry.registerPolicy('agePolicy', agePolicy);

      testEntity.setAttribute('age', 25);
      var result = evaluator.evaluate(testEntity);
      expect(result.success, isTrue);

      testEntity.setAttribute('age', 15);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');

      testEntity.setAttribute('age', 105);
      result = evaluator.evaluate(testEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');
    });

    test('RelationshipPolicy Evaluation', () {
      var parentConcept = Concept(model, 'ParentConcept');
      var childConcept = Concept(model, 'ChildConcept');
      parentConcept.children
          .add(Child(parentConcept, childConcept, 'children'));

      var parentEntity = ConcreteEntity(parentConcept);
      var childEntities = ConcreteEntities(childConcept);

      var childCountPolicy = RelationshipPolicy(
          name: 'Child Count Policy',
          description: 'Entity must have at least 2 children',
          relationshipName: 'children',
          relationshipType: RelationshipType.child,
          validator: RelationshipValidators.hasMinimumChildren(2));
      registry.registerPolicy('childCountPolicy', childCountPolicy);

      parentEntity.setChild('children', childEntities);

      var result = evaluator.evaluate(parentEntity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Child Count Policy');

      childEntities.add(ConcreteEntity(childConcept));
      childEntities.add(ConcreteEntity(childConcept));

      result = evaluator.evaluate(parentEntity);
      expect(result.success, isTrue);
    });

    test('CompositePolicy Evaluation', () {
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
}
