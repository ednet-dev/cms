import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/domain/repositories/entity_repository.dart';
import 'package:ednet_one/main.dart'; // Import main.dart to access global variables
import 'package:ednet_one/presentation/state/blocs/entity/entity_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_event.dart';
import 'package:ednet_one/presentation/state/blocs/entity/entity_state.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/widgets/entity/entity_dialog.dart';
import 'immersive_workspace_container.dart';

/// A specialized immersive workspace for Concept entities
///
/// This component displays a concept as a card that can expand into a full
/// workspace with its attributes, relationships, and instances.
class ConceptWorkspaceCard extends StatelessWidget {
  /// The concept to display
  final Concept concept;

  /// Optional list of entity instances for this concept
  final List<Entity<dynamic>>? entities;

  /// Callback when an entity is selected
  final Function(Entity<dynamic>)? onEntitySelected;

  /// Callback when the concept workspace is expanded
  final VoidCallback? onExpand;

  /// Callback when the concept workspace is collapsed
  final VoidCallback? onCollapse;

  /// Constructor for ConceptWorkspaceCard
  const ConceptWorkspaceCard({
    super.key,
    required this.concept,
    this.entities,
    this.onEntitySelected,
    this.onExpand,
    this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final isEntry = concept.entry;
    final attributeCount = concept.attributes.length;
    final entityCount = entities?.length ?? 0;

    return ImmersiveWorkspaceContainer(
      conceptType: 'Concept',
      title: concept.code,
      subtitle: isEntry ? 'Entry Point' : 'Supporting Concept',
      icon: isEntry ? Icons.star : Icons.category,
      badgeText: '$attributeCount attributes',
      heroTag: 'concept-${concept.code}',
      onExpand: onExpand,
      onCollapse: onCollapse,
      cardContent: _buildCardContent(context, isEntry, entityCount),
      workspaceContent: BlocProvider(
        create: (context) => EntityBloc(repository: entityRepository),
        child: Builder(
          builder:
              (context) => _buildWorkspaceContent(
                context,
                isEntry,
                entityCount,
                oneApplication,
              ),
        ),
      ),
    );
  }

  /// Build content for the card view (collapsed state)
  Widget _buildCardContent(
    BuildContext context,
    bool isEntry,
    int entityCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Concept type
        if (isEntry)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacingS,
              vertical: context.spacingXs / 2,
            ),
            margin: EdgeInsets.only(bottom: context.spacingS),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 255.0 * 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.amber.withValues(alpha: 255.0 * 0.3),
              ),
            ),
            child: Text(
              'Entry Point Concept',
              style: TextStyle(
                color: Colors.amber.shade800,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // Concept info
        Text(
          'Concept Properties',
          style: context.conceptTextStyle('Concept', role: 'sectionTitle'),
        ),
        const SizedBox(height: 8),

        // Properties table
        Table(
          columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
          children: [
            _buildTableRow(context, 'Type', 'Concept'),
            _buildTableRow(context, 'Entry', isEntry ? 'Yes' : 'No'),
            _buildTableRow(
              context,
              'Attributes',
              '${concept.attributes.length}',
            ),
            if (entityCount > 0)
              _buildTableRow(context, 'Entities', '$entityCount'),
          ],
        ),

        const SizedBox(height: 16),

        // Top attributes preview
        if (concept.attributes.isNotEmpty) ...[
          Text(
            'Attributes',
            style: context.conceptTextStyle('Concept', role: 'sectionTitle'),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: context.spacingS,
            runSpacing: context.spacingXs,
            children:
                concept.attributes.take(5).map((property) {
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
                      property.code,
                      style: context.conceptTextStyle(
                        'Attribute',
                        role: 'name',
                      ),
                    ),
                  );
                }).toList(),
          ),

          // More indicator if there are more attributes
          if (concept.attributes.length > 5)
            Padding(
              padding: EdgeInsets.only(top: context.spacingXs),
              child: Text(
                'And ${concept.attributes.length - 5} more...',
                style: context.conceptTextStyle('Concept', role: 'meta'),
              ),
            ),
        ],
      ],
    );
  }

  /// Build content for the workspace view (expanded state)
  Widget _buildWorkspaceContent(
    BuildContext context,
    bool isEntry,
    int entityCount,
    OneApplication app,
  ) {
    // Get the current domain and model
    final domain = concept.model?.domain;
    final model = concept.model;

    if (domain == null || model == null) {
      return Center(
        child: Text(
          'Concept is not properly linked to a domain and model',
          style: context.conceptTextStyle('Error', role: 'message'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Concept header with description
        Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Concept Details',
                    style: context.conceptTextStyle(
                      'Concept',
                      role: 'headerTitle',
                    ),
                  ),
                  const SizedBox(width: 16),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            'Entry Point',
                            style: TextStyle(
                              color: Colors.amber.shade800,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Concept properties
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacingM),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(context.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Concept Properties',
                    style: context.conceptTextStyle(
                      'Concept',
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
                      _buildTableRow(context, 'Type', 'Concept'),
                      _buildTableRow(context, 'Entry', isEntry ? 'Yes' : 'No'),
                      _buildTableRow(
                        context,
                        'Model',
                        concept.model?.code ?? 'Unknown',
                      ),
                      _buildTableRow(
                        context,
                        'Attributes',
                        '${concept.attributes.length}',
                      ),
                      if (concept.parents.isNotEmpty)
                        _buildTableRow(
                          context,
                          'Parents',
                          concept.parents.map((p) => p.code).join(', '),
                        ),
                      if (entityCount > 0)
                        _buildTableRow(context, 'Entities', '$entityCount'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Tab navigation
        Expanded(
          child: DefaultTabController(
            length: isEntry ? 3 : 2,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.spacingM),
                  child: TabBar(
                    tabs: [
                      const Tab(text: 'Attributes'),
                      const Tab(text: 'Relationships'),
                      if (isEntry) const Tab(text: 'Entities'),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      // Attributes tab
                      _buildAttributesTab(context),

                      // Relationships tab
                      _buildRelationshipsTab(context),

                      // Entities tab (only for entry concepts)
                      if (isEntry)
                        _buildEntitiesTabWithDataBinding(
                          context,
                          domain,
                          model,
                          app,
                        ),
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
            style: context.conceptTextStyle('Concept', role: 'propertyLabel'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            value,
            style: context.conceptTextStyle('Concept', role: 'propertyValue'),
          ),
        ),
      ],
    );
  }

  Widget _buildAttributesTab(BuildContext context) {
    if (concept.attributes.isEmpty) {
      return _buildEmptyState(
        context,
        'No attributes defined',
        'Add Attribute',
        Icons.add_circle_outline,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(context.spacingM),
      itemCount: concept.attributes.length,
      itemBuilder: (context, index) {
        final property = concept.attributes.elementAt(index);
        return _buildPropertyItem(context, property, index);
      },
    );
  }

  Widget _buildPropertyItem(
    BuildContext context,
    Property property,
    int index,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: context.spacingS),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.conceptColor(
            'Attribute',
            role: 'background',
          ),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: context.conceptColor('Attribute', role: 'foreground'),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          property.code,
          style: context.conceptTextStyle('Attribute', role: 'title'),
        ),
        subtitle: Text(
          'Type: ${property.type ?? 'String'}',
          style: context.conceptTextStyle('Attribute', role: 'subtitle'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (property.required ?? false)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacingS,
                  vertical: context.spacingXs / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 255.0 * 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 255.0 * 0.3),
                  ),
                ),
                child: Text(
                  'Required',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipsTab(BuildContext context) {
    return _buildEmptyState(
      context,
      'No relationships defined',
      'Add Relationship',
      Icons.add_link,
    );
  }

  /// Builds the entities tab with data binding
  Widget _buildEntitiesTabWithDataBinding(
    BuildContext context,
    Domain domain,
    Model model,
    OneApplication app,
  ) {
    return BlocConsumer<EntityBloc, EntityState>(
      listener: (context, state) {
        // Handle state changes if needed
      },
      builder: (context, state) {
        if (state.status == EntityStatus.initial) {
          // Load entities on first build
          context.read<EntityBloc>().add(
            LoadEntitiesEvent(domain: domain, model: model, concept: concept),
          );
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == EntityStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == EntityStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: context.conceptColor('Error', role: 'icon'),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'Failed to load entities',
                  style: context.conceptTextStyle('Error', role: 'message'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Retry loading entities
                    context.read<EntityBloc>().add(
                      LoadEntitiesEvent(
                        domain: domain,
                        model: model,
                        concept: concept,
                      ),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.entities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory,
                  size: 64,
                  color: context
                      .conceptColor('Concept', role: 'icon')
                      .withValues(alpha: 255.0 * 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No entities found',
                  style: context.conceptTextStyle(
                    'Concept',
                    role: 'emptyState',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create Entity'),
                  onPressed:
                      () => _showEntityDialog(context, domain, model, app),
                ),
              ],
            ),
          );
        }

        // Show entities list
        return Stack(
          children: [
            // Entities list
            ListView.builder(
              padding: EdgeInsets.all(context.spacingM),
              itemCount: state.entities.length,
              itemBuilder: (context, index) {
                final entity = state.entities[index];
                return _buildEntityItemWithActions(
                  context,
                  entity,
                  domain,
                  model,
                  app,
                );
              },
            ),

            // Floating action button for adding new entities
            Positioned(
              right: context.spacingM,
              bottom: context.spacingM,
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _showEntityDialog(context, domain, model, app),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build an entity item with edit and delete actions
  Widget _buildEntityItemWithActions(
    BuildContext context,
    Entity<dynamic> entity,
    Domain domain,
    Model model,
    OneApplication app,
  ) {
    // Extract entity fields based on concept attributes
    final Map<String, dynamic> entityData = {};
    for (final property in concept.attributes) {
      try {
        entityData[property.code] = entity.getAttribute(property.code);
      } catch (e) {
        entityData[property.code] = 'N/A';
      }
    }

    return Card(
      margin: EdgeInsets.only(bottom: context.spacingS),
      child: InkWell(
        onTap: () {
          if (onEntitySelected != null) {
            onEntitySelected!(entity);
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
                    Icons.category,
                    color: context.conceptColor('Entity', role: 'icon'),
                  ),
                  SizedBox(width: context.spacingS),
                  Expanded(
                    child: Text(
                      'Entity ${entity.oid}',
                      style: context.conceptTextStyle('Entity', role: 'title'),
                    ),
                  ),
                  // Edit button
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed:
                        () => _showEntityDialog(
                          context,
                          domain,
                          model,
                          app,
                          entity: entity,
                        ),
                  ),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed:
                        () => _showDeleteDialog(context, entity, domain, model),
                  ),
                ],
              ),
              const Divider(),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: entityData.length > 4 ? 4 : entityData.length,
                itemBuilder: (context, index) {
                  final entry = entityData.entries.elementAt(index);
                  return _buildEntityAttribute(
                    context,
                    entry.key,
                    entry.value.toString(),
                  );
                },
              ),
              if (entityData.length > 4) ...[
                const Divider(),
                Text(
                  'And ${entityData.length - 4} more attributes...',
                  style: context.conceptTextStyle('Entity', role: 'meta'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Show dialog for creating/editing an entity
  Future<void> _showEntityDialog(
    BuildContext context,
    Domain domain,
    Model model,
    OneApplication app, {
    Entity<dynamic>? entity,
  }) async {
    final result = await EntityDialog.show(
      context: context,
      concept: concept,
      domain: domain,
      model: model,
      app: app,
      entity: entity,
    );

    if (result == true) {
      // Refresh entities list
      if (!context.mounted) return;

      context.read<EntityBloc>().add(
        LoadEntitiesEvent(domain: domain, model: model, concept: concept),
      );
    }
  }

  /// Show confirmation dialog for deleting an entity
  Future<void> _showDeleteDialog(
    BuildContext context,
    Entity<dynamic> entity,
    Domain domain,
    Model model,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete this ${concept.code}?',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;

      // Delete the entity
      context.read<EntityBloc>().add(
        DeleteEntityEvent(
          domain: domain,
          model: model,
          concept: concept,
          entity: entity,
        ),
      );
    }
  }

  Widget _buildEntityAttribute(
    BuildContext context,
    String name,
    String value,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: context.conceptTextStyle('Entity', role: 'attributeName'),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Text(': '),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: context.conceptTextStyle('Entity', role: 'attributeValue'),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String message,
    String buttonText,
    IconData icon,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: context
                .conceptColor('Concept', role: 'icon')
                .withValues(alpha: 255.0 * 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.conceptTextStyle('Concept', role: 'emptyState'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: Icon(icon),
            label: Text(buttonText),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
