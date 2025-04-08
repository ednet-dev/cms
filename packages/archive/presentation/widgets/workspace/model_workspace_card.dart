import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'immersive_workspace_container.dart';

/// A specialized immersive workspace for Model entities
///
/// This component displays a model as a card that can expand into a full
/// workspace with its concepts, attributes, and other model-related information.
class ModelWorkspaceCard extends StatelessWidget {
  /// The model to display
  final Model model;

  /// Callback when a concept is selected
  final Function(Concept)? onConceptSelected;

  /// Callback when the model workspace is expanded
  final VoidCallback? onExpand;

  /// Callback when the model workspace is collapsed
  final VoidCallback? onCollapse;

  /// Constructor for ModelWorkspaceCard
  const ModelWorkspaceCard({
    super.key,
    required this.model,
    this.onConceptSelected,
    this.onExpand,
    this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    // Count entry concepts
    final entryConceptCount = model.concepts.where((c) => c.entry).length;

    return ImmersiveWorkspaceContainer(
      conceptType: 'Model',
      title: model.code,
      subtitle: model.description ?? 'Model',
      icon: Icons.data_object,
      badgeText: '${model.concepts.length} concepts',
      heroTag: 'model-${model.code}',
      onExpand: onExpand,
      onCollapse: onCollapse,
      cardContent: _buildCardContent(context, entryConceptCount),
      workspaceContent: _buildWorkspaceContent(context),
    );
  }

  /// Build content for the card view (collapsed state)
  Widget _buildCardContent(BuildContext context, int entryConceptCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Model info
        Text(
          'Model Properties',
          style: context.conceptTextStyle('Model', role: 'sectionTitle'),
        ),
        const SizedBox(height: 8),

        // Properties table
        Table(
          columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
          children: [
            _buildTableRow(context, 'Type', 'Model'),
            _buildTableRow(context, 'Domain', model.domain?.code ?? 'Unknown'),
            _buildTableRow(
              context,
              'Entry Concepts',
              '$entryConceptCount of ${model.concepts.length}',
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Top concepts preview
        if (model.concepts.isNotEmpty) ...[
          Text(
            'Key Concepts',
            style: context.conceptTextStyle('Model', role: 'sectionTitle'),
          ),
          const SizedBox(height: 8),

          // Show up to 3 concepts, prioritizing entry concepts
          ..._getTopConcepts(model).take(3).map((concept) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    concept.entry ? Icons.star : Icons.category,
                    size: 16,
                    color:
                        concept.entry
                            ? Colors.amber
                            : context.conceptColor('Concept', role: 'icon'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    concept.code,
                    style: context.conceptTextStyle('Concept', role: 'title'),
                  ),
                  const Spacer(),
                  Text(
                    '${concept.attributes.length} attributes',
                    style: context.conceptTextStyle('Concept', role: 'badge'),
                  ),
                ],
              ),
            );
          }),

          // More indicator if there are more concepts
          if (model.concepts.length > 3)
            Text(
              'And ${model.concepts.length - 3} more...',
              style: context.conceptTextStyle('Model', role: 'meta'),
            ),
        ],
      ],
    );
  }

  /// Build content for the workspace view (expanded state)
  Widget _buildWorkspaceContent(BuildContext context) {
    // Organize concepts by type (entry vs regular)
    final entryConcepts = <Concept>[];
    final regularConcepts = <Concept>[];

    for (var concept in model.concepts) {
      if (concept.entry) {
        entryConcepts.add(concept);
      } else {
        regularConcepts.add(concept);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Model header with description
        Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Model Details',
                style: context.conceptTextStyle('Model', role: 'headerTitle'),
              ),
              if (model.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  model.description!,
                  style: context.conceptTextStyle('Model', role: 'description'),
                ),
              ],
            ],
          ),
        ),

        // Model properties
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacingM),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(context.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model Properties',
                    style: context.conceptTextStyle(
                      'Model',
                      role: 'sectionTitle',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      _buildTableRow(context, 'Type', 'Model'),
                      _buildTableRow(
                        context,
                        'Domain',
                        model.domain?.code ?? 'Unknown',
                      ),
                      _buildTableRow(
                        context,
                        'Concepts',
                        '${model.concepts.length}',
                      ),
                      _buildTableRow(
                        context,
                        'Entry Concepts',
                        '${entryConcepts.length}',
                      ),
                      _buildTableRow(context, 'ID', model.oid.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Concepts tabs
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.spacingM),
                  child: Row(
                    children: [
                      // Tab bar
                      const Expanded(
                        child: TabBar(
                          tabs: [
                            Tab(text: 'Entry Concepts'),
                            Tab(text: 'Supporting Concepts'),
                          ],
                        ),
                      ),

                      // Add button
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add Concept',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      // Entry concepts tab
                      entryConcepts.isEmpty
                          ? _buildEmptyState(
                            context,
                            'No entry concepts defined',
                          )
                          : _buildConceptsList(context, entryConcepts, true),

                      // Supporting concepts tab
                      regularConcepts.isEmpty
                          ? _buildEmptyState(
                            context,
                            'No supporting concepts defined',
                          )
                          : _buildConceptsList(context, regularConcepts, false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(BuildContext context, String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8),
          child: Text(
            label,
            style: context.conceptTextStyle('Model', role: 'propertyLabel'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            value,
            style: context.conceptTextStyle('Model', role: 'propertyValue'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: context
                .conceptColor('Concept', role: 'icon')
                .withValues(alpha: 255.0 * 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.conceptTextStyle('Model', role: 'emptyState'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Concept'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildConceptsList(
    BuildContext context,
    List<Concept> concepts,
    bool isEntry,
  ) {
    return ListView.builder(
      padding: EdgeInsets.all(context.spacingM),
      itemCount: concepts.length,
      itemBuilder: (context, index) {
        final concept = concepts[index];
        return _buildConceptItem(context, concept, isEntry);
      },
    );
  }

  Widget _buildConceptItem(
    BuildContext context,
    Concept concept,
    bool isEntry,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: context.spacingS),
      color:
          isEntry
              ? context
                  .conceptColor('Concept', role: 'entryBackground')
                  .withValues(alpha: 255.0 * 0.05)
              : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side:
            isEntry
                ? BorderSide(
                  color: context
                      .conceptColor('Concept', role: 'entryBorder')
                      .withValues(alpha: 255.0 * 0.3),
                  width: 1,
                )
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          if (onConceptSelected != null) {
            onConceptSelected!(concept);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
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
                      style: context.conceptTextStyle('Concept', role: 'title'),
                    ),
                  ),
                  if (isEntry)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacingS,
                        vertical: context.spacingXs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 255.0 * 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 255.0 * 0.3),
                        ),
                      ),
                      child: Text(
                        'Entry Point',
                        style: TextStyle(
                          color: Colors.amber.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: context.spacingS),
              _buildAttributesPreview(context, concept),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttributesPreview(BuildContext context, Concept concept) {
    if (concept.attributes.isEmpty) {
      return Text(
        'No attributes defined',
        style: context.conceptTextStyle('Concept', role: 'meta'),
      );
    }

    return Wrap(
      spacing: context.spacingS,
      runSpacing: context.spacingXs,
      children:
          concept.attributes.take(5).map((attribute) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacingS,
                vertical: context.spacingXs / 2,
              ),
              decoration: BoxDecoration(
                color: context
                    .conceptColor('Attribute', role: 'background')
                    .withValues(alpha: 255.0 * 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context
                      .conceptColor('Attribute', role: 'border')
                      .withValues(alpha: 255.0 * 0.2),
                ),
              ),
              child: Text(
                attribute.code,
                style: context.conceptTextStyle('Attribute', role: 'name'),
              ),
            );
          }).toList(),
    );
  }

  /// Get the top concepts from the model, prioritizing entry concepts
  List<Concept> _getTopConcepts(Model model) {
    final concepts = <Concept>[];

    // Add entry concepts first
    for (var concept in model.concepts) {
      if (concept.entry) {
        concepts.add(concept);
      }
    }

    // Add regular concepts next
    for (var concept in model.concepts) {
      if (!concept.entry) {
        concepts.add(concept);
      }
    }

    return concepts;
  }
}
