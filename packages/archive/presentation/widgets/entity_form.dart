import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:provider/provider.dart';

/// A callback type for when an entity form is submitted
typedef EntityFormSubmitCallback<T extends Entity<T>> = Future<void> Function(
    T entity, Map<String, dynamic> formData);

/// A callback type for form validation
typedef EntityFormValidateCallback<T extends Entity<T>> = String? Function(
    String fieldName, dynamic value, T entity);

/// A form state for tracking changes and validation
class EntityFormState<T extends Entity<T>> extends ChangeNotifier {
  /// The entity being edited
  final T entity;

  /// The current form data
  final Map<String, dynamic> formData = {};

  /// Validation errors by field
  final Map<String, String?> validationErrors = {};

  /// Whether form is currently submitting
  bool isSubmitting = false;

  /// List of commands executed
  final List<Object> executedCommands = [];

  /// List of events triggered
  final List<Object> events = [];

  /// Constructor
  EntityFormState(this.entity);

  /// Update a field value
  void updateField(String name, dynamic value) {
    formData[name] = value;
    validationErrors.remove(name); // Clear validation error when value changes
    notifyListeners();
  }

  /// Set a validation error
  void setValidationError(String field, String? error) {
    validationErrors[field] = error;
    notifyListeners();
  }

  /// Start submission
  void startSubmitting() {
    isSubmitting = true;
    notifyListeners();
  }

  /// End submission
  void endSubmitting() {
    isSubmitting = false;
    notifyListeners();
  }

  /// Record executed command
  void recordCommand(Object command) {
    executedCommands.add(command);
    notifyListeners();
  }

  /// Record event
  void recordEvent(Object event) {
    events.add(event);
    notifyListeners();
  }

  /// Check if form has validation errors
  bool get hasErrors => validationErrors.values.any((error) => error != null);

  /// Clear all errors
  void clearErrors() {
    validationErrors.clear();
    notifyListeners();
  }
}

/// A generic form for editing any entity
class EntityForm<T extends Entity<T>> extends StatefulWidget {
  /// The entity to edit
  final T entity;

  /// Callback when form is submitted
  final EntityFormSubmitCallback<T>? onSubmit;

  /// Callback to validate fields
  final EntityFormValidateCallback<T>? onValidate;

  /// Title for the form
  final String title;

  /// Custom form fields builder
  final Widget Function(BuildContext, EntityFormState<T>)? fieldsBuilder;

  /// Submit button text
  final String submitButtonText;

  /// Whether to show debug information
  final bool showDebugInfo;

  /// Constructor
  const EntityForm({
    Key? key,
    required this.entity,
    this.onSubmit,
    this.onValidate,
    this.title = 'Entity Form',
    this.fieldsBuilder,
    this.submitButtonText = 'Save',
    this.showDebugInfo = false,
  }) : super(key: key);

  @override
  _EntityFormState<T> createState() => _EntityFormState<T>();
}

class _EntityFormState<T extends Entity<T>> extends State<EntityForm<T>> {
  late EntityFormState<T> _formState;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _formState = EntityFormState<T>(widget.entity);

    // Pre-populate form data from entity
    final concept = widget.entity.concept;
    for (var attribute in concept.attributes) {
      if (attribute is Attribute) {
        _formState.formData[attribute.code] =
            widget.entity.getAttribute(attribute.code);
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    _formState.startSubmitting();

    try {
      if (widget.onSubmit != null) {
        await widget.onSubmit!(widget.entity, _formState.formData);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      _formState.endSubmitting();
    }
  }

  String? _validateField(String fieldName, dynamic value) {
    // First, use custom validation if provided
    if (widget.onValidate != null) {
      final customError = widget.onValidate!(fieldName, value, widget.entity);
      if (customError != null) {
        return customError;
      }
    }

    // Then do standard validation based on attribute metadata
    final attribute = widget.entity.concept.attributes
        .whereType<Attribute>()
        .where((a) => a.code == fieldName)
        .firstOrNull;

    if (attribute == null) return null;

    // Check required field
    if (attribute.required && (value == null || value.toString().isEmpty)) {
      return 'This field is required';
    }

    // Check type validation if the attribute has a type
    if (attribute.type != null && value != null) {
      if (!attribute.type!.validateValue(value)) {
        return 'Invalid value for type ${attribute.type!.code}';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _formState,
      child: Form(
        key: _formKey,
        child: Consumer<EntityFormState<T>>(
          builder: (context, formState, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form title
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                // Form fields - either custom or generated
                if (widget.fieldsBuilder != null) ...[
                  widget.fieldsBuilder!(context, formState),
                ] else ...[
                  _buildGeneratedFormFields(formState),
                ],

                const SizedBox(height: 24),

                // Validation errors summary
                if (formState.hasErrors) ...[
                  Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Please fix the following issues:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          ...formState.validationErrors.entries
                              .where((e) => e.value != null)
                              .map(
                                (e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text('• ${e.key}: ${e.value}'),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit button
                ElevatedButton(
                  onPressed: formState.isSubmitting ? null : _submitForm,
                  child: formState.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.submitButtonText),
                ),

                // Debug info
                if (widget.showDebugInfo &&
                    (formState.executedCommands.isNotEmpty ||
                        formState.events.isNotEmpty)) ...[
                  const SizedBox(height: 24),
                  ExpansionTile(
                    title: const Text('Debug Information'),
                    children: [
                      if (formState.executedCommands.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Executed Commands:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...formState.executedCommands.map(
                          (cmd) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: Text(cmd.toString()),
                          ),
                        ),
                      ],
                      if (formState.events.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Events:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...formState.events.map(
                          (event) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: Text(event.toString()),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGeneratedFormFields(EntityFormState<T> formState) {
    final fields = <Widget>[];
    final concept = widget.entity.concept;

    // Build form fields based on entity attributes
    for (var attribute in concept.attributes.whereType<Attribute>()) {
      // Skip attributes that don't need UI representation
      if (attribute.code == 'id' || attribute.code == 'oid') continue;
      if (attribute.derive) continue; // Skip derived attributes

      fields.add(_buildFieldForAttribute(attribute, formState));
      fields.add(const SizedBox(height: 16));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: fields,
    );
  }

  Widget _buildFieldForAttribute(
      Attribute attribute, EntityFormState<T> formState) {
    // Default value from form data or entity
    final value = formState.formData[attribute.code] ??
        widget.entity.getAttribute(attribute.code);

    // Determine field type based on attribute type
    final type = attribute.type?.code ?? 'String';

    switch (type) {
      case 'bool':
        return SwitchListTile(
          title: Text(attribute.code),
          value: (value as bool?) ?? false,
          onChanged: (newValue) {
            formState.updateField(attribute.code, newValue);
          },
        );

      case 'int':
      case 'double':
      case 'num':
        return TextFormField(
          decoration: InputDecoration(
            labelText: attribute.code,
            border: const OutlineInputBorder(),
            errorText: formState.validationErrors[attribute.code],
          ),
          initialValue: value?.toString() ?? '',
          keyboardType: TextInputType.number,
          onChanged: (newValue) {
            dynamic parsedValue;
            try {
              if (type == 'int') {
                parsedValue = int.tryParse(newValue);
              } else {
                parsedValue = double.tryParse(newValue);
              }
            } catch (_) {
              parsedValue = null;
            }
            formState.updateField(attribute.code, parsedValue);
          },
          validator: (value) {
            final error = _validateField(attribute.code, value);
            formState.setValidationError(attribute.code, error);
            return error;
          },
        );

      case 'DateTime':
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: attribute.code,
                  border: const OutlineInputBorder(),
                  errorText: formState.validationErrors[attribute.code],
                ),
                initialValue: value?.toString() ?? '',
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: value ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    formState.updateField(attribute.code, date);
                  }
                },
                validator: (value) {
                  final error = _validateField(attribute.code, value);
                  formState.setValidationError(attribute.code, error);
                  return error;
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: value ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  formState.updateField(attribute.code, date);
                }
              },
            ),
          ],
        );

      // Handle enum types - we'll check for known enum-like behavior
      case 'enum':
        // Get possible values - this is a simplification since we don't have a validValues property
        // We're assuming this might be available in the future or can be derived from other metadata
        final possibleValues = _getPossibleValuesForAttribute(attribute);
        if (possibleValues.isNotEmpty) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: attribute.code,
              border: const OutlineInputBorder(),
              errorText: formState.validationErrors[attribute.code],
            ),
            value: value?.toString(),
            items: possibleValues.map((val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            }).toList(),
            onChanged: (newValue) {
              formState.updateField(attribute.code, newValue);
            },
            validator: (value) {
              final error = _validateField(attribute.code, value);
              formState.setValidationError(attribute.code, error);
              return error;
            },
          );
        }
        return _buildDefaultTextField(attribute, formState, value);

      // Default to String for all other types
      default:
        return _buildDefaultTextField(attribute, formState, value);
    }
  }

  // Helper method to extract potential valid values for an attribute
  List<String> _getPossibleValuesForAttribute(Attribute attribute) {
    // In a real implementation, we might derive this from metadata, annotations, or concept definition
    // For now, we'll return an empty list as a placeholder
    return [];
  }

  // Default text field implementation to avoid code duplication
  Widget _buildDefaultTextField(
      Attribute attribute, EntityFormState<T> formState, dynamic value) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: attribute.code,
        border: const OutlineInputBorder(),
        errorText: formState.validationErrors[attribute.code],
      ),
      initialValue: value?.toString() ?? '',
      maxLines: attribute.code.toLowerCase().contains('description') ? 3 : 1,
      onChanged: (newValue) {
        formState.updateField(attribute.code, newValue);
      },
      validator: (value) {
        final error = _validateField(attribute.code, value);
        formState.setValidationError(attribute.code, error);
        return error;
      },
    );
  }
}
