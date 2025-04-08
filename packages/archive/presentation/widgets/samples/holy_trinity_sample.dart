import 'package:flutter/material.dart';
import '../semantic_concept_container.dart';
import '../../theme/providers/theme_provider.dart';

/// Sample widget demonstrating the Holy Trinity architecture
///
/// This widget shows how to use the Holy Trinity architecture components
/// (layout strategy, theme strategy, and domain model) together to create
/// a semantic UI that adapts to different layout and theme strategies.
///
/// Use this as a reference when migrating existing components.
class HolyTrinitySample extends StatelessWidget {
  /// Constructor for HolyTrinitySample
  const HolyTrinitySample({super.key});

  @override
  Widget build(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'Sample',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header using semantic styling
          Text(
            'Holy Trinity Architecture Sample',
            style: context.conceptTextStyle('Sample', role: 'title'),
          ),
          const SizedBox(height: 16),

          // Domain section
          SemanticConceptContainer(
            conceptType: 'Domain',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      context.conceptIcon('Domain'),
                      color: context.conceptColor('Domain'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Domain Section',
                      style: context.conceptTextStyle('Domain', role: 'title'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a domain container with semantic styling.',
                  style: context.conceptTextStyle(
                    'Domain',
                    role: 'description',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Model section
          SemanticConceptContainer(
            conceptType: 'Model',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      context.conceptIcon('Model'),
                      color: context.conceptColor('Model'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Model Section',
                      style: context.conceptTextStyle('Model', role: 'title'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a model container with semantic styling.',
                  style: context.conceptTextStyle('Model', role: 'description'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Concept section
          SemanticConceptContainer(
            conceptType: 'Concept',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      context.conceptIcon('Concept'),
                      color: context.conceptColor('Concept'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Concept Section',
                      style: context.conceptTextStyle('Concept', role: 'title'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a concept container with semantic styling.',
                  style: context.conceptTextStyle(
                    'Concept',
                    role: 'description',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Entity section with attributes
          SemanticConceptContainer(
            conceptType: 'Entity',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      context.conceptIcon('Entity'),
                      color: context.conceptColor('Entity'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Entity Section',
                      style: context.conceptTextStyle('Entity', role: 'title'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Attributes list using semantic flow container
                SemanticFlowContainer(
                  children: [
                    _buildAttributeItem(context, 'ID', '12345'),
                    _buildAttributeItem(context, 'Name', 'Sample Entity'),
                    _buildAttributeItem(context, 'Type', 'Demo'),
                    _buildAttributeItem(context, 'Created', '2023-04-01'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build an attribute item with semantic styling
  Widget _buildAttributeItem(BuildContext context, String name, String value) {
    return SemanticConceptContainer(
      conceptType: 'Attribute',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$name: ',
            style: context.conceptTextStyle('Attribute', role: 'name'),
          ),
          Text(
            value,
            style: context.conceptTextStyle('Attribute', role: 'value'),
          ),
        ],
      ),
    );
  }
}
