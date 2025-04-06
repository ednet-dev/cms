import 'package:ednet_core_patterns/ednet_core_patterns.dart';
import 'package:test/test.dart';

void main() {
  group('Canonical Data Model Pattern', () {
    test('Converts between formats using canonical model', () {
      // Create an instance of a canonical model
      final canonicalUser = CanonicalModel<Map<String, dynamic>>(
        type: 'user',
        data: {
          'id': '123',
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john.doe@example.com',
          'age': 30,
        },
      );

      // Create formatters for different systems
      final systemAFormatter = SystemAFormatter();
      final systemBFormatter = SystemBFormatter();

      // System A has a different format (snake_case fields, combined name)
      final systemAFormat = systemAFormatter.toExternalFormat(canonicalUser);
      expect(systemAFormat, {
        'user_id': '123',
        'full_name': 'John Doe',
        'email_address': 'john.doe@example.com',
        'user_age': 30,
      });

      // System B has another format (camelCase, different field names)
      final systemBFormat = systemBFormatter.toExternalFormat(canonicalUser);
      expect(systemBFormat, {
        'userId': '123',
        'userName': 'John Doe',
        'contactInfo': {'emailAddress': 'john.doe@example.com'},
        'userDetails': {'ageInYears': 30},
      });

      // Convert from system formats back to canonical model
      final fromSystemA = systemAFormatter.fromExternalFormat(systemAFormat);
      final fromSystemB = systemBFormatter.fromExternalFormat(systemBFormat);

      // Both should represent the same user
      expect(fromSystemA.type, equals('user'));
      expect(fromSystemB.type, equals('user'));
      expect(fromSystemA.data['id'], equals('123'));
      expect(fromSystemB.data['id'], equals('123'));
      expect(fromSystemA.data['firstName'], equals('John'));
      expect(fromSystemB.data['firstName'], equals('John'));
      expect(fromSystemA.data['lastName'], equals('Doe'));
      expect(fromSystemB.data['lastName'], equals('Doe'));
    });

    test('Serializes to and from JSON correctly', () {
      final canonicalAddress = CanonicalModel<Map<String, dynamic>>(
        type: 'address',
        data: {
          'street': '123 Main St',
          'city': 'Anytown',
          'postalCode': '12345',
          'country': 'Exampleland',
        },
      );

      // Serialize to JSON string
      final json = canonicalAddress.toJson();

      // Deserialize from JSON string
      final restored = CanonicalModel.fromJson(json);

      // Should be equal to original
      expect(restored.type, equals(canonicalAddress.type));
      expect(restored.data, equals(canonicalAddress.data));
    });

    test('Validates models against schema', () {
      // Define a schema for the user model
      final userSchema = {
        'type': 'object',
        'required': ['id', 'firstName', 'lastName', 'email'],
        'properties': {
          'id': {'type': 'string'},
          'firstName': {'type': 'string'},
          'lastName': {'type': 'string'},
          'email': {'type': 'string', 'format': 'email'},
          'age': {'type': 'number', 'minimum': 0},
        },
      };

      // Create validator with schema
      final validator = ModelValidator(schemas: {'user': userSchema});

      // Valid model
      final validUser = CanonicalModel<Map<String, dynamic>>(
        type: 'user',
        data: {
          'id': '123',
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john.doe@example.com',
          'age': 30,
        },
      );

      // Invalid model (missing required field)
      final invalidUser = CanonicalModel<Map<String, dynamic>>(
        type: 'user',
        data: {
          'id': '123',
          'firstName': 'John',
          // missing lastName
          'email': 'john.doe@example.com',
          'age': 30,
        },
      );

      // Invalid model (wrong type)
      final typeInvalidUser = CanonicalModel<Map<String, dynamic>>(
        type: 'user',
        data: {
          'id': '123',
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john.doe@example.com',
          'age': 'thirty', // Should be a number
        },
      );

      expect(validator.validate(validUser), isTrue);
      expect(validator.validate(invalidUser), isFalse);
      expect(validator.validate(typeInvalidUser), isFalse);

      // Check error messages
      validator.validate(invalidUser);
      expect(validator.errors.first, contains('lastName'));

      validator.validate(typeInvalidUser);
      expect(validator.errors.first, contains('age'));
    });
  });
}
