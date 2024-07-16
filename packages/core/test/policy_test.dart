import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

import 'mock/test_entity_base.dart';

void main() {
  group('Policy Tests', () {
    final Domain domain = Domain('Test');
    late Model model;
    late PolicyRegistry registry;
    late PolicyEvaluator evaluator;
    late Entity testObject;
    late Concept testConcept;
    late Concept parentConcept;
    late Concept childConcept;

    late Entity user;
    late Concept userConcept;
    late Concept postConcept;
    late Concept commentConcept;

    late Entity citizen;
    late Concept citizenConcept;
    late Concept electionConcept;
    late Concept districtConcept;
    late Concept voteConcept;
    late Concept candidateConcept;

    setUp(() {
      registry = PolicyRegistry();
      evaluator = PolicyEvaluator(registry);
      model = Model(domain, 'Test');

      // Create concepts and their attributes
      parentConcept = Concept(model, 'ParentConcept');
      parentConcept.attributes.add(Attribute(parentConcept, 'parentType')
        ..type = AttributeType(domain, 'String'));

      testConcept = Concept(model, 'TestConcept');
      testConcept.attributes.add(
          Attribute(testConcept, 'age')..type = AttributeType(domain, 'int'));
      testConcept.attributes.add(Attribute(testConcept, 'name')
        ..type = AttributeType(domain, 'String'));

      childConcept = Concept(model, 'ChildConcept');
      childConcept.attributes.add(Attribute(childConcept, 'email')
        ..type = AttributeType(domain, 'String'));

      // Set parent and child relationships
      testConcept.parents.add(Parent(testConcept, parentConcept, 'parentType'));
      testConcept.children.add(Child(testConcept, childConcept, 'children'));

      // Set attributes for the child concept
      testConcept.attributes.add(Attribute(testConcept, 'email')
        ..type = AttributeType(domain, 'String'));

      // Set attributes for the parent concept
      testConcept.attributes.add(Attribute(testConcept, 'parentType')
        ..type = AttributeType(domain, 'String'));

      // Create a test entity
      testObject = TestEntity(testConcept);

      /// Direct democracy
      // Create concepts and their attributes
      userConcept = Concept(model, 'User');
      userConcept.attributes.add(
          Attribute(userConcept, 'age')..type = AttributeType(domain, 'int'));
      userConcept.attributes.add(Attribute(userConcept, 'name')
        ..type = AttributeType(domain, 'String'));
      userConcept.attributes.add(Attribute(userConcept, 'email')
        ..type = AttributeType(domain, 'String'));
      // posts

      postConcept = Concept(model, 'Post');
      postConcept.attributes.add(Attribute(postConcept, 'content')
        ..type = AttributeType(domain, 'String'));

      userConcept.children.add(Child(userConcept, postConcept, 'posts'));

      commentConcept = Concept(model, 'Comment');
      commentConcept.attributes.add(Attribute(commentConcept, 'content')
        ..type = AttributeType(domain, 'String'));

      // Set parent and child relationships
      postConcept.parents.add(Parent(postConcept, userConcept, 'author'));
      postConcept.children.add(Child(postConcept, commentConcept, 'comments'));
      commentConcept.parents.add(Parent(commentConcept, postConcept, 'post'));
      commentConcept.children
          .add(Child(commentConcept, commentConcept, 'replies'));

      // Create the test entity
      user = Entity<Concept>()..concept = userConcept;

      // Create concepts and their attributes
      citizenConcept = Concept(model, 'Citizen');
      citizenConcept.attributes.add(Attribute(citizenConcept, 'age')
        ..type = AttributeType(domain, 'int'));
      citizenConcept.attributes.add(Attribute(citizenConcept, 'nationality')
        ..type = AttributeType(domain, 'String'));
      citizenConcept.attributes.add(Attribute(citizenConcept, 'yearsInDistrict')
        ..type = AttributeType(domain, 'int'));
      citizenConcept.attributes.add(Attribute(citizenConcept, 'hasDebts')
        ..type = AttributeType(domain, 'bool'));
      citizenConcept.attributes.add(Attribute(citizenConcept, 'hasCourtCases')
        ..type = AttributeType(domain, 'bool'));
      citizenConcept.attributes.add(Attribute(citizenConcept, 'courtCaseType')
        ..type = AttributeType(domain, 'String'));

      electionConcept = Concept(model, 'Election');
      electionConcept.attributes.add(Attribute(electionConcept, 'name')
        ..type = AttributeType(domain, 'String'));

      districtConcept = Concept(model, 'District');
      districtConcept.attributes.add(Attribute(districtConcept, 'districtCode')
        ..type = AttributeType(domain, 'String'));
      districtConcept.attributes.add(Attribute(districtConcept, 'location')
        ..type = AttributeType(domain, 'String'));

      voteConcept = Concept(model, 'Vote');
      voteConcept.attributes.add(Attribute(voteConcept, 'candidate')
        ..type = AttributeType(domain, 'String'));

      candidateConcept = Concept(model, 'Candidate');
      candidateConcept.attributes.add(Attribute(candidateConcept, 'signatures')
        ..type = AttributeType(domain, 'int'));

      // Set parent and child relationships
      citizenConcept.children.add(Child(citizenConcept, voteConcept, 'votes'));
      voteConcept.parents.add(Parent(voteConcept, citizenConcept, 'citizen'));
      voteConcept.parents.add(Parent(voteConcept, electionConcept, 'election'));
      voteConcept.parents.add(Parent(voteConcept, districtConcept, 'district'));
      candidateConcept.parents
          .add(Parent(candidateConcept, electionConcept, 'election'));

      // Create the test entity
      citizen = Entity<Concept>()..concept = citizenConcept;
    });

    test('Basic Policy Evaluation', () {
      var policy = Policy(
          'AgePolicy',
          'Age must be greater than or equal to 18',
          (Entity e) => (e.getAttribute('age') as int? ?? 0) >= 18);
      registry.registerPolicy('AgePolicy', policy);

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

      testObject = Entity<Concept>()
        ..policyEvaluator = evaluator
        ..concept = testObject.concept;

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
      var parentConcept = Concept(model, 'ParentConcept');
      var childConcept = Concept(model, 'ChildConcept');
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
      // Define individual policies
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
          validator: AttributeValidators.isEmail);

      var parentTypePolicy = AttributePolicy(
          name: 'ParentTypePolicy',
          description: 'Parent type must be non-empty',
          attributeName: 'parentType',
          validator: AttributeValidators.isNotNull);

      // Composite policy 1 (all policies must pass)
      var compositePolicy1 = CompositePolicy(
          name: 'CompositePolicy1',
          description: 'Composite policy 1',
          policies: [agePolicy, namePolicy],
          type: CompositePolicyType.all);

      // Composite policy 2 (any policy must pass)
      var compositePolicy2 = CompositePolicy(
          name: 'CompositePolicy2',
          description: 'Composite policy 2',
          policies: [emailPolicy, parentTypePolicy],
          type: CompositePolicyType.any);

      // Composite policy of composite policies (complex expression)
      var complexCompositePolicy = CompositePolicy(
          name: 'ComplexCompositePolicy',
          description: 'Complex composite policy',
          policies: [compositePolicy1, compositePolicy2],
          type: CompositePolicyType.all);
      registry.clear();
      registry.registerPolicy('complexCompositePolicy', complexCompositePolicy);

      // Test scenario 1: All policies pass
      testObject.setAttribute('age', 25);
      testObject.setAttribute('name', 'John Doe');
      testObject.setAttribute('email', 'value_domain.com');
      testObject.setAttribute('parentType', 'type');
      var result = evaluator.evaluate(testObject);
      expect(result.success, isTrue);

      // Test scenario 2: One policy in compositePolicy1 fails
      testObject.setAttribute('age', 17);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');

      // Test scenario 3: All policies in compositePolicy2 fail
      testObject.setAttribute('age', 25);
      testObject.setAttribute('name', 'John Doe');
      testObject.setAttribute('email', null);
      testObject.setAttribute('parentType', null);
      result = evaluator.evaluate(testObject);
      expect(result.success, isFalse);
      expect(result.violations.length, 2);
      expect(result.violations[0].policyKey, 'ChildAttrPolicy');
      expect(result.violations[1].policyKey, 'ParentTypePolicy');
    });

    test('Complex CompositePolicy Evaluation', () {
      // Define individual policies
      var agePolicy = AttributePolicy(
          name: 'AgePolicy',
          description: 'Citizen must be at least 18 years old',
          attributeName: 'age',
          validator: AttributeValidators.isGreaterThan(18));

      var citizenshipPolicy = AttributePolicy(
          name: 'CitizenshipPolicy',
          description:
              'Citizen must be a citizen of AT or have lived 10 years in the district',
          attributeName: 'nationality',
          validator: (value) =>
              value == 'AT' ||
              citizen.getAttribute<int>('yearsInDistrict')! >= 10);

      var debtPolicy = AttributePolicy(
          name: 'DebtPolicy',
          description: 'Citizen must have no debts',
          attributeName: 'hasDebts',
          validator: (value) => value == false);

      var courtCasePolicy = AttributePolicy(
          name: 'CourtCasePolicy',
          description:
              'Citizen must have no court cases, or only non-criminal cases',
          attributeName: 'hasCourtCases',
          validator: (value) =>
              value == false ||
              citizen.getAttribute<String>('courtCaseType') != 'Criminal');

      var candidatePolicy = AttributePolicy(
          name: 'CandidatePolicy',
          description: 'Candidate must gather at least 1000 signatures',
          attributeName: 'signatures',
          validator: AttributeValidators.isGreaterThan(1000));

      // Composite policy for citizens
      var citizenCompositePolicy = CompositePolicy(
          name: 'CitizenCompositePolicy',
          description: 'Citizen must meet all criteria to vote',
          policies: [agePolicy, citizenshipPolicy, debtPolicy, courtCasePolicy],
          type: CompositePolicyType.all);

      // Composite policy for candidates
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
          type: CompositePolicyType.all);

      // Composite policy for overall validation
      var complexCompositePolicy = CompositePolicy(
          name: 'ComplexCompositePolicy',
          description: 'Overall validation for citizen and candidate',
          policies: [citizenCompositePolicy, candidateCompositePolicy],
          type: CompositePolicyType.all);

      registry.registerPolicy('complexCompositePolicy', complexCompositePolicy);

      // Test scenario 1: All policies pass
      citizen.setAttribute('age', 25);
      citizen.setAttribute('nationality', 'AT');
      citizen.setAttribute('yearsInDistrict', 5);
      citizen.setAttribute('hasDebts', false);
      citizen.setAttribute('hasCourtCases', false);
      var candidate = Entity<Concept>()..concept = candidateConcept;
      candidate.setAttribute('signatures', 10001);

      var result = evaluator.evaluate(citizen);
      if (!result.success) {
        print(result.violations);
      }
      expect(result.success, isTrue);

      result = evaluator.evaluate(candidate);
      expect(result.success, isTrue);

      // Test scenario 2: Age policy fails for citizen
      citizen.setAttribute('age', 17);
      result = evaluator.evaluate(citizen);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'AgePolicy');

      // Test scenario 3: Debt policy fails for candidate
      citizen.setAttribute('age', 25);
      citizen.setAttribute('hasDebts', true);
      candidate.setAttribute('signatures', 1000);
      result = evaluator.evaluate(citizen);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'DebtPolicy');

      result = evaluator.evaluate(candidate);
      expect(result.success, isFalse);
      expect(result.violations.length, 1);
      expect(result.violations[0].policyKey, 'DebtPolicy');
    });
  });
}
