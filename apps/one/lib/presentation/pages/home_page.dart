import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_event.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_state.dart';
import 'package:ednet_one/presentation/theme/theme.dart';
import 'package:ednet_one/presentation/theme/theme_constants.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/algorithms/master_detail_layout_algorithm.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/layout/graph/painters/meta_domain_canvas.dart';
import '../widgets/layout/web/footer_widget.dart';
import '../widgets/layout/web/left_sidebar_widget.dart';
import '../widgets/layout/web/main_content_widget.dart';
import '../widgets/layout/web/right_sidebar_widget.dart';

/// Main application page for EDNet One
///
/// This page serves as the primary entry point for the application interface.
/// It provides navigation across domains, models, and concepts, as well
/// as theme management and layout switching capabilities.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _showMetaCanvas = false;

  @override
  void initState() {
    super.initState();
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

  void _toggleTheme(BuildContext context) {
    context.read<ThemeBloc>().add(ToggleThemeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
          builder: (context, domainState) {
            return Row(
              children: [
                for (var domain in domainState.allDomains)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        context.read<DomainSelectionBloc>().add(
                          SelectDomainEvent(domain),
                        );

                        // Update models when domain changes
                        context.read<ModelSelectionBloc>().add(
                          UpdateModelsForDomainEvent(domain),
                        );
                      },
                      child: Text(
                        domain.code,
                        style: TextStyle(
                          fontWeight:
                              domain == domainState.selectedDomain
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                _ThemeDropdown(),
                Tooltip(
                  message: 'Show Domain Model DSL',
                  child: IconButton(
                    icon: const Icon(Icons.code),
                    onPressed: () => _showDSLFromGraph(context),
                  ),
                ),
                Tooltip(
                  message: 'Toggle Meta Canvas',
                  child: IconButton(
                    icon: const Icon(Icons.view_quilt),
                    onPressed: () {
                      setState(() {
                        _showMetaCanvas = !_showMetaCanvas;
                      });
                    },
                  ),
                ),
                Tooltip(
                  message: 'Toggle Theme',
                  child: IconButton(
                    icon: const Icon(Icons.brightness_6),
                    onPressed: () => _toggleTheme(context),
                  ),
                ),
                Tooltip(
                  message: 'Generate & Download Code',
                  child: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => _generateAndDownloadCode(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
        builder: (context, domainState) {
          return BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
            builder: (context, modelState) {
              return BlocBuilder<ConceptSelectionBloc, ConceptSelectionState>(
                builder: (context, conceptState) {
                  if (_showMetaCanvas) {
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
                  } else {
                    return Scaffold(
                      appBar: AppBar(
                        title: HeaderWidget(
                          filters: const [],
                          onAddFilter: (criteria) => print(criteria),
                          onBookmark: () => print('onBookmark'),
                          onPathSegmentTapped: print,
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
                          Expanded(
                            flex: 2,
                            child:
                                conceptState.availableConcepts.isEmpty
                                    ? const Center(child: Text('No Concepts'))
                                    : LeftSidebarWidget(
                                      entries: conceptState.availableConcepts,
                                      onConceptSelected: (concept) {
                                        context
                                            .read<ConceptSelectionBloc>()
                                            .add(SelectConceptEvent(concept));
                                      },
                                    ),
                          ),
                          // Main Content with Entities
                          Expanded(
                            flex: 8,
                            child:
                                conceptState.selectedEntities != null
                                    ? MainContentWidget(
                                      entities: conceptState.selectedEntities!,
                                    )
                                    : const Center(
                                      child: Text('No Entities Selected'),
                                    ),
                          ),
                          // Right Sidebar with Models
                          Expanded(
                            flex: 2,
                            child:
                                modelState.availableModels.isEmpty
                                    ? const Center(child: Text('No Models'))
                                    : RightSidebarWidget(
                                      models: modelState.availableModels,
                                      onModelSelected: (model) {
                                        context.read<ModelSelectionBloc>().add(
                                          SelectModelEvent(model),
                                        );

                                        // Update concepts when model changes
                                        context
                                            .read<ConceptSelectionBloc>()
                                            .add(
                                              UpdateConceptsForModelEvent(
                                                model,
                                              ),
                                            );
                                      },
                                    ),
                          ),
                        ],
                      ),
                      bottomNavigationBar: const FooterWidget(),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Theme dropdown widget for selecting between different theme styles
class _ThemeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final brightness =
            themeState.isDarkMode ? ThemeModes.dark : ThemeModes.light;
        final currentThemeName = themeState.themeName;

        return DropdownButton<String>(
          value: currentThemeName,
          hint: const Text('Select Theme'),
          items:
              themes[brightness]!.keys.map((String themeName) {
                return DropdownMenuItem<String>(
                  value: themeName,
                  child: Text(themeName),
                );
              }).toList(),
          onChanged: (themeName) {
            if (themeName != null) {
              context.read<ThemeBloc>().add(ChangeThemeEvent(themeName));
            }
          },
        );
      },
    );
  }
}
