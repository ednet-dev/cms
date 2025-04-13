part of ednet_core_flutter;

/// A form widget that uses domain model constraints for automatic validation
class ConstraintValidatedForm extends StatefulWidget {
  /// The concept used to build the form
  final Concept concept;

  /// Initial data to populate the form
  final Map<String, dynamic> initialData;

  /// Callback when form is submitted
  final Future<bool> Function(Map<String, dynamic> data)? onSubmit;

  /// Fields to exclude from the form
  final Set<String>? excludeFields;

  /// Disclosure level for progressive disclosure
  final DisclosureLevel disclosureLevel;

  /// Custom field display names
  final Map<String, String>? customDisplayNames;

  /// Custom field hints
  final Map<String, String>? customHints;

  /// Custom field help text
  final Map<String, String>? customHelp;

  /// Title of the form
  final String? title;

  /// Text for submit button
  final String submitButtonText;

  /// Whether to validate fields on change (true) or only on submit (false)
  final bool validateOnChange;

  /// Whether to show constraint indicators next to field labels
  final bool showConstraintIndicators;

  /// Creates a constraint-validated form
  const ConstraintValidatedForm({
    Key? key,
    required this.concept,
    this.initialData = const {},
    this.onSubmit,
    this.excludeFields,
    this.disclosureLevel = DisclosureLevel.basic,
    this.customDisplayNames,
    this.customHints,
    this.customHelp,
    this.title,
    this.submitButtonText = 'Submit',
    this.validateOnChange = true,
    this.showConstraintIndicators = true,
  }) : super(key: key);

  @override
  State<ConstraintValidatedForm> createState() =>
      _ConstraintValidatedFormState();
}

class _ConstraintValidatedFormState extends State<ConstraintValidatedForm> {
  /// Form data
  late Map<String, dynamic> _formData;

  /// Generated form fields
  late List<UXFieldDescriptor> _fields;

  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Loading state
  bool _isSubmitting = false;

  /// Error messages for fields
  final Map<String, String?> _errors = {};

  /// Tracks touched fields for validation
  final Set<String> _touchedFields = {};

  @override
  void initState() {
    super.initState();

    // Initialize form data
    _formData = Map.from(widget.initialData);

    // Generate form fields based on concept attributes and constraints
    _fields = DomainFieldBuilder.buildFormFromConcept(
      widget.concept,
      disclosureLevel: widget.disclosureLevel,
      excludeAttributes: widget.excludeFields,
      customDisplayNames: widget.customDisplayNames,
      customHints: widget.customHints,
      customHelp: widget.customHelp,
    );
  }

  @override
  void didUpdateWidget(ConstraintValidatedForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Regenerate fields if concept or disclosure level changed
    if (widget.concept != oldWidget.concept ||
        widget.disclosureLevel != oldWidget.disclosureLevel) {
      _fields = DomainFieldBuilder.buildFormFromConcept(
        widget.concept,
        disclosureLevel: widget.disclosureLevel,
        excludeAttributes: widget.excludeFields,
        customDisplayNames: widget.customDisplayNames,
        customHints: widget.customHints,
        customHelp: widget.customHelp,
      );
    }

    // Update form data if initialData changed
    if (widget.initialData != oldWidget.initialData) {
      _formData = Map.from(widget.initialData);
    }
  }

  /// Update field value and validate if needed
  void _updateField(String fieldName, dynamic value) {
    setState(() {
      _formData[fieldName] = value;
      _touchedFields.add(fieldName);

      // If validateOnChange is enabled, validate the field
      if (widget.validateOnChange) {
        _validateField(fieldName, value);
      } else {
        // Just clear the error in case there was one
        _errors.remove(fieldName);
      }
    });
  }

  /// Validate a single field
  bool _validateField(String fieldName, dynamic value) {
    // Find the field descriptor
    final field = _fields.firstWhere(
      (f) => f.fieldName == fieldName,
      orElse: () => throw Exception('Field not found: $fieldName'),
    );

    // Run all validators for this field
    for (final validator in field.validators) {
      final error = validator(value);

      if (error != null) {
        setState(() {
          _errors[fieldName] = error;
        });
        return false;
      }
    }

    // If we get here, the field is valid
    setState(() {
      _errors.remove(fieldName);
    });
    return true;
  }

  /// Validate the form
  bool _validateForm() {
    // Standard form validation
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }

    // Run any additional validation on fields
    bool isFieldValid = true;
    for (final field in _fields) {
      final value = _formData[field.fieldName];

      // Mark all fields as touched on form submission
      _touchedFields.add(field.fieldName);

      // Validate each field
      if (!_validateField(field.fieldName, value)) {
        isFieldValid = false;
      }
    }

    return isFieldValid;
  }

  /// Submit the form
  Future<void> _submitForm() async {
    if (!_validateForm()) {
      // Scroll to first error if any
      if (_errors.isNotEmpty) {
        _showErrorSnackbar('Please fix the errors in the form');
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (widget.onSubmit != null) {
        final success = await widget.onSubmit!(_formData);

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Form submitted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            _showErrorSnackbar('Form submission failed');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// Shows error snackbar with consistent styling
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Get constraint indicator for a field
  Widget _buildConstraintIndicator(UXFieldDescriptor field) {
    if (!widget.showConstraintIndicators) {
      return const SizedBox.shrink();
    }

    // Build indicators based on field properties
    final List<Widget> indicators = [];

    // Required field indicator
    if (field.required) {
      indicators.add(Tooltip(
        message: 'Required field',
        child: Icon(Icons.star,
            size: 16, color: Theme.of(context).colorScheme.primary),
      ));
    }

    // Check for min/max constraints
    if (field.min != null || field.max != null || field.maxLength != null) {
      indicators.add(Tooltip(
        message: 'Has value constraints',
        child: Icon(Icons.rule,
            size: 16, color: Theme.of(context).colorScheme.tertiary),
      ));
    }

    // For complex fields, we need to check the concept's attributes
    for (final attribute in widget.concept.attributes) {
      if (attribute.code == field.fieldName) {
        if (attribute.type != null) {
          // Special types like Email or Uri usually have constraints
          if (attribute.type!.code == 'Email' ||
              attribute.type!.code == 'Uri') {
            indicators.add(Tooltip(
              message: 'Has format validation',
              child: Icon(Icons.check_circle_outline,
                  size: 16, color: Theme.of(context).colorScheme.tertiary),
            ));
            break;
          }
        }
        break;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: indicators,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

          // Build form fields
          ..._fields.map((field) => _buildField(field)),

          const SizedBox(height: 16),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              child: _isSubmitting
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : Text(widget.submitButtonText),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a field widget based on its type
  Widget _buildField(UXFieldDescriptor field) {
    final value = _formData[field.fieldName];

    // Only show errors for touched fields (unless during form submission)
    final errorText = _touchedFields.contains(field.fieldName)
        ? _errors[field.fieldName]
        : null;

    // Add field label with constraint indicators
    Widget buildFieldLabel(String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          _buildConstraintIndicator(field),
        ],
      );
    }

    switch (field.fieldType) {
      case UXFieldType.text:
        return _buildTextField(field, value, errorText, buildFieldLabel);
      case UXFieldType.longText:
        return _buildLongTextField(field, value, errorText, buildFieldLabel);
      case UXFieldType.number:
        return _buildNumberField(field, value, errorText, buildFieldLabel);
      case UXFieldType.date:
        return _buildDateField(field, value, errorText, buildFieldLabel);
      case UXFieldType.checkbox:
        return _buildCheckboxField(field, value);
      case UXFieldType.dropdown:
        return _buildDropdownField(field, value, errorText, buildFieldLabel);
      case UXFieldType.radio:
        return _buildRadioField(field, value, errorText, buildFieldLabel);
      case UXFieldType.custom:
        return field.customRenderer != null
            ? field.customRenderer!(context, field.fieldName, value,
                (newValue) => _updateField(field.fieldName, newValue))
            : Container(); // Empty container for unsupported fields
    }
  }

  /// Build a text field
  Widget _buildTextField(
    UXFieldDescriptor field,
    dynamic value,
    String? errorText,
    Widget Function(String) labelBuilder,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: labelBuilder(field.displayName),
          hintText: field.hint,
          helperText: field.help,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        initialValue: value?.toString() ?? '',
        onChanged: (newValue) => _updateField(field.fieldName, newValue),
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  /// Build a multi-line text field
  Widget _buildLongTextField(
    UXFieldDescriptor field,
    dynamic value,
    String? errorText,
    Widget Function(String) labelBuilder,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: labelBuilder(field.displayName),
          hintText: field.hint,
          helperText: field.help,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        initialValue: value?.toString() ?? '',
        maxLines: 5,
        onChanged: (newValue) => _updateField(field.fieldName, newValue),
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  /// Build a number field
  Widget _buildNumberField(
    UXFieldDescriptor field,
    dynamic value,
    String? errorText,
    Widget Function(String) labelBuilder,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: labelBuilder(field.displayName),
          hintText: field.hint,
          helperText: field.help,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        initialValue: value?.toString() ?? '',
        keyboardType: TextInputType.number,
        onChanged: (newValue) {
          // Try to parse as a number
          if (newValue.isEmpty) {
            _updateField(field.fieldName, null);
          } else {
            try {
              if (newValue.contains('.')) {
                _updateField(field.fieldName, double.parse(newValue));
              } else {
                _updateField(field.fieldName, int.parse(newValue));
              }
            } catch (e) {
              // If parsing fails, store as string for validation error
              _updateField(field.fieldName, newValue);
            }
          }
        },
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  /// Build a date field
  Widget _buildDateField(
    UXFieldDescriptor field,
    dynamic value,
    String? errorText,
    Widget Function(String) labelBuilder,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                label: labelBuilder(field.displayName),
                hintText: field.hint,
                helperText: field.help,
                errorText: errorText,
                border: const OutlineInputBorder(),
              ),
              readOnly: true,
              initialValue: value is DateTime
                  ? '${value.day}/${value.month}/${value.year}'
                  : value?.toString() ?? '',
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: value is DateTime ? value : DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (date != null) {
                  _updateField(field.fieldName, date);
                }
              },
              validator: (value) {
                if (field.required && (value == null || value.isEmpty)) {
                  return 'This field is required';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: value is DateTime ? value : DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              if (date != null) {
                _updateField(field.fieldName, date);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Build a checkbox field
  Widget _buildCheckboxField(UXFieldDescriptor field, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CheckboxListTile(
        title: Text(field.displayName),
        subtitle: field.help != null ? Text(field.help!) : null,
        value: value as bool? ?? false,
        onChanged: (newValue) => _updateField(field.fieldName, newValue),
      ),
    );
  }

  /// Build a dropdown field
  Widget _buildDropdownField(
    UXFieldDescriptor field,
    dynamic value,
    String? errorText,
    Widget Function(String) labelBuilder,
  ) {
    final options = field.options ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<dynamic>(
        decoration: InputDecoration(
          label: labelBuilder(field.displayName),
          hintText: field.hint,
          helperText: field.help,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        value: value,
        items: options.map((option) {
          return DropdownMenuItem<dynamic>(
            value: option.value,
            enabled: !option.disabled,
            child: Text(option.label),
          );
        }).toList(),
        onChanged: (newValue) => _updateField(field.fieldName, newValue),
        validator: (value) {
          if (field.required && value == null) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  /// Build a radio field
  Widget _buildRadioField(
    UXFieldDescriptor field,
    dynamic value,
    String? errorText,
    Widget Function(String) labelBuilder,
  ) {
    final options = field.options ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormField<dynamic>(
        initialValue: value,
        validator: (value) {
          if (field.required && value == null) {
            return 'This field is required';
          }
          return null;
        },
        builder: (FormFieldState<dynamic> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelBuilder(field.displayName),
              if (field.help != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    field.help!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ...options.map((option) {
                return RadioListTile<dynamic>(
                  title: Text(option.label),
                  value: option.value,
                  groupValue: _formData[field.fieldName],
                  onChanged: (newValue) {
                    _updateField(field.fieldName, newValue);
                    state.didChange(newValue);
                  },
                );
              }).toList(),
              if (state.hasError || errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                  child: Text(
                    errorText ?? state.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12.0,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
