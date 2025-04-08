import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import '../../../presentation/layouts/app_module.dart';
import '../../../presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import '../../../presentation/state/blocs/domain_selection/domain_selection_state.dart';
import '../../../presentation/state/blocs/model_selection/model_selection_bloc.dart';
import '../../../presentation/state/blocs/model_selection/model_selection_event.dart';
import '../../../presentation/state/blocs/model_selection/model_selection_state.dart';
import '../../../presentation/theme/providers/theme_provider.dart';
import '../../../presentation/theme/extensions/theme_spacing.dart';
import '../../../presentation/widgets/semantic_concept_container.dart';
import '../../widgets/breadcrumb/breadcrumb.dart';
import '../../navigation/navigation_service.dart';
import 'model_detail_view.dart';
import '../../../presentation/widgets/card/enhanced_card.dart';
import '../../../presentation/widgets/list/enhanced_list_item.dart';

/// Model Manager Module - handles browsing, selecting and managing models
class ModelManagerModule extends AppModule {
  final IOneApplication _app;

  ModelManagerModule(this._app);

  @override
  String get id => 'models';

  @override
  String get name => 'Models';

  @override
  IconData get icon => Icons.data_object;

  @override
  Widget buildModuleContent(BuildContext context) {
    return const ModelManagerScreen();
  }

  @override
  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Refresh models',
        onPressed: () {
          final domainState = context.read<DomainSelectionBloc>().state;
          if (domainState.selectedDomain != null) {
            context.read<ModelSelectionBloc>().add(
              UpdateModelsForDomainEvent(domainState.selectedDomain!),
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('No domain selected')));
          }
        },
      ),
    ];
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Implement model creation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Model creation not implemented yet')),
        );
      },
      tooltip: 'Add Model',
      child: const Icon(Icons.add),
    );
  }
}

/// The main screen for the Model Manager module
class ModelManagerScreen extends StatelessWidget {
  const ModelManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
      builder: (context, domainState) {
        // Need domain context for model management
        final domain = domainState.selectedDomain;

        return BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
          builder: (context, modelState) {
            // Build breadcrumb navigation
            final List<BreadcrumbItem> breadcrumbs = [
              BreadcrumbItem(
                label: 'Models',
                icon: Icons.data_object,
                onTap: () {
                  // Clear model selection to return to list view
                  if (modelState.selectedModel != null) {
                    context.read<ModelSelectionBloc>().add(
                      ClearModelSelectionEvent(),
                    );
                  }
                },
              ),
              if (domain != null)
                BreadcrumbItem(
                  label: domain.code,
                  icon: Icons.domain,
                  subtitle: '${domain.models.length} models',
                  onTap: () {
                    // Go back to domain view
                    if (modelState.selectedModel != null) {
                      context.read<ModelSelectionBloc>().add(
                        ClearModelSelectionEvent(),
                      );
                    }
                  },
                ),
              if (modelState.selectedModel != null)
                BreadcrumbItem(
                  label: modelState.selectedModel!.code,
                  icon: Icons.data_object,
                  subtitle:
                      '${modelState.selectedModel!.concepts.length} concepts',
                  current: true,
                ),
            ];

            return SemanticConceptContainer(
              conceptType: 'ModelManager',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Breadcrumb navigation
                  BreadcrumbBar(items: breadcrumbs, title: 'Model Navigation'),

                  // Content area with master-detail pattern
                  Expanded(
                    child: _buildContent(context, domainState, modelState),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    DomainSelectionState domainState,
    ModelSelectionState modelState,
  ) {
    // Check domain selection
    if (domainState.selectedDomain == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.domain_disabled,
              size: 64,
              color: context.conceptColor('Info', role: 'icon'),
            ),
            const SizedBox(height: 16),
            Text(
              'Please select a domain first',
              style: context.conceptTextStyle('Info'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.category),
              label: const Text('Go to Domains'),
              onPressed: () {
                // Get the NavigationService and navigate to domains module
                final navigationService = Provider.of<NavigationService>(
                  context,
                  listen: false,
                );
                navigationService.navigateToModule('domains');
              },
            ),
          ],
        ),
      );
    }

    // Check model selection
    if (modelState.selectedModel != null) {
      // Detail view for selected model
      return ModelDetailView(model: modelState.selectedModel!);
    }

    // List of models view
    return _buildModelList(context, modelState);
  }

  Widget _buildModelList(BuildContext context, ModelSelectionState state) {
    if (state.availableModels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: context.conceptColor('Info', role: 'icon'),
            ),
            const SizedBox(height: 16),
            Text(
              'No models available for the selected domain',
              style: context.conceptTextStyle('Info'),
            ),
          ],
        ),
      );
    }

    final models = state.availableModels.toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Models',
            style: context.conceptTextStyle('ModelList', role: 'title'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout - use grid for wider screens, list for narrow
                final bool useGrid = constraints.maxWidth > 600;

                if (useGrid) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      return ModelCard(model: models[index]);
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      return ModelListItem(model: models[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Card view of a model for grid layout
class ModelCard extends StatelessWidget {
  final Model model;

  const ModelCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // Get the number of entry concepts
    final int entryConceptsCount = model.concepts.where((c) => c.entry).length;

    return SemanticConceptContainer(
      conceptType: 'Model',
      child: EnhancedCard(
        conceptType: 'Model',
        leadingIcon: Icons.data_object,
        badgeText: entryConceptsCount > 0 ? '$entryConceptsCount Entry' : null,
        onTap: () => _selectModel(context, model),
        isConcept: true,
        importance: 0.7,
        header: Text(
          model.code,
          style: context.conceptTextStyle('Model', role: 'header'),
          overflow: TextOverflow.ellipsis,
        ),
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${model.concepts.length} concepts',
              style: context.conceptTextStyle('Model', role: 'subtitle'),
            ),
            Text(
              _getModelDomain(),
              style: context.conceptTextStyle('Model', role: 'subtitle'),
            ),
          ],
        ),
        child:
            model.concepts.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'No concepts defined',
                      style: context.conceptTextStyle('Info'),
                    ),
                  ),
                )
                : Padding(
                  padding: EdgeInsets.symmetric(vertical: context.spacingS),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top concepts:',
                        style: context.conceptTextStyle(
                          'Model',
                          role: 'subtitle',
                        ),
                      ),
                      SizedBox(height: context.spacingXs),
                      Text(
                        _getTopConceptNames().join(', '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  String _getModelDomain() {
    return model.domain?.code ?? 'Unknown';
  }

  List<String> _getTopConceptNames() {
    final concepts = model.concepts.toList();
    if (concepts.isEmpty) return ['None'];

    // Prioritize entry concepts in the preview
    final entryConcepts = concepts.where((c) => c.entry).take(3).toList();
    if (entryConcepts.isNotEmpty) {
      return entryConcepts.map((c) => c.code).toList();
    }

    // Fall back to top 3 concepts if no entry concepts
    final topConcepts = concepts.take(3).toList();
    return topConcepts.map((c) => c.code).toList();
  }

  void _selectModel(BuildContext context, Model model) {
    context.read<ModelSelectionBloc>().add(SelectModelEvent(model));
  }
}

/// List item view of a model for list layout
class ModelListItem extends StatelessWidget {
  final Model model;

  const ModelListItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final int entryConceptsCount = model.concepts.where((c) => c.entry).length;

    return SemanticConceptContainer(
      conceptType: 'Model',
      child: EnhancedListItem(
        title: model.code,
        subtitle: _getTopConceptNames().join(', '),
        leadingIcon: Icons.data_object,
        conceptType: 'Model',
        isConcept: true,
        importance: 0.7,
        badgeText: entryConceptsCount > 0 ? '$entryConceptsCount Entry' : null,
        trailing: Text(
          '${model.concepts.length}',
          style: context.conceptTextStyle('Model', role: 'badge'),
        ),
        onTap: () => _selectModel(context, model),
        secondaryActionIcon: Icons.info_outline,
        onSecondaryAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Model info: ${model.code}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  List<String> _getTopConceptNames() {
    final concepts = model.concepts.toList();
    if (concepts.isEmpty) return ['No concepts'];

    // Prioritize entry concepts in the preview
    final entryConcepts = concepts.where((c) => c.entry).take(2).toList();
    if (entryConcepts.isNotEmpty) {
      return entryConcepts.map((c) => c.code).toList();
    }

    // Fall back to top 2 concepts if no entry concepts
    final topConcepts = concepts.take(2).toList();
    return topConcepts.map((c) => c.code).toList();
  }

  void _selectModel(BuildContext context, Model model) {
    context.read<ModelSelectionBloc>().add(SelectModelEvent(model));
  }
}
