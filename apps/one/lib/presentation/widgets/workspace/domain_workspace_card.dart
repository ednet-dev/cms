import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'immersive_workspace_container.dart';

/// A specialized immersive workspace for Domain entities
///
/// This component displays a domain as a card that can expand into a full
/// workspace with models, concepts, and other domain-related information.
class DomainWorkspaceCard extends StatelessWidget {
  /// The domain to display
  final Domain domain;

  /// Callback when a model is selected
  final Function(Model)? onModelSelected;

  /// Callback when the domain workspace is expanded
  final VoidCallback? onExpand;

  /// Callback when the domain workspace is collapsed
  final VoidCallback? onCollapse;

  /// Constructor for DomainWorkspaceCard
  const DomainWorkspaceCard({
    super.key,
    required this.domain,
    this.onModelSelected,
    this.onExpand,
    this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return ImmersiveWorkspaceContainer(
      conceptType: 'Domain',
      title: domain.code,
      subtitle: domain.description ?? 'Domain',
      icon: Icons.domain,
      badgeText: '${domain.models.length} models',
      heroTag: 'domain-${domain.code}',
      onExpand: onExpand,
      onCollapse: onCollapse,
      cardContent: _buildCardContent(context),
      workspaceContent: _buildWorkspaceContent(context),
    );
  }

  /// Build content for the card view (collapsed state)
  Widget _buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Domain info
        Text(
          'Domain Properties',
          style: context.conceptTextStyle('Domain', role: 'sectionTitle'),
        ),
        const SizedBox(height: 8),

        // Properties table
        Table(
          columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
          children: [
            _buildTableRow(context, 'Type', 'Domain'),
            _buildTableRow(context, 'Created', 'N/A'),
            _buildTableRow(context, 'Last Modified', 'N/A'),
          ],
        ),

        const SizedBox(height: 16),

        // Top models preview
        if (domain.models.isNotEmpty) ...[
          Text(
            'Top Models',
            style: context.conceptTextStyle('Domain', role: 'sectionTitle'),
          ),
          const SizedBox(height: 8),

          // Show up to 3 models
          ...domain.models.take(3).map((model) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.data_object,
                    size: 16,
                    color: context.conceptColor('Model', role: 'icon'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    model.code,
                    style: context.conceptTextStyle('Model', role: 'title'),
                  ),
                  const Spacer(),
                  Text(
                    '${model.concepts.length} concepts',
                    style: context.conceptTextStyle('Model', role: 'badge'),
                  ),
                ],
              ),
            );
          }),

          // More indicator if there are more models
          if (domain.models.length > 3)
            Text(
              'And ${domain.models.length - 3} more...',
              style: context.conceptTextStyle('Domain', role: 'meta'),
            ),
        ],
      ],
    );
  }

  /// Build content for the workspace view (expanded state)
  Widget _buildWorkspaceContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Domain header with description
        Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Domain Details',
                style: context.conceptTextStyle('Domain', role: 'headerTitle'),
              ),
              if (domain.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  domain.description!,
                  style: context.conceptTextStyle(
                    'Domain',
                    role: 'description',
                  ),
                ),
              ],
            ],
          ),
        ),

        // Domain properties
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacingM),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(context.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Domain Properties',
                    style: context.conceptTextStyle(
                      'Domain',
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
                      _buildTableRow(context, 'Type', 'Domain'),
                      _buildTableRow(context, 'Created', 'N/A'),
                      _buildTableRow(context, 'Last Modified', 'N/A'),
                      _buildTableRow(
                        context,
                        'Models',
                        '${domain.models.length}',
                      ),
                      _buildTableRow(context, 'ID', domain.oid.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Models list header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacingM),
          child: Row(
            children: [
              Text(
                'Models',
                style: context.conceptTextStyle('Domain', role: 'headerTitle'),
              ),
              const Spacer(),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Model'),
                onPressed: () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Models list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: context.spacingM),
            itemCount: domain.models.length,
            itemBuilder: (context, index) {
              final model = domain.models.elementAt(index);
              return _buildModelItem(context, model);
            },
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
            style: context.conceptTextStyle('Domain', role: 'propertyLabel'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            value,
            style: context.conceptTextStyle('Domain', role: 'propertyValue'),
          ),
        ),
      ],
    );
  }

  Widget _buildModelItem(BuildContext context, Model model) {
    return Card(
      margin: EdgeInsets.only(bottom: context.spacingS),
      child: InkWell(
        onTap: () {
          if (onModelSelected != null) {
            onModelSelected!(model);
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
                    Icons.data_object,
                    color: context.conceptColor('Model', role: 'icon'),
                  ),
                  SizedBox(width: context.spacingS),
                  Expanded(
                    child: Text(
                      model.code,
                      style: context.conceptTextStyle('Model', role: 'title'),
                    ),
                  ),
                  Text(
                    '${model.concepts.length} concepts',
                    style: context.conceptTextStyle('Model', role: 'badge'),
                  ),
                ],
              ),
              if (model.description != null) ...[
                SizedBox(height: context.spacingS),
                Text(
                  model.description!,
                  style: context.conceptTextStyle('Model', role: 'description'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: context.spacingS),
              if (model.concepts.isNotEmpty) ...[
                Text(
                  'Concepts: ${_getTopConceptNames(model).join(", ")}',
                  style: context.conceptTextStyle('Model', role: 'meta'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Get the names of the top 3 concepts
  List<String> _getTopConceptNames(Model model) {
    final conceptNames = <String>[];

    // Get entry concepts first
    for (var concept in model.concepts) {
      if (concept.entry && conceptNames.length < 3) {
        conceptNames.add(concept.code);
      }
    }

    // If we don't have 3 yet, add non-entry concepts
    if (conceptNames.length < 3) {
      for (var concept in model.concepts) {
        if (!concept.entry && conceptNames.length < 3) {
          conceptNames.add(concept.code);
        }
      }
    }

    return conceptNames;
  }
}
