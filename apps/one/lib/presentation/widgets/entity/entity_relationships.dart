import 'package:ednet_core/ednet_core.dart' as ednet;
import 'package:flutter/material.dart';

/// Component for rendering the relationships section of an entity
class EntityRelationships extends StatelessWidget {
  /// The entity whose relationships will be displayed
  final ednet.Entity entity;

  /// Optional callback when an entity is selected
  final void Function(ednet.Entity entity)? onEntitySelected;

  /// Constructor for EntityRelationships
  const EntityRelationships({
    super.key,
    required this.entity,
    this.onEntitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parent relationships
        if (entity.concept.parents.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
            child: Text(
              'Parent Entities',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...entity.concept.parents.map((parent) {
            final parentEntity = entity.getParent(parent.code) as ednet.Entity;
            return ListTile(
              title: Text(_getEntityTitle(parentEntity)),
              subtitle: Text(parentEntity.concept.code),
              onTap: () {
                if (onEntitySelected != null) {
                  onEntitySelected!(parentEntity);
                }
              },
            );
          }),
        ],

        // Child relationships
        if (entity.concept.children.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
            child: Text(
              'Child Entities',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...entity.concept.children.map((child) {
            final childEntities =
                entity.getChild(child.code) as ednet.Entities?;
            if (childEntities == null || childEntities.isEmpty) {
              return const SizedBox.shrink();
            }

            return ExpansionTile(
              title: Text(
                child.codeFirstLetterUpper,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              children:
                  childEntities.map((childEntity) {
                    return ListTile(
                      title: Text(
                        _getEntityTitle(childEntity as ednet.Entity),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      onTap: () {
                        if (onEntitySelected != null) {
                          onEntitySelected!(childEntity);
                        }
                      },
                    );
                  }).toList(),
            );
          }),
        ],
      ],
    );
  }

  /// Helper function to get a display title for an entity
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
}
