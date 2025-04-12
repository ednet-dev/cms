import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import 'test_helpers.dart';

void main() {
  group('Constraint Validation Integration Tests', () {
    late Domain domain;
    late Model model;
    late Concept concept;

    setUp(() {
      // Set up domain model with a test concept
      domain = Domain('TestDomain');
      model = Model(domain, 'TestModel');
      concept = Concept(model, 'TestEntity');
    });

    test('Should generate validators for string attributes with constraints',
        () {
      // Create string attribute with constraints
      final attribute = Attribute(concept, 'name');
      attribute.required = true;
      attribute.type = domain.getType('String');
      (attribute.type as AttributeType).setMinLength(3);

      // Create field descriptor
      final field = UXFieldBuilder.buildField(attribute);

      // Verify field properties
      expect(field.fieldName, equals('name'));
      expect(field.fieldType, equals(UXFieldType.text));
      expect(field.validators.length, greaterThan(0));

      // Test validators
      expect(field.validators[0](null), equals('This field is required'));
      expect(field.validators[1]('ab'), contains('characters'));
      expect(field.validators[1]('abc'), isNull);
    });

    test('Should generate validators for numeric attributes with constraints',
        () {
      // Create numeric attribute with constraints
      final attribute = Attribute(concept, 'age');
      attribute.required = true;
      attribute.type = domain.getType('int');
      (attribute.type as AttributeType).setMinValue(18);
      (attribute.type as AttributeType).setMaxValue(100);

      // Create field descriptor
      final field = UXFieldBuilder.buildField(attribute);

      // Verify field properties
      expect(field.fieldName, equals('age'));
      expect(field.fieldType, equals(UXFieldType.number));

      // Test validators
      expect(field.validators[1]('abc'), contains('valid integer'));
      expect(field.validators[2]('15'), contains('at least'));
      expect(field.validators[2]('18'), isNull);
      expect(field.validators[3]('120'), contains('at most'));
      expect(field.validators[3]('50'), isNull);
    });

    test('Should generate validators for email attributes', () {
      // Create email attribute
      final attribute = Attribute(concept, 'email');
      attribute.required = true;
      attribute.type = domain.getType('Email');

      // Create field descriptor
      final field = UXFieldBuilder.buildField(attribute);

      // Verify field properties
      expect(field.fieldName, equals('email'));
      expect(field.fieldType, equals(UXFieldType.text));

      // Test validators
      expect(field.validators[1]('not-an-email'), contains('valid email'));
      expect(field.validators[1]('test@example.com'), isNull);
    });

    test('Should create form fields from entire concept', () {
      // Create multiple attributes with various constraints
      final nameAttr = Attribute(concept, 'name');
      nameAttr.type = domain.getType('String');
      (nameAttr.type as AttributeType).setMinLength(2);

      final ageAttr = Attribute(concept, 'age');
      ageAttr.type = domain.getType('int');
      (ageAttr.type as AttributeType).setMinValue(18);

      final emailAttr = Attribute(concept, 'email');
      emailAttr.type = domain.getType('Email');

      // Generate form fields
      final fields = UXFieldBuilder.buildFormFromConcept(concept);

      // Verify fields
      expect(fields.length, equals(3));
      expect(fields.any((f) => f.fieldName == 'name'), isTrue);
      expect(fields.any((f) => f.fieldName == 'age'), isTrue);
      expect(fields.any((f) => f.fieldName == 'email'), isTrue);
    });
  });
}
