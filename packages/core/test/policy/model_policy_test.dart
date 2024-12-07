import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

import '../mock/test_entity_base.dart';

void main() {
  final Domain domain = Domain('Test');
  late Model model;
  late Entity testEntity;
  late Concept concept = testEntity.concept;
  late TestDomain testDomain;

  setUp(() {
    model = Model(domain, 'TestModel');
    testDomain = TestDomain(domain);
    testEntity = TestEntity(testDomain.testConcept);

    concept.attributes
        .add(Attribute(concept, 'age')..type = AttributeType(domain, 'int'));
    concept.attributes.add(
        Attribute(concept, 'name')..type = AttributeType(domain, 'String'));
    model.concepts.add(concept);
  });

  test('Entity Attribute Change Policy Evaluation', () {
    var agePolicy = AttributePolicy(
        name: 'Age Policy',
        description: 'Age must be between 18 and 100',
        attributeName: 'age',
        validator: AttributeValidators.isBetween(18, 100));

    model.registerPolicy('agePolicy', agePolicy);

    expect(() => testEntity.setAttribute('age', 1), returnsNormally);
    expect(testEntity.getAttribute('age'), equals(1));

    expect(() => testEntity.setAttribute('age', 15),
        throwsA(isA<PolicyViolationException>()));
    expect(testEntity.getAttribute('age'), equals(25));
  });

  test('Entity Parent Change Policy Evaluation', () {
    var parentConcept = testDomain.parentConcept;
    model.concepts.add(parentConcept);
    var parent = TestEntity(parentConcept);

    var parentPolicy = RelationshipPolicy(
        name: 'Parent Policy',
        description: 'Entity must have a parent',
        relationshipName: 'parent',
        relationshipType: RelationshipType.parent,
        validator: RelationshipValidators.isNotNull);

    model.registerPolicy('parentPolicy', parentPolicy);

    expect(() => testEntity.setParent('parent', parent), returnsNormally);
    expect(testEntity.getParent('parent'), equals(parent));

    expect(() => testEntity.setParent('parent', null),
        throwsA(isA<PolicyViolationException>()));
    expect(testEntity.getParent('parent'), equals(parent));
  });

  // Add more tests for child changes and other scenarios...
}
