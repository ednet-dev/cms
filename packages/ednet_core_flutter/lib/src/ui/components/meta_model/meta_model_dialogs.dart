part of ednet_core_flutter;

/// A global navigator key to access context from anywhere
final GlobalNavigatorKey = GlobalKey<NavigatorState>();

/// Base dialog for meta-model editing operations
abstract class BaseMetaModelDialog extends StatefulWidget {
  final ShellApp shellApp;

  const BaseMetaModelDialog({
    Key? key,
    required this.shellApp,
  }) : super(key: key);
}

/// Dialog for defining a missing relationship
class MetaModelDefinitionDialog extends BaseMetaModelDialog {
  final Entity entity;
  final String relationshipName;

  const MetaModelDefinitionDialog({
    Key? key,
    required ShellApp shellApp,
    required this.entity,
    required this.relationshipName,
  }) : super(key: key, shellApp: shellApp);

  @override
  State<MetaModelDefinitionDialog> createState() =>
      _MetaModelDefinitionDialogState();
}

class _MetaModelDefinitionDialogState extends State<MetaModelDefinitionDialog> {
  bool _isCreating = false;
  String _errorMessage = '';
  final _descriptionController = TextEditingController();
  bool _isParent = true;
  String _destinationConceptCode = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Define Missing Relationship'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Relationship "${widget.relationshipName}" is not defined for concept "${widget.entity.concept.code}".'),
            const SizedBox(height: 16),

            // Relationship type selection
            Text('Relationship Type:',
                style: Theme.of(context).textTheme.titleMedium),
            RadioListTile<bool>(
              title: Text('Parent'),
              value: true,
              groupValue: _isParent,
              onChanged: (value) {
                setState(() {
                  _isParent = value!;
                });
              },
            ),
            RadioListTile<bool>(
              title: Text('Child'),
              value: false,
              groupValue: _isParent,
              onChanged: (value) {
                setState(() {
                  _isParent = value!;
                });
              },
            ),

            // Destination concept
            TextField(
              decoration: InputDecoration(
                labelText: 'Destination Concept Code',
                hintText: 'Enter the code of the related concept',
              ),
              onChanged: (value) {
                setState(() {
                  _destinationConceptCode = value;
                });
              },
            ),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description for this relationship',
              ),
              maxLines: 2,
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),

            if (_isCreating)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createRelationship,
          child: Text('Create Relationship'),
        ),
      ],
    );
  }

  Future<void> _createRelationship() async {
    if (_destinationConceptCode.isEmpty) {
      setState(() {
        _errorMessage = 'Destination concept code is required';
      });
      return;
    }

    setState(() {
      _isCreating = true;
      _errorMessage = '';
    });

    try {
      final sourceConcept = widget.entity.concept;
      final model = sourceConcept.model;

      // Check if destination concept exists, or create it
      Concept? destinationConcept;
      for (final concept in model.concepts) {
        if (concept.code == _destinationConceptCode) {
          destinationConcept = concept;
          break;
        }
      }

      if (destinationConcept == null) {
        // Ask if user wants to create the concept
        final shouldCreate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Create Concept'),
            content: Text(
                'Concept "$_destinationConceptCode" does not exist. Do you want to create it?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Create'),
              ),
            ],
          ),
        );

        if (shouldCreate == true) {
          destinationConcept =
              await widget.shellApp.metaModelManager.createConcept(
            model,
            _destinationConceptCode,
            description: 'Auto-created concept during relationship definition',
          );
        } else {
          setState(() {
            _isCreating = false;
            _errorMessage = 'Operation cancelled';
          });
          return;
        }
      }

      if (_isParent) {
        // Add parent relationship
        await widget.shellApp.metaModelManager.addParent(
          sourceConcept,
          destinationConcept,
          widget.relationshipName,
          description: _descriptionController.text,
        );
      } else {
        // Add child relationship
        await widget.shellApp.metaModelManager.addChild(
          sourceConcept,
          destinationConcept,
          widget.relationshipName,
          description: _descriptionController.text,
        );
      }

      // Reload domain model
      await widget.shellApp.metaModelManager.reloadDomainModel();

      // Close dialog and show success message
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Relationship "${widget.relationshipName}" created successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isCreating = false;
        _errorMessage = 'Error creating relationship: $e';
      });
    }
  }
}

/// Dialog for defining a missing model
class ModelDefinitionDialog extends BaseMetaModelDialog {
  final Domain domain;
  final String modelCode;

  const ModelDefinitionDialog({
    Key? key,
    required ShellApp shellApp,
    required this.domain,
    required this.modelCode,
  }) : super(key: key, shellApp: shellApp);

  @override
  State<ModelDefinitionDialog> createState() => _ModelDefinitionDialogState();
}

class _ModelDefinitionDialogState extends State<ModelDefinitionDialog> {
  bool _isCreating = false;
  String _errorMessage = '';
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Define Missing Model'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Model "${widget.modelCode}" does not exist in domain "${widget.domain.code}".'),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description for this model',
              ),
              maxLines: 2,
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),

            if (_isCreating)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createModel,
          child: Text('Create Model'),
        ),
      ],
    );
  }

  Future<void> _createModel() async {
    setState(() {
      _isCreating = true;
      _errorMessage = '';
    });

    try {
      await widget.shellApp.metaModelManager.createModel(
        widget.domain,
        widget.modelCode,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : 'Auto-created model',
      );

      // Reload domain model
      await widget.shellApp.metaModelManager.reloadDomainModel();

      // Close dialog and show success message
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Model "${widget.modelCode}" created successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isCreating = false;
        _errorMessage = 'Error creating model: $e';
      });
    }
  }
}

/// Dialog for defining a missing concept
class ConceptDefinitionDialog extends BaseMetaModelDialog {
  final Model model;
  final String conceptCode;

  const ConceptDefinitionDialog({
    Key? key,
    required ShellApp shellApp,
    required this.model,
    required this.conceptCode,
  }) : super(key: key, shellApp: shellApp);

  @override
  State<ConceptDefinitionDialog> createState() =>
      _ConceptDefinitionDialogState();
}

class _ConceptDefinitionDialogState extends State<ConceptDefinitionDialog> {
  bool _isCreating = false;
  String _errorMessage = '';
  final _descriptionController = TextEditingController();
  bool _isEntry = false;
  bool _isAbstract = false;
  String? _category;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Define Missing Concept'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Concept "${widget.conceptCode}" does not exist in model "${widget.model.code}".'),
            const SizedBox(height: 16),

            // Concept properties
            CheckboxListTile(
              title: Text('Entry Concept'),
              subtitle: Text('This concept is an entry point in the domain'),
              value: _isEntry,
              onChanged: (value) {
                setState(() {
                  _isEntry = value ?? false;
                });
              },
            ),

            CheckboxListTile(
              title: Text('Abstract Concept'),
              subtitle: Text('This concept cannot be instantiated directly'),
              value: _isAbstract,
              onChanged: (value) {
                setState(() {
                  _isAbstract = value ?? false;
                });
              },
            ),

            // Category
            TextField(
              decoration: InputDecoration(
                labelText: 'Category (Optional)',
                hintText: 'Enter a category for grouping',
              ),
              onChanged: (value) {
                setState(() {
                  _category = value.isNotEmpty ? value : null;
                });
              },
            ),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description for this concept',
              ),
              maxLines: 2,
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),

            if (_isCreating)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createConcept,
          child: Text('Create Concept'),
        ),
      ],
    );
  }

  Future<void> _createConcept() async {
    setState(() {
      _isCreating = true;
      _errorMessage = '';
    });

    try {
      await widget.shellApp.metaModelManager.createConcept(
        widget.model,
        widget.conceptCode,
        entry: _isEntry,
        abstract: _isAbstract,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : 'Auto-created concept',
        category: _category,
      );

      // Add a default identifier attribute if entry concept
      if (_isEntry) {
        await widget.shellApp.metaModelManager.addAttribute(
          widget.model.getConcept(widget.conceptCode)!,
          'id',
          'String',
          identifier: true,
          required: true,
          description: 'Unique identifier',
        );
      }

      // Reload domain model
      await widget.shellApp.metaModelManager.reloadDomainModel();

      // Close dialog and show success message
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Concept "${widget.conceptCode}" created successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isCreating = false;
        _errorMessage = 'Error creating concept: $e';
      });
    }
  }
}

/// Dialog for defining a missing relationship
class RelationshipDefinitionDialog extends BaseMetaModelDialog {
  final Concept concept;
  final String relationshipCode;

  const RelationshipDefinitionDialog({
    Key? key,
    required ShellApp shellApp,
    required this.concept,
    required this.relationshipCode,
  }) : super(key: key, shellApp: shellApp);

  @override
  State<RelationshipDefinitionDialog> createState() =>
      _RelationshipDefinitionDialogState();
}

class _RelationshipDefinitionDialogState
    extends State<RelationshipDefinitionDialog> {
  bool _isCreating = false;
  String _errorMessage = '';
  final _descriptionController = TextEditingController();
  bool _isParent = true;
  String _destinationConceptCode = '';
  List<String> _availableConcepts = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableConcepts();
  }

  void _loadAvailableConcepts() {
    final model = widget.concept.model;
    _availableConcepts = model.concepts
        .where((c) => c.code != widget.concept.code) // Exclude self
        .map((c) => c.code)
        .toList();

    // Include concepts from other models as well
    final domain = model.domain;
    for (final otherModel in domain.models) {
      if (otherModel != model) {
        _availableConcepts.addAll(
            otherModel.concepts.map((c) => '${otherModel.code}.${c.code}'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Define Missing Relationship'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Relationship "${widget.relationshipCode}" is not defined for concept "${widget.concept.code}".'),
            const SizedBox(height: 16),

            // Relationship type selection
            Text('Relationship Type:',
                style: Theme.of(context).textTheme.titleMedium),
            RadioListTile<bool>(
              title: Text('Parent'),
              value: true,
              groupValue: _isParent,
              onChanged: (value) {
                setState(() {
                  _isParent = value!;
                });
              },
            ),
            RadioListTile<bool>(
              title: Text('Child'),
              value: false,
              groupValue: _isParent,
              onChanged: (value) {
                setState(() {
                  _isParent = value!;
                });
              },
            ),

            // Destination concept dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Destination Concept',
                hintText: 'Select a concept',
              ),
              items: _availableConcepts
                  .map((conceptCode) => DropdownMenuItem(
                        value: conceptCode,
                        child: Text(conceptCode),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _destinationConceptCode = value ?? '';
                });
              },
            ),

            const SizedBox(height: 8),

            // Or manually enter concept code
            TextField(
              decoration: InputDecoration(
                labelText: 'Or Enter New Concept Code',
                hintText: 'Enter code if not in dropdown',
              ),
              onChanged: (value) {
                setState(() {
                  _destinationConceptCode = value;
                });
              },
            ),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description for this relationship',
              ),
              maxLines: 2,
            ),

            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),

            if (_isCreating)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createRelationship,
          child: Text('Create Relationship'),
        ),
      ],
    );
  }

  Future<void> _createRelationship() async {
    if (_destinationConceptCode.isEmpty) {
      setState(() {
        _errorMessage = 'Destination concept code is required';
      });
      return;
    }

    setState(() {
      _isCreating = true;
      _errorMessage = '';
    });

    try {
      final model = widget.concept.model;
      final domain = model.domain;

      // Parse destination concept
      Concept? destinationConcept;
      if (_destinationConceptCode.contains('.')) {
        // Format: "ModelCode.ConceptCode"
        final parts = _destinationConceptCode.split('.');
        final modelCode = parts[0];
        final conceptCode = parts[1];

        // Find model and concept
        final targetModel = domain.getModel(modelCode);
        if (targetModel != null) {
          destinationConcept = targetModel.getConcept(conceptCode);
        }
      } else {
        // Concept in same model
        destinationConcept = model.getConcept(_destinationConceptCode);
      }

      if (destinationConcept == null) {
        // Ask if user wants to create the concept
        final shouldCreate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Create Concept'),
            content: Text(
                'Concept "$_destinationConceptCode" does not exist. Do you want to create it?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Create'),
              ),
            ],
          ),
        );

        if (shouldCreate == true) {
          destinationConcept =
              await widget.shellApp.metaModelManager.createConcept(
            model, // Create in the same model
            _destinationConceptCode,
            description: 'Auto-created concept during relationship definition',
          );
        } else {
          setState(() {
            _isCreating = false;
            _errorMessage = 'Operation cancelled';
          });
          return;
        }
      }

      if (_isParent) {
        // Add parent relationship
        await widget.shellApp.metaModelManager.addParent(
          widget.concept,
          destinationConcept,
          widget.relationshipCode,
          description: _descriptionController.text,
        );
      } else {
        // Add child relationship
        await widget.shellApp.metaModelManager.addChild(
          widget.concept,
          destinationConcept,
          widget.relationshipCode,
          description: _descriptionController.text,
        );
      }

      // Reload domain model
      await widget.shellApp.metaModelManager.reloadDomainModel();

      // Close dialog and show success message
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Relationship "${widget.relationshipCode}" created successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isCreating = false;
        _errorMessage = 'Error creating relationship: $e';
      });
    }
  }
}
