import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/domain/extensions/domain_model_extensions.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:ednet_one/main.dart' show oneApplication, persistenceService;
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';

/// Domain modeler page for visualizing and interacting with domain models
class DomainModelerPage extends StatefulWidget {
  /// The route name for navigation
  static const String routeName = '/domain-modeler';

  /// Constructor
  const DomainModelerPage({super.key});

  @override
  State<DomainModelerPage> createState() => _DomainModelerPageState();
}

class _DomainModelerPageState extends State<DomainModelerPage> {
  // Selected elements
  Domain? _selectedDomain;
  Model? _selectedModel;
  Concept? _selectedConcept;
  Property? _selectedAttribute;
  Concept? _selectedParent;

  // List of available domains, models, and concepts
  List<Domain> _availableDomains = [];
  List<Model> _availableModels = [];
  List<Concept> _availableConcepts = [];

  @override
  void initState() {
    super.initState();
    _loadDomains();
  }

  void _loadDomains() {
    setState(() {
      _availableDomains = oneApplication.getAllDomains();

      // If there are domains, select the first one
      if (_availableDomains.isNotEmpty) {
        _selectDomain(_availableDomains.first);
      }
    });
  }

  void _selectDomain(Domain domain) {
    setState(() {
      _selectedDomain = domain;
      _selectedModel = null;
      _selectedConcept = null;
      _selectedAttribute = null;
      _selectedParent = null;

      // Load models for this domain
      _availableModels = domain.getAllModels();
      _availableConcepts = [];

      // If there are models, select the first one
      if (_availableModels.isNotEmpty) {
        _selectModel(_availableModels.first);
      }
    });
  }

  void _selectModel(Model model) {
    setState(() {
      _selectedModel = model;
      _selectedConcept = null;
      _selectedAttribute = null;
      _selectedParent = null;

      // Load concepts for this model
      _availableConcepts = model.getAllConcepts();

      // If there are concepts, select the first one
      if (_availableConcepts.isNotEmpty) {
        _selectConcept(_availableConcepts.first);
      }
    });
  }

  void _selectConcept(Concept concept) {
    setState(() {
      _selectedConcept = concept;
      _selectedAttribute = null;
      _selectedParent = null;
    });
  }

  void _selectAttribute(Property attribute) {
    setState(() {
      _selectedAttribute = attribute;
      _selectedParent = null;
    });
  }

  void _selectParent(Concept parent) {
    setState(() {
      _selectedParent = parent;
      _selectedAttribute = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain Modeler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Domain Model',
            onPressed: _saveDomainModel,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Domain Model',
            onPressed: _loadDomainModel,
          ),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar with domain hierarchy browser
          SizedBox(width: 300, child: _buildDomainBrowser()),

          // Divider
          const VerticalDivider(width: 1),

          // Main content area
          Expanded(child: _buildDomainModelViewer()),
        ],
      ),
    );
  }

  Widget _buildDomainBrowser() {
    return Card(
      margin: EdgeInsets.all(context.spacingS),
      child: Padding(
        padding: EdgeInsets.all(context.spacingXs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(context.spacingS),
              child: Text(
                'Domain Model Browser',
                style: context.conceptTextStyle(
                  'Workspace',
                  role: 'sectionTitle',
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  // Domain section
                  ExpansionTile(
                    title: const Text('Domains'),
                    initiallyExpanded: true,
                    children: [
                      ..._availableDomains.map(
                        (domain) => ListTile(
                          title: Text(domain.code),
                          selected: domain == _selectedDomain,
                          onTap: () => _selectDomain(domain),
                        ),
                      ),
                    ],
                  ),

                  // Model section (show only if domain is selected)
                  if (_selectedDomain != null)
                    ExpansionTile(
                      title: const Text('Models'),
                      initiallyExpanded: true,
                      children: [
                        ..._availableModels.map(
                          (model) => ListTile(
                            title: Text(model.code),
                            selected: model == _selectedModel,
                            onTap: () => _selectModel(model),
                          ),
                        ),
                      ],
                    ),

                  // Concept section (show only if model is selected)
                  if (_selectedModel != null)
                    ExpansionTile(
                      title: const Text('Concepts'),
                      initiallyExpanded: true,
                      children: [
                        ..._availableConcepts.map(
                          (concept) => ListTile(
                            title: Text(concept.code),
                            subtitle: Text(concept.entry ? 'Entry Point' : ''),
                            selected: concept == _selectedConcept,
                            onTap: () => _selectConcept(concept),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainModelViewer() {
    if (_selectedConcept != null) {
      return _buildConceptViewer(_selectedConcept!);
    } else if (_selectedModel != null) {
      return _buildModelViewer(_selectedModel!);
    } else if (_selectedDomain != null) {
      return _buildDomainViewer(_selectedDomain!);
    } else {
      return Center(
        child: Text(
          'Select a domain, model, or concept to view details',
          style: context.conceptTextStyle('Workspace', role: 'emptyState'),
        ),
      );
    }
  }

  Widget _buildDomainViewer(Domain domain) {
    return SemanticConceptContainer(
      conceptType: 'Domain',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Domain header
            Text(
              'Domain: ${domain.code}',
              style: context.conceptTextStyle('Domain', role: 'title'),
            ),

            if (domain.description != null)
              Padding(
                padding: EdgeInsets.only(top: context.spacingS),
                child: Text(
                  domain.description!,
                  style: context.conceptTextStyle(
                    'Domain',
                    role: 'description',
                  ),
                ),
              ),

            Divider(height: context.spacingL * 2),

            // Models section
            Text(
              'Models in this Domain',
              style: context.conceptTextStyle('Domain', role: 'sectionTitle'),
            ),

            SizedBox(height: context.spacingM),

            Wrap(
              spacing: context.spacingM,
              runSpacing: context.spacingM,
              children:
                  domain
                      .getAllModels()
                      .map((model) => _buildModelCard(model))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelViewer(Model model) {
    return SemanticConceptContainer(
      conceptType: 'Model',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Model header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _selectDomain(_selectedDomain!),
                  tooltip: 'Back to Domain',
                ),

                Text(
                  'Model: ${model.code}',
                  style: context.conceptTextStyle('Model', role: 'title'),
                ),
              ],
            ),

            Divider(height: context.spacingL * 2),

            // Entry concepts section
            Text(
              'Entry Concepts',
              style: context.conceptTextStyle('Model', role: 'sectionTitle'),
            ),

            SizedBox(height: context.spacingM),

            Wrap(
              spacing: context.spacingM,
              runSpacing: context.spacingM,
              children:
                  model
                      .getEntryConcepts()
                      .map(
                        (concept) => _buildConceptCard(concept, isEntry: true),
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

            Wrap(
              spacing: context.spacingM,
              runSpacing: context.spacingM,
              children:
                  model
                      .getAllConcepts()
                      .where((concept) => !concept.entry)
                      .map(
                        (concept) => _buildConceptCard(concept, isEntry: false),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptViewer(Concept concept) {
    final parents = concept.getAllParents();

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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _selectModel(_selectedModel!),
                  tooltip: 'Back to Model',
                ),

                Text(
                  'Concept: ${concept.code}',
                  style: context.conceptTextStyle('Concept', role: 'title'),
                ),

                SizedBox(width: context.spacingM),

                if (concept.entry)
                  Chip(
                    label: const Text('Entry Point'),
                    backgroundColor: Colors.amber.withAlpha(80),
                  ),
              ],
            ),

            Divider(height: context.spacingL * 2),

            // Attributes section
            _buildAttributesSection(concept),

            SizedBox(height: context.spacingL),

            // Parents section
            if (parents.isNotEmpty) _buildParentsSection(concept, parents),

            SizedBox(height: context.spacingL),

            // Children section
            // This would ideally show all concepts that have this concept as a parent
            // But that requires a reverse lookup that might not be easily available
          ],
        ),
      ),
    );
  }

  Widget _buildAttributesSection(Concept concept) {
    final attributes = concept.getAllAttributes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attributes',
          style: context.conceptTextStyle('Concept', role: 'sectionTitle'),
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
                DataColumn(label: Text('Description')),
              ],
              rows:
                  attributes
                      .map(
                        (attribute) => DataRow(
                          selected: attribute == _selectedAttribute,
                          onSelectChanged: (selected) {
                            if (selected == true) {
                              _selectAttribute(attribute);
                            }
                          },
                          cells: [
                            DataCell(Text(attribute.code)),
                            DataCell(
                              Text(attribute.type?.toString() ?? 'String'),
                            ),
                            DataCell(
                              Text(attribute.required == true ? 'Yes' : 'No'),
                            ),
                            DataCell(Text(attribute.label ?? '')),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildParentsSection(Concept concept, List<Concept> parents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Parent Concepts',
          style: context.conceptTextStyle('Concept', role: 'sectionTitle'),
        ),

        SizedBox(height: context.spacingM),

        Wrap(
          spacing: context.spacingM,
          runSpacing: context.spacingM,
          children:
              parents
                  .map(
                    (parent) => _buildConceptCard(
                      parent,
                      isSelected: parent == _selectedParent,
                      onTap: () {
                        _selectConcept(parent);
                      },
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildModelCard(Model model) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _selectModel(model),
        child: Container(
          width: 200,
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

              // Concept count
              Text(
                '${model.getAllConcepts().length} concepts',
                style: context.conceptTextStyle('Model', role: 'meta'),
              ),

              // Entry point count
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

  Widget _buildConceptCard(
    Concept concept, {
    bool isEntry = false,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap ?? () => _selectConcept(concept),
        child: Container(
          width: 200,
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

              // Attribute count
              Text(
                '${concept.getAllAttributes().length} attributes',
                style: context.conceptTextStyle('Concept', role: 'meta'),
              ),

              // Parents count
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

  // Persistence methods
  Future<void> _saveDomainModel() async {
    if (_selectedDomain == null) {
      _showSnackBar('No domain selected to save');
      return;
    }

    bool success;
    if (_selectedModel != null) {
      // Save specific model
      success = await persistenceService.saveDomainModel(
        _selectedDomain!,
        _selectedModel!,
      );
      _showSnackBar(
        success
            ? 'Saved model ${_selectedModel!.code}'
            : 'Failed to save model ${_selectedModel!.code}',
      );
    } else {
      // Save all domain models
      success = await persistenceService.saveAllDomainModels();
      _showSnackBar(
        success ? 'Saved all domain models' : 'Failed to save domain models',
      );
    }
  }

  Future<void> _loadDomainModel() async {
    if (_selectedDomain == null) {
      _showSnackBar('No domain selected to load');
      return;
    }

    bool success;
    if (_selectedModel != null) {
      // Load specific model
      success = await persistenceService.loadDomainModel(
        _selectedDomain!,
        _selectedModel!,
      );
      _showSnackBar(
        success
            ? 'Loaded model ${_selectedModel!.code}'
            : 'Failed to load model ${_selectedModel!.code}',
      );
    } else {
      // Load all domain models
      success = await persistenceService.loadAllDomainModels();
      _showSnackBar(
        success ? 'Loaded all domain models' : 'No domain models found to load',
      );
    }

    // Refresh the view
    _loadDomains();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
