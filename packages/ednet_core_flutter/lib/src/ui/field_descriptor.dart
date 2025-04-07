part of ednet_core_flutter;

/// A field validator that returns an error message string or null if valid
typedef UXFieldValidator = String? Function(Object? value);

/// Describes different types of form fields that can be rendered
enum UXFieldType {
  /// Simple text input
  text,

  /// Multi-line text input
  longText,

  /// Numeric input
  number,

  /// Date/time picker
  date,

  /// Dropdown select
  dropdown,

  /// Boolean checkbox
  checkbox,

  /// Radio button group
  radio,

  /// Custom field with custom render logic
  custom,
}

/// A custom field renderer function
typedef UXFieldRenderer = Widget Function(
  BuildContext context,
  String fieldName,
  Object? value,
  Function(Object?) onChanged,
);

/// A field option for dropdowns and radio buttons
class UXFieldOption {
  /// The value to be stored when this option is selected
  final Object? value;

  /// The human-readable label for this option
  final String label;

  /// Whether this option is disabled
  final bool disabled;

  /// Constructor
  const UXFieldOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });
}

/// Describes a form field to be rendered in a UI
class UXFieldDescriptor {
  /// The internal field name, matching the attribute name
  final String fieldName;

  /// The human-readable display name
  final String displayName;

  /// The type of field to render
  final UXFieldType fieldType;

  /// Whether the field is required
  final bool required;

  /// Validator functions to run on field value
  final List<UXFieldValidator> validators;

  /// Disclosure level at which this field should be shown
  final DisclosureLevel disclosureLevel;

  /// Options for dropdown and radio fields
  final List<UXFieldOption>? options;

  /// Custom renderer for this field
  final UXFieldRenderer? customRenderer;

  /// Hint text to display below the field
  final String? hint;

  /// Help text to display when the user requests more information
  final String? help;

  /// Minimum value for numeric fields
  final num? min;

  /// Maximum value for numeric fields
  final num? max;

  /// Maximum text length for text fields
  final int? maxLength;

  /// Allowed values for the field
  final List<String>? allowedValues;

  /// Additional metadata for this field
  final Map<String, Object?> metadata;

  /// Constructor
  const UXFieldDescriptor({
    required this.fieldName,
    required this.displayName,
    required this.fieldType,
    this.required = false,
    List<UXFieldValidator>? validators,
    DisclosureLevel? disclosureLevel,
    this.options,
    this.customRenderer,
    this.hint,
    this.help,
    this.min,
    this.max,
    this.maxLength,
    this.allowedValues,
    Map<String, Object?>? metadata,
  })  : validators = validators ?? const [],
        disclosureLevel = disclosureLevel ?? DisclosureLevel.basic,
        metadata = metadata ?? const {};

  /// Create a copy with a different disclosure level
  UXFieldDescriptor withDisclosureLevel(DisclosureLevel level) {
    return UXFieldDescriptor(
      fieldName: fieldName,
      displayName: displayName,
      fieldType: fieldType,
      required: required,
      validators: validators,
      disclosureLevel: level,
      options: options,
      customRenderer: customRenderer,
      hint: hint,
      help: help,
      min: min,
      max: max,
      maxLength: maxLength,
      allowedValues: allowedValues,
      metadata: metadata,
    );
  }

  /// Create a copy with a custom renderer
  UXFieldDescriptor withCustomRenderer(UXFieldRenderer renderer) {
    return UXFieldDescriptor(
      fieldName: fieldName,
      displayName: displayName,
      fieldType: fieldType,
      required: required,
      validators: validators,
      disclosureLevel: disclosureLevel,
      options: options,
      customRenderer: renderer,
      hint: hint,
      help: help,
      min: min,
      max: max,
      maxLength: maxLength,
      allowedValues: allowedValues,
      metadata: metadata,
    );
  }

  /// Create a copy with options for dropdown/radio
  UXFieldDescriptor withOptions(List<UXFieldOption> fieldOptions) {
    return UXFieldDescriptor(
      fieldName: fieldName,
      displayName: displayName,
      fieldType: fieldType,
      required: required,
      validators: validators,
      disclosureLevel: disclosureLevel,
      options: fieldOptions,
      customRenderer: customRenderer,
      hint: hint,
      help: help,
      min: min,
      max: max,
      maxLength: maxLength,
      allowedValues: allowedValues,
      metadata: metadata,
    );
  }

  /// Create a copy with a hint text
  UXFieldDescriptor withHint(String hintText) {
    return UXFieldDescriptor(
      fieldName: fieldName,
      displayName: displayName,
      fieldType: fieldType,
      required: required,
      validators: validators,
      disclosureLevel: disclosureLevel,
      options: options,
      customRenderer: customRenderer,
      hint: hintText,
      help: help,
      min: min,
      max: max,
      maxLength: maxLength,
      allowedValues: allowedValues,
      metadata: metadata,
    );
  }

  /// Create a copy with help text
  UXFieldDescriptor withHelp(String helpText) {
    return UXFieldDescriptor(
      fieldName: fieldName,
      displayName: displayName,
      fieldType: fieldType,
      required: required,
      validators: validators,
      disclosureLevel: disclosureLevel,
      options: options,
      customRenderer: customRenderer,
      hint: hint,
      help: helpText,
      min: min,
      max: max,
      maxLength: maxLength,
      allowedValues: allowedValues,
      metadata: metadata,
    );
  }

  /// Create a copy with constraints
  UXFieldDescriptor withConstraints({
    num? min,
    num? max,
    int? maxLength,
    List<String>? allowedValues,
  }) {
    return UXFieldDescriptor(
      fieldName: fieldName,
      displayName: displayName,
      fieldType: fieldType,
      required: required,
      validators: validators,
      disclosureLevel: disclosureLevel,
      options: options,
      customRenderer: customRenderer,
      hint: hint,
      help: help,
      min: min ?? this.min,
      max: max ?? this.max,
      maxLength: maxLength ?? this.maxLength,
      allowedValues: allowedValues ?? this.allowedValues,
      metadata: metadata,
    );
  }
}

/// Utility function to filter a list of field descriptors by disclosure level
List<UXFieldDescriptor> filterFieldsByDisclosure(
  List<UXFieldDescriptor> fields,
  DisclosureLevel level,
) {
  return fields
      .where((field) => field.disclosureLevel.index >= level.index)
      .toList();
}

/// A builder class for form fields based on entity attributes
class UXFieldBuilder {
  /// Create a field from an entity attribute
  static UXFieldDescriptor fromAttribute(
    Attribute attribute, {
    String? displayName,
    DisclosureLevel? disclosureLevel,
  }) {
    // Determine field type based on attribute type
    final type = attribute.type?.code ?? 'String';
    final UXFieldType fieldType;

    switch (type) {
      case 'bool':
        fieldType = UXFieldType.checkbox;
      case 'int':
      case 'double':
      case 'num':
        fieldType = UXFieldType.number;
      case 'DateTime':
        fieldType = UXFieldType.date;
      default:
        if (attribute.code.toLowerCase().contains('description')) {
          fieldType = UXFieldType.longText;
        } else {
          fieldType = UXFieldType.text;
        }
    }

    // Create initial field descriptor
    final descriptor = UXFieldDescriptor(
      fieldName: attribute.code,
      displayName: displayName ?? _formatDisplayName(attribute.code),
      fieldType: fieldType,
      required: attribute.required,
      validators: [],
      metadata: {'attribute': attribute},
    );

    // Apply appropriate disclosure level
    if (disclosureLevel != null) {
      return descriptor.withDisclosureLevel(disclosureLevel);
    } else if (attribute.code.startsWith('internal') ||
        attribute.code.contains('Config') ||
        attribute.code.contains('Technical')) {
      return descriptor.withDisclosureLevel(DisclosureLevel.advanced);
    } else if (!attribute.required) {
      return descriptor.withDisclosureLevel(DisclosureLevel.intermediate);
    } else {
      return descriptor.withDisclosureLevel(DisclosureLevel.basic);
    }
  }

  /// Format display name by adding spaces before capitals and capitalizing first letter
  static String _formatDisplayName(String code) {
    // Add spaces before capital letters and capitalize first letter
    final spaced = code
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim();

    return spaced.substring(0, 1).toUpperCase() + spaced.substring(1);
  }
}
