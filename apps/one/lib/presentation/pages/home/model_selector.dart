import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/widgets/layout/model_pin_manager_dialog.dart';
import 'package:ednet_one/presentation/widgets/layout/semantic_layout_requirements.dart';

/// A component for selecting models in the application
class ModelSelector extends StatefulWidget {
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
  _ModelSelectorState createState() => _ModelSelectorState();
}

class _ModelSelectorState extends State<ModelSelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
      builder: (context, modelState) {
        final availableModels = modelState.availableModels;

        if (availableModels.isEmpty) {
          return Center(
            child: Text(
              widget.emptyMessage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return SemanticLayoutContainer(
          conceptType: 'Model',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Pin Manager button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (modelState.selectedModel != null)
                      IconButton(
                        icon: const Icon(Icons.push_pin_outlined),
                        tooltip: 'Manage Pinned Items',
                        onPressed: () {
                          ModelPinManagerDialog.show(
                            context,
                            modelState.selectedModel!.code,
                            title:
                                'Pinned Items for ${modelState.selectedModel!.code}',
                          );
                        },
                      ),
                  ],
                ),
              ),

              // Models list with fixed height constraint
              LayoutBuilder(
                builder: (context, constraints) {
                  // Safely calculate list height, ensuring it's always positive
                  final headerHeight = 64.0; // Height of the header
                  final availableHeight = constraints.maxHeight;
                  final listHeight =
                      (availableHeight > headerHeight)
                          ? availableHeight - headerHeight
                          : 200.0; // Default safe height if calculation would be negative

                  return SizedBox(
                    height: listHeight.clamp(
                      100.0,
                      300.0,
                    ), // Constrain between 100 and 300
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: availableModels.length,
                        itemBuilder: (context, index) {
                          final model = availableModels.elementAt(index);
                          final isSelected = model == modelState.selectedModel;

                          return _ModelListItem(
                            model: model,
                            isSelected: isSelected,
                            onTap: () {
                              // Use the centralized navigation helper
                              NavigationHelper.navigateToModel(context, model);

                              // Call optional callback
                              if (widget.onModelSelected != null) {
                                widget.onModelSelected!(model);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
