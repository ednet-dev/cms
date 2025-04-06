import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

class TestEntity extends Entity<TestEntity> {
  TestEntity() : super();
}

void main() {
  group('Attribute Validation Testing', () {
    late Domain domain;
    late Model model;
    late Concept concept;
    late Entities<TestEntity> entities;

    setUp(() {
      domain = Domain('TestDomain');
      model = Model(domain, 'TestModel');
      concept = Concept(model, 'TestConcept');
      entities = Entities<TestEntity>();
      entities.concept = concept;
    });

    test('Type validation should enforce correct value types', () {
      final attribute = Attribute(concept, 'testAttribute');
      final intType = domain.getType('int');
      attribute.type = intType;
      concept.attributes.add(attribute);

      final entity = TestEntity();
      entity.concept = concept;
      entity.setAttribute('testAttribute', 42);
      expect(entities.isValid(entity), isTrue);

      entity.setAttribute('testAttribute', 'not an int');
      expect(entities.isValid(entity), isFalse);
      expect(entities.exceptions.length, greaterThan(0));
      expect(entities.exceptions.toList()[0].category, equals('type'));
    });

    test('Required attribute should not accept null values', () {
      final attribute = Attribute(concept, 'testAttribute');
      attribute.required = true;
      concept.attributes.add(attribute);

      final entity = TestEntity();
      entity.concept = concept;
      expect(entities.isValid(entity), isFalse);
      expect(entities.exceptions.length, greaterThan(0));
      expect(entities.exceptions.toList()[0].category, equals('required'));
    });

    test('String length validation should enforce maximum length', () {
      final attribute = Attribute(concept, 'testAttribute');
      final stringType = domain.getType('String');
      attribute.type = stringType;
      attribute.length = 5;
      concept.attributes.add(attribute);

      final entity = TestEntity();
      entity.concept = concept;
      entity.setAttribute('testAttribute', '12345');
      expect(entities.isValid(entity), isTrue);

      entity.setAttribute('testAttribute', '123456');
      expect(entities.isValid(entity), isFalse);
      expect(entities.exceptions.length, greaterThan(0));
      expect(entities.exceptions.toList()[0].category, equals('length'));
    });

    test('Derived attribute should not be updatable', () {
      final attribute = Attribute(concept, 'testAttribute');
      attribute.derive = true;
      concept.attributes.add(attribute);

      final entity = TestEntity();
      entity.concept = concept;
      entity.setAttribute('testAttribute', 'value');
      expect(entities.isValid(entity), isFalse);
      expect(entities.exceptions.length, greaterThan(0));
      expect(entities.exceptions.toList()[0].category, equals('update'));
    });

    test('Attribute with increment should validate sequence', () {
      final attribute = Attribute(concept, 'testAttribute');
      final intType = domain.getType('int');
      attribute.type = intType;
      attribute.increment = 1;
      concept.attributes.add(attribute);

      final entity1 = TestEntity();
      entity1.concept = concept;
      entity1.setAttribute('testAttribute', 1);
      expect(entities.isValid(entity1), isTrue);
      entities.add(entity1);

      final entity2 = TestEntity();
      entity2.concept = concept;
      entity2.setAttribute('testAttribute', 2);
      expect(entities.isValid(entity2), isTrue);
      entities.add(entity2);

      final entity3 = TestEntity();
      entity3.concept = concept;
      entity3.setAttribute('testAttribute', 4); // Skipping 3
      expect(entities.isValid(entity3), isFalse);
      expect(entities.exceptions.length, greaterThan(0));
      expect(entities.exceptions.toList()[0].category, equals('increment'));
    });

    test('Email type should validate email format', () {
      final attribute = Attribute(concept, 'testAttribute');
      final emailType = domain.getType('Email');
      attribute.type = emailType;
      concept.attributes.add(attribute);

      final entity = TestEntity();
      entity.concept = concept;
      entity.setAttribute('testAttribute', 'test@example.com');
      expect(entities.isValid(entity), isTrue);

      entity.setAttribute('testAttribute', 'not-an-email');
      expect(entities.isValid(entity), isFalse);
      expect(entities.exceptions.length, greaterThan(0));
      expect(entities.exceptions.toList()[0].category, equals('format'));
    });

    test('DateTime type should validate date format', () {
      final attribute = Attribute(concept, 'testAttribute');
      final dateTimeType = domain.getType('DateTime');
      attribute.type = dateTimeType;
      concept.attributes.add(attribute);

      final entity = TestEntity();
      entity.concept = concept;
      entity.setAttribute('testAttribute', DateTime.now());
      expect(entities.isValid(entity), isTrue);

      entity.setAttribute('testAttribute', 'not-a-date');
      expect(entities.isValid(entity), isFalse);
      expect(entities.exceptions.length, greaterThan(0));
      expect(entities.exceptions.toList()[0].category, equals('type'));
    });

    test('Boolean type should validate boolean values', () {
      final attribute = Attribute(concept, 'testAttribute');
      final boolType = domain.getType('bool');
      attribute.type = boolType;
      concept.attributes.add(attribute);

      final entity = TestEntity();
      entity.concept = concept;
      entity.setAttribute('testAttribute', true);
      expect(entities.isValid(entity), isTrue);

      entity.setAttribute('testAttribute', 'not-a-bool');
      expect(entities.isValid(entity), isFalse);
      expect(entities.exceptions.length, greaterThan(0));
      expect(entities.exceptions.toList()[0].category, equals('type'));
    });
  });
}
