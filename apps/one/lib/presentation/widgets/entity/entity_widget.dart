import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'entity_actions.dart';
import 'entity_attributes.dart';
import 'entity_header.dart';
import 'entity_relationships.dart';

/// A utility class for extracting entity titles from an Entity
class EntityTitleUtils {
  /// Get a display title for an entity
  static String getTitle(Entity entity) {
    if (entity.getAttribute('firstName') != null) {
      if (entity.getAttribute('lastName') != null) {
        return '${entity.getAttribute('firstName')} ${entity.getAttribute('lastName')}';
      }
      return entity.getAttribute('firstName').toString();
    }

    if (entity.getAttribute('name') != null) {
      return entity.getAttribute('name').toString();
    }

    if (entity.getAttribute('title') != null) {
      return entity.getAttribute('title').toString();
    }

    // if have description trim to 50 characters with ...
    if (entity.getAttribute('description') != null) {
      return entity.getAttribute('description').toString().length > 50
          ? '${entity.getAttribute('description').toString().substring(0, 50)}...'
          : entity.getAttribute('description').toString();
    }

    if (entity.getAttribute('id') != null) {
      return entity.getAttribute('id').toString();
    }

    if (entity.getAttribute('code') != null) {
      return entity.getAttribute('code').toString();
    }

    try {
      return entity.concept.code;
    } catch (e) {
      return entity.concept.id.toString();
    }
  }
}

/// Widget for entity details screen
class EntityDetailScreen extends StatelessWidget {
  /// The entity to display
  final Entity entity;

  /// Constructor for EntityDetailScreen
  const EntityDetailScreen({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          entity.getStringFromAttribute('name') ?? 'Entity Detail',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
        ),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.primary, size: 24),
        elevation: 0,
        systemOverlayStyle:
            theme.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(child: EntityWidget(entity: entity)),
    );
  }
}

/// Main widget for displaying an entity with all its components
class EntityWidget extends StatelessWidget {
  /// The entity to display
  final Entity entity;

  /// Optional callback when an entity is selected
  final void Function(Entity entity)? onEntitySelected;

  /// Optional callback when the entity is deleted
  final VoidCallback? onDelete;

  /// Optional callback when the entity is saved
  final VoidCallback? onSave;

  /// Optional callback when the entity is exported
  final VoidCallback? onExport;

  /// Optional callback when a bookmark is created
  final Function(String title, String url)? onBookmark;

  /// Constructor for EntityWidget
  const EntityWidget({
    super.key,
    required this.entity,
    this.onEntitySelected,
    this.onDelete,
    this.onSave,
    this.onExport,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    try {
      // Access concept to verify it exists
      final concept = entity.concept;
      if (concept == null) {
        return _buildErrorDisplay(context, "Entity has no concept defined");
      }
    } catch (e) {
      return _buildErrorDisplay(
        context,
        "Error accessing entity concept: ${e.toString().split("\n").first}",
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8.0 : 16.0,
            vertical: 8.0,
          ),
          elevation: 2, // Slightly more elevation for better depth perception
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.6),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with entity type - improved contrast and semantics
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0, // Increased for better touch target
                ),
                color: colorScheme.surfaceContainerHighest,
                child: Row(
                  children: [
                    Icon(
                      _getIconForEntityType(_getConceptCodeSafely(entity)),
                      size: 20,
                      color: colorScheme.primary,
                      semanticLabel: "Entity type",
                    ),
                    const SizedBox(width: 12), // Increased for better spacing
                    Expanded(
                      child: Text(
                        _getConceptCodeSafely(entity),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Actions in the header for quick access
                    if (onSave != null || onExport != null || onDelete != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onSave != null)
                            IconButton(
                              icon: Icon(Icons.save, size: 20),
                              tooltip: 'Save',
                              onPressed: onSave,
                              color: colorScheme.primary,
                              constraints: BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                          if (onExport != null)
                            IconButton(
                              icon: Icon(Icons.share, size: 20),
                              tooltip: 'Export',
                              onPressed: onExport,
                              color: colorScheme.primary,
                              constraints: BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),

              // Main content with responsive padding
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12.0 : 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Entity Header with title and metadata
                      Semantics(
                        header: true,
                        child: EntityHeader(entity: entity),
                      ),

                      const SizedBox(height: 24),

                      // Attributes section with improved container
                      Container(
                        margin: const EdgeInsets.only(bottom: 24.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.list_alt,
                                    size: 20,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Attributes',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            EntityAttributes(entity: entity),
                          ],
                        ),
                      ),

                      // Relationships section with improved container
                      Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    size: 20,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Relationships',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            EntityRelationships(
                              entity: entity,
                              onEntitySelected: onEntitySelected,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom action bar with improved accessibility
              if (onDelete != null ||
                  onSave != null ||
                  onExport != null ||
                  onBookmark != null)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outlineVariant.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: isSmallScreen ? 8.0 : 12.0,
                  ),
                  child: EntityActions(
                    entity: entity,
                    onDelete: onDelete,
                    onSave: onSave,
                    onExport: onExport,
                    onBookmark: onBookmark,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Helper method to build an error display
  Widget _buildErrorDisplay(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      color: colorScheme.errorContainer,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.error,
              size: 48,
              semanticLabel: "Error",
            ),
            const SizedBox(height: 16),
            Text(
              "Entity Error",
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "This may be caused by data model changes or initialization issues.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: const Size(120, 48),
              ),
              child: const Text("Go Back"),
            ),
          ],
        ),
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
      default:
        return Icons.data_object;
    }
  }

  /// Helper method to safely get the concept code
  String _getConceptCodeSafely(Entity entity) {
    try {
      return entity.concept.code;
    } catch (e) {
      return "Unknown Type";
    }
  }
}
