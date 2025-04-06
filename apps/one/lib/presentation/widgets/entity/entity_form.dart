import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_event.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_state.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';

/// A form for creating or editing an entity
class EntityForm extends StatelessWidget {
  /// The concept for which the entity is being created/edited
  final Concept concept;

  /// The domain containing the concept
  final Domain domain;

  /// The model containing the concept
  final Model model;

  /// Callback when the form is canceled
  final VoidCallback? onCancel;

  /// Whether this form is for creating a new entity
  final bool isCreating;

  /// Creates an entity form
  const EntityForm({
    super.key,
    required this.concept,
    required this.domain,
    required this.model,
    this.onCancel,
    this.isCreating = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntityBloc, EntityState>(
      builder: (context, state) {
        if (state.status == EntityStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error if any
        if (state.errorMessage != null) {
          return _buildErrorMessage(context, state.errorMessage!);
        }

        return SemanticConceptContainer(
          conceptType: 'EntityForm',
          child: Padding(
            padding: EdgeInsets.all(context.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form title
                Text(
                  isCreating
                      ? 'Create ${concept.code}'
                      : 'Edit ${concept.code}',
                  style: context.conceptTextStyle('EntityForm', role: 'title'),
                ),
                SizedBox(height: context.spacingM),

                // Form fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Generate form fields for each attribute
                        ...concept.attributes.map(
                          (property) => _buildFormField(
                            context,
                            property,
                            state.formValues,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel button
                    OutlinedButton(
                      onPressed: () {
                        // Clear selection
                        context.read<EntityBloc>().add(ClearSelectionEvent());

                        // Call onCancel if provided
                        if (onCancel != null) {
                          onCancel!();
                        }
                      },
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: context.spacingM),

                    // Save button
                    ElevatedButton(
                      onPressed: () => _submitForm(context),
                      child: Text(isCreating ? 'Create' : 'Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage(BuildContext context, String errorMessage) {
    return SemanticConceptContainer(
      conceptType: 'Error',
      child: Padding(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: context.conceptColor('Error', role: 'icon'),
              size: 48,
            ),
            SizedBox(height: context.spacingM),
            Text(
              errorMessage,
              style: context.conceptTextStyle('Error', role: 'message'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacingM),
            ElevatedButton(
              onPressed: () {
                // Clear error and go back to editing
                context.read<EntityBloc>().add(ClearSelectionEvent());
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context,
    Property property,
    Map<String, dynamic> formValues,
  ) {
    final fieldValue = formValues[property.code];
    final propertyType = property.type?.toString().toLowerCase() ?? 'string';
    final isRequired = property.required ?? false;

    final bloc = context.read<EntityBloc>();

    // Build different form fields based on property type
    Widget formField;

    if (propertyType == 'string') {
      formField = TextFormField(
        initialValue: fieldValue as String? ?? '',
        decoration: InputDecoration(
          labelText: property.code,
          hintText: 'Enter ${property.code}',
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          bloc.add(SetFormFieldValueEvent(field: property.code, value: value));
        },
      );
    } else if (propertyType == 'int' || propertyType == 'integer') {
      formField = TextFormField(
        initialValue: (fieldValue as int?)?.toString() ?? '0',
        decoration: InputDecoration(
          labelText: property.code,
          hintText: 'Enter ${property.code}',
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          bloc.add(
            SetFormFieldValueEvent(
              field: property.code,
              value: int.tryParse(value) ?? 0,
            ),
          );
        },
      );
    } else if (propertyType == 'double' || propertyType == 'float') {
      formField = TextFormField(
        initialValue: (fieldValue as double?)?.toString() ?? '0.0',
        decoration: InputDecoration(
          labelText: property.code,
          hintText: 'Enter ${property.code}',
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          bloc.add(
            SetFormFieldValueEvent(
              field: property.code,
              value: double.tryParse(value) ?? 0.0,
            ),
          );
        },
      );
    } else if (propertyType == 'bool' || propertyType == 'boolean') {
      formField = CheckboxListTile(
        title: Text(property.code),
        value: fieldValue as bool? ?? false,
        onChanged: (value) {
          bloc.add(
            SetFormFieldValueEvent(field: property.code, value: value ?? false),
          );
        },
        controlAffinity: ListTileControlAffinity.leading,
      );
    } else if (propertyType == 'date' || propertyType == 'datetime') {
      final displayValue =
          fieldValue != null
              ? DateFormat('yyyy-MM-dd').format(fieldValue as DateTime)
              : 'Select date';

      formField = InkWell(
        onTap: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: fieldValue as DateTime? ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );

          if (selectedDate != null) {
            bloc.add(
              SetFormFieldValueEvent(field: property.code, value: selectedDate),
            );
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: property.code,
            border: const OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(displayValue), const Icon(Icons.calendar_today)],
          ),
        ),
      );
    } else {
      // Default to text field for unknown types
      formField = TextFormField(
        initialValue: fieldValue?.toString() ?? '',
        decoration: InputDecoration(
          labelText: property.code,
          hintText: 'Enter ${property.code}',
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          bloc.add(SetFormFieldValueEvent(field: property.code, value: value));
        },
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRequired)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Text(
                    'Required',
                    style: TextStyle(
                      color: context.conceptColor(
                        'EntityForm',
                        role: 'required',
                      ),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          formField,
        ],
      ),
    );
  }

  void _submitForm(BuildContext context) {
    final bloc = context.read<EntityBloc>();

    if (isCreating) {
      // Create new entity
      bloc.add(
        CreateEntityEvent(
          domain: domain,
          model: model,
          concept: concept,
          attributeValues: bloc.state.formValues,
        ),
      );
    } else {
      // Update existing entity
      final entity = bloc.state.selectedEntity;
      if (entity != null) {
        final oidValue = int.parse(entity.oid.toString());
        bloc.add(
          UpdateEntityEvent(
            domain: domain,
            model: model,
            concept: concept,
            oid: oidValue,
            attributeValues: bloc.state.formValues,
          ),
        );
      }
    }
  }
}
