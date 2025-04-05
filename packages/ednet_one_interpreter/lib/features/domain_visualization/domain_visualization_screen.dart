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

    final concepts = state.selectedModel!.concepts.toList();

    return ListView.builder(
      itemCount: concepts.length,
      itemBuilder: (context, index) {
        final concept = concepts[index];
        final isSelected = state.selectedConcept == concept;

        return ListTile(
          title: Text(concept.code),
          subtitle: Text(concept.entry ? 'Entry' : ''),
          selected: isSelected,
          leading:
              concept.entry
                  ? const Icon(Icons.star, color: Colors.amber)
                  : const Icon(Icons.circle, size: 12),
          tileColor: isSelected ? Theme.of(context).highlightColor : null,
          onTap: () {
            context.read<DomainBloc>().add(SelectConceptEvent(concept));
          },
        );
      },
    );
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
    final concept = state.selectedConcept! as Concept;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Concept: ${concept.code}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Is Entry: ${concept.entry}'),
            const SizedBox(height: 16),

            const Text(
              'Attributes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...concept.attributes.map((attribute) {
              return ListTile(
                title: Text(attribute.code),
                subtitle: Text('Type: ${attribute.type?.code ?? "Unknown"}'),
                dense: true,
              );
            }),

            const SizedBox(height: 16),

            if (concept.parents.isNotEmpty) ...[
              const Text(
                'Parent Relationships:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...concept.parents.map((parent) {
                return ListTile(
                  title: Text(parent.code),
                  subtitle: Text(
                    'Target: ${parent.concept?.code ?? "Unknown"}',
                  ),
                  dense: true,
                );
              }),
            ],

            if (concept.children.isNotEmpty) ...[
              const Text(
                'Child Relationships:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...concept.children.map((child) {
                return ListTile(
                  title: Text(child.code),
                  subtitle: Text('Target: ${child.concept?.code ?? "Unknown"}'),
                  dense: true,
                );
              }),
            ],
          ],
        ),
      ),
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
