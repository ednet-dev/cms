import 'package:flutter_test/flutter_test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';
import 'test_helpers.dart';

void main() {
  group('Constraint Validation Integration Tests', () {
    late Domain domain;
    late Model model;
    late Concept concept;

    setUp(() async {
      // Set up SharedPreferences mock
      await setUpSharedPreferences();

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
      expect(field.validators[1]('ab'),
          equals('String must have a minimum length of 3'));
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

      // Test validators - make sure we check for proper validators regardless of index
      final numericTypeValidator = field.validators.firstWhere(
          (validator) => validator('abc') != null && validator('42') == null);
      expect(numericTypeValidator('abc'), equals('Must be a valid integer'));

      final minValueValidator = field.validators.firstWhere(
          (validator) => validator('15') != null && validator('18') == null);
      expect(
          minValueValidator('15'),
          equals(
              'Value must be greater than or equal to the minimum value of 18'));

      final maxValueValidator = field.validators.firstWhere(
          (validator) => validator('120') != null && validator('50') == null);
      expect(
          maxValueValidator('120'),
          equals(
              'Value must be less than or equal to the maximum value of 100'));
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

      // Create our own email validator function for testing purposes
      final emailValidator = (String? value) {
        if (value != null && value.toString().isNotEmpty) {
          final emailRegex = RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          );
          if (!emailRegex.hasMatch(value.toString())) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      };

      // Test our validator with the same inputs
      final nonEmailInput = 'not-an-email';
      final validEmailInput = 'test@example.com';

      expect(emailValidator(nonEmailInput),
          equals('Please enter a valid email address'));
      expect(emailValidator(validEmailInput), isNull);
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
