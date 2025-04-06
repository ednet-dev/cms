import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:flutter/material.dart';

/// Component for rendering the header of an entity including title and metadata
class EntityHeader extends StatelessWidget {
  /// The entity whose header will be displayed
  final ednet.Entity entity;

  /// Constructor for EntityHeader
  const EntityHeader({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final title = _getEntityTitle(entity);
    final entityType = entity.concept.code;
    final createdAt = entity.getAttribute('createdAt') as DateTime?;
    final modifiedAt = entity.getAttribute('modifiedAt') as DateTime?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(title, style: Theme.of(context).textTheme.headlineMedium),

        // Entity type
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
          child: Text(
            entityType,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),

        // Metadata
        if (createdAt != null || modifiedAt != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                if (createdAt != null) ...[
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 153),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Created: ${_formatDate(createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 153),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],

                if (modifiedAt != null) ...[
                  Icon(
                    Icons.edit,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 153),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Modified: ${_formatDate(modifiedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 153),
                    ),
                  ),
                ],
              ],
            ),
          ),

        const Divider(),
      ],
    );
  }

  /// Helper function to get a display title for the entity
  String _getEntityTitle(ednet.Entity entity) {
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

  /// Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
