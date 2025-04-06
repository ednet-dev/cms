import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/domain/services/model_instance_service.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/main.dart' show oneApplication, persistenceService;
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';
import 'package:ednet_one/presentation/pages/model_instance/preview_widgets/feed_preview.dart';

/// LivePreviewEditor combines domain modeling with real-time preview capabilities
class LivePreviewEditor extends StatefulWidget {
  /// Route name for the LivePreviewEditor
  static const String routeName = '/live-preview-editor';

  /// Constructor
  const LivePreviewEditor({Key? key}) : super(key: key);

  @override
  _LivePreviewEditorState createState() => _LivePreviewEditorState();
}

class _LivePreviewEditorState extends State<LivePreviewEditor> {
  // Split view controller
  final _dividerPosition = ValueNotifier<double>(0.5);

  // Current editing state
  Domain? activeDomain;
  Model? activeModel;
  Concept? activeConcept;

  // Current preview state
  ModelInstanceConfig? activeConfig;
  ModelInstanceResult? previewResult;
  bool isPreviewLoading = false;

  // ACL Mapping state
  late AclMappingModel aclMappingModel;

  // Model instance service
  late ModelInstanceService _instanceService;

  // Available domains, models, and configs
  List<Domain> _availableDomains = [];
  List<ModelInstanceConfig> _availableConfigs = [];

  @override
  void initState() {
    super.initState();
    _instanceService = ModelInstanceService(oneApplication, persistenceService);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _instanceService.loadConfigurations();

    // Initialize ACL Mapping Model based on ednet_core
    final domain = Domain('ACL');
    domain.description = 'Anti-Corruption Layer Mapping Domain';

    final model = Model(domain, 'FieldMapping');
    model.description = 'Maps fields between different domains and services';

    // Create concepts for the ACL model
    final mappingConcept = Concept(model, 'Mapping');
    mappingConcept.description =
        'Defines a mapping between source and target fields';
    mappingConcept.entry = true;

    // Add attributes to the mapping concept
    final sourceFieldAttribute = Attribute('sourceField', mappingConcept);
    sourceFieldAttribute.type = AttributeType()..code = 'String';

    final targetFieldAttribute = Attribute('targetField', mappingConcept);
    targetFieldAttribute.type = AttributeType()..code = 'String';

    final transformationAttribute = Attribute('transformation', mappingConcept);
    transformationAttribute.type = AttributeType()..code = 'String';

    // Initialize the ACL model
    aclMappingModel = AclMappingModel(domain, model);

    // Load available domains
    setState(() {
      _availableDomains = oneApplication.domains.toList();
      _availableConfigs = _instanceService.allConfigurations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Domain Model Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Domain Model',
            onPressed: _saveDomainModel,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Update Preview',
            onPressed: _refreshPreview,
          ),
        ],
      ),
      body: Column(children: [Expanded(child: _buildSplitView())]),
    );
  }

  Widget _buildSplitView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return Stack(
          children: [
            // Left panel - Domain Model Editor
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: maxWidth * _dividerPosition.value,
              child: _buildEditorPanel(),
            ),

            // Divider
            Positioned(
              left: maxWidth * _dividerPosition.value - 5,
              top: 0,
              bottom: 0,
              width: 10,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    final newPosition =
                        _dividerPosition.value + details.delta.dx / maxWidth;
                    if (newPosition > 0.2 && newPosition < 0.8) {
                      _dividerPosition.value = newPosition;
                      setState(() {});
                    }
                  },
                  child: Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: const Center(
                      child: Icon(Icons.drag_indicator, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            // Right panel - Live Preview
            Positioned(
              left: maxWidth * _dividerPosition.value + 5,
              top: 0,
              bottom: 0,
              right: 0,
              child: _buildPreviewPanel(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditorPanel() {
    return SemanticConceptContainer(
      conceptType: 'DomainEditor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain/Model selection
          _buildModelSelector(),

          // Divider
          const Divider(),

          // Concept editor or ACL mapping editor based on selection
          Expanded(
            child:
                activeDomain != null
                    ? _buildModelEditor()
                    : _buildEmptyStateMessage(),
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelector() {
    return Padding(
      padding: EdgeInsets.all(context.spacingM),
      child: Row(
        children: [
          // Domain dropdown
          Expanded(
            child: DropdownButtonFormField<Domain>(
              decoration: const InputDecoration(
                labelText: 'Domain',
                border: OutlineInputBorder(),
              ),
              value: activeDomain,
              items:
                  _availableDomains.map((domain) {
                    return DropdownMenuItem<Domain>(
                      value: domain,
                      child: Text(domain.code),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  activeDomain = newValue;
                  activeModel = null;
                  activeConcept = null;
                });
              },
            ),
          ),

          SizedBox(width: context.spacingM),

          // Model dropdown (enabled if domain selected)
          Expanded(
            child: DropdownButtonFormField<Model>(
              decoration: const InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(),
              ),
              value: activeModel,
              items:
                  activeDomain != null
                      ? activeDomain!.models.toList().map((model) {
                        return DropdownMenuItem<Model>(
                          value: model,
                          child: Text(model.code),
                        );
                      }).toList()
                      : [],
              onChanged:
                  activeDomain != null
                      ? (newValue) {
                        setState(() {
                          activeModel = newValue;
                          activeConcept = null;
                        });
                      }
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelEditor() {
    if (activeModel == null) {
      return Center(
        child: Text(
          'Select a model to begin editing',
          style: context.conceptTextStyle('Workspace', role: 'emptyState'),
        ),
      );
    }

    // Get all concepts from the model
    final concepts = activeModel!.concepts.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Model info
        Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Model: ${activeModel!.code}',
                style: context.conceptTextStyle('Model', role: 'title'),
              ),
              if (activeModel!.description != null)
                Padding(
                  padding: EdgeInsets.only(top: context.spacingS),
                  child: Text(
                    activeModel!.description,
                    style: context.conceptTextStyle(
                      'Model',
                      role: 'description',
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Actions
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Concept'),
                onPressed: _showAddConceptDialog,
              ),
            ],
          ),
        ),

        // Concepts list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(context.spacingM),
            itemCount: concepts.length,
            itemBuilder: (context, index) {
              final concept = concepts[index];
              return Card(
                margin: EdgeInsets.only(bottom: context.spacingM),
                child: ListTile(
                  title: Text(concept.code),
                  subtitle: Text(concept.description),
                  leading: Icon(
                    Icons.circle,
                    color: concept.entry ? Colors.green : Colors.blue,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        activeConcept = concept;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      activeConcept = concept;
                    });
                  },
                ),
              );
            },
          ),
        ),

        // If a concept is selected, show its editor
        if (activeConcept != null) _buildConceptEditor(),
      ],
    );
  }

  Widget _buildConceptEditor() {
    if (activeConcept == null) {
      return const SizedBox.shrink();
    }

    // Get attributes and relationships
    final attributes = activeConcept!.attributes.toList();

    return Container(
      padding: EdgeInsets.all(context.spacingM),
      color: Colors.grey.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Concept header
          Text(
            'Concept: ${activeConcept!.code}',
            style: context.conceptTextStyle('Concept', role: 'title'),
          ),

          SizedBox(height: context.spacingS),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Attribute'),
                onPressed: _showAddAttributeDialog,
              ),
              SizedBox(width: context.spacingS),
              ElevatedButton.icon(
                icon: const Icon(Icons.link),
                label: const Text('Add Relationship'),
                onPressed: _showAddRelationshipDialog,
              ),
            ],
          ),

          SizedBox(height: context.spacingM),

          // Attributes table
          attributes.isNotEmpty
              ? DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Required')),
                  DataColumn(label: Text('Action')),
                ],
                rows:
                    attributes.map((attribute) {
                      return DataRow(
                        cells: [
                          DataCell(Text(attribute.code)),
                          DataCell(Text(attribute.type?.code ?? 'String')),
                          DataCell(Text(attribute.required ? 'Yes' : 'No')),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteAttribute(attribute),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              )
              : const Center(child: Text('No attributes defined')),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview header
          Padding(
            padding: EdgeInsets.all(context.spacingM),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Live Preview',
                    style: context.conceptTextStyle('Preview', role: 'title'),
                  ),
                ),
                // Service configuration dropdown
                Expanded(
                  child: DropdownButtonFormField<ModelInstanceConfig>(
                    decoration: const InputDecoration(
                      labelText: 'Service Config',
                      border: OutlineInputBorder(),
                    ),
                    value: activeConfig,
                    items:
                        _availableConfigs.map((config) {
                          return DropdownMenuItem<ModelInstanceConfig>(
                            value: config,
                            child: Text(config.name),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        activeConfig = newValue;
                        _refreshPreview();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // ACL Mapping editor
          if (activeConfig != null &&
              activeDomain != null &&
              activeModel != null)
            Padding(
              padding: EdgeInsets.all(context.spacingM),
              child: _buildAclMappingEditor(),
            ),

          // Divider
          const Divider(),

          // Preview content
          Expanded(
            child:
                isPreviewLoading
                    ? const Center(child: CircularProgressIndicator())
                    : activeConfig != null && previewResult != null
                    ? _buildPreviewContent()
                    : _buildEmptyPreviewState(),
          ),
        ],
      ),
    );
  }

  Widget _buildAclMappingEditor() {
    // This editor allows defining mappings between external service fields
    // and the current domain model

    if (activeConfig == null || activeDomain == null || activeModel == null) {
      return const SizedBox.shrink();
    }

    // Get service type to determine available fields
    final serviceType = activeConfig!.serviceType;

    // Get concepts with their attributes
    final concepts = activeModel!.concepts.toList();
    List<String> availableModelFields = [];

    // Gather all available target fields from the domain model
    for (var concept in concepts) {
      for (var attr in concept.attributes.toList()) {
        availableModelFields.add('${concept.code}.${attr.code}');
      }
    }

    // Source fields depend on service type
    List<String> availableSourceFields = _getServiceFields(serviceType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Field Mappings',
          style: context.conceptTextStyle('ACL', role: 'title'),
        ),

        SizedBox(height: context.spacingS),

        // Mapping table
        // This will allow adding, editing and removing field mappings
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Field Mapping'),
          onPressed:
              () => _showAddFieldMappingDialog(
                availableSourceFields,
                availableModelFields,
              ),
        ),

        SizedBox(height: context.spacingS),

        // Display existing mappings
        Card(
          child: Padding(
            padding: EdgeInsets.all(context.spacingS),
            child:
                aclMappingModel.mappings.isNotEmpty
                    ? DataTable(
                      columns: const [
                        DataColumn(label: Text('Source Field')),
                        DataColumn(label: Text('Target Field')),
                        DataColumn(label: Text('Transformation')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows:
                          aclMappingModel.mappings.map((mapping) {
                            return DataRow(
                              cells: [
                                DataCell(Text(mapping.sourceField)),
                                DataCell(Text(mapping.targetField)),
                                DataCell(Text(mapping.transformation ?? '')),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed:
                                        () => _deleteFieldMapping(mapping),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    )
                    : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No field mappings defined'),
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewContent() {
    // Show a preview based on the data and model configuration
    if (previewResult == null || activeConfig == null) {
      return const Center(child: Text('No preview data available'));
    }

    // Different preview widgets based on service type
    switch (activeConfig!.serviceType) {
      case ServiceType.twitter:
        return FeedPreview(
          data: previewResult!.data,
          mappings: aclMappingModel.mappings,
          domain: activeDomain!,
          model: activeModel!,
        );
      case ServiceType.facebook:
        return FeedPreview(
          data: previewResult!.data,
          mappings: aclMappingModel.mappings,
          domain: activeDomain!,
          model: activeModel!,
        );
      default:
        return Center(
          child: Text(
            'Preview not implemented for ${activeConfig!.serviceType.name}',
          ),
        );
    }
  }

  Widget _buildEmptyStateMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.model_training, size: 48),
          SizedBox(height: context.spacingM),
          Text(
            'Select a domain and model to begin editing',
            style: context.conceptTextStyle('Workspace', role: 'emptyState'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPreviewState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.preview, size: 48),
          SizedBox(height: context.spacingM),
          Text(
            'Select a service configuration to preview data',
            style: context.conceptTextStyle('Preview', role: 'emptyState'),
          ),
        ],
      ),
    );
  }

  // Dialogs and Actions

  void _showAddConceptDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isEntry = false;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Add New Concept'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Concept Name',
                        hintText: 'e.g., Product, Order, Customer',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text('Is Entry Point'),
                      value: isEntry,
                      onChanged: (value) {
                        setState(() {
                          isEntry = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _createConcept(
                        nameController.text.trim(),
                        descriptionController.text.trim(),
                        isEntry,
                      );
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showAddAttributeDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'String';
    bool isRequired = false;
    bool isIdentifier = false;

    final types = ['String', 'int', 'double', 'bool', 'DateTime', 'Uri'];

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Add New Attribute'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Attribute Name',
                        hintText: 'e.g., name, price, description',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items:
                          types.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedType = newValue!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                    CheckboxListTile(
                      title: const Text('Required'),
                      value: isRequired,
                      onChanged: (value) {
                        setState(() {
                          isRequired = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Identifier'),
                      value: isIdentifier,
                      onChanged: (value) {
                        setState(() {
                          isIdentifier = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _createAttribute(
                        nameController.text.trim(),
                        descriptionController.text.trim(),
                        selectedType,
                        isRequired,
                        isIdentifier,
                      );
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showAddRelationshipDialog() {
    // TODO: Implement relationship dialog
  }

  void _showAddFieldMappingDialog(
    List<String> sourceFields,
    List<String> targetFields,
  ) {
    String? selectedSourceField;
    String? selectedTargetField;
    final transformationController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Add Field Mapping'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedSourceField,
                      items:
                          sourceFields.map((field) {
                            return DropdownMenuItem<String>(
                              value: field,
                              child: Text(field),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedSourceField = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Source Field',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedTargetField,
                      items:
                          targetFields.map((field) {
                            return DropdownMenuItem<String>(
                              value: field,
                              child: Text(field),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedTargetField = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Target Field',
                      ),
                    ),
                    TextField(
                      controller: transformationController,
                      decoration: const InputDecoration(
                        labelText: 'Transformation (optional)',
                        hintText: 'e.g., toUpperCase, parseInt, etc.',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedSourceField != null &&
                          selectedTargetField != null) {
                        Navigator.pop(context);
                        _createFieldMapping(
                          selectedSourceField!,
                          selectedTargetField!,
                          transformationController.text.trim(),
                        );
                      }
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          ),
    );
  }

  // Action implementations

  Future<void> _refreshPreview() async {
    if (activeConfig == null) {
      _showErrorSnackBar('No service configuration selected');
      return;
    }

    setState(() {
      isPreviewLoading = true;
    });

    try {
      final result = await _instanceService.runInstance(activeConfig!.id);

      setState(() {
        previewResult = result;
        isPreviewLoading = false;
      });
    } catch (e) {
      setState(() {
        isPreviewLoading = false;
      });
      _showErrorSnackBar('Error refreshing preview: $e');
    }
  }

  Future<void> _saveDomainModel() async {
    if (activeDomain == null) {
      _showErrorSnackBar('No domain selected');
      return;
    }

    try {
      bool saved;
      if (activeModel != null) {
        saved = await persistenceService.saveDomainModel(
          activeDomain!,
          activeModel!,
        );

        // Also save ACL mappings if we have them
        if (aclMappingModel.mappings.isNotEmpty && activeConfig != null) {
          final mappingsJson = aclMappingModel.toJson();
          await persistenceService.saveConfiguration(
            'acl_mappings_${activeConfig!.id}',
            mappingsJson,
          );
        }
      } else {
        saved = await persistenceService.saveAllDomainModels();
      }

      if (saved) {
        _showInfoSnackBar('Domain model saved successfully');
      } else {
        _showErrorSnackBar('Failed to save domain model');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving domain model: $e');
    }
  }

  void _createConcept(String name, String description, bool isEntry) {
    if (name.isEmpty || activeModel == null) return;

    // Create a new concept
    final newConcept = Concept(activeModel!, name);
    newConcept.entry = isEntry;
    if (description.isNotEmpty) {
      newConcept.description = description;
    }

    setState(() {
      activeConcept = newConcept;
    });

    _showInfoSnackBar('Concept "$name" created successfully');
  }

  void _createAttribute(
    String name,
    String description,
    String typeName,
    bool isRequired,
    bool isIdentifier,
  ) {
    if (name.isEmpty || activeConcept == null) return;

    // Create a new attribute
    final attribute = Attribute(name, activeConcept!);

    // Set properties
    if (description.isNotEmpty) {
      attribute.description = description;
    }

    attribute.type = AttributeType()..code = typeName;
    attribute.required = isRequired;
    attribute.identifier = isIdentifier;

    setState(() {});

    _showInfoSnackBar('Attribute "$name" created successfully');
  }

  void _deleteAttribute(Attribute attribute) {
    if (activeConcept == null) return;

    // Remove the attribute
    activeConcept!.attributes.remove(attribute);

    setState(() {});

    _showInfoSnackBar('Attribute "${attribute.code}" deleted');
  }

  void _createFieldMapping(
    String sourceField,
    String targetField,
    String transformation,
  ) {
    // Add a new field mapping
    final mapping = FieldMapping(
      sourceField,
      targetField,
      transformation.isNotEmpty ? transformation : null,
    );

    aclMappingModel.addMapping(mapping);

    setState(() {});

    _showInfoSnackBar('Field mapping created successfully');
  }

  void _deleteFieldMapping(FieldMapping mapping) {
    aclMappingModel.removeMapping(mapping);

    setState(() {});

    _showInfoSnackBar('Field mapping deleted');
  }

  List<String> _getServiceFields(ServiceType serviceType) {
    // Return available fields based on service type
    switch (serviceType) {
      case ServiceType.twitter:
        return [
          'tweet.id',
          'tweet.text',
          'tweet.created_at',
          'user.name',
          'user.handle',
          'user.profile_image',
        ];
      case ServiceType.facebook:
        return [
          'post.id',
          'post.message',
          'post.created_time',
          'author.name',
          'author.id',
          'attachment.url',
        ];
      case ServiceType.instagram:
        return [
          'post.id',
          'post.caption',
          'post.image_url',
          'user.username',
          'user.full_name',
        ];
      case ServiceType.youtube:
        return [
          'video.id',
          'video.title',
          'video.description',
          'channel.name',
          'channel.id',
        ];
      case ServiceType.custom:
        return ['custom.field1', 'custom.field2', 'custom.field3'];
    }
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }
}

/// ACL Mapping model that uses ednet_core concepts
class AclMappingModel {
  final Domain domain;
  final Model model;
  final List<FieldMapping> mappings = [];

  AclMappingModel(this.domain, this.model);

  void addMapping(FieldMapping mapping) {
    mappings.add(mapping);
  }

  void removeMapping(FieldMapping mapping) {
    mappings.remove(mapping);
  }

  Map<String, dynamic> toJson() {
    return {
      'domainCode': domain.code,
      'modelCode': model.code,
      'mappings': mappings.map((m) => m.toJson()).toList(),
    };
  }

  factory AclMappingModel.fromJson(
    Map<String, dynamic> json,
    Domain domain,
    Model model,
  ) {
    final aclModel = AclMappingModel(domain, model);

    final mappingsJson = json['mappings'] as List<dynamic>;
    for (var mappingJson in mappingsJson) {
      aclModel.addMapping(FieldMapping.fromJson(mappingJson));
    }

    return aclModel;
  }
}
