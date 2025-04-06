import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import 'entity_widget.dart';

/// A component for navigating between related entities
class RelationshipNavigator extends StatefulWidget {
  /// The current entity being displayed
  final Entity currentEntity;

  /// Optional navigation history (path of entities leading to current)
  final List<Entity>? navigationHistory;

  /// Callback when an entity is selected for navigation
  final void Function(Entity entity) onEntitySelected;

  /// Whether to show a compact version of the navigator
  final bool compact;

  /// Constructor
  const RelationshipNavigator({
    super.key,
    required this.currentEntity,
    this.navigationHistory,
    required this.onEntitySelected,
    this.compact = false,
  });

  @override
  State<RelationshipNavigator> createState() => _RelationshipNavigatorState();
}

class _RelationshipNavigatorState extends State<RelationshipNavigator> {
  late List<Entity> _navigationHistory;
  late Entity _currentEntity;
  bool _isExpanded = false;
  final Map<String, bool> _expandedSections = {};

  @override
  void initState() {
    super.initState();
    _currentEntity = widget.currentEntity;
    _navigationHistory = widget.navigationHistory ?? [];
    if (!_navigationHistory.contains(_currentEntity)) {
      _navigationHistory = [..._navigationHistory, _currentEntity];
    }
  }

  @override
  void didUpdateWidget(RelationshipNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentEntity != widget.currentEntity) {
      _currentEntity = widget.currentEntity;
      if (widget.navigationHistory != null) {
        _navigationHistory = widget.navigationHistory!;
      } else if (!_navigationHistory.contains(_currentEntity)) {
        _navigationHistory = [..._navigationHistory, _currentEntity];
      }
    }
  }

  // Helper to get all parent relationships
  List<_RelationshipInfo> _getParentRelationships() {
    final relationships = <_RelationshipInfo>[];

    try {
      for (final parent in _currentEntity.concept.parents.whereType<Parent>()) {
        final parentEntity = _currentEntity.getParent(parent.code);
        relationships.add(
          _RelationshipInfo(
            name: parent.code,
            direction: _RelationshipDirection.parent,
            entity: parentEntity as Entity?,
            required: parent.required,
            identifier: parent.identifier,
            maxCount: parent.maxc,
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions when accessing parents
    }

    // Sort relationships: required first, then identifier, then alphabetically
    relationships.sort((a, b) {
      if (a.required != b.required) {
        return a.required ? -1 : 1;
      }
      if (a.identifier != b.identifier) {
        return a.identifier ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });

    return relationships;
  }

  // Helper to get all child relationships
  List<_RelationshipInfo> _getChildRelationships() {
    final relationships = <_RelationshipInfo>[];

    try {
      for (final child in _currentEntity.concept.children.whereType<Child>()) {
        final childEntities = _currentEntity.getChild(child.code) as Entities?;
        relationships.add(
          _RelationshipInfo(
            name: child.code,
            direction: _RelationshipDirection.child,
            entityCollection: childEntities,
            count: childEntities?.length ?? 0,
            maxCount: child.maxc,
            internal: child.internal,
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions when accessing children
    }

    // Sort relationships: internal first, then by name
    relationships.sort((a, b) {
      if (a.internal != b.internal) {
        return a.internal ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });

    return relationships;
  }

  @override
  Widget build(BuildContext context) {
    return widget.compact
        ? _buildCompactNavigator(context)
        : _buildFullNavigator(context);
  }

  // Build compact version (breadcrumbs only)
  Widget _buildCompactNavigator(BuildContext context) {
    return _buildBreadcrumbTrail(context);
  }

  // Build full navigator with breadcrumbs and relationship navigation
  Widget _buildFullNavigator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb navigation
        _buildBreadcrumbTrail(context),

        // Divider
        Divider(color: colorScheme.outlineVariant, height: 24),

        // Relationship content
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Relationships',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_isExpanded) ...[
          // Parent relationships section
          ..._buildParentRelationships(context),

          const SizedBox(height: 16),

          // Child relationships section
          ..._buildChildRelationships(context),
        ],
      ],
    );
  }

  // Build breadcrumb navigation trail
  Widget _buildBreadcrumbTrail(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            for (int i = 0; i < _navigationHistory.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              InkWell(
                onTap:
                    i < _navigationHistory.length - 1
                        ? () {
                          final selectedEntity = _navigationHistory[i];
                          // Navigate to this entity and truncate history
                          widget.onEntitySelected(selectedEntity);
                          setState(() {
                            _navigationHistory = _navigationHistory.sublist(
                              0,
                              i + 1,
                            );
                          });
                        }
                        : null,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForEntityType(
                          _navigationHistory[i].concept.code,
                        ),
                        size: 16,
                        color:
                            i == _navigationHistory.length - 1
                                ? colorScheme.primary
                                : colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        EntityTitleUtils.getTitle(_navigationHistory[i]),
                        style:
                            i == _navigationHistory.length - 1
                                ? theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                )
                                : theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Build parent relationships section
  List<Widget> _buildParentRelationships(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final parentRelationships = _getParentRelationships();
    if (parentRelationships.isEmpty) {
      return [];
    }

    return [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: Text(
          'Parent References',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              parentRelationships.map((relationship) {
                // Create a parent relationship chip
                return _buildRelationshipChip(
                  context,
                  relationship,
                  onTap:
                      relationship.entity != null
                          ? () {
                            // Navigate to parent entity
                            widget.onEntitySelected(relationship.entity!);
                            setState(() {
                              _navigationHistory = [
                                ..._navigationHistory,
                                relationship.entity!,
                              ];
                            });
                          }
                          : null,
                );
              }).toList(),
        ),
      ),
    ];
  }

  // Build child relationships section
  List<Widget> _buildChildRelationships(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final childRelationships = _getChildRelationships();
    if (childRelationships.isEmpty) {
      return [];
    }

    // Try to access the _expandedSections for each relationship
    for (final relationship in childRelationships) {
      if (!_expandedSections.containsKey(relationship.name)) {
        _expandedSections[relationship.name] = false;
      }
    }

    return [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
        child: Text(
          'Child Collections',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 8),
      ...childRelationships.map((relationship) {
        final expanded = _expandedSections[relationship.name] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Collection header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: InkWell(
                onTap:
                    relationship.count > 0
                        ? () {
                          setState(() {
                            _expandedSections[relationship.name] = !expanded;
                          });
                        }
                        : null,
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    if (relationship.count > 0)
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      )
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 4),
                    // Collection info
                    Expanded(
                      child: _buildRelationshipChip(context, relationship),
                    ),
                  ],
                ),
              ),
            ),

            // Expanded collection preview
            if (expanded && relationship.entityCollection != null)
              Padding(
                padding: const EdgeInsets.only(left: 36.0, right: 16.0),
                child:
                    relationship.entityCollection!.isEmpty
                        ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            'No entities in this collection',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withOpacity(
                                0.7,
                              ),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show up to 5 child entities
                            for (
                              int i = 0;
                              i < relationship.entityCollection!.length &&
                                  i < 5;
                              i++
                            )
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    final entity = relationship
                                        .entityCollection!
                                        .elementAt(i);
                                    // Navigate to child entity
                                    widget.onEntitySelected(entity as Entity);
                                    setState(() {
                                      _navigationHistory = [
                                        ..._navigationHistory,
                                        entity,
                                      ];
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 8.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getIconForEntityType(
                                            (relationship.entityCollection!
                                                        .elementAt(i)
                                                    as Entity)
                                                .concept
                                                .code,
                                          ),
                                          size: 14,
                                          color: colorScheme.primary
                                              .withOpacity(0.7),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            EntityTitleUtils.getTitle(
                                              relationship.entityCollection!
                                                      .elementAt(i)
                                                  as Entity,
                                            ),
                                            style: theme.textTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            // "Show more" button if there are more than 5 entities
                            if (relationship.entityCollection!.length > 5)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  left: 8.0,
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    // TODO: Implement view all dialog or navigation
                                  },
                                  icon: Icon(
                                    Icons.more_horiz,
                                    size: 16,
                                    color: colorScheme.primary,
                                  ),
                                  label: Text(
                                    'Show all ${relationship.entityCollection!.length} items',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ),
                          ],
                        ),
              ),
          ],
        );
      }),
    ];
  }

  // Build a relationship chip
  Widget _buildRelationshipChip(
    BuildContext context,
    _RelationshipInfo relationship, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine chip color based on relationship type
    final bool isParent =
        relationship.direction == _RelationshipDirection.parent;
    final bool hasValue =
        isParent ? relationship.entity != null : relationship.count > 0;

    // For parent relationships
    if (isParent) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:
                hasValue
                    ? relationship.identifier
                        ? colorScheme.primaryContainer.withOpacity(0.7)
                        : colorScheme.secondaryContainer.withOpacity(0.5)
                    : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  hasValue
                      ? relationship.identifier
                          ? colorScheme.primary.withOpacity(0.5)
                          : colorScheme.secondary.withOpacity(0.3)
                      : colorScheme.outlineVariant,
              width: relationship.required ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_upward,
                size: 14,
                color:
                    hasValue
                        ? relationship.identifier
                            ? colorScheme.primary
                            : colorScheme.secondary
                        : colorScheme.outline,
              ),
              const SizedBox(width: 6),
              Text(
                relationship.name,
                style: theme.textTheme.labelMedium?.copyWith(
                  color:
                      hasValue
                          ? relationship.identifier
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSecondaryContainer
                          : colorScheme.onSurfaceVariant,
                  fontWeight: relationship.required ? FontWeight.w600 : null,
                ),
              ),
              if (hasValue) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    relationship.entity != null
                        ? EntityTitleUtils.getTitle(relationship.entity!)
                        : 'None',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ] else if (relationship.required) ...[
                const SizedBox(width: 4),
                Icon(Icons.warning_amber, size: 14, color: Colors.amber),
              ],
            ],
          ),
        ),
      );
    }

    // For child relationships
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            hasValue
                ? relationship.internal
                    ? colorScheme.tertiaryContainer.withOpacity(0.5)
                    : colorScheme.secondaryContainer.withOpacity(0.3)
                : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              hasValue
                  ? relationship.internal
                      ? colorScheme.tertiary.withOpacity(0.3)
                      : colorScheme.secondary.withOpacity(0.2)
                  : colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_downward,
            size: 14,
            color:
                hasValue
                    ? relationship.internal
                        ? colorScheme.tertiary
                        : colorScheme.secondary
                    : colorScheme.outline,
          ),
          const SizedBox(width: 6),
          Text(
            relationship.name,
            style: theme.textTheme.labelMedium?.copyWith(
              color:
                  hasValue
                      ? relationship.internal
                          ? colorScheme.onTertiaryContainer
                          : colorScheme.onSecondaryContainer
                      : colorScheme.onSurfaceVariant,
            ),
          ),
          if (hasValue) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                relationship.count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Helper method to get an appropriate icon based on entity type
  IconData _getIconForEntityType(String type) {
    // Map common entity types to appropriate icons
    switch (type.toLowerCase()) {
      case 'user':
      case 'person':
      case 'customer':
      case 'employee':
        return Icons.person;
      case 'product':
      case 'item':
        return Icons.shopping_bag;
      case 'project':
      case 'task':
        return Icons.assignment;
      case 'document':
      case 'file':
        return Icons.description;
      case 'message':
      case 'comment':
        return Icons.message;
      case 'event':
      case 'meeting':
        return Icons.event;
      case 'location':
      case 'place':
        return Icons.location_on;
      case 'organization':
      case 'company':
        return Icons.business;
      case 'role':
        return Icons.assignment_ind;
      case 'status':
        return Icons.info;
      case 'theme':
        return Icons.palette;
      case 'application':
        return Icons.apps;
      case 'model':
        return Icons.schema;
      case 'concept':
        return Icons.category;
      case 'domain':
        return Icons.domain;
      default:
        return Icons.data_object;
    }
  }
}

/// Direction of a relationship
enum _RelationshipDirection { parent, child }

/// Information about a relationship (parent or child)
class _RelationshipInfo {
  final String name;
  final _RelationshipDirection direction;
  final Entity? entity;
  final Entities? entityCollection;
  final int count;
  final String maxCount;
  final bool required;
  final bool identifier;
  final bool internal;

  _RelationshipInfo({
    required this.name,
    required this.direction,
    this.entity,
    this.entityCollection,
    this.count = 0,
    this.maxCount = 'N',
    this.required = false,
    this.identifier = false,
    this.internal = false,
  });
}
