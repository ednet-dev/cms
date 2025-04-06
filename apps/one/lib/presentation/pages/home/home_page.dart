import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State management blocs
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';

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
  bool _isDrawerPinned = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadDrawerState();
  }

  Future<void> _loadDrawerState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDrawerPinned = prefs.getBool(_drawerPinnedKey) ?? false;
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
              width: 280, // Standard drawer width
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
          onPathSegmentTapped: (segment) {
            debugPrint('Path segment tapped: $segment');
          },
          path: [
            'Home',
            if (domainState.selectedDomain != null)
              domainState.selectedDomain!.code,
            if (modelState.selectedModel != null)
              modelState.selectedModel!.code,
            if (conceptState.selectedConcept != null)
              conceptState.selectedConcept!.code,
          ],
        ),
      ),
      body: Row(
        children: [
          // Left Sidebar with Concepts
          Expanded(flex: 2, child: ConceptSelector()),

          // Main Content with Entities
          Expanded(
            flex: 8,
            child:
                conceptState.selectedEntities != null
                    ? MainContentWidget(
                      entities: conceptState.selectedEntities!,
                    )
                    : const Center(child: Text('No Entities Selected')),
          ),

          // Right Sidebar with Models
          Expanded(flex: 2, child: ModelSelector()),
        ],
      ),
      bottomNavigationBar: const FooterWidget(),
    );
  }
}
