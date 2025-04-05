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
    return Scaffold(
      appBar: AppBar(
        title: Text(entity.getStringFromAttribute('name') ?? 'Entity Detail'),
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
      entity.concept;
    } catch (e) {
      return const Center(
        child: Text(
          "*** concept is not set ***\nSee also: https://flutter.dev/docs/testing/errors",
          style: TextStyle(color: Colors.yellow, fontSize: 16),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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

            // Attributes section
            EntityAttributes(entity: entity, sectionTitle: 'Attributes'),

            // Relationships section (parents and children)
            EntityRelationships(
              entity: entity,
              onEntitySelected: onEntitySelected,
            ),
          ],
        ),
      ),
    );
  }
}
