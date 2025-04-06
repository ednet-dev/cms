import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart'
    as header;

import '../widgets/layout/web/header_widget.dart';

/// Models listing page for the application
///
/// This page displays all available models within a domain and allows
/// navigation to specific model details.
class ModelsPage extends StatelessWidget {
  /// Route name for this page
  static const String routeName = '/models';

  /// The models to display
  final Models models;

  /// Callback for when a model is selected
  final void Function(Model model)? onModelSelected;

  /// The current domain name for navigation context
  final String domainName;

  /// Creates a models page
  const ModelsPage({
    super.key,
    required this.models,
    required this.domainName,
    this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: ['Home', domainName, 'Models'],
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else if (index == 1) {
              Navigator.popUntil(context, ModalRoute.withName('/domains'));
            }
          },
          filters: [],
          onAddFilter: (header.FilterCriteria filter) {},
          onBookmark: () {},
        ),
      ),
      body: ModelsListWidget(models: models, onModelSelected: onModelSelected),
    );
  }
}

/// Widget for displaying a list of models
///
/// This widget renders a list of models with consistent styling and
/// handles model selection.
class ModelsListWidget extends StatelessWidget {
  /// The models to display
  final Models models;

  /// Callback for when a model is selected
  final void Function(Model model)? onModelSelected;

  /// Creates a models list widget
  const ModelsListWidget({
    super.key,
    required this.models,
    this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return models.isEmpty
        ? const Center(child: Text('No models available in this domain'))
        : ListView.builder(
          itemCount: models.length,
          itemBuilder: (context, index) {
            var model = models.elementAt(index);
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              elevation: 2,
              child: ListTile(
                title: Text(model.code, style: theme.textTheme.titleMedium),
                subtitle: Text(
                  '${model.concepts.length} concepts',
                  style: theme.textTheme.bodySmall,
                ),
                leading: CircleAvatar(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  child: Text(model.code.substring(0, 1).toUpperCase()),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.secondary,
                ),
                onTap: () {
                  if (onModelSelected != null) {
                    onModelSelected!(model);
                  }
                },
              ),
            );
          },
        );
  }
}
