import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

/// @deprecated Use HomePage from pages/home instead
/// This class is being phased out as part of the screens to pages migration.
/// It will be removed in a future release.
@Deprecated('Use HomePage from pages/home instead')
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, this.appLinks});

  final String title;
  final AppLinks? appLinks;

  @override
  HomePageState createState() => HomePageState();
}

/// @deprecated Use HomePageState from pages/home instead
@Deprecated('Use HomePageState from pages/home instead')
class HomePageState extends State<HomePage> {
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    if (widget.appLinks != null) {
      _sub = widget.appLinks!.uriLinkStream.listen(_handleBookmarkSelected);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleBookmarkSelected(Uri? uri) {
    // Placeholder
  }

  @override
  Widget build(BuildContext context) {
    // Use a simple scaffold to inform users about the migration
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This page has been migrated to a new implementation.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the home screen again - will use the new implementation
                // from main.dart since we're not directly importing it here
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Go to New Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}

// Old implementation retained for reference - will be removed in future
/* 
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
    context.read<DomainBloc>().add(domain_events.GenerateCodeEvent());
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
                                  domain_events.SelectDomainEvent(domain),
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
                                    ? domainState.selectedDomain!.toDomains()
                                    : Domains(),
                            initialTransformation: null,
                            onTransformationChanged: (m) {},
                            onChangeLayoutAlgorithm: (algo) {},
                            layoutAlgorithm: MasterDetailLayoutAlgorithm(),
                            decorators: const [],
                          )
                          : Scaffold(
                            appBar: AppBar(
                              title: HeaderWidget(
                                filters: const [],
                                onAddFilter:
                                    (header_types.FilterCriteria criteria) =>
                                        print(criteria),
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
                                                domain_events.SelectConceptEvent(
                                                  concept,
                                                ),
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
                                                domain_events.SelectModelEvent(
                                                  model,
                                                ),
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

// extension DomainToDomainsExtension on Domain {
//   Domains toDomains() {
//     final ds = Domains();
//     ds.add(this);
//     return ds;
//   }
// }

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
          context.read<ThemeBloc>().add(ChangeThemeEvent(themeName));
        }
      },
    );
  }
}
*/
