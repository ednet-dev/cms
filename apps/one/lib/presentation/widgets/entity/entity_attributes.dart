import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import 'attribute_widget_factory.dart';

/// Component for rendering the attributes section of an entity
class EntityAttributes extends StatelessWidget {
  /// The entity whose attributes will be displayed
  final Entity entity;

  /// Optional title for the attributes section
  final String? sectionTitle;

  /// Constructor for EntityAttributes
  const EntityAttributes({super.key, required this.entity, this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final attributes = entity.concept.attributes;

    if (attributes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No attributes available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    // Group attributes for better organization
    final idAttributes = <Property>[];
    final nameAttributes = <Property>[];
    final dateAttributes = <Property>[];
    final otherAttributes = <Property>[];

    for (final attribute in attributes) {
      if (attribute.code.toLowerCase().contains('id') ||
          attribute.code.toLowerCase().contains('code')) {
        idAttributes.add(attribute);
      } else if (attribute.code.toLowerCase().contains('name') ||
          attribute.code.toLowerCase().contains('title')) {
        nameAttributes.add(attribute);
      } else if (attribute.code.toLowerCase().contains('date') ||
          attribute.code.toLowerCase().contains('time')) {
        dateAttributes.add(attribute);
      } else {
        otherAttributes.add(attribute);
      }
    }

    // Display attributes in a more organized way
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title if provided
          if (sectionTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                sectionTitle!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),

          // All attributes in a better layout
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              // First show name attributes
              ...nameAttributes.map(
                (attribute) => _buildAttributeCard(context, attribute),
              ),

              // Then show identifier attributes
              ...idAttributes.map(
                (attribute) => _buildAttributeCard(context, attribute),
              ),

              // Then show date attributes
              ...dateAttributes.map(
                (attribute) => _buildAttributeCard(context, attribute),
              ),

              // Finally show other attributes
              ...otherAttributes.map(
                (attribute) => _buildAttributeCard(context, attribute),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build an individual attribute card with improved styling
  Widget _buildAttributeCard(BuildContext context, Property attribute) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final attributeValue = entity.getAttribute(attribute.code);
    final valueString =
        attributeValue != null ? attributeValue.toString() : 'Not set';

    // Determine if this is a primary attribute
    final isPrimary =
        attribute.code.toLowerCase() == 'name' ||
        attribute.code.toLowerCase() == 'title' ||
        attribute.code.toLowerCase() == 'id';

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 150, maxWidth: 300),
      child: Card(
        elevation: 0,
        color:
            isPrimary
                ? colorScheme.primaryContainer.withOpacity(0.3)
                : colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color:
                isPrimary
                    ? colorScheme.primary.withOpacity(0.5)
                    : colorScheme.outline.withOpacity(0.2),
            width: isPrimary ? 1 : 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Attribute name
              Text(
                attribute.code,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      isPrimary
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 6),

              // Attribute value with better handling of different types
              Semantics(
                value: valueString,
                child: SelectableText(
                  valueString,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: isPrimary ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
