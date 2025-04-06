import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/domain/extensions/domain_model_extensions.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/main.dart' show oneApplication, persistenceService;
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';

/// DomainModelEditor enables in-vivo domain modeling with the existing infrastructure
class DomainModelEditor extends StatefulWidget {
  /// Route name for the DomainModelEditor
  static const String routeName = '/domain-model-editor';

  /// Constructor
  const DomainModelEditor({Key? key}) : super(key: key);

  @override
  _DomainModelEditorState createState() => _DomainModelEditorState();
}

class _DomainModelEditorState extends State<DomainModelEditor> {
  // Current editing state
  Domain? activeDomain;
  Model? activeModel;
  Concept? activeConcept;

  // Creation mode flags
  bool creatingDomain = false;
  bool creatingModel = false;
  bool creatingConcept = false;
  bool creatingAttribute = false;
  bool creatingParent = false;

  // Form controllers
  final _domainNameController = TextEditingController();
  final _domainDescriptionController = TextEditingController();
  final _modelNameController = TextEditingController();
  final _modelDescriptionController = TextEditingController();
  final _conceptNameController = TextEditingController();
  final _conceptDescriptionController = TextEditingController();
  final _attributeNameController = TextEditingController();
  final _attributeDescriptionController = TextEditingController();

  // Attribute properties
  String _selectedAttributeType = 'String';
  bool _attributeRequired = false;
  bool _attributeIdentifier = false;

  // Model properties
  bool isEntryPoint = false;

  // Available domains, models, and concepts
  List<Domain> _availableDomains = [];

  @override
  void initState() {
    super.initState();
    _loadDomains();
  }

  @override
  void dispose() {
    // Dispose all controllers
    _domainNameController.dispose();
    _domainDescriptionController.dispose();
    _modelNameController.dispose();
    _modelDescriptionController.dispose();
    _conceptNameController.dispose();
    _conceptDescriptionController.dispose();
    _attributeNameController.dispose();
    _attributeDescriptionController.dispose();
    super.dispose();
  }

  void _loadDomains() {
    setState(() {
      _availableDomains = oneApplication.getAllDomains();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain Model Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDomainModel,
            tooltip: 'Save Domain Model',
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _launchModel,
            tooltip: 'Launch as App',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar with domain hierarchy
          Container(width: 300, child: _buildHierarchyExplorer()),

          // Vertical divider
          const VerticalDivider(),

          // Main content area
          Expanded(child: _buildEditorPanel()),
        ],
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildHierarchyExplorer() {
    return Card(
      margin: EdgeInsets.all(context.spacingS),
      child: Padding(
        padding: EdgeInsets.all(context.spacingXs),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Domains',
                style: context.conceptTextStyle(
                  'Workspace',
                  role: 'sectionTitle',
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => creatingDomain = true),
                tooltip: 'Add Domain',
              ),
            ),

            // List existing domains
            ..._availableDomains.map(
              (domain) => ExpansionTile(
                title: Text(domain.code),
                initiallyExpanded: domain == activeDomain,
                onExpansionChanged: (expanded) {
                  if (expanded) setState(() => activeDomain = domain);
                },
                children: [
                  ListTile(
                    title: Text(
                      'Models',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed:
                          () => setState(() {
                            creatingModel = true;
                            activeDomain = domain;
                          }),
                      tooltip: 'Add Model',
                    ),
                  ),

                  // List models in this domain
                  ...domain.getAllModels().map(
                    (model) => ExpansionTile(
                      title: Text(model.code),
                      initiallyExpanded:
                          model == activeModel && domain == activeDomain,
                      onExpansionChanged: (expanded) {
                        if (expanded)
                          setState(() {
                            activeDomain = domain;
                            activeModel = model;
                          });
                      },
                      children: [
                        ListTile(
                          title: Text(
                            'Concepts',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed:
                                () => setState(() {
                                  creatingConcept = true;
                                  activeDomain = domain;
                                  activeModel = model;
                                }),
                            tooltip: 'Add Concept',
                          ),
                        ),

                        // List concepts in this model
                        ...model.getAllConcepts().map(
                          (concept) => ListTile(
                            title: Text(concept.code),
                            subtitle: Text(concept.entry ? 'Entry Point' : ''),
                            selected:
                                concept == activeConcept &&
                                model == activeModel &&
                                domain == activeDomain,
                            onTap:
                                () => setState(() {
                                  activeDomain = domain;
                                  activeModel = model;
                                  activeConcept = concept;
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorPanel() {
    if (creatingDomain) {
      return _buildDomainCreationForm();
    } else if (creatingModel) {
      return _buildModelCreationForm();
    } else if (creatingConcept) {
      return _buildConceptCreationForm();
    } else if (creatingAttribute && activeConcept != null) {
      return _buildAttributeCreationForm();
    } else if (activeConcept != null) {
      return _buildConceptEditor();
    } else if (activeModel != null) {
      return _buildModelEditor();
    } else if (activeDomain != null) {
      return _buildDomainEditor();
    } else {
      return Center(
        child: Text(
          'Select or create a domain to begin modeling',
          style: context.conceptTextStyle('Workspace', role: 'emptyState'),
        ),
      );
    }
  }

  Widget _buildDomainCreationForm() {
    return SemanticConceptContainer(
      conceptType: 'Domain',
      child: Card(
        margin: EdgeInsets.all(context.spacingM),
        child: Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Domain',
                style: context.conceptTextStyle('Domain', role: 'title'),
              ),
              SizedBox(height: context.spacingM),

              // Domain name field
              TextField(
                controller: _domainNameController,
                decoration: const InputDecoration(
                  labelText: 'Domain Name',
                  helperText: 'Enter a unique name for this domain',
                ),
              ),
              SizedBox(height: context.spacingM),

              // Domain description field
              TextField(
                controller: _domainDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  helperText: 'Enter a description for this domain',
                ),
                maxLines: 3,
              ),
              SizedBox(height: context.spacingL),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => creatingDomain = false),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: context.spacingM),
                  ElevatedButton(
                    onPressed: _createDomain,
                    child: const Text('Create Domain'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelCreationForm() {
    return SemanticConceptContainer(
      conceptType: 'Model',
      child: Card(
        margin: EdgeInsets.all(context.spacingM),
        child: Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Model in ${activeDomain?.code}',
                style: context.conceptTextStyle('Model', role: 'title'),
              ),
              SizedBox(height: context.spacingM),

              // Model name field
              TextField(
                controller: _modelNameController,
                decoration: const InputDecoration(
                  labelText: 'Model Name',
                  helperText: 'Enter a unique name for this model',
                ),
              ),
              SizedBox(height: context.spacingM),

              // Model description field
              TextField(
                controller: _modelDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  helperText: 'Enter a description for this model',
                ),
                maxLines: 3,
              ),
              SizedBox(height: context.spacingL),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => creatingModel = false),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: context.spacingM),
                  ElevatedButton(
                    onPressed: _createModel,
                    child: const Text('Create Model'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConceptCreationForm() {
    return SemanticConceptContainer(
      conceptType: 'Concept',
      child: Card(
        margin: EdgeInsets.all(context.spacingM),
        child: Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Concept in ${activeModel?.code}',
                style: context.conceptTextStyle('Concept', role: 'title'),
              ),
              SizedBox(height: context.spacingM),

              // Concept name field
              TextField(
                controller: _conceptNameController,
                decoration: const InputDecoration(
                  labelText: 'Concept Name',
                  helperText: 'Enter a unique name for this concept',
                ),
              ),
              SizedBox(height: context.spacingM),

              // Entry point checkbox
              CheckboxListTile(
                title: const Text('Entry Point'),
                subtitle: const Text(
                  'Is this a root concept that can exist independently?',
                ),
                value: isEntryPoint,
                onChanged:
                    (value) => setState(() => isEntryPoint = value ?? false),
              ),

              // Concept description field
              TextField(
                controller: _conceptDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  helperText: 'Enter a description for this concept',
                ),
                maxLines: 3,
              ),
              SizedBox(height: context.spacingL),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => creatingConcept = false),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: context.spacingM),
                  ElevatedButton(
                    onPressed: _createConcept,
                    child: const Text('Create Concept'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeCreationForm() {
    final attributeTypes = [
      'String',
      'num',
      'int',
      'double',
      'bool',
      'DateTime',
      'Uri',
      'Email',
      'Telephone',
      'Name',
      'Description',
      'Money',
      'dynamic',
      'Other',
    ];

    return SemanticConceptContainer(
      conceptType: 'Attribute',
      child: Card(
        margin: EdgeInsets.all(context.spacingM),
        child: Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Attribute to ${activeConcept?.code}',
                style: context.conceptTextStyle('Attribute', role: 'title'),
              ),
              SizedBox(height: context.spacingM),

              // Attribute name field
              TextField(
                controller: _attributeNameController,
                decoration: const InputDecoration(
                  labelText: 'Attribute Name',
                  helperText: 'Enter a unique name for this attribute',
                ),
              ),
              SizedBox(height: context.spacingM),

              // Attribute type dropdown
              DropdownButtonFormField<String>(
                value: _selectedAttributeType,
                decoration: const InputDecoration(labelText: 'Attribute Type'),
                items:
                    attributeTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(
                      () => _selectedAttributeType = value ?? 'String',
                    ),
              ),
              SizedBox(height: context.spacingM),

              // Required checkbox
              CheckboxListTile(
                title: const Text('Required'),
                subtitle: const Text('Is this attribute required?'),
                value: _attributeRequired,
                onChanged:
                    (value) =>
                        setState(() => _attributeRequired = value ?? false),
              ),

              // Identifier checkbox
              CheckboxListTile(
                title: const Text('Identifier'),
                subtitle: const Text(
                  'Is this attribute part of the entity identity?',
                ),
                value: _attributeIdentifier,
                onChanged:
                    (value) =>
                        setState(() => _attributeIdentifier = value ?? false),
              ),

              // Description field
              TextField(
                controller: _attributeDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  helperText: 'Enter a description for this attribute',
                ),
                maxLines: 3,
              ),
              SizedBox(height: context.spacingL),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => creatingAttribute = false),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: context.spacingM),
                  ElevatedButton(
                    onPressed: _createAttribute,
                    child: const Text('Add Attribute'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConceptEditor() {
    final attributes = activeConcept?.getAllAttributes() ?? [];
    final parents = activeConcept?.getAllParents() ?? [];

    return SemanticConceptContainer(
      conceptType: 'Concept',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concept header
            Row(
              children: [
                Text(
                  'Concept: ${activeConcept?.code}',
                  style: context.conceptTextStyle('Concept', role: 'title'),
                ),
                SizedBox(width: context.spacingM),
                if (activeConcept?.entry == true)
                  Chip(
                    label: const Text('Entry Point'),
                    backgroundColor: Colors.amber.withAlpha(80),
                  ),
              ],
            ),

            if (activeConcept?.description != null &&
                activeConcept!.description.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: context.spacingS),
                child: Text(
                  activeConcept!.description,
                  style: context.conceptTextStyle(
                    'Concept',
                    role: 'description',
                  ),
                ),
              ),

            Divider(height: context.spacingL * 2),

            // Attributes section with add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attributes',
                  style: context.conceptTextStyle(
                    'Concept',
                    role: 'sectionTitle',
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Attribute'),
                  onPressed: () => setState(() => creatingAttribute = true),
                ),
              ],
            ),

            SizedBox(height: context.spacingM),

            if (attributes.isEmpty)
              Text(
                'No attributes defined',
                style: context.conceptTextStyle('Concept', role: 'emptyState'),
              )
            else
              Card(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Required')),
                    DataColumn(label: Text('Identifier')),
                  ],
                  rows:
                      attributes
                          .map(
                            (attribute) => DataRow(
                              cells: [
                                DataCell(Text(attribute.code)),
                                DataCell(
                                  Text(attribute.type?.code ?? 'String'),
                                ),
                                DataCell(
                                  Text(attribute.required ? 'Yes' : 'No'),
                                ),
                                DataCell(
                                  Text(attribute.identifier ? 'Yes' : 'No'),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                ),
              ),

            SizedBox(height: context.spacingL),

            // Relationships section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Relationships',
                  style: context.conceptTextStyle(
                    'Concept',
                    role: 'sectionTitle',
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Relationship'),
                  onPressed: () => _showAddRelationshipDialog(),
                ),
              ],
            ),

            SizedBox(height: context.spacingM),

            // This would show parent and child relationships
            Card(
              child: Padding(
                padding: EdgeInsets.all(context.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parents',
                      style: context.conceptTextStyle(
                        'Concept',
                        role: 'subsectionTitle',
                      ),
                    ),
                    SizedBox(height: context.spacingS),
                    if (parents.isEmpty)
                      Text(
                        'No parent relationships defined',
                        style: context.conceptTextStyle(
                          'Concept',
                          role: 'emptyState',
                        ),
                      )
                    else
                      Column(
                        children:
                            parents
                                .map(
                                  (parent) => ListTile(
                                    title: Text(parent.code),
                                    // We would handle parent relationships differently in a real implementation
                                    subtitle: Text('Parent Concept'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _removeParent(parent),
                                      tooltip: 'Remove Relationship',
                                    ),
                                  ),
                                )
                                .toList(),
                      ),

                    Divider(height: context.spacingL),

                    Text(
                      'Children',
                      style: context.conceptTextStyle(
                        'Concept',
                        role: 'subsectionTitle',
                      ),
                    ),
                    SizedBox(height: context.spacingS),
                    Text(
                      'Children relationships are managed from the child concept',
                      style: context.conceptTextStyle(
                        'Concept',
                        role: 'emptyState',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelEditor() {
    final concepts = activeModel?.getAllConcepts() ?? [];

    return SemanticConceptContainer(
      conceptType: 'Model',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Model header
            Text(
              'Model: ${activeModel?.code}',
              style: context.conceptTextStyle('Model', role: 'title'),
            ),

            if (activeModel?.description != null)
              Padding(
                padding: EdgeInsets.only(top: context.spacingS),
                child: Text(
                  activeModel!.description,
                  style: context.conceptTextStyle('Model', role: 'description'),
                ),
              ),

            Divider(height: context.spacingL * 2),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Concept'),
                  onPressed:
                      () => setState(() {
                        creatingConcept = true;
                      }),
                ),
              ],
            ),

            SizedBox(height: context.spacingM),

            // Entry concepts section
            Text(
              'Entry Concepts',
              style: context.conceptTextStyle('Model', role: 'sectionTitle'),
            ),

            SizedBox(height: context.spacingM),

            if (activeModel?.getEntryConcepts().isEmpty ?? true)
              Text(
                'No entry concepts defined',
                style: context.conceptTextStyle('Model', role: 'emptyState'),
              )
            else
              Wrap(
                spacing: context.spacingM,
                runSpacing: context.spacingM,
                children:
                    activeModel!
                        .getEntryConcepts()
                        .map(
                          (concept) =>
                              _buildConceptCard(concept, isEntry: true),
                        )
                        .toList(),
              ),

            SizedBox(height: context.spacingL),

            // Supporting concepts section
            Text(
              'Supporting Concepts',
              style: context.conceptTextStyle('Model', role: 'sectionTitle'),
            ),

            SizedBox(height: context.spacingM),

            if (concepts.where((c) => !c.entry).isEmpty)
              Text(
                'No supporting concepts defined',
                style: context.conceptTextStyle('Model', role: 'emptyState'),
              )
            else
              Wrap(
                spacing: context.spacingM,
                runSpacing: context.spacingM,
                children:
                    concepts
                        .where((c) => !c.entry)
                        .map(
                          (concept) =>
                              _buildConceptCard(concept, isEntry: false),
                        )
                        .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainEditor() {
    final models = activeDomain?.getAllModels() ?? [];

    return SemanticConceptContainer(
      conceptType: 'Domain',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Domain header
            Text(
              'Domain: ${activeDomain?.code}',
              style: context.conceptTextStyle('Domain', role: 'title'),
            ),

            if (activeDomain?.description != null)
              Padding(
                padding: EdgeInsets.only(top: context.spacingS),
                child: Text(
                  activeDomain!.description,
                  style: context.conceptTextStyle(
                    'Domain',
                    role: 'description',
                  ),
                ),
              ),

            Divider(height: context.spacingL * 2),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Model'),
                  onPressed:
                      () => setState(() {
                        creatingModel = true;
                      }),
                ),
              ],
            ),

            SizedBox(height: context.spacingM),

            // Models section
            Text(
              'Models in this Domain',
              style: context.conceptTextStyle('Domain', role: 'sectionTitle'),
            ),

            SizedBox(height: context.spacingM),

            if (models.isEmpty)
              Text(
                'No models defined in this domain',
                style: context.conceptTextStyle('Domain', role: 'emptyState'),
              )
            else
              Wrap(
                spacing: context.spacingM,
                runSpacing: context.spacingM,
                children:
                    models.map((model) => _buildModelCard(model)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptCard(Concept concept, {required bool isEntry}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap:
            () => setState(() {
              activeConcept = concept;
              activeModel = concept.model;
              activeDomain = activeModel!.domain;
            }),
        child: Container(
          width: 220,
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isEntry ? Icons.star : Icons.category,
                    color:
                        isEntry
                            ? Colors.amber
                            : context.conceptColor('Concept', role: 'icon'),
                  ),
                  SizedBox(width: context.spacingS),
                  Expanded(
                    child: Text(
                      concept.code,
                      style: context.conceptTextStyle(
                        'Concept',
                        role: 'cardTitle',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.spacingS),

              Text(
                '${concept.getAllAttributes().length} attributes',
                style: context.conceptTextStyle('Concept', role: 'meta'),
              ),

              if (concept.getAllParents().isNotEmpty)
                Text(
                  '${concept.getAllParents().length} ${concept.getAllParents().length == 1 ? 'parent' : 'parents'}',
                  style: context.conceptTextStyle('Concept', role: 'meta'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelCard(Model model) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap:
            () => setState(() {
              activeModel = model;
              activeDomain = model.domain;
              activeConcept = null;
            }),
        child: Container(
          width: 220,
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dataset,
                    color: context.conceptColor('Model', role: 'icon'),
                  ),
                  SizedBox(width: context.spacingS),
                  Expanded(
                    child: Text(
                      model.code,
                      style: context.conceptTextStyle(
                        'Model',
                        role: 'cardTitle',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.spacingS),

              Text(
                '${model.getAllConcepts().length} concepts',
                style: context.conceptTextStyle('Model', role: 'meta'),
              ),

              Text(
                '${model.getEntryConcepts().length} entry points',
                style: context.conceptTextStyle('Model', role: 'meta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildAddButton() {
    if (activeConcept != null) {
      return FloatingActionButton(
        onPressed: () => setState(() => creatingAttribute = true),
        tooltip: 'Add Attribute',
        child: const Icon(Icons.add),
      );
    } else if (activeModel != null) {
      return FloatingActionButton(
        onPressed: () => setState(() => creatingConcept = true),
        tooltip: 'Add Concept',
        child: const Icon(Icons.add),
      );
    } else if (activeDomain != null) {
      return FloatingActionButton(
        onPressed: () => setState(() => creatingModel = true),
        tooltip: 'Add Model',
        child: const Icon(Icons.add),
      );
    } else {
      return FloatingActionButton(
        onPressed: () => setState(() => creatingDomain = true),
        tooltip: 'Add Domain',
        child: const Icon(Icons.add),
      );
    }
  }

  // Creation methods
  Future<void> _createDomain() async {
    final name = _domainNameController.text.trim();
    if (name.isEmpty) return;

    // Create a new domain
    final newDomain = Domain(name);
    newDomain.description = _domainDescriptionController.text.trim();

    // Register with OneApplication
    await _registerNewDomain(newDomain);

    // Reset state
    setState(() {
      _domainNameController.clear();
      _domainDescriptionController.clear();
      creatingDomain = false;
      activeDomain = newDomain;
    });

    // Save immediately
    await persistenceService.saveAllDomainModels();
    _loadDomains();
  }

  Future<void> _createModel() async {
    if (activeDomain == null) return;

    final name = _modelNameController.text.trim();
    if (name.isEmpty) return;

    // Create a new model
    final newModel = Model(activeDomain!, name);
    if (_modelDescriptionController.text.isNotEmpty) {
      newModel.description = _modelDescriptionController.text.trim();
    }

    // Register with the domain (already done in constructor)

    // Reset state
    setState(() {
      _modelNameController.clear();
      _modelDescriptionController.clear();
      creatingModel = false;
      activeModel = newModel;
    });

    // Save immediately
    await persistenceService.saveDomainModel(activeDomain!, newModel);
    _loadDomains();
  }

  Future<void> _createConcept() async {
    if (activeDomain == null || activeModel == null) return;

    final name = _conceptNameController.text.trim();
    if (name.isEmpty) return;

    // Create a new concept
    final newConcept = Concept(activeModel!, name);
    newConcept.entry = isEntryPoint;
    if (_conceptDescriptionController.text.isNotEmpty) {
      newConcept.description = _conceptDescriptionController.text.trim();
    }

    // Reset state
    setState(() {
      _conceptNameController.clear();
      _conceptDescriptionController.clear();
      creatingConcept = false;
      activeConcept = newConcept;
      isEntryPoint = false;
    });

    // Save immediately
    await persistenceService.saveDomainModel(activeDomain!, activeModel!);
    _loadDomains();
  }

  Future<void> _createAttribute() async {
    if (activeConcept == null) return;

    final name = _attributeNameController.text.trim();
    if (name.isEmpty) return;

    // Get the attribute type - handle null or empty string case
    final String typeCode =
        _selectedAttributeType.isNotEmpty ? _selectedAttributeType : 'String';
    final attributeType =
        activeConcept!.model.domain.getType(typeCode) ??
        activeConcept!.model.domain.getType('String');

    // Create a new attribute
    if (attributeType != null) {
      final newAttribute = Attribute(activeConcept!, name, attributeType);
      newAttribute.required = _attributeRequired;
      newAttribute.identifier = _attributeIdentifier;
      if (_attributeDescriptionController.text.isNotEmpty) {
        newAttribute.label = _attributeDescriptionController.text;
      }

      // Reset state
      setState(() {
        _attributeNameController.clear();
        _attributeDescriptionController.clear();
        creatingAttribute = false;
        _attributeRequired = false;
        _attributeIdentifier = false;
      });

      // Save immediately
      await persistenceService.saveDomainModel(activeDomain!, activeModel!);
      _loadDomains();
    } else {
      _showErrorSnackBar('Attribute type not found: $_selectedAttributeType');
    }
  }

  // Backend registration methods
  Future<void> _registerNewDomain(Domain domain) async {
    // Register domain with OneApplication
    try {
      oneApplication.domains.add(domain);
      oneApplication.groupedDomains.add(domain);
    } catch (e) {
      _showErrorSnackBar('Failed to register domain: $e');
    }
  }

  void _showAddRelationshipDialog() {
    // TODO: Implement relationship creation dialog
    _showInfoSnackBar('Relationship creation not yet implemented');
  }

  void _removeParent(dynamic parent) {
    // TODO: Implement parent relationship removal
    _showInfoSnackBar('Relationship removal not yet implemented');
  }

  // Saving and loading
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

  // Launch as app
  void _launchModel() {
    if (activeDomain == null || activeModel == null) {
      _showErrorSnackBar('Select a model to launch');
      return;
    }

    _showInfoSnackBar('Launching model ${activeModel!.code} as an app');

    // TODO: Implement app launching
    // This would navigate to a dynamically generated app based on the domain model
    // Navigator.of(context).pushNamed(
    //   '/model-app',
    //   arguments: {
    //     'domain': activeDomain,
    //     'model': activeModel,
    //   },
    // );
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
