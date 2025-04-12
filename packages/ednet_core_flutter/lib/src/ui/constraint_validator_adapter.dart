part of ednet_core_flutter;

/// Converts ednet_core constraints into validators for Flutter form fields
class ConstraintValidatorAdapter {
  /// Generates a list of field validators based on the attribute and its type
  static List<UXFieldValidator> generateValidators(Attribute attribute) {
    final List<UXFieldValidator> validators = [];
    final attributeType = attribute.type;

    if (attributeType == null) {
      return validators;
    }

    // Handle required validation
    if (attribute.required) {
      validators.add((value) {
        if (value == null || value.toString().isEmpty) {
          return 'This field is required';
        }
        return null;
      });
    }

    // Type-specific validators
    if (attributeType.base == 'String') {
      _addStringValidators(attributeType, validators);
    } else if (['int', 'double', 'num'].contains(attributeType.base)) {
      _addNumericValidators(attributeType, validators);
    } else if (attributeType.code == 'Email') {
      _addEmailValidator(validators);
    } else if (attributeType.code == 'Uri') {
      _addUriValidator(validators);
    }

    return validators;
  }

  /// Add string-related validators based on type constraints
  static void _addStringValidators(
      AttributeType type, List<UXFieldValidator> validators) {
    // String-specific validation
    validators.add((value) {
      if (value != null && value.toString().isNotEmpty) {
        // Use the validation method from the type first
        final typeValid = type.validateValue(value.toString());
        if (!typeValid) {
          // If validation failed, try to get a detailed error message
          final errorMsg = type.getValidationError();
          if (errorMsg != null) {
            return errorMsg;
          }
          return 'Must be a valid ${type.code} value';
        }

        // Additional check for max length (belt-and-suspenders approach)
        if (value.toString().length > type.length) {
          return 'Must be at most ${type.length} characters';
        }
      }
      return null;
    });
  }

  /// Add numeric validators based on type constraints
  static void _addNumericValidators(
      AttributeType type, List<UXFieldValidator> validators) {
    // First add basic number validation
    validators.add((value) {
      if (value == null || value.toString().isEmpty) {
        return null; // Empty is handled by required validator
      }

      if (type.base == 'int') {
        if (int.tryParse(value.toString()) == null) {
          return 'Must be a valid integer';
        }
      } else {
        if (num.tryParse(value.toString()) == null) {
          return 'Must be a valid number';
        }
      }
      return null;
    });

    // For min/max range constraints using the type's validation
    validators.add((value) {
      if (value != null && value.toString().isNotEmpty) {
        final numValue = type.base == 'int'
            ? int.tryParse(value.toString())
            : num.tryParse(value.toString());

        if (numValue != null) {
          // Use the type's validation to check constraints
          if (!type.validateValue(numValue)) {
            // If validation failed, get detailed error message
            final errorMsg = type.getValidationError();
            if (errorMsg != null) {
              return errorMsg;
            }
            return 'Value must be within the allowed range';
          }
        }
      }
      return null;
    });
  }

  /// Add email validation
  static void _addEmailValidator(List<UXFieldValidator> validators) {
    validators.add((value) {
      if (value != null && value.toString().isNotEmpty) {
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(value.toString())) {
          return 'Must be a valid email address';
        }
      }
      return null;
    });
  }

  /// Add URI validation
  static void _addUriValidator(List<UXFieldValidator> validators) {
    validators.add((value) {
      if (value != null && value.toString().isNotEmpty) {
        try {
          final uri = Uri.parse(value.toString());
          if (uri.scheme.isEmpty || uri.host.isEmpty) {
            return 'Must be a valid URL';
          }
        } catch (e) {
          return 'Must be a valid URL';
        }
      }
      return null;
    });
  }

  /// Create field descriptor from entity attribute with proper validation
  static UXFieldDescriptor createFieldFromAttribute(
    Attribute attribute, {
    String? displayName,
    DisclosureLevel? disclosureLevel,
    String? hint,
    String? help,
  }) {
    // Get field type from attribute type
    final UXFieldType fieldType = _determineFieldType(attribute);

    // Generate validators
    final validators = generateValidators(attribute);

    // Create field descriptor with constraints
    var descriptor = UXFieldDescriptor(
      fieldName: attribute.code,
      displayName: displayName ?? _formatDisplayName(attribute.code),
      fieldType: fieldType,
      required: attribute.required,
      validators: validators,
    );

    // Apply constraints - we can't directly access min/max values
    // so we'll just set the max length from the type's length property
    final type = attribute.type;
    if (type != null) {
      descriptor = descriptor.withConstraints(
        // We can't directly access min/max values from here
        // Will rely on validators using validateValue instead
        maxLength: type.length,
      );
    }

    // Apply help and hint
    if (hint != null) {
      descriptor = descriptor.withHint(hint);
    }

    if (help != null) {
      descriptor = descriptor.withHelp(help);
    }

    // Apply disclosure level based on attribute properties
    if (disclosureLevel != null) {
      descriptor = descriptor.withDisclosureLevel(disclosureLevel);
    } else {
      // Default disclosure level logic
      if (attribute.code.startsWith('internal') ||
          attribute.code.contains('Config') ||
          attribute.essential == false) {
        descriptor = descriptor.withDisclosureLevel(DisclosureLevel.advanced);
      } else if (!attribute.required) {
        descriptor =
            descriptor.withDisclosureLevel(DisclosureLevel.intermediate);
      } else {
        descriptor = descriptor.withDisclosureLevel(DisclosureLevel.basic);
      }
    }

    return descriptor;
  }

  /// Determine the appropriate field type based on the attribute
  static UXFieldType _determineFieldType(Attribute attribute) {
    final typeCode = attribute.type?.code ?? 'String';

    switch (typeCode) {
      case 'bool':
        return UXFieldType.checkbox;
      case 'int':
      case 'double':
      case 'num':
        return UXFieldType.number;
      case 'DateTime':
        return UXFieldType.date;
      case 'Email':
        return UXFieldType.text; // Email uses text field with validation
      case 'Uri':
        return UXFieldType.text; // URL uses text field with validation
      default:
        // For string types, determine if it should be longText
        if (attribute.code.toLowerCase().contains('description') ||
            attribute.code.toLowerCase().contains('notes') ||
            attribute.code.toLowerCase().contains('comment') ||
            (attribute.type?.length ?? 0) > 100) {
          return UXFieldType.longText;
        } else {
          return UXFieldType.text;
        }
    }
  }

  /// Format a field name for display
  static String _formatDisplayName(String fieldName) {
    // Convert camelCase to Title Case with spaces
    final formatted = fieldName.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    );

    // Capitalize first letter and trim any leading space
    return formatted.trim().isNotEmpty
        ? '${formatted.trim()[0].toUpperCase()}${formatted.trim().substring(1)}'
        : fieldName;
  }
}
