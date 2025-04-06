import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/domain/providers/entity_provider.dart';
import 'package:ednet_one/domain/services/persistence_service.dart';
import 'package:ednet_one/main.dart' show oneApplication, persistenceService;
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';

/// Example page demonstrating entity persistence
class EntityPersistenceExamplePage extends StatefulWidget {
  /// Static route name
  static const String routeName = '/examples/entity-persistence';

  /// Constructor
  const EntityPersistenceExamplePage({super.key});

  @override
  EntityPersistenceExamplePageState createState() =>
      EntityPersistenceExamplePageState();
}

class EntityPersistenceExamplePageState
    extends State<EntityPersistenceExamplePage> {
  // Selected domain, model, and concept
  Domain? selectedDomain;
  Model? selectedModel;
  Concept? selectedConcept;

  // Available domains, models, and concepts
  List<Domain> availableDomains = [];
  List<Model> availableModels = [];
  List<Concept> availableConcepts = [];

  @override
  void initState() {
    super.initState();

    // Load available domains
    availableDomains = oneApplication.groupedDomains.toList();

    // Select the first domain if available
    if (availableDomains.isNotEmpty) {
      _selectDomain(availableDomains.first);
    }
  }

  void _selectDomain(Domain domain) {
    setState(() {
      selectedDomain = domain;
      selectedModel = null;
      selectedConcept = null;

      // Load available models for this domain
      availableModels = domain.models.toList();
      availableConcepts = [];

      // Select the first model if available
      if (availableModels.isNotEmpty) {
        _selectModel(availableModels.first);
      }
    });
  }

  void _selectModel(Model model) {
    setState(() {
      selectedModel = model;
      selectedConcept = null;

      // Load available concepts for this model
      availableConcepts = model.concepts.where((c) => c.entry).toList();

      // Select the first concept if available
      if (availableConcepts.isNotEmpty) {
        _selectConcept(availableConcepts.first);
      }
    });
  }

  void _selectConcept(Concept concept) {
    setState(() {
      selectedConcept = concept;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entity Persistence Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save All Domain Models',
            onPressed: () async {
              // Save all domain models
              final saved = await persistenceService.saveAllDomainModels();
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    saved
                        ? 'All domain models saved successfully'
                        : 'Failed to save domain models',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Load All Domain Models',
            onPressed: () async {
              // Load all domain models
              final loaded = await persistenceService.loadAllDomainModels();
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    loaded
                        ? 'All domain models loaded successfully'
                        : 'No domain models to load',
                  ),
                ),
              );

              // Refresh state
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selection controls
          Padding(
            padding: EdgeInsets.all(context.spacingM),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(context.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Domain, Model, and Concept',
                      style: context.conceptTextStyle(
                        'Workspace',
                        role: 'sectionTitle',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Domain selector
                        Expanded(
                          child: DropdownButtonFormField<Domain>(
                            decoration: const InputDecoration(
                              labelText: 'Domain',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedDomain,
                            items:
                                availableDomains.map((domain) {
                                  return DropdownMenuItem<Domain>(
                                    value: domain,
                                    child: Text(domain.code),
                                  );
                                }).toList(),
                            onChanged: (domain) {
                              if (domain != null) {
                                _selectDomain(domain);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Model selector
                        Expanded(
                          child: DropdownButtonFormField<Model>(
                            decoration: const InputDecoration(
                              labelText: 'Model',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedModel,
                            items:
                                availableModels.map((model) {
                                  return DropdownMenuItem<Model>(
                                    value: model,
                                    child: Text(model.code),
                                  );
                                }).toList(),
                            onChanged: (model) {
                              if (model != null) {
                                _selectModel(model);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Concept selector
                        Expanded(
                          child: DropdownButtonFormField<Concept>(
                            decoration: const InputDecoration(
                              labelText: 'Concept',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedConcept,
                            items:
                                availableConcepts.map((concept) {
                                  return DropdownMenuItem<Concept>(
                                    value: concept,
                                    child: Text(concept.code),
                                  );
                                }).toList(),
                            onChanged: (concept) {
                              if (concept != null) {
                                _selectConcept(concept);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Entity list
          Expanded(child: _buildEntityList()),
        ],
      ),
      floatingActionButton:
          selectedDomain != null &&
                  selectedModel != null &&
                  selectedConcept != null
              ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  _showCreateEntityDialog();
                },
              )
              : null,
    );
  }

  Widget _buildEntityList() {
    if (selectedDomain == null ||
        selectedModel == null ||
        selectedConcept == null) {
      return Center(
        child: Text(
          'Select a domain, model, and concept to view entities',
          style: context.conceptTextStyle('Workspace', role: 'emptyState'),
        ),
      );
    }

    return EntityProvider.createEntityWidgetExample(
      context: context,
      concept: selectedConcept!,
      domain: selectedDomain!,
      model: selectedModel!,
      persistenceService: persistenceService,
    );
  }

  void _showCreateEntityDialog() {
    if (selectedDomain == null ||
        selectedModel == null ||
        selectedConcept == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        // Create form fields for each attribute
        final Map<String, TextEditingController> controllers = {};

        for (final attribute in selectedConcept!.attributes) {
          controllers[attribute.code] = TextEditingController();
        }

        return AlertDialog(
          title: Text('Create ${selectedConcept!.code}'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final attribute in selectedConcept!.attributes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: controllers[attribute.code],
                        decoration: InputDecoration(
                          labelText: attribute.code,
                          hintText: 'Enter ${attribute.code}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Create'),
              onPressed: () async {
                // Collect values from controllers
                final Map<String, dynamic> values = {};

                for (final entry in controllers.entries) {
                  // Get attribute type
                  final attribute = selectedConcept!.attributes.firstWhere(
                    (a) => a.code == entry.key,
                    orElse:
                        () =>
                            throw Exception(
                              'Attribute not found: ${entry.key}',
                            ),
                  );

                  final type = attribute.type?.toString().toLowerCase();
                  final value = entry.value.text;

                  // Convert to appropriate type
                  if (type == 'int' || type == 'integer') {
                    values[entry.key] = int.tryParse(value) ?? 0;
                  } else if (type == 'double' || type == 'float') {
                    values[entry.key] = double.tryParse(value) ?? 0.0;
                  } else if (type == 'bool' || type == 'boolean') {
                    values[entry.key] = value.toLowerCase() == 'true';
                  } else {
                    values[entry.key] = value;
                  }
                }

                // Close the dialog
                Navigator.of(context).pop();

                // Create the entity
                final domainModel = _getDomainModel();
                if (domainModel == null) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Domain model not found')),
                  );
                  return;
                }

                final entity = domainModel.newEntity(selectedConcept!.code);

                // Set attributes
                for (final entry in values.entries) {
                  entity.setAttribute(entry.key, entry.value);
                }

                // Save the entity
                await persistenceService.saveEntity<Entity<dynamic>>(
                  entity,
                  selectedConcept!,
                  selectedDomain!,
                  selectedModel!,
                );

                // Refresh state
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  /// Helper method to get the domain model
  dynamic _getDomainModel() {
    if (selectedDomain == null || selectedModel == null) return null;

    try {
      // Access the domain from app's groupedDomains
      final targetDomain = oneApplication.groupedDomains.firstWhere(
        (d) => d.code == selectedDomain!.code,
        orElse:
            () => throw Exception('Domain not found: ${selectedDomain!.code}'),
      );

      // Find the model within this domain
      final domainModel = targetDomain.models.firstWhere(
        (m) => m.code == selectedModel!.code,
        orElse:
            () =>
                throw Exception(
                  'Model not found: ${selectedModel!.code} in domain ${selectedDomain!.code}',
                ),
      );

      return domainModel;
    } catch (e) {
      print('Error getting domain model: $e');
      return null;
    }
  }
}
