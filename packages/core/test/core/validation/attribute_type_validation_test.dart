import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('AttributeType with constraints', () {
    late Domain domain;

    setUp(() {
      domain = Domain('TestDomain');
    });

    group('Numeric constraints', () {
      test('should validate integer with min/max constraints', () {
        // Arrange
        var intType = domain.getType('int')!;
        intType.setMinValue(5);
        intType.setMaxValue(10);

        // Act & Assert
        expect(intType.validateValue(5), isTrue);
        expect(intType.validateValue(7), isTrue);
        expect(intType.validateValue(10), isTrue);
        expect(intType.validateValue(4), isFalse);
        expect(intType.validateValue(11), isFalse);
        expect(intType.validateValue('not an int'), isFalse);
      });

      test('should validate double with min/max constraints', () {
        // Arrange
        var doubleType = domain.getType('double')!;
        doubleType.setMinValue(1.5);
        doubleType.setMaxValue(5.5);

        // Act & Assert
        expect(doubleType.validateValue(1.5), isTrue);
        expect(doubleType.validateValue(3.0), isTrue);
        expect(doubleType.validateValue(5.5), isTrue);
        expect(doubleType.validateValue(1.4), isFalse);
        expect(doubleType.validateValue(5.6), isFalse);
      });

      test('should provide validation error messages for invalid numbers', () {
        // Arrange
        var intType = domain.getType('int')!;
        intType.setMinValue(5);
        intType.setMaxValue(10);

        // Act
        expect(intType.validateValue(4), isFalse);

        // Assert
        var errorMessage = intType.getValidationError();
        expect(errorMessage, isNotNull);
        expect(errorMessage, contains('minimum value of 5'));

        // Act again with a different error
        expect(intType.validateValue(11), isFalse);

        // Assert
        errorMessage = intType.getValidationError();
        expect(errorMessage, isNotNull);
        expect(errorMessage, contains('maximum value of 10'));
      });
    });

    group('String constraints', () {
      test('should validate string with length constraints', () {
        // Arrange
        var stringType = domain.getType('String')!;
        stringType.setMinLength(3);
        // The default maxLength is already set to the type's length property (64)

        // Act & Assert
        expect(stringType.validateValue('abc'), isTrue);
        expect(stringType.validateValue('abcdef'), isTrue);
        expect(stringType.validateValue('ab'), isFalse);
        expect(stringType.validateValue(123), isFalse); // not a string
      });

      test('should validate string with pattern constraint', () {
        // Arrange
        var stringType = domain.getType('String')!;
        stringType.setPattern(r'^[a-zA-Z0-9]+$');

        // Act & Assert
        expect(stringType.validateValue('abc123'), isTrue);
        expect(stringType.validateValue('ABC'), isTrue);
        expect(stringType.validateValue('123'), isTrue);
        expect(stringType.validateValue('abc-123'), isFalse);
        expect(stringType.validateValue('abc 123'), isFalse);
      });

      // Email validation test
      test('should validate email type', () {
        // Note: The native type only checks if it's a string
        // The constraint validator is activated when requested
        var emailType = domain.getType('Email')!;

        // Basic type validation (just ensures it's a string)
        expect(emailType.validateValue('test@example.com'), isTrue);
        expect(
          emailType.validateValue('invalid'),
          isTrue,
        ); // This passes because it's a string
        expect(emailType.validateValue(123), isFalse); // Not a string

        // Get validator with format checking
        var validator = TypeConstraintValidator.forEmail();
        expect(validator.validate('test@example.com'), isTrue);
        expect(validator.validate('user.name+tag@example.co.uk'), isTrue);
        expect(validator.validate('invalid'), isFalse);
        expect(validator.validate('invalid@'), isFalse);
        expect(validator.validate('@example.com'), isFalse);
      });

      // URL validation test using the validator directly
      test('should validate URLs with the TypeConstraintValidator', () {
        var validator = TypeConstraintValidator.forUrl();
        expect(validator.validate('https://example.com'), isTrue);
        expect(
          validator.validate('http://subdomain.example.co.uk/path'),
          isTrue,
        );
        expect(validator.validate('invalid'), isFalse);
        expect(validator.validate('example.com'), isFalse); // missing protocol
      });
    });

    group('Complex type validation', () {
      test('should combine multiple constraints correctly', () {
        // Arrange - Create a string type with both length and pattern constraints
        var stringType = domain.getType('String')!;
        stringType.setMinLength(3);
        stringType.setPattern(r'^[A-Z][a-z]+$');

        // Act & Assert - Test various values against both constraints
        expect(
          stringType.validateValue('Alice'),
          isTrue,
        ); // Valid: Starts with uppercase, all letters, length >= 3
        expect(stringType.validateValue('Ab'), isFalse); // Invalid: Too short
        expect(
          stringType.validateValue('alice'),
          isFalse,
        ); // Invalid: Doesn't start with uppercase
        expect(
          stringType.validateValue('A1ice'),
          isFalse,
        ); // Invalid: Contains numbers

        // Check error messages
        stringType.validateValue('Ab');
        expect(
          stringType.getValidationError(),
          contains('minimum length of 3'),
        );

        stringType.validateValue('alice');
        expect(stringType.getValidationError(), contains('pattern'));
      });
    });
  });
}
