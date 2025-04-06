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
import '../../widgets/layout/web/main_content_widget.dart';
import '../../widgets/canvas/meta_domain_canvas.dart';

// Importing domain_selector directly
import 'domain_selector.dart';

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
          '📱 After init - Domains available: ${domainState.availableDomains.length}',
        );
        if (domainState.availableDomains.isEmpty && domains.isNotEmpty) {
          // If BLoC doesn't have domains but application does, force direct update
          debugPrint('📱 Directly setting domains in BLoC');
          domainSelectionBloc.updateDomains(domains);
        }

        // 2. Select the first domain if none is selected
        final selectedDomain =
            domainState.selectedDomain ??
            (domainState.availableDomains.isNotEmpty
                ? domainState.availableDomains.first
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
    debugPrint('📱 Domains available: ${domainState.availableDomains.length}');
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
        domainState.availableDomains.isNotEmpty) {
      debugPrint(
        '📱 Auto-selecting first domain: ${domainState.availableDomains.first.code}',
      );
      NavigationHelper.navigateToDomain(
        context,
        domainState.availableDomains.first,
      );
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
    // Get screen size for responsive adjustments
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    // Get theme for consistent styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show drawer permanently if pinned
            if (_isDrawerPinned)
              SizedBox(
                width: isSmallScreen ? 240 : 300, // Adjust for screen size
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
                          // Check if we need to initialize selections
                          if (domainState.availableDomains.isNotEmpty &&
                              (domainState.selectedDomain == null ||
                                  modelState.selectedModel == null ||
                                  conceptState.selectedConcept == null)) {
                            // Use a post-frame callback to avoid build-phase navigation
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _initializeSelections();
                            });
                          }

                          // Show the meta domain canvas if enabled
                          if (_showMetaCanvas) {
                            return _buildMetaDomainCanvas(
                              domainState,
                              modelState,
                              conceptState,
                            );
                          }

                          // Main layout with improved accessibility and spacing
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Top section with improved selector spacing
                              Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: colorScheme.outlineVariant
                                          .withValues(alpha: 255.0 * 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 12.0 : 16.0,
                                  vertical: 12.0,
                                ),
                                child: Wrap(
                                  spacing: 16.0,
                                  runSpacing: 16.0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    // Domain selector with improved focus management
                                    Semantics(
                                      label: 'Domain Selection',
                                      child: DomainSelector(
                                        onDomainSelected:
                                            (domain) =>
                                                NavigationHelper.navigateToDomain(
                                                  context,
                                                  domain,
                                                ),
                                      ),
                                    ),

                                    // Model selector with improved focus management
                                    if (domainState.selectedDomain != null)
                                      Semantics(
                                        label: 'Model Selection',
                                        child: ModelSelector(
                                          onModelSelected:
                                              (model) =>
                                                  NavigationHelper.navigateToModel(
                                                    context,
                                                    model,
                                                  ),
                                        ),
                                      ),

                                    // Concept selector with improved focus management
                                    if (modelState.selectedModel != null)
                                      Semantics(
                                        label: 'Concept Selection',
                                        child: ConceptSelector(
                                          onConceptSelected:
                                              (concept) =>
                                                  NavigationHelper.navigateToConcept(
                                                    context,
                                                    concept,
                                                  ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Content area - expanded to fill remaining space
                              Expanded(
                                child:
                                    conceptState.selectedConcept != null &&
                                            conceptState.selectedEntities !=
                                                null
                                        ? MainContentWidget(
                                          entities:
                                              conceptState.selectedEntities!,
                                        )
                                        : _buildNoConceptSelectedMessage(
                                          context,
                                        ),
                              ),

                              // Footer with improved contrast
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.shadow.withValues(
                                        alpha: 255.0 * 0.1,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, -1),
                                    ),
                                  ],
                                  border: Border(
                                    top: BorderSide(
                                      color: colorScheme.outlineVariant
                                          .withValues(alpha: 255.0 * 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const FooterWidget(),
                              ),
                            ],
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
      ),
    );
  }

  /// Build the meta domain canvas view
  Widget _buildMetaDomainCanvas(
    DomainSelectionState domainState,
    ModelSelectionState modelState,
    ConceptSelectionState conceptState,
  ) {
    return MetaDomainCanvas(
      domains: domainState.availableDomains,
      layoutAlgorithm: MasterDetailLayoutAlgorithm(),
      decorators: const [],
      onTransformationChanged: (matrix) {},
      onChangeLayoutAlgorithm: (algorithm) {},
    );
  }

  /// Build a message for when no concept is selected
  Widget _buildNoConceptSelectedMessage(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 255.0 * 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Select a concept to view entities',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Use the selectors above to navigate through domains, models, and concepts',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
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
}
