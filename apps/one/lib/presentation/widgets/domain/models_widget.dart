import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

/// Widget for displaying a list of models
class ModelsWidget extends StatelessWidget {
  /// The models to display
  final Models models;

  /// Callback when a model is selected
  final void Function(Model model) onModelSelected;

  /// Constructor for ModelsWidget
  const ModelsWidget({
    super.key,
    required this.models,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models.elementAt(index);
        return ListTile(
          title: Text(model.code),
          subtitle: model.description != null ? Text(model.description!) : null,
          leading: const Icon(Icons.model_training),
          onTap: () => onModelSelected(model),
        );
      },
    );
  }
}
