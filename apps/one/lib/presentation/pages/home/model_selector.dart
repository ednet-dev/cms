import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';

/// A component for selecting models in the application
class ModelSelector extends StatelessWidget {
  /// Optional callback when a model is selected
  final Function(Model)? onModelSelected;

  /// Title for the model selector
  final String title;

  /// Empty state message when no models are available
  final String emptyMessage;

  /// Constructor for ModelSelector
  const ModelSelector({
    super.key,
    this.onModelSelected,
    this.title = 'Models',
    this.emptyMessage = 'No Models Available',
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
      builder: (context, modelState) {
        final availableModels = modelState.availableModels;

        if (availableModels.isEmpty) {
          return Center(
            child: Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),

            // Models list
            Expanded(
              child: ListView.builder(
                controller: ScrollController(),
                itemCount: availableModels.length,
                itemBuilder: (context, index) {
                  final model = availableModels.elementAt(index);
                  final isSelected = model == modelState.selectedModel;

                  return _ModelListItem(
                    model: model,
                    isSelected: isSelected,
                    onTap: () {
                      // Update model selection
                      context.read<ModelSelectionBloc>().add(
                        SelectModelEvent(model),
                      );

                      // Update concepts for the selected model
                      try {
                        debugPrint(
                          'Updating concepts for model: ${model.code}',
                        );
                        context.read<ConceptSelectionBloc>().add(
                          UpdateConceptsForModelEvent(model),
                        );
                      } catch (e) {
                        debugPrint('Error updating concepts: $e');
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to load concepts for ${model.code}',
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }

                      // Call optional callback
                      if (onModelSelected != null) {
                        onModelSelected!(model);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Internal widget for rendering a model list item
class _ModelListItem extends StatelessWidget {
  final Model model;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModelListItem({
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        model.code,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle:
          model.description != null
              ? Text(
                model.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
              : null,
      selected: isSelected,
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onTap: onTap,
      leading: Icon(
        Icons.model_training,
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      trailing:
          isSelected
              ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
              : null,
    );
  }
}
