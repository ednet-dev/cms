import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_state.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';
import 'package:ednet_one/presentation/widgets/workspace/domain_workspace_card.dart';
import 'package:ednet_one/presentation/widgets/workspace/model_workspace_card.dart';
import 'package:ednet_one/presentation/widgets/workspace/concept_workspace_card.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';

/// An immersive workspace page that provides fluid navigation between domains, models, and concepts
///
/// This page implements the workspace pattern with expandable cards that transform
/// into full application views. It showcases the Holy Trinity architecture
/// and provides a modern, immersive UI experience.
class ImmersiveWorkspacePage extends StatefulWidget {
  /// The title of the page
  final String title;

  /// Route name for navigation
  static const String routeName = '/workspace';

  /// Constructor for ImmersiveWorkspacePage
  const ImmersiveWorkspacePage({super.key, required this.title});

  @override
  State<ImmersiveWorkspacePage> createState() => _ImmersiveWorkspacePageState();
}

class _ImmersiveWorkspacePageState extends State<ImmersiveWorkspacePage> {
  // Track expanded state for each workspace type
  Domain? _expandedDomain;
  Model? _expandedModel;
  Concept? _expandedConcept;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.view_module),
            tooltip: 'Toggle View',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: () {},
          ),
        ],
      ),
      body: _buildWorkspaceContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Create New',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWorkspaceContent(BuildContext context) {
    // If any item is expanded, show only that item
    if (_expandedDomain != null) {
      return _buildExpandedDomainView(context, _expandedDomain!);
    }

    if (_expandedModel != null) {
      return _buildExpandedModelView(context, _expandedModel!);
    }

    if (_expandedConcept != null) {
      return _buildExpandedConceptView(context, _expandedConcept!);
    }

    // Otherwise show the grid view of domains and models
    return _buildCollapsedGridView(context);
  }

  Widget _buildCollapsedGridView(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'Workspace',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header for domains
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.spacingM,
                  horizontal: context.spacingS,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.domain,
                      color: context.conceptColor('Domain', role: 'icon'),
                    ),
                    SizedBox(width: context.spacingS),
                    Text(
                      'Domains',
                      style: context.conceptTextStyle(
                        'Workspace',
                        role: 'sectionTitle',
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Domain'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Domains grid
              BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
                builder: (context, state) {
                  if (state.availableDomains.isEmpty) {
                    return _buildEmptyState(
                      context,
                      'No domains available',
                      'Create your first domain to get started',
                      Icons.domain_add,
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _calculateGridCrossAxisCount(context),
                      crossAxisSpacing: context.spacingM,
                      mainAxisSpacing: context.spacingM,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: state.availableDomains.length,
                    itemBuilder: (context, index) {
                      final domain = state.availableDomains.elementAt(index);
                      return DomainWorkspaceCard(
                        domain: domain,
                        onExpand: () => _expandDomain(domain),
                        onCollapse: _collapseAll,
                        onModelSelected: (model) {
                          NavigationHelper.navigateToModel(context, model);
                          _expandModel(model);
                        },
                      );
                    },
                  );
                },
              ),

              // Section header for recently viewed models
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.spacingM,
                  horizontal: context.spacingS,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.model_training,
                      color: context.conceptColor('Model', role: 'icon'),
                    ),
                    SizedBox(width: context.spacingS),
                    Text(
                      'Recent Models',
                      style: context.conceptTextStyle(
                        'Workspace',
                        role: 'sectionTitle',
                      ),
                    ),
                    const Spacer(),
                    TextButton(child: const Text('View All'), onPressed: () {}),
                  ],
                ),
              ),

              // Recent models grid
              BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
                builder: (context, state) {
                  if (state.availableModels.isEmpty) {
                    return _buildEmptyState(
                      context,
                      'No models available',
                      'Select a domain to view its models',
                      Icons.model_training,
                    );
                  }

                  // Show only first 4 models in this view
                  final models = state.availableModels.take(4).toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _calculateGridCrossAxisCount(context),
                      crossAxisSpacing: context.spacingM,
                      mainAxisSpacing: context.spacingM,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      final model = models[index];
                      return ModelWorkspaceCard(
                        model: model,
                        onExpand: () => _expandModel(model),
                        onCollapse: _collapseAll,
                        onConceptSelected: (concept) {
                          NavigationHelper.navigateToConcept(context, concept);
                          _expandConcept(concept);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedDomainView(BuildContext context, Domain domain) {
    return DomainWorkspaceCard(
      domain: domain,
      onCollapse: _collapseAll,
      onModelSelected: (model) {
        NavigationHelper.navigateToModel(context, model);
        _expandModel(model);
      },
    );
  }

  Widget _buildExpandedModelView(BuildContext context, Model model) {
    return ModelWorkspaceCard(
      model: model,
      onCollapse: _collapseAll,
      onConceptSelected: (concept) {
        NavigationHelper.navigateToConcept(context, concept);
        _expandConcept(concept);
      },
    );
  }

  Widget _buildExpandedConceptView(BuildContext context, Concept concept) {
    // Get entities for this concept if it's an entry concept
    final entities =
        concept.entry &&
                BlocProvider.of<ConceptSelectionBloc>(
                      context,
                    ).state.selectedEntities !=
                    null
            ? BlocProvider.of<ConceptSelectionBloc>(
              context,
            ).state.selectedEntities!.toList()
            : <Entity>[];

    return ConceptWorkspaceCard(
      concept: concept,
      entities: entities,
      onCollapse: _collapseAll,
      onEntitySelected: (entity) {
        // Handle entity selection
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String message,
    IconData icon,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: context
                  .conceptColor('Workspace', role: 'icon')
                  .withValues(alpha: 255.0 * 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: context.conceptTextStyle(
                'Workspace',
                role: 'emptyStateTitle',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.conceptTextStyle(
                'Workspace',
                role: 'emptyStateMessage',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: Icon(icon),
              label: const Text('Create New'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // Helper to calculate grid columns based on screen width
  int _calculateGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > 1400) return 4; // Extra large screens
    if (width > 1000) return 3; // Large screens
    if (width > 700) return 2; // Medium screens
    return 1; // Small screens
  }

  // Expansion state management methods
  void _expandDomain(Domain domain) {
    setState(() {
      _expandedDomain = domain;
      _expandedModel = null;
      _expandedConcept = null;
    });
  }

  void _expandModel(Model model) {
    setState(() {
      _expandedDomain = null;
      _expandedModel = model;
      _expandedConcept = null;
    });
  }

  void _expandConcept(Concept concept) {
    setState(() {
      _expandedDomain = null;
      _expandedModel = null;
      _expandedConcept = concept;
    });
  }

  void _collapseAll() {
    setState(() {
      _expandedDomain = null;
      _expandedModel = null;
      _expandedConcept = null;
    });
  }
}
