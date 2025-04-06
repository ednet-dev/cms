import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart'
    as header;

import '../widgets/layout/web/header_widget.dart';

/// Concepts listing page for the application
///
/// This page displays all available concepts within a model and allows
/// navigation to specific concept details.
class ConceptsPage extends StatelessWidget {
  /// Route name for this page
  static const String routeName = '/concepts';

  /// The concepts to display
  final Concepts concepts;

  /// Callback for when a concept is selected
  final void Function(Concept concept)? onConceptSelected;

  /// The current domain and model names for navigation context
  final String domainName;
  final String modelName;

  /// Creates a concepts page
  const ConceptsPage({
    super.key,
    required this.concepts,
    required this.domainName,
    required this.modelName,
    this.onConceptSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: ['Home', domainName, modelName, 'Concepts'],
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else if (index == 1) {
              Navigator.popUntil(context, ModalRoute.withName('/domains'));
            } else if (index == 2) {
              Navigator.pop(context);
            }
          },
          filters: [],
          onAddFilter: (header.FilterCriteria filter) {},
          onBookmark: () {},
        ),
      ),
      body: ConceptsListWidget(
        concepts: concepts,
        onConceptSelected: onConceptSelected,
      ),
    );
  }
}

/// Widget for displaying a list of concepts
///
/// This widget renders a list of concepts with consistent styling and
/// handles concept selection.
class ConceptsListWidget extends StatelessWidget {
  /// The concepts to display
  final Concepts concepts;

  /// Callback for when a concept is selected
  final void Function(Concept concept)? onConceptSelected;

  /// Creates a concepts list widget
  const ConceptsListWidget({
    super.key,
    required this.concepts,
    this.onConceptSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return concepts.isEmpty
        ? const Center(child: Text('No concepts available in this model'))
        : ListView.builder(
          itemCount: concepts.length,
          itemBuilder: (context, index) {
            var concept = concepts.elementAt(index);
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              elevation: 2,
              child: ListTile(
                title: Text(concept.code, style: theme.textTheme.titleMedium),
                subtitle: Text(
                  '${concept.attributes.length} attributes',
                  style: theme.textTheme.bodySmall,
                ),
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: Text(concept.code.substring(0, 1).toUpperCase()),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.primary,
                ),
                onTap: () {
                  if (onConceptSelected != null) {
                    onConceptSelected!(concept);
                  }
                },
              ),
            );
          },
        );
  }
}
