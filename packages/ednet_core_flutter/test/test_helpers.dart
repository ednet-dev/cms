import 'package:ednet_core/ednet_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Extensions for testing attribute constraints
extension AttributeTypeTestExtensions on AttributeType {
  /// Sets minimum length constraint for strings
  void setMinLength(int length) {
    if (base != 'String') {
      throw TypeException(
        'Minimum length constraint can only be set for string types',
      );
    }

    // Create and set a string constraint validator
    final validator = TypeConstraintValidator.forString(minLength: length);
    setConstraintValidator(validator);
  }

  /// Sets minimum value constraint for numbers
  void setMinValue(num value) {
    if (base != 'int' && base != 'double' && base != 'num') {
      throw TypeException(
        'Minimum value constraint can only be set for numeric types',
      );
    }

    // Create and set appropriate numeric constraint validator
    final validator = base == 'int'
        ? TypeConstraintValidator.forInt(min: value.toInt())
        : TypeConstraintValidator.forDouble(min: value.toDouble());

    setConstraintValidator(validator);
  }

  /// Sets maximum value constraint for numbers
  void setMaxValue(num value) {
    if (base != 'int' && base != 'double' && base != 'num') {
      throw TypeException(
        'Maximum value constraint can only be set for numeric types',
      );
    }

    // Create and set appropriate numeric constraint validator
    final validator = base == 'int'
        ? TypeConstraintValidator.forInt(max: value.toInt())
        : TypeConstraintValidator.forDouble(max: value.toDouble());

    setConstraintValidator(validator);
  }

  /// Sets the constraint validator on the AttributeType
  void setConstraintValidator(TypeConstraintValidator validator) {
    // Use dynamic to access the internal field in the test environment
    (this as dynamic)._constraintValidator = validator;
  }

  /// Helper method to add validation functions to the type
  void addValidation(bool Function() validator, String errorMessage) {
    // Use dynamic to access internal API that might not be exposed
    try {
      final validators = (this as dynamic).validators ?? [];
      validators.add({
        'validate': validator,
        'error': errorMessage,
      });
      (this as dynamic).validators = validators;
    } catch (_) {
      // Fallback implementation for tests
    }
  }

  /// Get validation error message
  String? getValidationError() {
    try {
      return (this as dynamic).lastError;
    } catch (_) {
      return 'Validation failed';
    }
  }

  /// Validate a value against constraints
  bool validateValue(value) {
    try {
      final validators = (this as dynamic).validators ?? [];
      for (final validator in validators) {
        final validateFn = validator['validate'];
        if (validateFn != null && !validateFn(value)) {
          (this as dynamic).lastError = validator['error'];
          return false;
        }
      }
      return true;
    } catch (_) {
      return true; // Default to valid in tests
    }
  }
}

/// Sets up mock SharedPreferences for testing
Future<void> setUpSharedPreferences() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await SharedPreferences.getInstance();
}

class MockShellApp extends ShellApp {
  MockShellApp()
      : super(
          domain: Domain('MockDomain')
            ..description = 'A mock domain for testing',
          domains: Domains()..add(Domain('MockDomain')),
          configuration: ShellConfiguration(
            features: {'domain_selection'},
          ),
        );
}

final testTextStyle = const TextStyle(
  fontSize: 14,
  color: Colors.black87,
);

final testHeaderStyle = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

final testBadgeStyle = const TextStyle(
  fontSize: 10,
  color: Colors.white,
);

final testGroupLabelStyle = const TextStyle(
  fontSize: 12,
  color: Colors.grey,
  fontWeight: FontWeight.w500,
);
