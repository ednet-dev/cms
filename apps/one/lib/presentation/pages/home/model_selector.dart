import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/widgets/layout/model_pin_manager_dialog.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';

/// A component for selecting models in the application
///
/// Follows the Holy Trinity architecture by using semantic concept containers
/// and applying theme styling based on model concepts.
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
          return SemanticConceptContainer(
            conceptType: 'ModelSelectorEmpty',
            child: Text(
              widget.emptyMessage,
              style: context.conceptTextStyle('Model', role: 'empty'),
            ),
          );
        }

        // Use LayoutBuilder to make responsive decisions
        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine if we should use a compact layout
            final bool useCompactLayout = constraints.maxWidth < 600;

            return SemanticConceptContainer(
              conceptType: 'ModelSelector',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Pin Manager button
                  _buildHeader(context, modelState),

                  // Choose between compact dropdown or full list view
                  useCompactLayout
                      ? _buildCompactSelector(context, modelState)
                      : _buildModelList(context, modelState, constraints),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Build the header section with title and pin button
  Widget _buildHeader(BuildContext context, ModelSelectionState modelState) {
    return Padding(
      padding: EdgeInsets.all(context.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: context.conceptTextStyle('ModelSelector', role: 'title'),
          ),
          if (modelState.selectedModel != null)
            IconButton(
              icon: Icon(
                Icons.push_pin_outlined,
                color: context.conceptColor('ModelSelector', role: 'icon'),
              ),
              tooltip: 'Manage Pinned Items',
              onPressed: () {
                ModelPinManagerDialog.show(
                  context,
                  modelState.selectedModel!.code,
                  title: 'Pinned Items for ${modelState.selectedModel!.code}',
                );
              },
            ),
        ],
      ),
    );
  }

  /// Build a compact dropdown selector for narrow layouts
  Widget _buildCompactSelector(
    BuildContext context,
    ModelSelectionState modelState,
  ) {
    return Container(
      padding: EdgeInsets.all(context.spacingXs),
      margin: EdgeInsets.symmetric(horizontal: context.spacingM),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.conceptColor('Model', role: 'border'),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<Model>(
        value: modelState.selectedModel ?? modelState.availableModels.first,
        underline: const SizedBox.shrink(),
        icon: Icon(Icons.arrow_drop_down, color: context.conceptColor('Model')),
        isExpanded: true,
        onChanged: (Model? newValue) {
          if (newValue != null) {
            NavigationHelper.navigateToModel(context, newValue);

            if (widget.onModelSelected != null) {
              widget.onModelSelected!(newValue);
            }
          }
        },
        items:
            modelState.availableModels.map((Model model) {
              return DropdownMenuItem<Model>(
                value: model,
                child: Text(
                  model.code,
                  style: context.conceptTextStyle('Model', role: 'title'),
                ),
              );
            }).toList(),
      ),
    );
  }

  /// Build a scrollable list of models for wider layouts
  Widget _buildModelList(
    BuildContext context,
    ModelSelectionState modelState,
    BoxConstraints constraints,
  ) {
    // Calculate appropriate list height
    final headerHeight = 48.0;
    final availableHeight = constraints.maxHeight;
    final listHeight =
        availableHeight > headerHeight ? availableHeight - headerHeight : 200.0;

    return Container(
      height: listHeight.clamp(100.0, 300.0),
      padding: EdgeInsets.symmetric(horizontal: context.spacingS),
      child: SemanticConceptContainer(
        conceptType: 'ModelList',
        scrollable: true,
        scrollController: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: modelState.availableModels.length,
          itemBuilder: (context, index) {
            final model = modelState.availableModels.elementAt(index);
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
    return SemanticConceptContainer(
      conceptType: 'Model',
      child: ListTile(
        title: Text(
          model.code,
          style: context.conceptTextStyle(
            'Model',
            role: isSelected ? 'selected' : 'default',
          ),
        ),
        subtitle:
            model.description != null
                ? Text(
                  model.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.conceptTextStyle('Model', role: 'description'),
                )
                : null,
        selected: isSelected,
        selectedTileColor: context
            .conceptColor('Model', role: 'selectedBackground')
            .withValues(alpha: 51),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onTap: onTap,
        leading: Icon(
          Icons.model_training,
          color:
              isSelected
                  ? context.conceptColor('Model', role: 'selected')
                  : context.conceptColor('Model', role: 'icon'),
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: context.conceptColor('Model', role: 'selected'),
                )
                : null,
      ),
    );
  }
}
