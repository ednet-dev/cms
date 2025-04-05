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
    final attributes = entity.concept.attributes;

    if (attributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title if provided
        if (sectionTitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              sectionTitle!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

        // Attributes
        ...attributes.map((attributeBase) {
          final attribute = attributeBase as Attribute;
          final value = entity.getAttribute(attribute.code);

          return AttributeWidgetFactory.createAttributeWidget(
            attribute: attribute,
            value: value,
            onValueChanged: (newValue) {
              entity.setAttribute(attribute.code, newValue);
            },
            context: context,
          );
        }),
      ],
    );
  }
}
