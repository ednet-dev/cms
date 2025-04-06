import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State management blocs
// Import OneApplication
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';

// Main application reference
import 'package:ednet_one/main.dart' show oneApplication;

// Refactored components
import 'concept_selector.dart';
import 'home_app_bar.dart';
import 'home_drawer.dart';
import 'model_selector.dart';

// Layout components
import '../../widgets/layout/graph/algorithms/master_detail_layout_algorithm.dart';
import '../../widgets/layout/web/footer_widget.dart';
import '../../widgets/layout/web/header_widget.dart';
import '../../widgets/layout/web/main_content_widget.dart';
import '../../widgets/canvas/meta_domain_canvas.dart';

/// Main application page for EDNet One
///
/// This page serves as the primary entry point for the application interface.
/// It provides navigation across domains, models, and concepts, as well
/// as theme management and layout switching capabilities.
class HomePage extends StatefulWidget {
  /// Title of the home page
  final String title;

  /// Constructor for HomePage
  const HomePage({super.key, required this.title});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const String _drawerPinnedKey = 'drawer_pinned';

  bool _showMetaCanvas = false;
  bool _isDrawerPinned = true; // Default to pinned
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadDrawerState();

    // Allow the UI to build first, then initialize selections
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Force a more comprehensive initialization
      _forceInitialSelections();
    });
  }

  /// A more robust method to force initial selection of domain/model/concept
  void _forceInitialSelections() {
    debugPrint('📱 Force initializing selections from application data');

    try {
      // Get direct access to the application data
      final domains = oneApplication.groupedDomains;
      debugPrint('📱 Direct access - Domains available: ${domains.length}');

      if (domains.isEmpty) {
        debugPrint('❌ No domains available in OneApplication!');
        return;
      }

      // 1. Force domain selection initialization first
      final domainSelectionBloc = context.read<DomainSelectionBloc>();
      domainSelectionBloc.add(InitializeDomainSelectionEvent());

      // Wait briefly for the initialization to take effect
      Future.delayed(const Duration(milliseconds: 100), () {
        final domainState = domainSelectionBloc.state;

        debugPrint(
          '📱 After init - Domains available: ${domainState.allDomains.length}',
        );
        if (domainState.allDomains.isEmpty && domains.isNotEmpty) {
          // If BLoC doesn't have domains but application does, force direct update
          debugPrint('📱 Directly setting domains in BLoC');
          domainSelectionBloc.updateDomainsDirectly(domains);
        }

        // 2. Select the first domain if none is selected
        final selectedDomain =
            domainState.selectedDomain ??
            (domainState.allDomains.isNotEmpty
                ? domainState.allDomains.first
                : null);

        if (selectedDomain == null && domains.isNotEmpty) {
          debugPrint('📱 Force selecting first domain: ${domains.first.code}');
          domainSelectionBloc.add(SelectDomainEvent(domains.first));
        } else if (selectedDomain != null) {
          debugPrint('📱 Domain selected: ${selectedDomain.code}');

          // 3. Handle model selection
          final modelSelectionBloc = context.read<ModelSelectionBloc>();
          modelSelectionBloc.add(UpdateModelsForDomainEvent(selectedDomain));

          // Wait briefly for models to update
          Future.delayed(const Duration(milliseconds: 100), () {
            final modelState = modelSelectionBloc.state;
            debugPrint(
              '📱 Models available: ${modelState.availableModels.length}',
            );

            if (modelState.availableModels.isEmpty &&
                selectedDomain.models.isNotEmpty) {
              debugPrint('📱 Directly updating models in BLoC');
              modelSelectionBloc.updateModelsDirectly(selectedDomain.models);
            }

            // 4. Select first model if none selected (specifically avoid Application model if possible)
            if (modelState.selectedModel == null &&
                modelState.availableModels.isNotEmpty) {
              // Try to find a model other than "Application" to select by default
              Model? firstModel;

              // First try to find a model that's not "Application"
              for (var model in modelState.availableModels) {
                if (model.code.toLowerCase() != "application") {
                  firstModel = model;
                  break;
                }
              }

              // If no other model is found, use the first one (even if it's Application)
              firstModel ??= modelState.availableModels.first;

              debugPrint('📱 Force selecting model: ${firstModel.code}');
              modelSelectionBloc.add(SelectModelEvent(firstModel));
            } else if (modelState.selectedModel != null) {
              final selectedModel = modelState.selectedModel!;
              debugPrint('📱 Model selected: ${selectedModel.code}');

              // 5. Handle concept selection, but be careful with Application model
              final conceptSelectionBloc = context.read<ConceptSelectionBloc>();

              // Check if this is the Application model, which might need special handling
              if (selectedModel.code.toLowerCase() == "application") {
                debugPrint(
                  '📱 Application model detected - using special handling',
                );
                try {
                  conceptSelectionBloc.add(
                    UpdateConceptsForModelEvent(selectedModel),
                  );
                } catch (e) {
                  debugPrint(
                    '📱 Error updating concepts for Application model: $e',
                  );
                  // For Application model, we might need to handle failure gracefully
                }
              } else {
                // Regular model handling
                conceptSelectionBloc.add(
                  UpdateConceptsForModelEvent(selectedModel),
                );
              }

              // Wait briefly for concepts to update
              Future.delayed(const Duration(milliseconds: 100), () {
                final conceptState = conceptSelectionBloc.state;
                debugPrint(
                  '📱 Concepts available: ${conceptState.availableConcepts.length}',
                );

                if (conceptState.availableConcepts.isEmpty &&
                    selectedModel.concepts.isNotEmpty) {
                  debugPrint('📱 Directly updating concepts in BLoC');
                  conceptSelectionBloc.updateConceptsDirectly(
                    selectedModel.concepts,
                  );
                }

                // 6. Select first concept if none selected
                if (conceptState.selectedConcept == null &&
                    conceptState.availableConcepts.isNotEmpty) {
                  final firstConcept = conceptState.availableConcepts.first;
                  debugPrint(
                    '📱 Force selecting first concept: ${firstConcept.code}',
                  );
                  debugPrint(
                    '📱 Concept details - entry: ${firstConcept.entry}, attributes: ${firstConcept.attributes.length}',
                  );

                  // Log any test entities that should be there
                  try {
                    // Try to get entities through a safer method
                    // Concepts don't have direct getEntities, we need to check if it's entry
                    if (firstConcept.entry) {
                      debugPrint(
                        '📱 This is an entry concept - should have entities',
                      );
                    } else {
                      debugPrint(
                        '📱 Not an entry concept - may not have entities',
                      );
                    }
                  } catch (e) {
                    debugPrint('📱 Error accessing concept details: $e');
                  }

                  conceptSelectionBloc.add(SelectConceptEvent(firstConcept));

                  // Check entities after selection (should happen in next event cycle)
                  Future.delayed(const Duration(milliseconds: 100), () {
                    final updatedState = conceptSelectionBloc.state;
                    debugPrint(
                      '📱 After selection - Entities: ${updatedState.selectedEntities?.length ?? 0}',
                    );

                    // If still no entities but concept has entry flag, try forcing entity load
                    if ((updatedState.selectedEntities == null ||
                            updatedState.selectedEntities!.isEmpty) &&
                        firstConcept.entry) {
                      try {
                        debugPrint('📱 Forcing entity load for entry concept');
                        // Manually refresh entities for this concept
                        conceptSelectionBloc.add(
                          RefreshConceptEvent(firstConcept),
                        );
                      } catch (e) {
                        debugPrint('📱 Error forcing entity load: $e');
                      }
                    }
                  });
                }
              });
            }
          });
        }
      });
    } catch (e, stack) {
      debugPrint('❌ Error in _forceInitialSelections: $e');
      debugPrint('❌ Stack trace: $stack');
    }
  }

  /// Initialize domain, model, and concept selections if not already selected
  void _initializeSelections() {
    final domainState = context.read<DomainSelectionBloc>().state;
    final modelState = context.read<ModelSelectionBloc>().state;
    final conceptState = context.read<ConceptSelectionBloc>().state;

    debugPrint('📱 Initializing selections:');
    debugPrint('📱 Domains available: ${domainState.allDomains.length}');
    debugPrint('📱 Current domain: ${domainState.selectedDomain?.code}');
    debugPrint('📱 Models available: ${modelState.availableModels.length}');
    debugPrint('📱 Current model: ${modelState.selectedModel?.code}');
    debugPrint(
      '📱 Concepts available: ${conceptState.availableConcepts.length}',
    );
    debugPrint('📱 Current concept: ${conceptState.selectedConcept?.code}');
    debugPrint(
      '📱 Entities available: ${conceptState.selectedEntities?.length ?? 0}',
    );

    // If no domain is selected but domains are available, select the first one
    if (domainState.selectedDomain == null &&
        domainState.allDomains.isNotEmpty) {
      debugPrint(
        '📱 Auto-selecting first domain: ${domainState.allDomains.first.code}',
      );
      NavigationHelper.navigateToDomain(context, domainState.allDomains.first);
    }
    // If domain is selected but no model is selected, select the first model
    else if (domainState.selectedDomain != null &&
        modelState.selectedModel == null &&
        modelState.availableModels.isNotEmpty) {
      debugPrint(
        '📱 Auto-selecting first model: ${modelState.availableModels.first.code}',
      );
      NavigationHelper.navigateToModel(
        context,
        modelState.availableModels.first,
      );
    }
    // If model is selected but no concept is selected, select the first concept
    else if (modelState.selectedModel != null &&
        conceptState.selectedConcept == null &&
        conceptState.availableConcepts.isNotEmpty) {
      debugPrint(
        '📱 Auto-selecting first concept: ${conceptState.availableConcepts.first.code}',
      );
      NavigationHelper.navigateToConcept(
        context,
        conceptState.availableConcepts.first,
      );
    }
  }

  Future<void> _loadDrawerState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDrawerPinned =
          prefs.getBool(_drawerPinnedKey) ?? true; // Default to pinned
    });
  }

  void _handleDrawerPinStateChanged(bool isPinned) {
    setState(() {
      _isDrawerPinned = isPinned;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showDSLFromGraph(BuildContext context) {
    final conceptBloc = context.read<ConceptSelectionBloc>();
    final dsl = conceptBloc.getDSL();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('DSL Export'),
          content: SelectableText(dsl),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generateAndDownloadCode(BuildContext context) async {
    // Trigger code generation event
    context.read<ConceptSelectionBloc>().add(GenerateCodeEvent());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code generation & download triggered.')),
    );
  }

  void _toggleCanvas() {
    setState(() {
      _showMetaCanvas = !_showMetaCanvas;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create a responsive layout that handles the pinned drawer
    return Scaffold(
      key: _scaffoldKey,
      appBar: HomeAppBar(
        title: widget.title,
        isCanvasVisible: _showMetaCanvas,
        onShowDSL: () => _showDSLFromGraph(context),
        onToggleCanvas: _toggleCanvas,
        onGenerateCode: () => _generateAndDownloadCode(context),
        // Only show menu button if drawer isn't pinned
        showMenuButton: !_isDrawerPinned,
      ),
      // Use drawer or show permanently based on pin state
      drawer: _isDrawerPinned ? null : _buildDrawer(),
      // Adjust body layout based on drawer being pinned or not
      body: Row(
        children: [
          // Show drawer permanently if pinned
          if (_isDrawerPinned)
            SizedBox(
              width: 300, // Wider drawer for better readability
              child: _buildDrawer(),
            ),

          // Main content area
          Expanded(
            child: BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
              builder: (context, domainState) {
                return BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
                  builder: (context, modelState) {
                    return BlocBuilder<
                      ConceptSelectionBloc,
                      ConceptSelectionState
                    >(
                      builder: (context, conceptState) {
                        // Show the meta domain canvas if enabled
                        if (_showMetaCanvas) {
                          return _buildMetaCanvas(domainState);
                        }

                        // Otherwise show the standard layout with selectors and content
                        return _buildStandardLayout(
                          context,
                          domainState,
                          modelState,
                          conceptState,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the drawer with consistent parameters
  Widget _buildDrawer() {
    return HomeDrawer(
      isPinned: _isDrawerPinned,
      onPinStateChanged: _handleDrawerPinStateChanged,
      onSettings: () {
        // Handle settings navigation
      },
      onDocs: () {
        // Handle docs navigation
      },
      onHelp: () {
        // Handle help navigation
      },
      onAbout: () {
        // Handle about navigation
      },
    );
  }

  /// Builds the meta domain canvas view
  Widget _buildMetaCanvas(DomainSelectionState domainState) {
    final domains = Domains();
    if (domainState.selectedDomain != null) {
      domains.add(domainState.selectedDomain!);
    }

    return MetaDomainCanvas(
      domains: domains,
      initialTransformation: null,
      onTransformationChanged: (m) {},
      onChangeLayoutAlgorithm: (algo) {},
      layoutAlgorithm: MasterDetailLayoutAlgorithm(),
      decorators: const [],
    );
  }

  /// Builds the standard layout with sidebars and content area
  Widget _buildStandardLayout(
    BuildContext context,
    DomainSelectionState domainState,
    ModelSelectionState modelState,
    ConceptSelectionState conceptState,
  ) {
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    final useCompactLayout = screenWidth < 1100;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Show loading state if domains are still empty but OneApplication has domains
    final appHasDomains = oneApplication.groupedDomains.isNotEmpty;
    final uiHasDomains = domainState.allDomains.isNotEmpty;

    if (appHasDomains && !uiHasDomains) {
      // Application has data, but UI doesn't yet - still initializing
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Initializing domain data...',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Available domains: ${oneApplication.groupedDomains.length}',
              style: theme.textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: _forceInitialSelections,
              child: const Text('Force Initialization'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Don't show back button in nested scaffold
        title: HeaderWidget(
          filters: const [],
          onAddFilter: (criteria) {
            debugPrint('Filter criteria: $criteria');
          },
          onBookmark: () {
            debugPrint('Bookmark action triggered');
          },
          onBookmarkCreated: (bookmark) {
            debugPrint('Bookmark created: ${bookmark.title}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bookmark created: ${bookmark.title}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
      body:
          useCompactLayout
              // Compact layout for smaller screens - stack the panels vertically
              ? Column(
                children: [
                  // Top row with concept and model selectors
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        // Left panel - Concepts
                        Expanded(
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ConceptSelector(),
                          ),
                        ),
                        // Right panel - Models
                        Expanded(
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ModelSelector(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main content area
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child:
                          conceptState.selectedEntities != null
                              ? MainContentWidget(
                                entities: conceptState.selectedEntities!,
                              )
                              : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 48,
                                      color: colorScheme.primary.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No Entities Selected',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Select a domain, model, and concept to view entities',
                                      style: theme.textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ),
                ],
              )
              // Standard layout for larger screens - side by side panels
              : Row(
                children: [
                  // Left Sidebar with Concepts - smaller for better proportions
                  Expanded(
                    flex: 2,
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ConceptSelector(),
                    ),
                  ),

                  // Main Content with Entities - larger to show more content
                  Expanded(
                    flex: 5,
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child:
                          conceptState.selectedEntities != null
                              ? MainContentWidget(
                                entities: conceptState.selectedEntities!,
                              )
                              : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 48,
                                      color: colorScheme.primary.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No Entities Selected',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Select a domain, model, and concept to view entities',
                                      style: theme.textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                    if (conceptState.selectedConcept !=
                                        null) ...[
                                      const SizedBox(height: 16),
                                      Text(
                                        'Selected concept: ${conceptState.selectedConcept!.code}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      Text(
                                        'Is entry concept: ${conceptState.selectedConcept!.entry}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          final conceptBloc =
                                              context
                                                  .read<ConceptSelectionBloc>();
                                          conceptBloc.add(
                                            RefreshConceptEvent(
                                              conceptState.selectedConcept!,
                                            ),
                                          );
                                        },
                                        child: const Text('Refresh Entities'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                    ),
                  ),

                  // Right Sidebar with Models - smaller for better proportions
                  Expanded(
                    flex: 2,
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ModelSelector(),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: const FooterWidget(),
    );
  }
}
