part of ednet_core_flutter;

/// A generic form component for editing any entity type
///
/// This component automatically creates form fields for all attributes of the entity
/// and handles validation, submission and error handling.
class GenericEntityForm extends StatefulWidget {
  /// The entity to edit
  final Entity entity;

  /// The shell app instance
  final ShellApp shellApp;

  /// Initial data to populate the form
  final Map<String, dynamic>? initialData;

  /// Disclosure level to control which fields are shown
  final DisclosureLevel? disclosureLevel;

  /// Callback when the form is submitted and saved
  final void Function(Map<String, dynamic> data)? onSaved;

  /// Callback when the form is cancelled
  final VoidCallback? onCancel;

  /// Whether to show a loading indicator during submission
  final bool showLoadingIndicator;

  /// Whether the form is in edit mode (vs create mode)
  final bool isEditMode;

  /// Custom field descriptors that override the auto-generated ones
  final List<UXFieldDescriptor>? customFields;

  /// Constructor
  const GenericEntityForm({
    Key? key,
    required this.entity,
    required this.shellApp,
    this.initialData,
    this.disclosureLevel,
    this.onSaved,
    this.onCancel,
    this.showLoadingIndicator = true,
    this.isEditMode = true,
    this.customFields,
  }) : super(key: key);

  @override
  State<GenericEntityForm> createState() => _GenericEntityFormState();
}

class _GenericEntityFormState extends State<GenericEntityForm> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Current form data
  late Map<String, dynamic> _formData;

  /// Field descriptors for the form
  late List<UXFieldDescriptor> _fields;

  /// Current disclosure level
  late DisclosureLevel _disclosureLevel;

  /// Loading state
  bool _isSubmitting = false;

  /// Error message if any
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(GenericEntityForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reinitialize if entity changed
    if (widget.entity != oldWidget.entity) {
      _initialize();
    }
  }

  /// Initialize the form with entity data
  void _initialize() {
    // Set initial form data
    _formData = Map.from(widget.initialData ?? _extractEntityData());

    // Set disclosure level
    _disclosureLevel =
        widget.disclosureLevel ?? widget.shellApp.currentDisclosureLevel;

    // Build field descriptors
    _buildFieldDescriptors();
  }

  /// Extract data from the entity
  Map<String, dynamic> _extractEntityData() {
    final data = <String, dynamic>{};

    // Get all attributes from the entity's concept
    for (final attribute in widget.entity.concept.attributes) {
      if (attribute is Attribute) {
        try {
          // Get attribute value from entity
          final value = widget.entity.getAttribute(attribute.code);
          data[attribute.code] = value;
        } catch (e) {
          // Skip attributes that don't exist on the entity
        }
      }
    }

    return data;
  }

  /// Build field descriptors for all attributes
  void _buildFieldDescriptors() {
    if (widget.customFields != null) {
      _fields = widget.customFields!;
      return;
    }

    // Create field descriptors for each attribute
    final attributes = widget.entity.concept.attributes;
    _fields = [];

    for (final attribute in attributes) {
      if (attribute is Attribute) {
        // Skip system attributes
        if (attribute.code == 'oid' || attribute.code == 'whenModified') {
          continue;
        }

        // Build field descriptor
        final field = UXFieldBuilder.buildField(attribute);
        _fields.add(field);
      }
    }

    // Filter fields by disclosure level
    _fields = filterFieldsByDisclosure(_fields, _disclosureLevel);

    // Sort fields - required first, then alphabetical
    _fields.sort((a, b) {
      if (a.required && !b.required) return -1;
      if (!a.required && b.required) return 1;
      return a.displayName.compareTo(b.displayName);
    });
  }

  /// Handle form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) {
      // Form validation failed
      return;
    }

    // Save the form
    _formKey.currentState?.save();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Check if there's a custom save handler
      if (widget.onSaved != null) {
        widget.onSaved!(_formData);
        return;
      }

      // Default save behavior - save to repository
      final conceptCode = widget.entity.concept.code;

      // If edit mode, include the ID
      if (widget.isEditMode) {
        _formData['id'] = widget.entity.oid.toString();
      }

      // Save entity data
      final success = await widget.shellApp.saveEntity(conceptCode, _formData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${widget.entity.concept.code} saved successfully')),
        );

        if (widget.onSaved != null) {
          widget.onSaved!(_formData);
        } else {
          // Close form on success if no custom handler
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to save ${widget.entity.concept.code}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// Handle disclosure level change
  void _handleDisclosureLevelChange(DisclosureLevel newLevel) {
    setState(() {
      _disclosureLevel = newLevel;
      _buildFieldDescriptors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              widget.isEditMode
                  ? 'Edit ${widget.entity.concept.code}'
                  : 'Create ${widget.entity.concept.code}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          // Error message
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),
            ),

          // Form fields
          ..._fields
              .map((field) => _buildField(field, _formData[field.fieldName])),

          // Disclosure level buttons
          _buildDisclosureControls(),

          // Form buttons
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          if (widget.onCancel != null) {
                            widget.onCancel!();
                          } else {
                            Navigator.of(context).pop(false);
                          }
                        },
                  child: const Text('Cancel'),
                ),

                const SizedBox(width: 16.0),

                // Save button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting && widget.showLoadingIndicator
                      ? const SizedBox(
                          width: 16.0,
                          height: 16.0,
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        )
                      : Text(widget.isEditMode ? 'Save' : 'Create'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a field based on its descriptor
  Widget _buildField(UXFieldDescriptor field, dynamic value) {
    // Use local variable to store the form data value
    final fieldValue = _formData[field.fieldName];

    // Check for a custom renderer in the field
    if (field.customRenderer != null) {
      return field.customRenderer!(
          context,
          field.fieldName,
          fieldValue,
          (newValue) => setState(() {
                _formData[field.fieldName] = newValue;
              }));
    }

    // Otherwise, use field type to determine widget type
    switch (field.fieldType) {
      case UXFieldType.checkbox:
        return _buildCheckboxField(field, fieldValue);
      case UXFieldType.dropdown:
        return _buildDropdownField(field, fieldValue);
      case UXFieldType.radio:
        return _buildRadioField(field, fieldValue);
      case UXFieldType.date:
        return _buildDateField(field, fieldValue);
      case UXFieldType.number:
        return _buildNumberField(field, fieldValue);
      case UXFieldType.longText:
        return _buildLongTextField(field, fieldValue);
      case UXFieldType.text:
      default:
        return _buildTextField(field, fieldValue);
    }
  }

  /// Build a text field
  Widget _buildTextField(UXFieldDescriptor field, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        key: GlobalKey<FormFieldState>(),
        decoration: InputDecoration(
          labelText: field.displayName,
          hintText: field.hint,
          helperText: field.help,
          border: const OutlineInputBorder(),
        ),
        initialValue: value?.toString() ?? '',
        onChanged: (newValue) => setState(() {
          _formData[field.fieldName] = newValue;
        }),
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }

          for (final validator in field.validators) {
            final error = validator(value);
            if (error != null) {
              return error;
            }
          }

          return null;
        },
      ),
    );
  }

  /// Build a long text field
  Widget _buildLongTextField(UXFieldDescriptor field, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        key: GlobalKey<FormFieldState>(),
        decoration: InputDecoration(
          labelText: field.displayName,
          hintText: field.hint,
          helperText: field.help,
          border: const OutlineInputBorder(),
        ),
        initialValue: value?.toString() ?? '',
        maxLines: 5,
        onChanged: (newValue) => setState(() {
          _formData[field.fieldName] = newValue;
        }),
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }

          for (final validator in field.validators) {
            final error = validator(value);
            if (error != null) {
              return error;
            }
          }

          return null;
        },
      ),
    );
  }

  /// Build a number field
  Widget _buildNumberField(UXFieldDescriptor field, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        key: GlobalKey<FormFieldState>(),
        decoration: InputDecoration(
          labelText: field.displayName,
          hintText: field.hint,
          helperText: field.help,
          border: const OutlineInputBorder(),
        ),
        initialValue: value?.toString() ?? '',
        keyboardType: TextInputType.number,
        onChanged: (newValue) => setState(() {
          // Try to parse as a number
          if (newValue.isEmpty) {
            _formData[field.fieldName] = null;
          } else {
            try {
              if (newValue.contains('.')) {
                _formData[field.fieldName] = double.parse(newValue);
              } else {
                _formData[field.fieldName] = int.parse(newValue);
              }
            } catch (e) {
              // Invalid number, keep as string
              _formData[field.fieldName] = newValue;
            }
          }
        }),
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return 'This field is required';
          }

          if (value != null && value.isNotEmpty) {
            final numValue = double.tryParse(value);
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

          for (final validator in field.validators) {
            final error = validator(value);
            if (error != null) {
              return error;
            }
          }

          return null;
        },
      ),
    );
  }

  /// Build a date field
  Widget _buildDateField(UXFieldDescriptor field, dynamic value) {
    String displayValue = '';

    if (value is DateTime) {
      displayValue = '${value.day}/${value.month}/${value.year}';
    } else if (value != null) {
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              key: GlobalKey<FormFieldState>(),
              decoration: InputDecoration(
                labelText: field.displayName,
                hintText: field.hint,
                helperText: field.help,
                border: const OutlineInputBorder(),
              ),
              readOnly: true,
              initialValue: displayValue,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: value is DateTime ? value : DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (date != null) {
                  setState(() {
                    _formData[field.fieldName] = date;
                  });
                }
              },
              validator: (value) {
                if (field.required && (value == null || value.isEmpty)) {
                  return 'This field is required';
                }

                for (final validator in field.validators) {
                  final error = validator(value);
                  if (error != null) {
                    return error;
                  }
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
                setState(() {
                  _formData[field.fieldName] = date;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  /// Build checkbox field
  Widget _buildCheckboxField(UXFieldDescriptor field, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormField<bool>(
        key: GlobalKey<FormFieldState>(),
        initialValue: value is bool ? value : false,
        validator: (value) {
          if (field.required && value != true) {
            return 'This field is required';
          }

          for (final validator in field.validators) {
            final error = validator(value);
            if (error != null) {
              return error;
            }
          }

          return null;
        },
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                title: Text(field.displayName),
                subtitle: field.help != null ? Text(field.help!) : null,
                value: formState.value ?? false,
                onChanged: (newValue) {
                  formState.didChange(newValue);
                  setState(() {
                    _formData[field.fieldName] = newValue;
                  });
                },
              ),
              if (formState.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    formState.errorText!,
                    style:
                        TextStyle(color: Colors.red.shade700, fontSize: 12.0),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Build a dropdown field
  Widget _buildDropdownField(UXFieldDescriptor field, dynamic value) {
    final options = field.options ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<Object?>(
        key: GlobalKey<FormFieldState>(),
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
        onChanged: (newValue) => setState(() {
          _formData[field.fieldName] = newValue;
        }),
        validator: (value) {
          if (field.required && value == null) {
            return 'This field is required';
          }

          for (final validator in field.validators) {
            final error = validator(value);
            if (error != null) {
              return error;
            }
          }

          return null;
        },
      ),
    );
  }

  /// Build a radio field
  Widget _buildRadioField(UXFieldDescriptor field, dynamic value) {
    final options = field.options ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormField<Object?>(
        key: GlobalKey<FormFieldState>(),
        initialValue: value,
        validator: (value) {
          if (field.required && value == null) {
            return 'This field is required';
          }

          for (final validator in field.validators) {
            final error = validator(value);
            if (error != null) {
              return error;
            }
          }

          return null;
        },
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                child: Text(
                  field.displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...options.map((option) {
                return RadioListTile<Object?>(
                  title: Text(option.label),
                  value: option.value,
                  groupValue: formState.value,
                  onChanged: option.disabled
                      ? null
                      : (newValue) {
                          formState.didChange(newValue);
                          setState(() {
                            _formData[field.fieldName] = newValue;
                          });
                        },
                );
              }),
              if (formState.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    formState.errorText!,
                    style:
                        TextStyle(color: Colors.red.shade700, fontSize: 12.0),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Build disclosure level controls
  Widget _buildDisclosureControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_disclosureLevel != DisclosureLevel.minimal)
            TextButton.icon(
              icon: const Icon(Icons.remove_circle_outline),
              label: const Text('Show less'),
              onPressed: () {
                _handleDisclosureLevelChange(_disclosureLevel.previous);
              },
            ),
          if (_disclosureLevel != DisclosureLevel.complete)
            TextButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Show more'),
              onPressed: () {
                _handleDisclosureLevelChange(_disclosureLevel.next);
              },
            ),
        ],
      ),
    );
  }
}
