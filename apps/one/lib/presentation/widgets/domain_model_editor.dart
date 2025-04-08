import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:provider/provider.dart';
import 'package:ednet_one/presentation/providers/project_provider.dart';
import 'package:ednet_one/main.dart';

/// Widget for editing a domain model
class DomainModelEditor extends StatefulWidget {
  /// The domain code
  final String domainCode;

  /// The model code (optional)
  final String? modelCode;

  /// Constructor
  const DomainModelEditor({
    Key? key,
    required this.domainCode,
    this.modelCode,
  }) : super(key: key);

  @override
  _DomainModelEditorState createState() => _DomainModelEditorState();
}

class _DomainModelEditorState extends State<DomainModelEditor> {
  Domain? _domain;
  Model? _model;
  Concept? _selectedConcept;
  Property? _selectedAttribute;

  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDomainModel();
  }

  Future<void> _loadDomainModel() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Find the domain
      _domain = oneApplication.domains.firstWhere(
        (d) => d.code == widget.domainCode,
        orElse: () => throw Exception('Domain not found: ${widget.domainCode}'),
      );

      // Find the model
      if (widget.modelCode != null) {
        _model = _domain!.models.firstWhere(
          (m) => m.code == widget.modelCode,
          orElse: () => throw Exception('Model not found: ${widget.modelCode}'),
        );
      } else if (_domain!.models.isNotEmpty) {
        _model = _domain!.models.first;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading domain model: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveDomainModel() async {
    if (_domain == null || _model == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await persistenceService.saveDomainModel(_domain!, _model!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Domain model saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving domain model: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addConcept() {
    if (_model == null) return;

    showDialog(
      context: context,
      builder: (context) => _ConceptFormDialog(
        onSave: (name, description) {
          setState(() {
            final concept = Concept(_model!, name);
            concept.description = description;
            _model!.concepts.add(concept);
            _selectedConcept = concept;
            _selectedAttribute = null;
          });
        },
      ),
    );
  }

  void _editConcept(Concept concept) {
    showDialog(
      context: context,
      builder: (context) => _ConceptFormDialog(
        initialName: concept.code,
        initialDescription: concept.description,
        onSave: (name, description) {
          setState(() {
            // Cannot change concept code (not supported in ednet_core)
            concept.description = description;
          });
        },
      ),
    );
  }

  void _deleteConcept(Concept concept) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Concept'),
        content: Text('Are you sure you want to delete "${concept.code}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _model!.concepts.remove(concept);
                if (_selectedConcept == concept) {
                  _selectedConcept = null;
                  _selectedAttribute = null;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addAttribute() {
    if (_selectedConcept == null) return;

    showDialog(
      context: context,
      builder: (context) => _AttributeFormDialog(
        domain: _domain!,
        onSave: (name, type, required) {
          setState(() {
            final attribute = Property(_selectedConcept!, name);
            attribute.type = type;
            attribute.required = required;
            _selectedConcept!.attributes.add(attribute);
            _selectedAttribute = attribute;
          });
        },
      ),
    );
  }

  void _editAttribute(Property attribute) {
    showDialog(
      context: context,
      builder: (context) => _AttributeFormDialog(
        domain: _domain!,
        initialName: attribute.code,
        initialType: attribute.type,
        initialRequired: attribute.required,
        onSave: (name, type, required) {
          setState(() {
            // Cannot change attribute code (not supported in ednet_core)
            attribute.type = type;
            attribute.required = required;
          });
        },
      ),
    );
  }

  void _deleteAttribute(Property attribute) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attribute'),
        content: Text('Are you sure you want to delete "${attribute.code}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _selectedConcept!.attributes.remove(attribute);
                if (_selectedAttribute == attribute) {
                  _selectedAttribute = null;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_domain == null) {
      return const Center(child: Text('Domain not found'));
    }

    if (_model == null) {
      return const Center(child: Text('No models available for this domain'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        const Divider(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Concepts panel
              SizedBox(
                width: 250,
                child: _buildConceptsPanel(),
              ),
              const VerticalDivider(),
              // Attributes panel
              Expanded(
                child: _buildAttributesPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Domain: ${_domain!.code}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Model: ${_model!.code}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_domain!.description.isNotEmpty ||
                    _model!.description.isNotEmpty)
                  const SizedBox(height: 8),
                if (_domain!.description.isNotEmpty)
                  Text(
                    'Domain Description: ${_domain!.description}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                if (_model!.description.isNotEmpty)
                  Text(
                    'Model Description: ${_model!.description}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save Model'),
            onPressed: _saveDomainModel,
          ),
        ],
      ),
    );
  }

  Widget _buildConceptsPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Concepts',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add Concept',
                onPressed: _addConcept,
              ),
            ],
          ),
        ),
        Expanded(
          child: _model!.concepts.isEmpty
              ? const Center(child: Text('No concepts defined'))
              : ListView.builder(
                  itemCount: _model!.concepts.length,
                  itemBuilder: (context, index) {
                    final concept = _model!.concepts.elementAt(index);
                    final isSelected = _selectedConcept == concept;

                    return ListTile(
                      title: Text(concept.code),
                      subtitle: concept.description.isNotEmpty
                          ? Text(
                              concept.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedConcept = concept;
                          _selectedAttribute = null;
                        });
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _editConcept(concept),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () => _deleteConcept(concept),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAttributesPanel() {
    if (_selectedConcept == null) {
      return const Center(
        child: Text('Select a concept to view attributes'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attributes for ${_selectedConcept!.code}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (_selectedConcept!.description.isNotEmpty)
                      Text(
                        _selectedConcept!.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add Attribute',
                onPressed: _addAttribute,
              ),
            ],
          ),
        ),
        Expanded(
          child: _selectedConcept!.attributes.isEmpty
              ? const Center(child: Text('No attributes defined'))
              : ListView.builder(
                  itemCount: _selectedConcept!.attributes.length,
                  itemBuilder: (context, index) {
                    final attribute =
                        _selectedConcept!.attributes.elementAt(index);
                    if (attribute is! Property) {
                      return const ListTile(
                        title: Text('Non-property attribute (not editable)'),
                      );
                    }

                    final property = attribute as Property;
                    final isSelected = _selectedAttribute == property;

                    return ListTile(
                      title: Text(property.code),
                      subtitle: Text(
                        'Type: ${property.type?.code ?? 'not set'} | ${property.required ? 'Required' : 'Optional'}',
                      ),
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedAttribute = property;
                        });
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _editAttribute(property),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () => _deleteAttribute(property),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Dialog for creating/editing concepts
class _ConceptFormDialog extends StatefulWidget {
  final String? initialName;
  final String? initialDescription;
  final Function(String name, String description) onSave;

  const _ConceptFormDialog({
    Key? key,
    this.initialName,
    this.initialDescription,
    required this.onSave,
  }) : super(key: key);

  @override
  _ConceptFormDialogState createState() => _ConceptFormDialogState();
}

class _ConceptFormDialogState extends State<_ConceptFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialName != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Concept' : 'Add Concept'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Concept Name',
                hintText: 'e.g., Person, Product, Order',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$').hasMatch(value)) {
                  return 'Name must start with a letter and contain only letters and numbers';
                }
                return null;
              },
              enabled:
                  !isEditing, // Cannot edit name if editing existing concept
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Describe the purpose of this concept',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _nameController.text,
                _descriptionController.text,
              );
              Navigator.pop(context);
            }
          },
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}

/// Dialog for creating/editing attributes
class _AttributeFormDialog extends StatefulWidget {
  final Domain domain;
  final String? initialName;
  final AttributeType? initialType;
  final bool initialRequired;
  final Function(String name, AttributeType type, bool required) onSave;

  const _AttributeFormDialog({
    Key? key,
    required this.domain,
    this.initialName,
    this.initialType,
    this.initialRequired = false,
    required this.onSave,
  }) : super(key: key);

  @override
  _AttributeFormDialogState createState() => _AttributeFormDialogState();
}

class _AttributeFormDialogState extends State<_AttributeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  AttributeType? _selectedType;
  bool _isRequired = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedType = widget.initialType;
    _isRequired = widget.initialRequired;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialName != null;
    final types = widget.domain.types.toList();

    return AlertDialog(
      title: Text(isEditing ? 'Edit Attribute' : 'Add Attribute'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Attribute Name',
                hintText: 'e.g., firstName, price, orderDate',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$').hasMatch(value)) {
                  return 'Name must start with a letter and contain only letters and numbers';
                }
                return null;
              },
              enabled:
                  !isEditing, // Cannot edit name if editing existing attribute
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AttributeType>(
              decoration: const InputDecoration(
                labelText: 'Type',
              ),
              value: _selectedType,
              items: types.map((type) {
                return DropdownMenuItem<AttributeType>(
                  value: type,
                  child: Text(type.code),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Required'),
              value: _isRequired,
              onChanged: (value) {
                setState(() {
                  _isRequired = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedType != null) {
              widget.onSave(
                _nameController.text,
                _selectedType!,
                _isRequired,
              );
              Navigator.pop(context);
            }
          },
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
