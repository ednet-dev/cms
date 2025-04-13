part of ednet_core_flutter;

/// A default form builder that can render any entity using field descriptors
class DefaultFormBuilder<T extends Entity<T>> extends StatefulWidget {
  /// The entity being edited
  final T entity;

  /// The fields to display in the form
  final List<UXFieldDescriptor> fields;

  /// Initial form data
  final Map<String, dynamic> initialData;

  /// Current disclosure level
  final DisclosureLevel disclosureLevel;

  /// Callback when disclosure level changes
  final Widget Function(DisclosureLevel newLevel)? onLevelChanged;

  /// Submit callback
  final Future<bool> Function(Map<String, dynamic> formData)? onSubmit;

  /// Constructor
  const DefaultFormBuilder({
    Key? key,
    required this.entity,
    required this.fields,
    required this.initialData,
    this.disclosureLevel = DisclosureLevel.basic,
    this.onLevelChanged,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<DefaultFormBuilder<T>> createState() => _DefaultFormBuilderState<T>();
}

class _DefaultFormBuilderState<T extends Entity<T>>
    extends State<DefaultFormBuilder<T>> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Current form data
  late Map<String, dynamic> _formData;

  /// Validation errors
  final Map<String, String?> _errors = {};

  /// Loading state
  bool _isSubmitting = false;

  /// Form field keys
  final Map<String, GlobalKey<FormFieldState>> _fieldKeys = {};

  @override
  void initState() {
    super.initState();
    _formData = Map.from(widget.initialData);

    // Create form field keys
    for (final field in widget.fields) {
      _fieldKeys[field.fieldName] = GlobalKey<FormFieldState>();
    }
  }

  @override
  void didUpdateWidget(DefaultFormBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update form data if initial data changed
    if (widget.initialData != oldWidget.initialData) {
      setState(() {
        _formData = Map.from(widget.initialData);
      });
    }
  }

  /// Update a field value
  void _updateField(String fieldName, Object? value) {
    setState(() {
      _formData[fieldName] = value;
      _errors.remove(fieldName);
    });
  }

  /// Validate the form
  bool _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      // Form validation failed
      return false;
    }

    // Perform additional validation on fields
    var finalValidity = true;
    for (final field in widget.fields) {
      for (final validator in field.validators) {
        final value = _formData[field.fieldName];
        final error = validator(value);

        if (error != null) {
          setState(() {
            _errors[field.fieldName] = error;
          });
          finalValidity = false;
        }
      }
    }

    return finalValidity;
  }

  /// Submit the form
  Future<void> _submitForm() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (widget.onSubmit != null) {
        final success = await widget.onSubmit!(_formData);

        if (success) {
          // Form submitted successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully')),
          );
        } else {
          // Form submission failed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submission failed')),
          );
        }
      }
    } catch (e) {
      // Form submission error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form fields
          ...widget.fields.map(_buildField).toList(),

          // Disclosure level selector
          if (widget.onLevelChanged != null) _buildDisclosureControl(),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build the disclosure control
  Widget _buildDisclosureControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.disclosureLevel != DisclosureLevel.minimal)
          TextButton.icon(
            icon: const Icon(Icons.remove_circle_outline),
            label: const Text('Show less'),
            onPressed: () {
              if (widget.onLevelChanged != null) {
                final newLevel = widget.disclosureLevel.previous;
                widget.onLevelChanged!(newLevel);

                // Replace the current widget with the new one
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    // This will trigger a rebuild with the new widget
                  });
                });
              }
            },
          ),
        if (widget.disclosureLevel != DisclosureLevel.complete)
          TextButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Show more'),
            onPressed: () {
              if (widget.onLevelChanged != null) {
                final newLevel = widget.disclosureLevel.next;
                widget.onLevelChanged!(newLevel);

                // Replace the current widget with the new one
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    // This will trigger a rebuild with the new widget
                  });
                });
              }
            },
          ),
      ],
    );
  }

  /// Build a field based on its descriptor
  Widget _buildField(UXFieldDescriptor field) {
    final value = _formData[field.fieldName];
    final errorText = _errors[field.fieldName];

    // Check for a custom renderer
    final customRenderer = field.metadata['renderer'] as Widget Function(
      BuildContext,
      String,
      Object?,
      ValueChanged<Object?>,
    )?;

    if (customRenderer != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: customRenderer(
          context,
          field.fieldName,
          value,
          (newValue) => _updateField(field.fieldName, newValue),
        ),
      );
    }

    // Otherwise, use field type to determine widget
    switch (field.fieldType) {
      case UXFieldType.checkbox:
        return _buildCheckboxField(field, value);
      case UXFieldType.dropdown:
        return _buildDropdownField(field, value);
      case UXFieldType.radio:
        return _buildRadioField(field, value);
      case UXFieldType.date:
        return _buildDateField(field, value);
      case UXFieldType.number:
        return _buildNumberField(field, value, errorText);
      case UXFieldType.longText:
        return _buildLongTextField(field, value, errorText);
      case UXFieldType.text:
      default:
        return _buildTextField(field, value, errorText);
    }
  }

  /// Build a text field
  Widget _buildTextField(
    UXFieldDescriptor field,
    Object? value,
    String? errorText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: field.displayName,
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
    Object? value,
    String? errorText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: field.displayName,
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
    Object? value,
    String? errorText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: field.displayName,
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
              // Invalid number, keep as string
              _updateField(field.fieldName, newValue);
            }
          }
        },
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }

          if (value != null && value.isNotEmpty) {
            final numValue = double.tryParse(value.toString());
            if (numValue == null) {
              return 'Please enter a valid number';
            }

            // Check min/max constraints
            if (field.min != null && numValue < field.min!) {
              return 'Value must be at least ${field.min}';
            }

            if (field.max != null && numValue > field.max!) {
              return 'Value must be at most ${field.max}';
            }
          }

          return null;
        },
      ),
    );
  }

  /// Build a date field
  Widget _buildDateField(UXFieldDescriptor field, Object? value) {
    final errorText = _errors[field.fieldName];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: field.displayName,
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
  Widget _buildCheckboxField(UXFieldDescriptor field, Object? value) {
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
  Widget _buildDropdownField(UXFieldDescriptor field, Object? value) {
    final options = field.options ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<Object?>(
        decoration: InputDecoration(
          labelText: field.displayName,
          hintText: field.hint,
          helperText: field.help,
          border: const OutlineInputBorder(),
        ),
        value: value,
        items: options.map((option) {
          return DropdownMenuItem<Object?>(
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
  Widget _buildRadioField(UXFieldDescriptor field, Object? value) {
    final options = field.options ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              field.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...options.map((option) {
            return RadioListTile<Object?>(
              title: Text(option.label),
              value: option.value,
              groupValue: value,
              onChanged: option.disabled
                  ? null
                  : (newValue) => _updateField(field.fieldName, newValue),
            );
          }),
          if (field.required && value == null)
            const Padding(
              padding: EdgeInsets.only(top: 4.0, left: 12.0),
              child: Text(
                'This field is required',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
