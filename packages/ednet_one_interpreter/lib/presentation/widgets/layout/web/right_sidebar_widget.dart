import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';

/// A widget that displays available models in the right sidebar.
///
/// This widget shows models from the selected domain and allows
/// the user to select them for further exploration.
class RightSidebarWidget extends StatelessWidget {
  /// The models to display
  final Iterable<Model> models;

  /// Callback when a model is selected
  final Function(Model) onModelSelected;

  /// Creates a new right sidebar widget.
  const RightSidebarWidget({
    Key? key,
    required this.models,
    required this.onModelSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            width: double.infinity,
            child: Text(
              'Domain Models',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child:
                models.isEmpty
                    ? const Center(child: Text('No models'))
                    : _buildModelList(context),
          ),
        ],
      ),
    );
  }

  /// Builds the list of models.
  Widget _buildModelList(BuildContext context) {
    final modelsList = models.toList();

    return ListView.builder(
      itemCount: modelsList.length,
      itemBuilder: (context, index) {
        final model = modelsList[index];
        final entryConcepts = model.concepts.where((c) => c.entry);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Text(model.code),
            subtitle: Text('${model.concepts.length} concepts'),
            leading: const Icon(Icons.dataset),
            trailing: Chip(
              label: Text('${entryConcepts.length}'),
              avatar: const Icon(Icons.data_object, size: 16),
            ),
            onTap: () => onModelSelected(model),
          ),
        );
      },
    );
  }
}
