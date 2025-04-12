import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('TypeConstraintValidator', () {
    // Test for numeric constraints
    group('Numeric constraints', () {
      test('should validate minimum value', () {
        // Arrange
        final validator = TypeConstraintValidator.forInt(min: 5);

        // Act & Assert
        expect(validator.validate(10), isTrue);
        expect(validator.validate(5), isTrue);
        expect(validator.validate(4), isFalse);
        expect(validator.validate(null), isTrue); // null is valid by default
      });

      test('should validate maximum value', () {
        // Arrange
        final validator = TypeConstraintValidator.forInt(max: 10);

        // Act & Assert
        expect(validator.validate(5), isTrue);
        expect(validator.validate(10), isTrue);
        expect(validator.validate(11), isFalse);
      });

      test('should validate value in range', () {
        // Arrange
        final validator = TypeConstraintValidator.forInt(min: 5, max: 10);

        // Act & Assert
        expect(validator.validate(5), isTrue);
        expect(validator.validate(7), isTrue);
        expect(validator.validate(10), isTrue);
        expect(validator.validate(4), isFalse);
        expect(validator.validate(11), isFalse);
      });

      test('should validate double values', () {
        // Arrange
        final validator = TypeConstraintValidator.forDouble(min: 1.5, max: 5.5);

        // Act & Assert
        expect(validator.validate(1.5), isTrue);
        expect(validator.validate(3.0), isTrue);
        expect(validator.validate(5.5), isTrue);
        expect(validator.validate(1.4), isFalse);
        expect(validator.validate(5.6), isFalse);
      });
    });

    // Test for string constraints
    group('String constraints', () {
      test('should validate minimum length', () {
        // Arrange
        final validator = TypeConstraintValidator.forString(minLength: 3);

        // Act & Assert
        expect(validator.validate('abc'), isTrue);
        expect(validator.validate('abcd'), isTrue);
        expect(validator.validate('ab'), isFalse);
        expect(validator.validate(''), isFalse);
      });

      test('should validate maximum length', () {
        // Arrange
        final validator = TypeConstraintValidator.forString(maxLength: 5);

        // Act & Assert
        expect(validator.validate('abc'), isTrue);
        expect(validator.validate('abcde'), isTrue);
        expect(validator.validate('abcdef'), isFalse);
      });

      test('should validate string in length range', () {
        // Arrange
        final validator = TypeConstraintValidator.forString(
          minLength: 3,
          maxLength: 5,
        );

        // Act & Assert
        expect(validator.validate('abc'), isTrue);
        expect(validator.validate('abcd'), isTrue);
        expect(validator.validate('abcde'), isTrue);
        expect(validator.validate('ab'), isFalse);
        expect(validator.validate('abcdef'), isFalse);
      });

      test('should validate string against pattern', () {
        // Arrange
        final validator = TypeConstraintValidator.forString(
          pattern: r'^[a-zA-Z0-9]+$',
        );

        // Act & Assert
        expect(validator.validate('abc123'), isTrue);
        expect(validator.validate('ABC'), isTrue);
        expect(validator.validate('123'), isTrue);
        expect(validator.validate('abc-123'), isFalse);
        expect(validator.validate('abc 123'), isFalse);
      });

      test('should validate email format', () {
        // Arrange
        final validator = TypeConstraintValidator.forEmail();

        // Act & Assert
        expect(validator.validate('test@example.com'), isTrue);
        expect(validator.validate('user.name+tag@example.co.uk'), isTrue);
        expect(validator.validate('invalid'), isFalse);
        expect(validator.validate('invalid@'), isFalse);
        expect(validator.validate('@example.com'), isFalse);
      });

      test('should validate URL format', () {
        // Arrange
        final validator = TypeConstraintValidator.forUrl();

        // Act & Assert
        expect(validator.validate('https://example.com'), isTrue);
        expect(
          validator.validate('http://subdomain.example.co.uk/path'),
          isTrue,
        );
        expect(validator.validate('invalid'), isFalse);
        expect(validator.validate('example.com'), isFalse); // missing protocol
      });
    });

    // Test for validating error messages
    group('Validation error messages', () {
      test(
        'should return appropriate error message for numeric validation',
        () {
          // Arrange
          final validator = TypeConstraintValidator.forInt(min: 5, max: 10);

          // Act & Assert
          expect(validator.validate(3), isFalse);
          expect(validator.getLastError(), contains('minimum value of 5'));

          expect(validator.validate(15), isFalse);
          expect(validator.getLastError(), contains('maximum value of 10'));
        },
      );

      test('should return appropriate error message for string validation', () {
        // Arrange
        final validator = TypeConstraintValidator.forString(
          minLength: 3,
          maxLength: 5,
        );

        // Act & Assert
        expect(validator.validate('ab'), isFalse);
        expect(validator.getLastError(), contains('minimum length of 3'));

        expect(validator.validate('abcdef'), isFalse);
        expect(validator.getLastError(), contains('maximum length of 5'));
      });
    });
  });
}
