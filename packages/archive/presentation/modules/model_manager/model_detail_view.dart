import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../presentation/theme/providers/theme_provider.dart';
import '../../../presentation/theme/extensions/theme_spacing.dart';
import '../../../presentation/widgets/semantic_concept_container.dart';
import '../../../presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import '../../../presentation/state/blocs/concept_selection/concept_selection_event.dart';
import '../../../presentation/state/blocs/concept_selection/concept_selection_state.dart';

/// Displays detailed information about a model and its concepts
class ModelDetailView extends StatefulWidget {
  /// The model to display
  final Model model;

  const ModelDetailView({super.key, required this.model});

  @override
  State<ModelDetailView> createState() => _ModelDetailViewState();
}

class _ModelDetailViewState extends State<ModelDetailView> {
  @override
  void initState() {
    super.initState();
    // Trigger concepts loading for this model
    context.read<ConceptSelectionBloc>().add(
      UpdateConceptsForModelEvent(widget.model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'ModelDetail',
      child: Padding(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Model header section
            _buildModelHeader(context),

            SizedBox(height: context.spacingL),

            // Concepts section
            _buildConceptsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildModelHeader(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'ModelHeader',
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.data_object,
                    size: 32,
                    color: context.conceptColor('Model', role: 'icon'),
                  ),
                  SizedBox(width: context.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.code,
                          style: context.conceptTextStyle(
                            'Model',
                            role: 'header',
                          ),
                        ),
                        SizedBox(height: context.spacingXs),
                        Text(
                          '${widget.model.concepts.length} concepts',
                          style: context.conceptTextStyle(
                            'Model',
                            role: 'subtitle',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.spacingM),

              // Model metadata
              _buildMetadataSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'ModelMetadata',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Model Properties',
            style: context.conceptTextStyle('ModelMetadata', role: 'title'),
          ),
          SizedBox(height: context.spacingS),
          _buildMetadataItem(context, 'Type', 'Model'),
          _buildMetadataItem(
            context,
            'Entry Concepts',
            _getEntryConceptsCount(),
          ),
          _buildMetadataItem(
            context,
            'Domain',
            widget.model.domain?.code ?? 'Unknown',
          ),
        ],
      ),
    );
  }

  String _getEntryConceptsCount() {
    int entryCount = 0;
    for (var concept in widget.model.concepts) {
      if (concept.entry) {
        entryCount++;
      }
    }
    return '$entryCount of ${widget.model.concepts.length}';
  }

  Widget _buildMetadataItem(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: context.conceptTextStyle('ModelMetadata', role: 'label'),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.conceptTextStyle('ModelMetadata', role: 'value'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptsSection(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ConceptSelectionBloc, ConceptSelectionState>(
        builder: (context, state) {
          if (state.availableConcepts.isEmpty) {
            return Center(
              child: Text(
                'No concepts available for this model',
                style: context.conceptTextStyle('Info'),
              ),
            );
          }

          return _buildConceptsList(context, state.availableConcepts.toList());
        },
      ),
    );
  }

  Widget _buildConceptsList(BuildContext context, List<Concept> concepts) {
    // Group concepts by entry and non-entry
    final entryConcepts = concepts.where((c) => c.entry).toList();
    final nonEntryConcepts = concepts.where((c) => !c.entry).toList();

    return SemanticConceptContainer(
      conceptType: 'ConceptList',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Concepts',
            style: context.conceptTextStyle('ConceptList', role: 'title'),
          ),
          SizedBox(height: context.spacingM),
          if (entryConcepts.isNotEmpty) ...[
            Text(
              'Entry Concepts',
              style: context.conceptTextStyle('ConceptList', role: 'subtitle'),
            ),
            SizedBox(height: context.spacingS),
            Expanded(
              flex: entryConcepts.length,
              child: ListView.builder(
                itemCount: entryConcepts.length,
                itemBuilder: (context, index) {
                  return _buildConceptCard(context, entryConcepts[index], true);
                },
              ),
            ),
          ],
          if (nonEntryConcepts.isNotEmpty) ...[
            if (entryConcepts.isNotEmpty) SizedBox(height: context.spacingM),
            Text(
              'Supporting Concepts',
              style: context.conceptTextStyle('ConceptList', role: 'subtitle'),
            ),
            SizedBox(height: context.spacingS),
            Expanded(
              flex: nonEntryConcepts.length,
              child: ListView.builder(
                itemCount: nonEntryConcepts.length,
                itemBuilder: (context, index) {
                  return _buildConceptCard(
                    context,
                    nonEntryConcepts[index],
                    false,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConceptCard(
    BuildContext context,
    Concept concept,
    bool isEntry,
  ) {
    return SemanticConceptContainer(
      conceptType: 'Concept',
      child: Card(
        margin: EdgeInsets.only(bottom: context.spacingS),
        child: InkWell(
          onTap: () => _selectConcept(context, concept),
          child: Padding(
            padding: EdgeInsets.all(context.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isEntry ? Icons.subject : Icons.schema,
                      color: context.conceptColor(
                        'Concept',
                        role: isEntry ? 'entry' : 'standard',
                      ),
                    ),
                    SizedBox(width: context.spacingS),
                    Expanded(
                      child: Text(
                        concept.code,
                        style: context.conceptTextStyle(
                          'Concept',
                          role: 'title',
                        ),
                      ),
                    ),
                    if (isEntry)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacingXs,
                          vertical: context.spacingXs / 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.conceptColor(
                            'Concept',
                            role: 'entryBadge',
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Entry',
                          style: context.conceptTextStyle(
                            'Concept',
                            role: 'badge',
                          ),
                        ),
                      ),
                  ],
                ),
                if (concept.attributes.isNotEmpty ||
                    concept.parents.isNotEmpty) ...[
                  SizedBox(height: context.spacingS),
                  Text(
                    _getConceptSummary(concept),
                    style: context.conceptTextStyle(
                      'Concept',
                      role: 'description',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getConceptSummary(Concept concept) {
    final List<String> summaryParts = [];

    if (concept.attributes.isNotEmpty) {
      summaryParts.add('${concept.attributes.length} attributes');
    }

    if (concept.parents.isNotEmpty) {
      summaryParts.add('${concept.parents.length} parents');
    }

    if (concept.children.isNotEmpty) {
      summaryParts.add('${concept.children.length} children');
    }

    return summaryParts.join(' • ');
  }

  void _selectConcept(BuildContext context, Concept concept) {
    context.read<ConceptSelectionBloc>().add(SelectConceptEvent(concept));

    // In a production app, you'd navigate to the concept detail page or
    // tell the shell to switch to the Concepts module
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected concept: ${concept.code}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
