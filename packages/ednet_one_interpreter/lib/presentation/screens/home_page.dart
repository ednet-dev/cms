import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one_interpreter/presentation/widgets/layout/graph/algorithms/master_detail_layout_algorithm.dart';
import 'package:ednet_one_interpreter/presentation/widgets/layout/web/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/domain_block.dart';
import '../blocs/domain_event.dart';
import '../blocs/domain_state.dart';
import '../blocs/layout_block.dart';
import '../blocs/layout_event.dart';
import '../blocs/layout_state.dart';
import '../blocs/theme_block.dart';
import '../blocs/theme_event.dart';
import '../theme.dart';
import '../widgets/layout/graph/painters/meta_domain_canvas.dart';
import '../widgets/layout/web/footer_widget.dart';
import '../widgets/layout/web/left_sidebar_widget.dart';
import '../widgets/layout/web/main_content_widget.dart';
import '../widgets/layout/web/right_sidebar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.appLinks});

  final String title;
  final AppLinks appLinks;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.appLinks.uriLinkStream.listen(_handleBookmarkSelected);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleBookmarkSelected(Uri? uri) {
    // If needed, handle incoming link
  }

  void _showDSLFromGraph(BuildContext context) {
    final domainBloc = context.read<DomainBloc>();
    final dsl = domainBloc.getDSL();
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
    context.read<DomainBloc>().add(GenerateCodeEvent());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code generation & download triggered.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DomainBloc, DomainState>(
      builder: (context, domainState) {
        return BlocBuilder<LayoutBloc, LayoutState>(
          builder: (context, layoutState) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                final showMetaCanvas =
                    layoutState.layoutType == LayoutType.alternativeLayout;

                return Scaffold(
                  appBar: AppBar(
                    title: Row(
                      children: [
                        for (var domain
                            in context.read<DomainBloc>().app.groupedDomains)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                context.read<DomainBloc>().add(
                                  SelectDomainEvent(domain),
                                );
                              },
                              child: Text(domain.code),
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
                              // Instead of toggling showMetaCanvas via setState,
                              // we can keep layout toggling in LayoutBloc.
                              context.read<LayoutBloc>().add(
                                ToggleLayoutEvent(),
                              );
                            },
                          ),
                        ),
                        Tooltip(
                          message: 'Toggle Layout',
                          child: IconButton(
                            icon: const Icon(Icons.swap_horiz),
                            onPressed: () {
                              context.read<LayoutBloc>().add(
                                ToggleLayoutEvent(),
                              );
                            },
                          ),
                        ),
                        Tooltip(
                          message: 'Toggle Theme',
                          child: IconButton(
                            icon: const Icon(Icons.brightness_6),
                            onPressed: () {
                              context.read<ThemeBloc>().add(ToggleThemeEvent());
                            },
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
                    ),
                  ),
                  body:
                      showMetaCanvas
                          ? MetaDomainCanvas(
                            domains:
                                domainState.selectedDomain != null
                                    ? (() {
                                      final ds = Domains();
                                      ds.add(domainState.selectedDomain!);
                                      return ds;
                                    })()
                                    : Domains(),
                            initialTransformation: null,
                            onTransformationChanged: (m) {},
                            onChangeLayoutAlgorithm: (algo) {},
                            layoutAlgorithm:
                                const MasterDetailLayoutAlgorithm(),
                            decorators: const [],
                          )
                          : Scaffold(
                            appBar: AppBar(
                              title: HeaderWidget(
                                filters: const [],
                                onAddFilter: (criteria) => print(criteria),
                                onBookmark: () => print('onBookmark'),
                                onPathSegmentTapped: print,
                                path: const ['Home'],
                              ),
                            ),
                            body: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child:
                                      domainState.selectedEntries == null
                                          ? const Center(
                                            child: Text('No Entries'),
                                          )
                                          : LeftSidebarWidget(
                                            entries:
                                                domainState.selectedEntries
                                                    as Concepts,
                                            onConceptSelected: (concept) {
                                              context.read<DomainBloc>().add(
                                                SelectConceptEvent(concept),
                                              );
                                            },
                                          ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child:
                                      domainState.selectedConcept != null
                                          ? MainContentWidget(
                                            entities:
                                                domainState.selectedEntities ??
                                                Entities<Concept>(),
                                          )
                                          : const Text('No Concept selected'),
                                ),
                                Expanded(
                                  flex: 2,
                                  child:
                                      domainState.selectedDomain != null
                                          ? RightSidebarWidget(
                                            models:
                                                domainState
                                                    .selectedDomain!
                                                    .models,
                                            onModelSelected: (model) {
                                              context.read<DomainBloc>().add(
                                                SelectModelEvent(model),
                                              );
                                            },
                                          )
                                          : const Text('No Domain selected'),
                                ),
                              ],
                            ),
                            bottomNavigationBar: const FooterWidget(),
                          ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ThemeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeBloc>().state;
    final brightness = themeState.isDarkMode ? 'dark' : 'light';
    final currentThemeName = themes[brightness]!.keys.firstWhere(
      (themeName) => themes[brightness]![themeName] == themeState.themeData,
      orElse: () => themes[brightness]!.keys.first,
    );

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
          final themeData = themes[brightness]![themeName]!;
          context.read<ThemeBloc>().add(ChangeThemeEvent(themeData));
        }
      },
    );
  }
}
