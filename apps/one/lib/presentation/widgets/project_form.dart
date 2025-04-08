import 'package:flutter/material.dart';
import 'package:ednet_one/domain/services/project_service.dart';
import 'package:ednet_one/presentation/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:ednet_core/ednet_core.dart';

/// Form for creating and editing projects
class ProjectForm extends StatefulWidget {
  /// Project to edit (null for create mode)
  final Project? project;

  /// Callback when form is submitted
  final Function(bool success)? onComplete;

  /// Constructor
  const ProjectForm({
    Key? key,
    this.project,
    this.onComplete,
  }) : super(key: key);

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  String? _selectedDomainCode;
  String? _selectedModelCode;
  ProjectStatus _selectedStatus = ProjectStatus.development;

  List<Model> _availableModels = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Initialize with project data if editing
    final project = widget.project;
    _nameController = TextEditingController(text: project?.name ?? '');
    _descriptionController =
        TextEditingController(text: project?.description ?? '');

    _selectedStatus = project?.status ?? ProjectStatus.development;
    _selectedDomainCode = project?.domainCode;
    _selectedModelCode = project?.modelCode;

    // Load models if domain is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedDomainCode != null) {
        _loadModelsForDomain(_selectedDomainCode!);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadModelsForDomain(String domainCode) {
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    setState(() {
      _availableModels = projectProvider.getModelsForDomain(domainCode);

      // Clear model selection if it's not available in the new domain
      if (_selectedModelCode != null &&
          !_availableModels.any((m) => m.code == _selectedModelCode)) {
        _selectedModelCode = null;
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isSubmitting = true;
    });

    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);

    try {
      if (widget.project == null) {
        // Create new project
        final project = await projectProvider.createProject(
          name: _nameController.text,
          description: _descriptionController.text,
          domainCode: _selectedDomainCode!,
          modelCode: _selectedModelCode,
          status: _selectedStatus,
        );

        widget.onComplete?.call(project != null);
      } else {
        // Update existing project
        final project = await projectProvider.updateProject(
          id: widget.project!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          domainCode: _selectedDomainCode!,
          modelCode: _selectedModelCode,
          status: _selectedStatus,
        );

        widget.onComplete?.call(project != null);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      widget.onComplete?.call(false);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final availableDomains = projectProvider.availableDomains;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name field
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Description field
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Domain dropdown
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Domain',
              border: OutlineInputBorder(),
            ),
            value: _selectedDomainCode,
            items: availableDomains.map((domain) {
              return DropdownMenuItem<String>(
                value: domain.code,
                child: Text(domain.code),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDomainCode = value;
                _selectedModelCode = null; // Reset model when domain changes
              });

              if (value != null) {
                _loadModelsForDomain(value);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a domain';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Model dropdown (only enabled if domain is selected)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Model (Optional)',
              border: OutlineInputBorder(),
            ),
            value: _selectedModelCode,
            items: _availableModels.map((model) {
              return DropdownMenuItem<String>(
                value: model.code,
                child: Text(model.code),
              );
            }).toList(),
            onChanged: _selectedDomainCode == null
                ? null
                : (value) {
                    setState(() {
                      _selectedModelCode = value;
                    });
                  },
          ),

          const SizedBox(height: 16),

          // Status dropdown
          DropdownButtonFormField<ProjectStatus>(
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            value: _selectedStatus,
            items: ProjectStatus.values.map((status) {
              return DropdownMenuItem<ProjectStatus>(
                value: status,
                child: Text(status.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
          ),

          const SizedBox(height: 24),

          // Submit button
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.project == null
                    ? 'Create Project'
                    : 'Update Project'),
          ),
        ],
      ),
    );
  }
}
