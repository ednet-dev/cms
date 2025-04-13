part of ednet_core_flutter;

/// Builds form fields from domain model attributes with automatic constraint validation
class DomainFieldBuilder {
  /// Builds a complete form from an entity's concept
  static List<UXFieldDescriptor> buildFormFromConcept(
    Concept concept, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
    Set<String>? excludeAttributes,
    Map<String, String>? customDisplayNames,
    Map<String, String>? customHints,
    Map<String, String>? customHelp,
  }) {
    final attributes = concept.attributes;
    final fields = <UXFieldDescriptor>[];

    // Process each attribute
    for (final property in attributes) {
      // Skip excluded attributes
      if (excludeAttributes != null &&
          excludeAttributes.contains(property.code)) {
        continue;
      }

      // Check if property is an Attribute
      if (property is Attribute) {
        // Get custom display name, hint, and help text if provided
        final displayName = customDisplayNames?[property.code];
        final hint = customHints?[property.code];
        final help = customHelp?[property.code];

        // Create field using constraint validator adapter
        final field = ConstraintValidatorAdapter.createFieldFromAttribute(
          property,
          displayName: displayName,
          hint: hint,
          help: help,
        );

        fields.add(field);
      }
    }

    // Filter fields based on disclosure level
    return filterFieldsByDisclosure(fields, disclosureLevel);
  }

  /// Builds a single field from an attribute
  static UXFieldDescriptor buildField(
    Attribute attribute, {
    String? displayName,
    String? hint,
    String? help,
    DisclosureLevel? disclosureLevel,
  }) {
    return ConstraintValidatorAdapter.createFieldFromAttribute(
      attribute,
      displayName: displayName,
      hint: hint,
      help: help,
      disclosureLevel: disclosureLevel,
    );
  }

  /// Builds multiple fields from a selection of attributes
  static List<UXFieldDescriptor> buildFieldsFromAttributes(
    List<Attribute> attributes, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
    Map<String, String>? customDisplayNames,
    Map<String, String>? customHints,
    Map<String, String>? customHelp,
    Map<String, DisclosureLevel>? customDisclosureLevels,
  }) {
    final fields = <UXFieldDescriptor>[];

    for (final attribute in attributes) {
      final displayName = customDisplayNames?[attribute.code];
      final hint = customHints?[attribute.code];
      final help = customHelp?[attribute.code];
      final level = customDisclosureLevels?[attribute.code];

      final field = ConstraintValidatorAdapter.createFieldFromAttribute(
        attribute,
        displayName: displayName,
        hint: hint,
        help: help,
        disclosureLevel: level,
      );

      fields.add(field);
    }

    return filterFieldsByDisclosure(fields, disclosureLevel);
  }

  /// Creates a pre-filled UXFieldDescriptor for an enumeration/dropdown field
  static UXFieldDescriptor createEnumField(
    String fieldName,
    String displayName,
    List<UXFieldOption> options, {
    bool required = false,
    String? hint,
    String? help,
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    return UXFieldDescriptor(
      fieldName: fieldName,
      displayName: displayName,
      fieldType: UXFieldType.dropdown,
      required: required,
      validators: required
          ? [
              (value) {
                if (value == null) {
                  return 'This field is required';
                }
                return null;
              }
            ]
          : [],
    )
        .withOptions(options)
        .withDisclosureLevel(disclosureLevel)
        .withHint(hint ?? '')
        .withHelp(help ?? '');
  }

  /// Filter fields based on disclosure level
  static List<UXFieldDescriptor> filterFieldsByDisclosure(
    List<UXFieldDescriptor> fields,
    DisclosureLevel disclosureLevel,
  ) {
    return fields.where((field) {
      // Include fields at or below the current disclosure level
      // Basic (0) fields always shown
      // Intermediate (1) fields shown at intermediate or advanced level
      // Advanced (2) fields shown only at advanced level
      return field.disclosureLevel.index <= disclosureLevel.index;
    }).toList();
  }
}
