import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';

import '../../presentation/blocs/domain_block.dart';
import '../../presentation/blocs/domain_state.dart';
import '../../presentation/blocs/domain_event.dart';
import '../../domain_model_visualization/domain_model_visualization.dart';
import '../../presentation/widgets/drafts_panel.dart';

/// A screen that visualizes a domain model with interactive elements
class DomainVisualizationScreen extends StatefulWidget {
  const DomainVisualizationScreen({Key? key}) : super(key: key);

  @override
  State<DomainVisualizationScreen> createState() =>
      _DomainVisualizationScreenState();
}

class _DomainVisualizationScreenState extends State<DomainVisualizationScreen> {
  bool _useMasterDetailLayout = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DomainBloc, DomainState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Domain Model Visualization'),
            actions: [
              IconButton(
                icon: const Icon(Icons.code),
                tooltip: 'Export DSL',
                onPressed: () {
                  context.read<DomainBloc>().add(ExportDSLEvent());
                  _showDSLDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Save Draft',
                onPressed:
                    state.selectedDomain != null && state.selectedModel != null
                        ? () {
                          context.read<DomainBloc>().add(
                            SaveDraftEvent(
                              domain: state.selectedDomain!,
                              model: state.selectedModel!,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Draft saved')),
                          );
                        }
                        : null,
              ),
              IconButton(
                icon: const Icon(Icons.build),
                tooltip: 'Generate Code',
                onPressed: () {
                  context.read<DomainBloc>().add(GenerateCodeEvent());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code generation started...')),
                  );
                },
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DomainState state) {
    if (state.selectedDomain == null) {
      return const Center(
        child: Text('No domain selected. Please select a domain.'),
      );
    }

    return Row(
      children: [
        // Domain/Model Selection Panel
        SizedBox(width: 250, child: _buildSelectionPanel(context, state)),
        const VerticalDivider(),
        // Visualization Area
        Expanded(
          child: Column(
            children: [
              Expanded(flex: 3, child: _buildVisualizationArea(context, state)),
              if (state.selectedModel != null)
                SizedBox(height: 250, child: const DraftsPanel()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionPanel(BuildContext context, DomainState state) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Layout Control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Master-Detail:'),
                Switch(
                  value: _useMasterDetailLayout,
                  onChanged: (value) {
                    setState(() {
                      _useMasterDetailLayout = value;
                    });
                  },
                ),
              ],
            ),
            const Divider(),

            // Domain Selection
            const Text(
              'Domains',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDomainSelector(context, state),

            const SizedBox(height: 16),

            // Model Selection
            const Text(
              'Models',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildModelSelector(context, state),

            const SizedBox(height: 16),

            // Concepts List
            const Text(
              'Concepts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildConceptsList(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainSelector(BuildContext context, DomainState state) {
    final domainBloc = context.read<DomainBloc>();
    final domains = domainBloc.app.groupedDomains.toList();

    return DropdownButton<Domain>(
      isExpanded: true,
      value: state.selectedDomain,
      hint: const Text('Select a domain'),
      onChanged: (Domain? newValue) {
        if (newValue != null) {
          context.read<DomainBloc>().add(SelectDomainEvent(newValue));
        }
      },
      items:
          domains.map<DropdownMenuItem<Domain>>((Domain domain) {
            return DropdownMenuItem<Domain>(
              value: domain,
              child: Text(domain.code),
            );
          }).toList(),
    );
  }

  Widget _buildModelSelector(BuildContext context, DomainState state) {
    if (state.selectedDomain == null) {
      return const Text('Select a domain first');
    }

    final models = state.selectedDomain!.models.toList();

    return DropdownButton<Model>(
      isExpanded: true,
      value: state.selectedModel,
      hint: const Text('Select a model'),
      onChanged: (Model? newValue) {
        if (newValue != null) {
          context.read<DomainBloc>().add(SelectModelEvent(newValue));

          // Also load drafts when selecting a model
          context.read<DomainBloc>().add(ListDraftsEvent());
          context.read<DomainBloc>().add(
            ListVersionsEvent(
              domainCode: state.selectedDomain!.codeFirstLetterLower,
              modelCode: newValue.codeFirstLetterLower,
            ),
          );
        }
      },
      items:
          models.map<DropdownMenuItem<Model>>((Model model) {
            return DropdownMenuItem<Model>(
              value: model,
              child: Text(model.code),
            );
          }).toList(),
    );
  }

  Widget _buildConceptsList(BuildContext context, DomainState state) {
    if (state.selectedModel == null) {
      return const Text('Select a model first');
    }

    // Handle potential null values
    try {
      final concepts = state.selectedModel!.concepts.toList();

      if (concepts.isEmpty) {
        return const Center(
          child: Text(
            'This model has no concepts',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      }

      return ListView.builder(
        itemCount: concepts.length,
        itemBuilder: (context, index) {
          try {
            final concept = concepts[index];
            final isSelected = state.selectedConcept == concept;

            // Safely check concept.entry - handle potential errors
            bool isEntry = false;
            try {
              isEntry = concept.entry;
            } catch (e) {
              print('Error checking if concept is entry: $e');
            }

            return ListTile(
              title: Text(concept.code),
              subtitle: Text(isEntry ? 'Entry' : ''),
              selected: isSelected,
              leading:
                  isEntry
                      ? const Icon(Icons.star, color: Colors.amber)
                      : const Icon(Icons.circle, size: 12),
              tileColor: isSelected ? Theme.of(context).highlightColor : null,
              onTap: () {
                context.read<DomainBloc>().add(SelectConceptEvent(concept));
              },
            );
          } catch (e) {
            // Skip this item if there was an error
            return const SizedBox.shrink();
          }
        },
      );
    } catch (e) {
      return Center(child: Text('Error loading concepts: $e'));
    }
  }

  Widget _buildVisualizationArea(BuildContext context, DomainState state) {
    if (state.selectedModel == null) {
      return const Center(
        child: Text('No model loaded. Select a domain and model.'),
      );
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Graph Visualization
            Expanded(
              flex: 3,
              child: DomainModelVisualization(
                domain: state.selectedDomain!,
                model: state.selectedModel!,
                useMasterDetailLayout: _useMasterDetailLayout,
                onConceptSelected: (concept) {
                  // When a concept is selected in the visualization, update the selected concept in the bloc
                  context.read<DomainBloc>().add(SelectConceptEvent(concept));
                },
              ),
            ),

            // Details Panel (if a concept is selected)
            if (state.selectedConcept != null)
              Expanded(flex: 1, child: _buildDetailsPanel(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsPanel(BuildContext context, DomainState state) {
    try {
      final concept = state.selectedConcept! as Concept;

      // Safely check if properties are accessible
      bool isEntry = false;
      try {
        isEntry = concept.entry;
      } catch (e) {
        print('Error checking if concept is entry: $e');
      }

      // Safely get attributes
      final attributes = <Attribute>[];
      try {
        for (var attr in concept.attributes) {
          attributes.add(attr as Attribute);
        }
      } catch (e) {
        print('Error getting concept attributes: $e');
      }

      // Safely get parents and children
      final parents = <Parent>[];
      final children = <Child>[];
      try {
        for (var parent in concept.parents) {
          parents.add(parent as Parent);
        }
      } catch (e) {
        print('Error getting concept parents: $e');
      }

      try {
        for (var child in concept.children) {
          children.add(child as Child);
        }
      } catch (e) {
        print('Error getting concept children: $e');
      }

      return Card(
        margin: const EdgeInsets.all(8.0),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Parents'),
                  Tab(text: 'Children'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Overview tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Concept: ${concept.code}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Is Entry: $isEntry'),
                          const SizedBox(height: 16),
                          const Text(
                            'Attributes:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (attributes.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'No attributes defined',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            )
                          else
                            ...attributes.map((attribute) {
                              String typeName = 'Unknown';
                              try {
                                typeName = attribute.type?.code ?? 'Unknown';
                              } catch (e) {
                                print('Error getting attribute type: $e');
                              }

                              bool isRequired = false;
                              try {
                                isRequired = attribute.required;
                              } catch (e) {
                                print(
                                  'Error checking if attribute is required: $e',
                                );
                              }

                              return ListTile(
                                title: Text(attribute.code),
                                subtitle: Text(
                                  'Type: $typeName${isRequired ? " (Required)" : ""}',
                                ),
                                dense: true,
                              );
                            }),
                        ],
                      ),
                    ),

                    // Parents tab
                    parents.isEmpty
                        ? const Center(child: Text('No parent relationships'))
                        : _buildRelationshipsList(
                          context,
                          parents
                              .map((parent) => parent.concept)
                              .whereType<Concept>()
                              .toList(),
                          icon: Icons.arrow_upward,
                          emptyMessage: 'No parent relationships',
                        ),

                    // Children tab
                    children.isEmpty
                        ? const Center(child: Text('No child relationships'))
                        : _buildRelationshipsList(
                          context,
                          children
                              .map((child) => child.concept)
                              .whereType<Concept>()
                              .toList(),
                          icon: Icons.arrow_downward,
                          emptyMessage: 'No child relationships',
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return Center(child: Text('Error displaying concept details: $e'));
    }
  }

  Widget _buildRelationshipsList(
    BuildContext context,
    List<Concept> concepts, {
    IconData icon = Icons.link,
    String emptyMessage = 'No relationships',
  }) {
    if (concepts.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: concepts.length,
      itemBuilder: (context, index) {
        final concept = concepts[index];

        // Check if entry
        bool isEntry = false;
        try {
          isEntry = concept.entry;
        } catch (e) {}

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: Icon(icon, color: isEntry ? Colors.amber : Colors.blue),
            title: Text(concept.code),
            subtitle: Text(isEntry ? 'Entry Concept' : 'Regular Concept'),
            trailing: ElevatedButton.icon(
              icon: const Icon(Icons.visibility),
              label: const Text('View'),
              onPressed: () {
                context.read<DomainBloc>().add(SelectConceptEvent(concept));
              },
            ),
            onTap: () {
              context.read<DomainBloc>().add(SelectConceptEvent(concept));
            },
          ),
        );
      },
    );
  }

  void _showDSLDialog(BuildContext context) {
    final dsl = context.read<DomainBloc>().getDSL();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Domain Specific Language (YAML)'),
          content: SingleChildScrollView(child: SelectableText(dsl)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
