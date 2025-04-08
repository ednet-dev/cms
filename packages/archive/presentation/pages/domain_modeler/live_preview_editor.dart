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
import 'package:ednet_one/domain/models/field_mapping.dart';

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

  // ACL Mapping state - Restored
  late AclMappingModel aclMappingModel;

  // Model instance service - Restored
  late ModelInstanceService _instanceService;

  // Available domains, models, and configs - Restored
  List<Domain> _availableDomains = [];
  List<ModelInstanceConfig> _availableConfigs = [];

  // Text editing controllers - Restored
  final _domainCodeController = TextEditingController();
  final _modelCodeController = TextEditingController();
  final _conceptCodeController = TextEditingController();
  final _conceptNameController = TextEditingController();
  final _attributeCodeController = TextEditingController();
  final _attributeNameController = TextEditingController();
  final _sourceFieldController = TextEditingController();
  final _targetFieldController = TextEditingController();
  final _transformationController = TextEditingController();

  // Selected preview type - Restored
  String previewType = 'Twitter';

  // Mock data - Restored
  final List<Map<String, dynamic>> _twitterData = [
    {
      'tweet_id': '1',
      'user_handle': '@john_doe',
      'user_name': 'John Doe',
      'content': 'Just deployed my first app with EDNet!',
      'timestamp': '2023-06-15T10:30:00Z',
      'likes': 42,
      'retweets': 12,
    },
    // ... other mock data
  ];
  final List<Map<String, dynamic>> _facebookData = [
    {
      'post_id': '101',
      'author': 'Jane Smith',
      // ... other mock data
    },
  ];

  @override
  void initState() {
    super.initState();
    _instanceService = ModelInstanceService(oneApplication, persistenceService);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _instanceService.loadConfigurations();

    // Initialize ACL Mapping Model based on ednet_core
    final aclDomain = Domain('ACL');
    aclDomain.description = 'Anti-Corruption Layer Mapping Domain';

    final aclModel = Model(aclDomain, 'FieldMapping');
    aclModel.description = 'Maps fields between different domains and services';

    final mappingConcept = Concept(aclModel, 'Mapping');
    mappingConcept.description =
        'Defines a mapping between source and target fields';
    mappingConcept.entry = true;

    final sourceFieldAttribute = Attribute(mappingConcept, 'sourceField');
    sourceFieldAttribute.type = aclDomain.getType('String');

    final targetFieldAttribute = Attribute(mappingConcept, 'targetField');
    targetFieldAttribute.type = aclDomain.getType('String');

    final transformationAttribute = Attribute(mappingConcept, 'transformation');
    transformationAttribute.type = aclDomain.getType('String');

    aclMappingModel = AclMappingModel(aclDomain, aclModel);

    // Load available domains and configs
    setState(() {
      _availableDomains = oneApplication.domains.toList();
      _availableConfigs = _instanceService.allConfigurations;
    });

    _initializeDomainModel();
  }

  void _initializeDomainModel() {
    // Use oneApplication.createDomain if it exists, otherwise create manually
    try {
      activeDomain = oneApplication.createDomain('LivePreviewDomain');
    } catch (e) {
      activeDomain = Domain('LivePreviewDomain');
    }
    activeDomain!.description = 'Domain model for live preview demonstration';

    // Use domain.createModel if it exists, otherwise create manually
    try {
      activeModel = activeDomain!.createModel('TwitterFeedModel');
    } catch (e) {
      activeModel = Model(activeDomain!, 'TwitterFeedModel');
    }
    activeModel!.description = 'Model for Twitter feed integration';

    // Use model.createConcept if it exists, otherwise create manually
    Concept mappingConcept;
    try {
      mappingConcept = activeModel!.createConcept('FieldMapping');
    } catch (e) {
      mappingConcept = Concept(activeModel!, 'FieldMapping');
    }
    mappingConcept.description =
        'Maps fields between external data and domain model';

    // Create attributes for the mapping
    final sourceFieldAttribute = Attribute(mappingConcept, 'sourceField');
    sourceFieldAttribute.label = 'Field name in source data';
    sourceFieldAttribute.type = activeDomain!.getType('String'); // Set type

    final targetFieldAttribute = Attribute(mappingConcept, 'targetField');
    targetFieldAttribute.label = 'Field name in target model';
    targetFieldAttribute.type = activeDomain!.getType('String'); // Set type

    final transformationAttribute = Attribute(mappingConcept, 'transformation');
    transformationAttribute.label = 'Optional transformation expression';
    transformationAttribute.type = activeDomain!.getType('String'); // Set type

    // Create Twitter feed concept
    Concept tweetConcept;
    try {
      tweetConcept = activeModel!.createConcept('Tweet');
    } catch (e) {
      tweetConcept = Concept(activeModel!, 'Tweet');
    }
    tweetConcept.description = 'Represents a tweet from Twitter API';

    final tweetIdAttr = Attribute(tweetConcept, 'id');
    tweetIdAttr.label = 'Unique identifier for the tweet';
    tweetIdAttr.type = activeDomain!.getType('String'); // Set type

    final contentAttr = Attribute(tweetConcept, 'content');
    contentAttr.label = 'Content of the tweet';
    contentAttr.type = activeDomain!.getType('String'); // Set type

    final authorAttr = Attribute(tweetConcept, 'author');
    authorAttr.label = 'Author of the tweet';
    authorAttr.type = activeDomain!.getType('String'); // Set type

    final timestampAttr = Attribute(tweetConcept, 'timestamp');
    timestampAttr.label = 'When the tweet was posted';
    timestampAttr.type = activeDomain!.getType('DateTime'); // Set type

    // Set active concept
    activeConcept = tweetConcept;

    // Create default field mappings using the imported FieldMapping
    aclMappingModel.addMapping(
      FieldMapping(
        sourceField: 'tweet_id',
        targetField: 'id',
        transformation: '',
      ),
    );
    aclMappingModel.addMapping(
      FieldMapping(
        sourceField: 'content',
        targetField: 'content',
        transformation: '',
      ),
    );
    aclMappingModel.addMapping(
      FieldMapping(
        sourceField: 'user_name',
        targetField: 'author',
        transformation: '',
      ),
    );
    aclMappingModel.addMapping(
      FieldMapping(
        sourceField: 'timestamp',
        targetField: 'timestamp',
        transformation: '',
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (build method structure remains the same)
  }

  Widget _buildSplitView() {
    // ... (split view logic remains the same)
  }

  Widget _buildEditorPanel() {
    // ... (editor panel structure remains the same)
  }

  Widget _buildModelSelector() {
    // ... (model selector logic remains the same)
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
                    activeModel!.description ?? '', // Handle potential null
                    style: context.conceptTextStyle(
                      'Model',
                      role: 'description',
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ... (Rest of _buildModelEditor remains the same)

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
                  subtitle: Text(
                    concept.description ?? '',
                  ), // Handle null description
                  // ... (rest of ListTile)
                ),
              );
            },
          ),
        ),

        // ... (rest of _buildModelEditor remains the same)
      ],
    );
  }

  Widget _buildConceptEditor() {
    // ... (_buildConceptEditor logic remains the same)
  }

  Widget _buildPreviewPanel() {
    // ... (_buildPreviewPanel logic remains the same)
  }

  Widget _buildAclMappingEditor() {
    // ... (_buildAclMappingEditor logic remains the same)
  }

  Widget _buildPreviewContent() {
    final data = previewType == 'Twitter' ? _twitterData : _facebookData;

    if (aclMappingModel.mappings.isEmpty) {
      return const Center(
        child: Text('Define field mappings to see a preview'),
      );
    }

    if (activeConcept == null || activeDomain == null || activeModel == null) {
      return const Center(
        child: Text('Select a concept, domain, and model to preview data'),
      );
    }

    return FeedPreview(
      data: data,
      domain: activeDomain!,
      model: activeModel!,
      mappings: aclMappingModel.mappings, // Use the correct mappings
    );
  }

  void _addAttribute() {
    if (_attributeCodeController.text.isEmpty ||
        activeConcept == null ||
        activeDomain == null) {
      return;
    }
    final name = _attributeCodeController.text;
    final label = _attributeNameController.text;

    setState(() {
      final attribute = Attribute(activeConcept!, name);
      attribute.label = label; // Assuming Attribute has a label setter
      attribute.type = activeDomain!.getType('String');
      _attributeCodeController.clear();
      _attributeNameController.clear();
    });
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
          (context) => AlertDialog(
            title: const Text('Add Field Mapping'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Source Field',
                    ),
                    value: selectedSourceField,
                    items:
                        sourceFields
                            .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)),
                            )
                            .toList(),
                    onChanged: (v) => selectedSourceField = v,
                  ),
                  SizedBox(height: context.spacingM),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Target Field',
                    ),
                    value: selectedTargetField,
                    items:
                        targetFields
                            .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)),
                            )
                            .toList(),
                    onChanged: (v) => selectedTargetField = v,
                  ),
                  SizedBox(height: context.spacingM),
                  TextField(
                    controller: transformationController,
                    decoration: const InputDecoration(
                      labelText: 'Transformation (Optional)',
                    ),
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
                  if (selectedSourceField != null &&
                      selectedTargetField != null) {
                    setState(() {
                      aclMappingModel.addMapping(
                        FieldMapping(
                          sourceField: selectedSourceField!,
                          targetField: selectedTargetField!,
                          transformation: transformationController.text,
                        ),
                      );
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _deleteFieldMapping(FieldMapping mapping) {
    setState(() {
      aclMappingModel.mappings.remove(mapping);
    });
  }

  List<String> _getServiceFields(String serviceType) {
    // Placeholder - replace with actual logic
    if (serviceType.toLowerCase().contains('twitter')) {
      return [
        'tweet_id',
        'user_handle',
        'user_name',
        'content',
        'timestamp',
        'likes',
        'retweets',
      ];
    } else if (serviceType.toLowerCase().contains('facebook')) {
      return [
        'post_id',
        'author',
        'profile_pic',
        'message',
        'posted_time',
        'reactions',
        'comments',
        'shares',
      ];
    }
    return [];
  }
}

/// Model for ACL field mappings (Uses the imported FieldMapping)
class AclMappingModel {
  final Domain domain;
  final Model model;
  final List<FieldMapping> mappings = [];

  AclMappingModel(this.domain, this.model);

  void addMapping(FieldMapping mapping) {
    mappings.add(mapping);
  }
}
