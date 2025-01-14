import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

import '../mock/test_entity_base.dart';

void main() {
  group('Policy Tests', () {
    final Domain domain = Domain('Test');
    // late Model model;
    late PolicyRegistry registry;
    late PolicyEvaluator evaluator;
    late TestDomain testDomain;

    setUp(() {
      registry = PolicyRegistry();
      evaluator = PolicyEvaluator(registry);
      testDomain = TestDomain(domain);

      // model = testDomain.testModel;
    });

    test('Basic Policy Evaluation', () {
      var policy = Policy(
          'AgePolicy',
          'Age must be greater than or equal to 18',
          (Entity e) => (e.getAttribute('age') as int? ?? 0) >= 18);
      registry.registerPolicy('AgePolicy', policy);

      var testObject = TestEntity(testDomain.testConcept);
      testObject.setAttribute('age', 20);
      var result = evaluator.evaluate(testObject);
      expect(result.success, isTrue);

      testObject.setAttribute('age', 15);
      result = evaluator.evaluate(testObject);
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

      var testObject = TestEntity(testDomain.testConcept);
      testObject.setAttribute('age', 20);
      var result = evaluator.evaluate(testObject);
      expect(result.success, isTrue);

      testObject.setAttribute('age', 19);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'EvenAgePolicy');

      testObject.setAttribute('age', 17);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 2);
    });

    test('Policy Evaluation in Entity', () {
      registry.registerPolicy(
          'agePolicy',
          Policy('AgePolicy', 'Age must be greater than or equal to 18',
              (Entity e) => (e.getAttribute('age') as int? ?? 0) >= 18));

      var testObject = TestEntity(testDomain.testConcept)
        ..policyEvaluator = evaluator
        ..concept = testDomain.testConcept;

      expect(() => testObject.setAttribute('age', 15),
          throwsA(isA<PolicyViolationException>()));

      testObject.setAttribute('age', 20);
      expect(testObject.getAttribute('age'), 20);
    });

    test('AttributePolicy Evaluation', () {
      var agePolicy = AttributePolicy(
          name: 'AgePolicy',
          description: 'Age must be between 18 and 100',
          attributeName: 'age',
          validator: AttributeValidators.isBetween(18, 100));
      registry.registerPolicy('agePolicy', agePolicy);

      var testObject = TestEntity(testDomain.testConcept);
      testObject.setAttribute('age', 25);
      var result = evaluator.evaluate(testObject);
      expect(result.success, isTrue);

      testObject.setAttribute('age', 15);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');

      testObject.setAttribute('age', 105);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');
    });

    test('RelationshipPolicy Evaluation', () {
      var parentConcept = testDomain.parentConcept;
      var childConcept = testDomain.childConcept;
      parentConcept.children
          .add(Child(parentConcept, childConcept, 'children'));

      var parentEntity = TestEntity(parentConcept);
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

      childEntities.add(TestEntity(childConcept));
      childEntities.add(TestEntity(childConcept));

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

      var testObject = TestEntity(testDomain.testConcept);
      testObject.setAttribute('age', 25);
      testObject.setAttribute('name', 'John Doe');
      var result = evaluator.evaluate(testObject);
      expect(result.success, isTrue);

      testObject.setAttribute('age', 15);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Age Policy');

      testObject.setAttribute('age', 25);
      testObject.setAttribute('name', null);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'Name Policy');

      testObject.setAttribute('age', 15);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 2);
    });

    test('Complex CompositePolicy Evaluation', () {
      var agePolicy = AttributePolicy(
          name: 'AgePolicy',
          description: 'Age must be between 18 and 100',
          attributeName: 'age',
          validator: AttributeValidators.isBetween(18, 100));

      var namePolicy = AttributePolicy(
          name: 'NamePolicy',
          description: 'Name must not be empty',
          attributeName: 'name',
          validator: AttributeValidators.isNotNull);

      var emailPolicy = AttributePolicy(
          name: 'ChildAttrPolicy',
          description: 'Child attribute must be non-empty',
          attributeName: 'email',
          validator: AttributeValidators.isEmail,
          scope: PolicyScope({'TestEntity'}));

      var parentTypePolicy = AttributePolicy(
          name: 'ParentTypePolicy',
          description: 'Parent type must be non-empty',
          attributeName: 'parentType',
          validator: AttributeValidators.isNotNull);

      var compositePolicy1 = CompositePolicy(
          name: 'CompositePolicy1',
          description: 'Composite policy 1',
          policies: [agePolicy, namePolicy],
          type: CompositePolicyType.all);

      var compositePolicy2 = CompositePolicy(
          name: 'CompositePolicy2',
          description: 'Composite policy 2',
          policies: [emailPolicy, parentTypePolicy],
          type: CompositePolicyType.any);

      var complexCompositePolicy = CompositePolicy(
          name: 'ComplexCompositePolicy',
          description: 'Complex composite policy',
          policies: [compositePolicy1, compositePolicy2],
          type: CompositePolicyType.all);
      registry.clear();
      registry.registerPolicy('complexCompositePolicy', complexCompositePolicy);

      var testObject = TestEntity(testDomain.testConcept);
      testObject.setAttribute('age', 25);
      testObject.setAttribute('name', 'John Doe');
      testObject.setAttribute('email', 'value_domain.com');
      testObject.setAttribute('parentType', 'type');
      var result = evaluator.evaluate(testObject);
      expect(result.success, isTrue);

      testObject.setAttribute('age', 17);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');

      testObject.setAttribute('age', 25);
      testObject.setAttribute('name', 'John Doe');
      testObject.setAttribute('email', null);
      testObject.setAttribute('parentType', null);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'ParentTypePolicy');
    });

    test('Complex CompositePolicy Evaluation for Citizen and Candidate', () {
      var citizenScope = PolicyScope({'Citizen', 'Candidate'});
      var candidateScope = PolicyScope({'Candidate'});

      var agePolicy = AttributePolicy(
        name: 'AgePolicy',
        description: 'Person must be at least 18 years old',
        attributeName: 'age',
        validator: AttributeValidators.isGreaterThan(18),
      );

      var citizenshipPolicy = AttributePolicy(
        name: 'CitizenshipPolicy',
        description:
            'Citizen must be a citizen of AT or have lived 10 years in the district',
        attributeName: 'nationality',
        validator: (value) =>
            value == 'AT' ||
            testDomain.citizen.getAttribute<int>('yearsInDistrict')! >= 10,
        scope: citizenScope,
      );

      var debtPolicy = AttributePolicy(
        name: 'DebtPolicy',
        description: 'Citizen must have no debts',
        attributeName: 'hasDebts',
        validator: (value) => value == false,
        scope: citizenScope,
      );

      var courtCasePolicy = AttributePolicy(
        name: 'CourtCasePolicy',
        description:
            'Citizen must have no court cases, or only non-criminal cases',
        attributeName: 'hasCourtCases',
        validator: (value) =>
            value == false ||
            testDomain.citizen.getAttribute<String>('courtCaseType') !=
                'Criminal',
        scope: citizenScope,
      );

      var candidatePolicy = AttributePolicy(
        name: 'CandidatePolicy',
        description: 'Candidate must gather at least 1000 signatures',
        attributeName: 'signatures',
        validator: AttributeValidators.isGreaterThan(1000),
        scope: candidateScope,
      );

      var citizenCompositePolicy = CompositePolicy(
        name: 'CitizenCompositePolicy',
        description: 'Citizen must meet all criteria to vote',
        policies: [agePolicy, citizenshipPolicy, debtPolicy, courtCasePolicy],
        type: CompositePolicyType.all,
        scope: citizenScope,
      );

      var candidateCompositePolicy = CompositePolicy(
        name: 'CandidateCompositePolicy',
        description: 'Candidate must meet all criteria to run',
        policies: [
          agePolicy,
          citizenshipPolicy,
          debtPolicy,
          courtCasePolicy,
          candidatePolicy
        ],
        type: CompositePolicyType.all,
        scope: candidateScope,
      );

      var complexCompositePolicy = CompositePolicy(
        name: 'ComplexCompositePolicy',
        description: 'Overall validation for citizen and candidate',
        policies: [citizenCompositePolicy, candidateCompositePolicy],
        type: CompositePolicyType.all,
        // No scope - applies to all entities
      );

      registry.registerPolicy('complexCompositePolicy', complexCompositePolicy);

      var citizen = Citizen(testDomain.citizenConcept);
      citizen.setAttribute('age', 25);
      citizen.setAttribute('nationality', 'AT');
      citizen.setAttribute('yearsInDistrict', 5);
      citizen.setAttribute('hasDebts', false);
      citizen.setAttribute('hasCourtCases', false);

      var candidate = Candidate(testDomain.candidateConcept);
      candidate.setAttribute('age', 30);
      candidate.setAttribute('nationality', 'AT');
      candidate.setAttribute('yearsInDistrict', 10);
      candidate.setAttribute('hasDebts', false);
      candidate.setAttribute('hasCourtCases', false);
      candidate.setAttribute('signatures', 1001);

      var result = evaluator.evaluate(citizen);
      expect(result.success, isTrue);

      result = evaluator.evaluate(candidate);
      expect(result.success, isTrue);

      citizen.setAttribute('age', 17);
      result = evaluator.evaluate(citizen);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');

      citizen.setAttribute('age', 25);
      citizen.setAttribute('hasDebts', true);
      candidate.setAttribute('signatures', 900);
      result = evaluator.evaluate(citizen);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'DebtPolicy');

      result = evaluator.evaluate(candidate);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);

      expect(result.violations.any((v) => v.policyKey == 'CandidatePolicy'),
          isTrue);
    });

    test('CompositePolicyType.all', () {
      var policy1 = AttributePolicy(
        name: 'JohnDoePolicy',
        description: 'Attribute "name" must be "John Doe"',
        attributeName: 'name',
        validator: (value) => value == 'John Doe',
        scope: PolicyScope({'TestConcept'}),
      );

      var policy2 = AttributePolicy(
        name: 'Policy2',
        description: 'Attribute "age" must be greater than 18',
        attributeName: 'age',
        validator: (value) => (value as int) > 18,
        scope: PolicyScope({'TestConcept'}),
      );

      var compositePolicy = CompositePolicy(
        name: 'AllPolicy',
        description: 'All policies must pass',
        policies: [policy1, policy2],
        type: CompositePolicyType.all,
        scope: PolicyScope({'TestConcept'}),
      );

      registry.registerPolicy('AllPolicy', compositePolicy);

      var entity = TestEntity(testDomain.testConcept);
      entity.setAttribute('age', 25);
      entity.setAttribute('name', 'John Doe');

      var result = evaluator.evaluate(entity);
      expect(result.success, isTrue);
      entity.setAttribute('name', 'John Does');

      result = evaluator.evaluate(entity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'JohnDoePolicy');
    });

    test('CompositePolicyType.none', () {
      var johnDoePolicy = AttributePolicy(
        name: 'JohnDoePolicy',
        description: 'Attribute "name" must be "John Does"',
        attributeName: 'name',
        validator: (value) => value == 'John Does',
        scope: PolicyScope({'TestConcept'}),
      );

      var policy2 = AttributePolicy(
        name: 'Policy2',
        description: 'Attribute "age" must be less than 18',
        attributeName: 'age',
        validator: (value) => (value as int) < 18,
        scope: PolicyScope({'TestConcept'}),
      );

      var compositePolicy = CompositePolicy(
        name: 'NonePolicy',
        description: 'No policies should pass',
        policies: [johnDoePolicy, policy2],
        type: CompositePolicyType.none,
        scope: PolicyScope({'TestConcept'}),
      );

      registry.clear();
      registry.registerPolicy('NonePolicy', compositePolicy);

      var entity = TestEntity(testDomain.testConcept);
      entity.setAttribute('name', 'John Doe');
      entity.setAttribute('age', 25);

      var result = evaluator.evaluate(entity);
      expect(result.success, isTrue);

      entity.setAttribute('age', 15);
      result = evaluator.evaluate(entity);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'JohnDoePolicy');
    });

    test('CompositePolicyType.majority', () {
      var johnDoePolicy = AttributePolicy(
        name: 'JohnDoePolicy',
        description: 'Attribute "name" must be John Doe',
        attributeName: 'name',
        validator: (value) => value == 'John Doe',
        scope: PolicyScope({'TestConcept'}),
      );

      var policy2 = AttributePolicy(
        name: 'Policy2',
        description: 'Attribute "age" must be greater than 18',
        attributeName: 'age',
        validator: (value) => (value as int) > 18,
        scope: PolicyScope({'TestConcept'}),
      );

      var policy3 = AttributePolicy(
        name: 'Policy3',
        description: 'Attribute "email" must be "active"',
        attributeName: 'email',
        validator: (value) => value == 'active',
        scope: PolicyScope({'TestConcept'}),
      );

      var compositePolicy = CompositePolicy(
        name: 'MajorityPolicy',
        description: 'More than half of the policies must pass',
        policies: [johnDoePolicy, policy2, policy3],
        type: CompositePolicyType.majority,
        scope: PolicyScope({'TestConcept'}),
      );

      registry.registerPolicy('MajorityPolicy', compositePolicy);

      var entity = TestEntity(testDomain.testConcept);
      entity.setAttribute('name', 'John Doe');
      entity.setAttribute('age', 25);
      entity.setAttribute('email', 'inactive');

      var result = evaluator.evaluate(entity);
      expect(result.success, isTrue);

      entity.setAttribute('name', 'John Does');
      result = evaluator.evaluate(entity);
      expect(result.success, isFalse);
      expect(result.violations.length, 2);
      expect(result.violations[0].policyKey, 'JohnDoePolicy');
      expect(result.violations[1].policyKey, 'Policy3');

      entity.setAttribute('age', 15);
      result = evaluator.evaluate(entity);
      expect(result.success, isFalse);
      expect(result.violations.length, 3);
    });
  });
}
