import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

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
          ),
        ),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.primary),
        elevation: 0,
      ),
      body: EntityWidget(entity: entity),
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

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with entity type
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                color: colorScheme.surfaceContainerHighest,
                child: Row(
                  children: [
                    Icon(Icons.category, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      _getConceptCodeSafely(entity),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: ListView(
                  controller: ScrollController(),
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Header with entity title and metadata
                    EntityHeader(entity: entity),

                    // Actions (save, delete, etc.)
                    EntityActions(
                      entity: entity,
                      onDelete: onDelete,
                      onSave: onSave,
                      onExport: onExport,
                      onBookmark: onBookmark,
                    ),

                    // Attributes section with improved styling
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withOpacity(0.2),
                        ),
                      ),
                      child: EntityAttributes(
                        entity: entity,
                        sectionTitle: 'Attributes',
                      ),
                    ),

                    // Relationships section with improved styling
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withOpacity(0.2),
                        ),
                      ),
                      child: EntityRelationships(
                        entity: entity,
                        onEntitySelected: onEntitySelected,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper method to build an error display
  Widget _buildErrorDisplay(BuildContext context, String message) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              "Entity Error",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "This may be caused by data model changes or initialization issues.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
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
