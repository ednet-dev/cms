part of ednet_core_flutter;

/// A Canonical Model for UI representation of domain entities.
///
/// Implements the Canonical Data Model pattern from Enterprise Integration Patterns
/// to provide a standardized representation of domain entities for UI rendering.
///
/// The UXCanonicalModel converts domain-specific entities into a canonical format
/// that can be understood by UI components, ensuring clear separation between
/// domain logic and presentation concerns.
///
/// Benefits:
/// - Decouples domain model from UI representation
/// - Standardizes UI data format regardless of entity type
/// - Simplifies UI component implementation
/// - Enables consistent override points for customization
///
/// Example usage:
/// ```dart
/// // Create a canonical model from an entity
/// final model = UXCanonicalModel.fromEntity(myEntity, DisclosureLevel.intermediate);
///
/// // Access UI-specific properties
/// final formFields = model.getFormFields();
/// final displayProperties = model.getDisplayProperties();
/// ```
class UXCanonicalModel {
  /// The type identifier for this model
  final String entityType;

  /// The data content of this model
  final Map<String, dynamic> content;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Create a new canonical model for UI representation
  UXCanonicalModel({
    required this.entityType,
    required this.content,
    this.metadata,
  });

  /// Extract form representation from the canonical model
  Map<String, dynamic> getFormRepresentation() =>
      content['form'] as Map<String, dynamic>? ?? {};

  /// Extract list item representation from the canonical model
  Map<String, dynamic> getListItemRepresentation() =>
      content['listItem'] as Map<String, dynamic>? ?? {};

  /// Extract detail view representation from the canonical model
  Map<String, dynamic> getDetailRepresentation() =>
      content['detail'] as Map<String, dynamic>? ?? {};

  /// Extract visualization representation from the canonical model
  Map<String, dynamic> getVisualizationRepresentation() =>
      content['visualization'] as Map<String, dynamic>? ?? {};

  /// Get the form fields for this entity
  List<UXFieldDescriptor> getFormFields() {
    final formData = getFormRepresentation();
    final fieldsData = formData['fields'] as List<dynamic>? ?? [];

    return fieldsData
        .map((field) => _fieldDataToDescriptor(field as Map<String, dynamic>))
        .toList();
  }

  /// Get display properties for showing the entity in a list
  Map<String, dynamic> getDisplayProperties() {
    final listData = getListItemRepresentation();
    return listData['display'] as Map<String, dynamic>? ?? {};
  }

  /// Convert field data to a field descriptor
  UXFieldDescriptor _fieldDataToDescriptor(Map<String, dynamic> fieldData) {
    final fieldType = _stringToFieldType(
      fieldData['type'] as String? ?? 'text',
    );
    final disclosureLevel = _stringToDisclosureLevel(
      fieldData['disclosureLevel'] as String? ?? 'basic',
    );

    // Extract validators
    final validators = <UXFieldValidator>[];
    final validatorsData = fieldData['validators'] as List<dynamic>? ?? [];
    for (final validator in validatorsData) {
      if (validator is Map<String, dynamic>) {
        validators.add(_createValidator(validator));
      }
    }

    // Create basic field descriptor
    var descriptor = UXFieldDescriptor(
      fieldName: fieldData['name'] as String,
      displayName: fieldData['displayName'] as String? ??
          _formatDisplayName(fieldData['name'] as String),
      fieldType: fieldType,
      required: fieldData['required'] as bool? ?? false,
      validators: validators,
      metadata: fieldData['metadata'] as Map<String, dynamic>? ?? {},
    );

    // Apply disclosure level
    descriptor = descriptor.withDisclosureLevel(disclosureLevel);

    // Apply constraints if available
    if (fieldData.containsKey('constraints')) {
      final constraints = fieldData['constraints'] as Map<String, dynamic>;
      descriptor = descriptor.withConstraints(
        min: constraints['min'],
        max: constraints['max'],
        allowedValues: constraints['allowedValues'] as List<String>?,
        maxLength: constraints['maxLength'] as int?,
      );
    }

    // Apply options if available for dropdown/radio fields
    if (fieldData.containsKey('options')) {
      final optionsData = fieldData['options'] as List<dynamic>? ?? [];
      final options = optionsData
          .map(
            (option) =>
                _optionDataToFieldOption(option as Map<String, dynamic>),
          )
          .toList();
      descriptor = descriptor.withOptions(options);
    }

    // Apply hint if available
    if (fieldData.containsKey('hint')) {
      descriptor = descriptor.withHint(fieldData['hint'] as String);
    }

    // Apply help if available
    if (fieldData.containsKey('help')) {
      descriptor = descriptor.withHelp(fieldData['help'] as String);
    }

    return descriptor;
  }

  /// Convert option data to field option
  UXFieldOption _optionDataToFieldOption(Map<String, dynamic> optionData) {
    return UXFieldOption(
      value: optionData['value'],
      label: optionData['label'] as String,
      disabled: optionData['disabled'] as bool? ?? false,
    );
  }

  /// Create a validator from configuration
  UXFieldValidator _createValidator(Map<String, dynamic> validatorData) {
    final type = validatorData['type'] as String;

    switch (type) {
      case 'required':
        return (value) => (value == null || value.toString().isEmpty)
            ? validatorData['message'] as String? ?? 'This field is required'
            : null;
      case 'min':
        final min = validatorData['min'];
        return (value) {
          if (value == null) return null;
          if (value is num && value < min) {
            return validatorData['message'] as String? ??
                'Value must be at least $min';
          }
          return null;
        };
      case 'max':
        final max = validatorData['max'];
        return (value) {
          if (value == null) return null;
          if (value is num && value > max) {
            return validatorData['message'] as String? ??
                'Value must be at most $max';
          }
          return null;
        };
      case 'minLength':
        final minLength = validatorData['minLength'] as int;
        return (value) {
          if (value == null) return null;
          if (value.toString().length < minLength) {
            return validatorData['message'] as String? ??
                'Must be at least $minLength characters';
          }
          return null;
        };
      case 'maxLength':
        final maxLength = validatorData['maxLength'] as int;
        return (value) {
          if (value == null) return null;
          if (value.toString().length > maxLength) {
            return validatorData['message'] as String? ??
                'Must be at most $maxLength characters';
          }
          return null;
        };
      case 'pattern':
        final pattern = RegExp(validatorData['pattern'] as String);
        return (value) {
          if (value == null) return null;
          if (!pattern.hasMatch(value.toString())) {
            return validatorData['message'] as String? ??
                'Value does not match the required pattern';
          }
          return null;
        };
      default:
        // Custom validator - always returns null (no validation)
        return (_) => null;
    }
  }

  /// Convert string to field type
  UXFieldType _stringToFieldType(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'text':
        return UXFieldType.text;
      case 'longtext':
        return UXFieldType.longText;
      case 'number':
        return UXFieldType.number;
      case 'date':
        return UXFieldType.date;
      case 'dropdown':
        return UXFieldType.dropdown;
      case 'checkbox':
        return UXFieldType.checkbox;
      case 'radio':
        return UXFieldType.radio;
      case 'custom':
        return UXFieldType.custom;
      default:
        return UXFieldType.text;
    }
  }

  /// Convert string to disclosure level
  DisclosureLevel _stringToDisclosureLevel(String levelStr) {
    switch (levelStr.toLowerCase()) {
      case 'minimal':
        return DisclosureLevel.minimal;
      case 'basic':
        return DisclosureLevel.basic;
      case 'intermediate':
        return DisclosureLevel.intermediate;
      case 'advanced':
        return DisclosureLevel.advanced;
      case 'complete':
        return DisclosureLevel.complete;
      default:
        return DisclosureLevel.basic;
    }
  }

  /// Format a field name for display
  String _formatDisplayName(String code) {
    // Add spaces before capital letters and capitalize first letter
    final spaced = code
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim();

    return spaced.substring(0, 1).toUpperCase() + spaced.substring(1);
  }

  /// Create a canonical model from an entity
  static UXCanonicalModel fromEntity(
    Entity entity, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    // Get the adapter for the entity
    final adapter = UXAdapterRegistry().getAdapterByConceptCode(
      entity,
      entity.concept.code,
    );

    // Build form representation
    final fieldDescriptors = adapter.getFieldDescriptors(
      disclosureLevel: disclosureLevel,
    );
    final initialData = adapter.getInitialFormData();

    // Create canonical model
    return UXCanonicalModel(
      entityType: entity.concept.code,
      content: {
        'form': {
          'fields': fieldDescriptors
              .map((field) => _fieldDescriptorToMap(field))
              .toList(),
          'initialData': initialData,
          'entity': entity.toJsonMap(),
        },
        'listItem': _buildListItemRepresentation(entity, adapter),
        'detail': _buildDetailRepresentation(entity, adapter),
        'visualization': _buildVisualizationRepresentation(entity, adapter),
      },
      metadata: {
        'disclosureLevel': disclosureLevel.toString(),
        'entityId': entity.id?.toString(),
      },
    );
  }

  /// Convert a field descriptor to a map
  static Map<String, dynamic> _fieldDescriptorToMap(UXFieldDescriptor field) {
    return {
      'name': field.fieldName,
      'displayName': field.displayName,
      'type': field.fieldType.toString().split('.').last,
      'required': field.required,
      'metadata': field.metadata,
      // Validators and other properties could be added here
    };
  }

  /// Build list item representation
  static Map<String, dynamic> _buildListItemRepresentation(
    Entity entity,
    UXAdapter adapter,
  ) {
    // Extract key display properties for list items
    return {
      'display': {
        'title': entity.code,
        'subtitle': entity.concept.code,
        'identifier': entity.id.toString(),
      },
    };
  }

  /// Build detail representation
  static Map<String, dynamic> _buildDetailRepresentation(
    Entity entity,
    UXAdapter adapter,
  ) {
    // Extract properties for detail view
    return {
      'display': {
        'title': entity.code,
        'type': entity.concept.code,
        'id': entity.id.toString(),
      },
    };
  }

  /// Build visualization representation
  static Map<String, dynamic> _buildVisualizationRepresentation(
    Entity entity,
    UXAdapter adapter,
  ) {
    // Properties for visualization (e.g., in diagrams)
    return {
      'display': {'label': entity.code, 'type': entity.concept.code},
    };
  }
}

/// A channel adapter that translates between domain entities and their UI representations
class ModelUXChannelAdapter<T extends Entity<T>> {
  /// The UX adapter for the entity type
  final UXAdapter uxAdapter;

  /// The build context for rendering widgets
  final BuildContext context;

  /// Current disclosure level
  final DisclosureLevel disclosureLevel;

  /// Constructor
  ModelUXChannelAdapter(
    this.uxAdapter, {
    required this.context,
    this.disclosureLevel = DisclosureLevel.basic,
  });

  /// Convert a domain entity to a UI widget
  Widget renderEntity(T entity, String renderMode) {
    // Based on render mode, render the appropriate UI component
    switch (renderMode) {
      case 'form':
        return uxAdapter.buildForm(context, disclosureLevel: disclosureLevel);
      case 'list':
        return uxAdapter.buildListItem(
          context,
          disclosureLevel: disclosureLevel,
        );
      case 'visualization':
        return uxAdapter.buildVisualization(
          context,
          disclosureLevel: disclosureLevel,
        );
      case 'detail':
      default:
        return uxAdapter.buildDetailView(
          context,
          disclosureLevel: disclosureLevel,
        );
    }
  }

  /// Handle form submission
  Future<bool> handleFormSubmit(Map<String, dynamic> formData) async {
    try {
      // In a real app, we would submit the form data to the adapter
      return await uxAdapter.submitForm(formData);
    } catch (e) {
      print('Error handling form submit: $e');
      return false;
    }
  }
}
