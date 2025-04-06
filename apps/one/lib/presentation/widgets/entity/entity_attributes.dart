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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title with icon if provided
        if (sectionTitle != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.list_alt, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  sectionTitle!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

        // Attributes list with dividers between items
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: attributes.length,
          separatorBuilder:
              (context, index) => Divider(
                color: colorScheme.outlineVariant.withOpacity(0.1),
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
          itemBuilder: (context, index) {
            final attribute = attributes.elementAt(index) as Attribute;
            final value = entity.getAttribute(attribute.code);

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Attribute name with capitalization
                  SizedBox(
                    width: 120,
                    child: Text(
                      _formatAttributeName(attribute.code),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Attribute value with appropriate widget
                  Expanded(
                    child: AttributeWidgetFactory.createAttributeWidget(
                      attribute: attribute,
                      value: value,
                      onValueChanged: (newValue) {
                        entity.setAttribute(attribute.code, newValue);
                      },
                      context: context,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Helper method to format attribute names for display
  String _formatAttributeName(String name) {
    // Convert camelCase or snake_case to space-separated words and capitalize first letter
    final spaceSeparated =
        name
            .replaceAllMapped(
              RegExp(r'([A-Z])'),
              (match) => ' ${match.group(0)}',
            )
            .replaceAll('_', ' ')
            .trim();

    if (spaceSeparated.isEmpty) return '';

    return spaceSeparated[0].toUpperCase() + spaceSeparated.substring(1);
  }
}
