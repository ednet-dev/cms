import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart' as ednet;
import '../layout/responsive_semantic_wrapper.dart';

/// A responsive list of entities with semantic prioritization
class ResponsiveEntitiesList extends StatelessWidget {
  /// The entities to display
  final List<ednet.Entity> entities;

  /// Callback when an entity is selected
  final Function(ednet.Entity entity)? onEntitySelected;

  /// Callback when an entity is bookmarked
  final Function(ednet.Entity entity)? onEntityBookmarked;

  /// Show a grid layout instead of a list on larger screens
  final bool useGridOnLargeScreens;

  /// Grid column count for desktop and larger screens
  final int gridColumns;

  /// Constructor for ResponsiveEntitiesList
  const ResponsiveEntitiesList({
    super.key,
    required this.entities,
    this.onEntitySelected,
    this.onEntityBookmarked,
    this.useGridOnLargeScreens = true,
    this.gridColumns = 2,
  });

  @override
  Widget build(BuildContext context) {
    final screenCategory = ResponsiveSemanticWrapper.getScreenCategory(context);
    final isLargeScreen =
        screenCategory.index >= ScreenSizeCategory.desktop.index;

    // Group entities by their concept types for semantic organization
    final entityGroups = _groupEntitiesByConcept(entities);

    // For larger screens, optionally use a grid layout
    if (isLargeScreen && useGridOnLargeScreens) {
      return _buildGrid(context, entityGroups);
    }

    // Otherwise use a list layout
    return _buildList(context, entityGroups);
  }

  /// Build a grid layout for desktop+ screens
  Widget _buildGrid(
    BuildContext context,
    Map<String, List<ednet.Entity>> entityGroups,
  ) {
    return CustomScrollView(
      slivers: [
        for (final conceptCode in entityGroups.keys)
          SliverToBoxAdapter(
            child: ResponsiveSemanticWrapper(
              artifactId: 'entity_group_$conceptCode',
              modelCode: entityGroups[conceptCode]?.first.concept.model.code,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conceptCode,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: entityGroups[conceptCode]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final entity = entityGroups[conceptCode]![index];
                        return _buildEntityCard(context, entity);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Build a list layout for smaller screens
  Widget _buildList(
    BuildContext context,
    Map<String, List<ednet.Entity>> entityGroups,
  ) {
    return ListView.builder(
      itemCount: entityGroups.keys.length,
      itemBuilder: (context, groupIndex) {
        final conceptCode = entityGroups.keys.elementAt(groupIndex);
        final entitiesInGroup = entityGroups[conceptCode] ?? [];

        return ResponsiveSemanticWrapper(
          artifactId: 'entity_group_$conceptCode',
          modelCode:
              entitiesInGroup.isNotEmpty
                  ? entitiesInGroup.first.concept.model.code
                  : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  conceptCode,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entitiesInGroup.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entity = entitiesInGroup[index];
                  return _buildEntityListItem(context, entity);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build a card for an entity in grid view
  Widget _buildEntityCard(BuildContext context, ednet.Entity entity) {
    final theme = Theme.of(context);

    // Create a unique ID for this entity
    final String artifactId = 'entity_${entity.concept.code}_${entity.oid}';
    final String modelCode = entity.concept.model.code;

    return ResponsiveSemanticWrapper(
      artifactId: artifactId,
      modelCode: modelCode,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap:
              onEntitySelected != null ? () => onEntitySelected!(entity) : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Entity title
                Text(
                  _getEntityDisplayName(entity),
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Entity attributes (limited)
                Expanded(child: _buildLimitedAttributes(context, entity)),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEntityBookmarked != null)
                      IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () => onEntityBookmarked!(entity),
                        tooltip: 'Bookmark',
                      ),
                    if (onEntitySelected != null)
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => onEntitySelected!(entity),
                        tooltip: 'View Details',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build a list item for an entity
  Widget _buildEntityListItem(BuildContext context, ednet.Entity entity) {
    // Create a unique ID for this entity
    final String artifactId = 'entity_${entity.concept.code}_${entity.oid}';
    final String modelCode = entity.concept.model.code;

    return ResponsiveSemanticWrapper(
      artifactId: artifactId,
      modelCode: modelCode,
      child: ListTile(
        title: Text(_getEntityDisplayName(entity)),
        subtitle: Text(entity.concept.code),
        onTap:
            onEntitySelected != null ? () => onEntitySelected!(entity) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEntityBookmarked != null)
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () => onEntityBookmarked!(entity),
                tooltip: 'Bookmark',
              ),
            if (onEntitySelected != null)
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => onEntitySelected!(entity),
                tooltip: 'View Details',
              ),
          ],
        ),
      ),
    );
  }

  /// Build a limited set of attributes for card view
  Widget _buildLimitedAttributes(BuildContext context, ednet.Entity entity) {
    final attributes = entity.concept.attributes;

    // Group attributes by priority
    final prioritizedAttributes = <SemanticPriority, List<ednet.Attribute>>{};
    for (final priority in SemanticPriority.values) {
      prioritizedAttributes[priority] = [];
    }

    for (final attr in attributes) {
      // Use extension on Attribute to get semantic priority
      if (attr is ednet.Attribute) {
        final priority = attr.semanticPriority;
        prioritizedAttributes[priority]!.add(attr);
      }
    }

    // Show critical and important attributes first, limited to 3 total
    final criticalAttrs = prioritizedAttributes[SemanticPriority.critical]!;
    final importantAttrs = prioritizedAttributes[SemanticPriority.important]!;

    final displayAttrs = [...criticalAttrs, ...importantAttrs].take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          displayAttrs
              .map((attr) => _buildAttributePreview(context, entity, attr))
              .toList(),
    );
  }

  /// Build a preview of an attribute value
  Widget _buildAttributePreview(
    BuildContext context,
    ednet.Entity entity,
    ednet.Attribute attribute,
  ) {
    final theme = Theme.of(context);
    final value = entity.getAttribute(attribute.code);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${attribute.code}: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not set',
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Get a display name for an entity using its identifier attribute if available
  String _getEntityDisplayName(ednet.Entity entity) {
    // Try to find identifier attribute
    for (final attr in entity.concept.attributes) {
      if (attr.identifier == true) {
        final value = entity.getAttribute(attr.code);
        if (value != null) {
          return value.toString();
        }
      }
    }

    // If no identifier, use the OID or name attribute
    final nameValue = entity.getAttribute('name');
    if (nameValue != null) {
      return nameValue.toString();
    }

    // Last resort is OID or concept code
    return '${entity.concept.code} ${entity.oid}';
  }

  /// Group entities by their concept types
  Map<String, List<ednet.Entity>> _groupEntitiesByConcept(
    List<ednet.Entity> entities,
  ) {
    final result = <String, List<ednet.Entity>>{};

    for (final entity in entities) {
      final conceptCode = entity.concept.code;
      if (!result.containsKey(conceptCode)) {
        result[conceptCode] = [];
      }
      result[conceptCode]!.add(entity);
    }

    return result;
  }
}
