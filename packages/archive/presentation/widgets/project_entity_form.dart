import 'package:flutter/material.dart';
import 'package:ednet_one/domain/entities/project_entity.dart';
import 'package:ednet_one/domain/services/project_service.dart';
import 'package:ednet_one/presentation/widgets/entity_form.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/main.dart';

/// A specialized form for editing or creating ProjectEntity instances
class ProjectEntityForm extends StatelessWidget {
  /// The project entity to edit (null for create mode)
  final ProjectEntity? projectEntity;

  /// Callback when form is submitted
  final Function(bool success)? onComplete;

  /// Project service for persistence operations
  final ProjectService projectService;

  /// Constructor
  const ProjectEntityForm({
    Key? key,
    this.projectEntity,
    this.onComplete,
    required this.projectService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCreating = projectEntity == null;

    return EntityForm<ProjectEntity>(
      entity: projectEntity ?? ProjectEntity(), // Use empty entity for creation
      title: isCreating ? 'Create Project' : 'Edit Project',
      submitButtonText: isCreating ? 'Create' : 'Update',
      showDebugInfo: true, // Show events and commands for debugging
      fieldsBuilder: _buildProjectFields,
      onSubmit: (entity, formData) => _submitProject(entity, formData, context),
      onValidate: _validateProjectField,
    );
  }

  /// Build custom fields for the project form
  Widget _buildProjectFields(
      BuildContext context, EntityFormState<ProjectEntity> formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Name field
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Project Name',
            border: OutlineInputBorder(),
            errorText: null,
          ),
          initialValue: formState.entity.name,
          onChanged: (value) => formState.updateField('name', value),
          validator: (value) {
            final error =
                _validateProjectField('name', value, formState.entity);
            formState.setValidationError('name', error);
            return error;
          },
        ),

        const SizedBox(height: 16),

        // Description field
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Project Description',
            border: OutlineInputBorder(),
            errorText: null,
          ),
          initialValue: formState.entity.description,
          maxLines: 3,
          onChanged: (value) => formState.updateField('description', value),
          validator: (value) {
            final error =
                _validateProjectField('description', value, formState.entity);
            formState.setValidationError('description', error);
            return error;
          },
        ),

        const SizedBox(height: 16),

        // Domain dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Domain',
            border: OutlineInputBorder(),
          ),
          value: formState.entity.domainCode.isNotEmpty
              ? formState.entity.domainCode
              : null,
          items: _buildDomainItems(),
          onChanged: (value) {
            if (value != null) {
              formState.updateField('domainCode', value);

              // Reset model when domain changes
              formState.updateField('modelCode', null);
            }
          },
          validator: (value) {
            final error =
                _validateProjectField('domainCode', value, formState.entity);
            formState.setValidationError('domainCode', error);
            return error;
          },
        ),

        const SizedBox(height: 16),

        // Model dropdown (only enabled if domain is selected)
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Model (Optional)',
            border: OutlineInputBorder(),
          ),
          value: formState.entity.modelCode,
          items: _buildModelItems(
              formState.formData['domainCode'] ?? formState.entity.domainCode),
          onChanged: formState.formData['domainCode'] != null ||
                  formState.entity.domainCode.isNotEmpty
              ? (value) => formState.updateField('modelCode', value)
              : null,
        ),

        const SizedBox(height: 16),

        // Status dropdown
        DropdownButtonFormField<ProjectStatus>(
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
          ),
          value: formState.entity.status,
          items: ProjectStatus.values.map((status) {
            return DropdownMenuItem<ProjectStatus>(
              value: status,
              child: Text(status.toString().split('.').last),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              formState.updateField('status', value);
            }
          },
        ),
      ],
    );
  }

  /// Custom validation for project fields
  String? _validateProjectField(
      String fieldName, dynamic value, ProjectEntity entity) {
    switch (fieldName) {
      case 'name':
        if (value == null || value.toString().isEmpty) {
          return 'Project name is required';
        }
        if (value.toString().length < 3) {
          return 'Project name must be at least 3 characters';
        }
        return null;

      case 'description':
        if (value == null || value.toString().isEmpty) {
          return 'Project description is required';
        }
        return null;

      case 'domainCode':
        if (value == null || value.toString().isEmpty) {
          return 'Domain is required';
        }
        return null;

      default:
        return null;
    }
  }

  /// Build domain dropdown items
  List<DropdownMenuItem<String>> _buildDomainItems() {
    final domains = oneApplication.domains.toList();
    return domains.map((domain) {
      return DropdownMenuItem<String>(
        value: domain.code,
        child: Text(domain.code),
      );
    }).toList();
  }

  /// Build model dropdown items for a specific domain
  List<DropdownMenuItem<String>> _buildModelItems(String domainCode) {
    if (domainCode.isEmpty) {
      return [];
    }

    try {
      final domain = oneApplication.domains.firstWhere(
        (d) => d.code == domainCode,
      );

      return domain.models.map((model) {
        return DropdownMenuItem<String>(
          value: model.code,
          child: Text(model.code),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Submit the project form
  Future<void> _submitProject(
    ProjectEntity entity,
    Map<String, dynamic> formData,
    BuildContext context,
  ) async {
    // Apply form data to entity
    if (formData.containsKey('name')) {
      entity.name = formData['name'];
    }

    if (formData.containsKey('description')) {
      entity.description = formData['description'];
    }

    if (formData.containsKey('domainCode')) {
      entity.domainCode = formData['domainCode'];
    }

    if (formData.containsKey('modelCode')) {
      entity.modelCode = formData['modelCode'];
    }

    if (formData.containsKey('status')) {
      entity.status = formData['status'];
    }

    try {
      if (projectEntity == null) {
        // Create new project
        final newEntity = ProjectEntity.create(
          name: entity.name,
          description: entity.description,
          domainCode: entity.domainCode,
          modelCode: entity.modelCode,
          status: entity.status,
        );

        // Save using project service
        final project = await projectService.createProject(
          name: newEntity.name,
          description: newEntity.description,
          domainCode: newEntity.domainCode,
          modelCode: newEntity.modelCode,
          status: newEntity.status,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created successfully')),
        );

        onComplete?.call(project != null);
      } else {
        // Update existing project
        entity.update(
          name: entity.name,
          description: entity.description,
          domainCode: entity.domainCode,
          modelCode: entity.modelCode,
          status: entity.status,
        );

        // Save using project service
        final project = await projectService.updateProject(
          id: entity.id,
          name: entity.name,
          description: entity.description,
          domainCode: entity.domainCode,
          modelCode: entity.modelCode,
          status: entity.status,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project updated successfully')),
        );

        onComplete?.call(project != null);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      onComplete?.call(false);
    }
  }
}
