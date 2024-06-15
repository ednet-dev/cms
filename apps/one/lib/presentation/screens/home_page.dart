// my_home_page.dart
// ednet core
// ednet cms
import 'package:app_links/app_links.dart';
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/layout_block.dart';
import '../blocs/layout_event.dart';
import '../blocs/layout_state.dart';
import '../blocs/theme_block.dart';
import '../widgets/layout/graph/meta_domain_canvas.dart';
import '../widgets/layout/web/left_sidebar_widget.dart';
import '../widgets/layout/web/right_sidebar_widget.dart';
import 'entries_sidebar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.appLinks});

  final String title;
  final AppLinks appLinks;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> path = ['Home'];

  late OneApplication app;
  Domain? selectedDomain;
  Model? selectedModel;
  Entities? selectedEntries;
  Entity? selectedEntity;

  List<Bookmark> bookmarks = [];
  BookmarkManager bookmarkManager = BookmarkManager();

  bool showMetaCanvas = false;
  LayoutAlgorithm _selectedAlgorithm =
      ForceDirectedLayoutAlgorithm() as LayoutAlgorithm;

  @override
  void initState() {
    super.initState();
    app = OneApplication();

    if (app.domains.isNotEmpty) {
      selectedDomain = app.domains.first;
      if (selectedDomain!.models.isNotEmpty) {
        selectedModel = selectedDomain!.models.first;
        if (selectedModel!.concepts.isNotEmpty) {
          selectedEntries = selectedModel!.concepts;
        }
      }
    }

    widget.appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleBookmarkSelected(uri.toString());
      }
    });
  }

  void _handleDomainSelected(Domain domain) {
    setState(() {
      selectedDomain = domain;
      selectedModel = domain.models.isNotEmpty ? domain.models.first : null;
      selectedEntries = selectedModel?.concepts.isNotEmpty ?? false
          ? selectedModel!.concepts
          : null;
    });
  }

  void _handleModelSelected(Model model) {
    setState(() {
      selectedModel = model;
      selectedEntries = model.concepts.isNotEmpty ? model.concepts : null;
    });
  }

  void _handleBookmarkSelected(String bookmark) {
    // Implement bookmark selection logic here
  }

  void _changeLayoutAlgorithm(LayoutAlgorithm algorithm) {
    setState(() {
      _selectedAlgorithm = algorithm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(Icons.view_quilt),
              onPressed: () {
                setState(() {
                  showMetaCanvas = !showMetaCanvas;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.swap_horiz),
              onPressed: () {
                context.read<LayoutBloc>().add(ToggleLayoutEvent());
              },
            ),
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                BlocProvider.of<ThemeBloc>(context).toggleTheme();
              },
            ),
          ],
        ),
        body: BlocProvider(
          create: (context) => LayoutBloc(),
          child: BlocBuilder<LayoutBloc, LayoutState>(
            builder: (context, state) {
              if (showMetaCanvas) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LayoutAlgorithmIcon(
                          icon: Icons.auto_fix_high,
                          name: 'Force Directed',
                          onTap: () => _changeLayoutAlgorithm(
                              ForceDirectedLayoutAlgorithm()
                                  as LayoutAlgorithm),
                        ),
                        LayoutAlgorithmIcon(
                          icon: Icons.grid_on,
                          name: 'Grid',
                          onTap: () => _changeLayoutAlgorithm(
                              GridLayoutAlgorithm() as LayoutAlgorithm),
                        ),
                        LayoutAlgorithmIcon(
                          icon: Icons.circle,
                          name: 'Circular',
                          onTap: () => _changeLayoutAlgorithm(
                              CircularLayoutAlgorithm() as LayoutAlgorithm),
                        ),
                        LayoutAlgorithmIcon(
                          icon: Icons.format_indent_increase,
                          name: 'Master Detail',
                          onTap: () => _changeLayoutAlgorithm(
                              MasterDetailLayoutAlgorithm() as LayoutAlgorithm),
                        ),
                      ],
                    ),
                    Expanded(
                      child: MetaDomainCanvas(
                        domains: app.domains,
                        layoutAlgorithm: _selectedAlgorithm,
                        decorators: [],
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    LeftSidebarWidget(
                      domains: app.domains,
                      onDomainSelected: _handleDomainSelected,
                    ),
                    if (selectedDomain != null)
                      RightSidebarWidget(
                        models: selectedDomain!.models,
                        onModelSelected: _handleModelSelected,
                      ),
                    if (selectedEntries != null)
                      EntriesSidebarWidget(
                        entries: selectedEntries!,
                      ),
                  ],
                );
              }
            },
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                // Handle zoom in
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(Icons.add, color: Colors.white),
            ),
            SizedBox(width: 16.0),
            FloatingActionButton(
              onPressed: () {
                // Handle zoom out
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(Icons.remove, color: Colors.white),
            ),
          ],
        ));
  }
}
