// my_home_page.dart
// ednet core
// ednet cms
import 'package:app_links/app_links.dart';
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/presentation/household_management/blocs/theme_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/layout_block.dart';
import '../blocs/layout_event.dart';
import '../blocs/layout_state.dart';
import '../widgets/layout/graph/meta_domain_canvas.dart';
import '../widgets/layout/header_widget.dart';
import '../widgets/layout/left_sidebar_widget.dart';
import '../widgets/layout/right_sidebar_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.appLinks});

  final String title;
  final AppLinks appLinks;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> path = ['Home'];

  late OneApplication app;
  Domain? selectedDomain;
  Model? selectedModel;
  Entities? selectedEntries;
  Entity? selectedEntity;

  List<Bookmark> bookmarks = [];
  BookmarkManager bookmarkManager = BookmarkManager();

  bool showMetaCanvas = false;
  LayoutAlgorithm _selectedAlgorithm = ForceDirectedLayoutAlgorithm();

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                      IconButton(
                        icon: Icon(Icons.auto_fix_high),
                        onPressed: () => _changeLayoutAlgorithm(
                            ForceDirectedLayoutAlgorithm()),
                      ),
                      IconButton(
                        icon: Icon(Icons.grid_on),
                        onPressed: () =>
                            _changeLayoutAlgorithm(GridLayoutAlgorithm()),
                      ),
                    ],
                  ),
                  Expanded(
                    child: MetaDomainCanvas(
                      domains: app.domains,
                      layoutAlgorithm: _selectedAlgorithm,
                      decorators: [
                        UXDecorator(
                          color: Colors.blue,
                          strokeWidth: 2.0,
                          radius: 10.0,
                        ),
                      ],
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
    );
  }
}

class DomainDetailScreen extends StatelessWidget {
  final Domain domain;
  final List<String> path;
  final void Function(Model model) onModelSelected;

  DomainDetailScreen({required this.domain, required this.onModelSelected})
      : path = ['Home', domain.code];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: path,
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else if (index == 1) {
              Navigator.pop(context);
            }
          },
          filters: [],
          onAddFilter: (FilterCriteria filter) {},
          onBookmark: () {},
        ),
      ),
      body: ModelsWidget(
        models: domain.models,
        onModelSelected: (model) {
          onModelSelected(model);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModelDetailScreen(
                domain: domain,
                model: model,
                path: path + [model.code],
                onEntitySelected: (entity) {
                  // Handle entity selection
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ModelDetailScreen extends StatelessWidget {
  final Domain domain;
  final Model model;
  final List<String> path;
  final void Function(Entity entity) onEntitySelected;

  ModelDetailScreen({
    required this.domain,
    required this.model,
    required this.path,
    required this.onEntitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: path,
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else if (index == 1) {
              Navigator.popUntil(context, ModalRoute.withName('/domain'));
            } else if (index == 2) {
              Navigator.pop(context);
            }
          },
          filters: [],
          onAddFilter: (FilterCriteria filter) {},
          onBookmark: () {},
        ),
      ),
      body: EntitiesWidget(
        entities: model.concepts,
        onEntitySelected: (entity) {
          onEntitySelected(entity);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntityDetailScreen(
                entity: entity,
              ),
            ),
          );
        },
        bookmarkManager: BookmarkManager(),
        onBookmarkCreated: (Bookmark bookmark) {},
      ),
    );
  }
}

class DomainsWidget extends StatelessWidget {
  final Domains domains;
  final void Function(Domain domain)? onDomainSelected;

  DomainsWidget({required this.domains, this.onDomainSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: domains.length,
      itemBuilder: (context, index) {
        var domain = domains.elementAt(index);
        return ListTile(
          title: Text(domain.code),
          onTap: () {
            if (onDomainSelected != null) {
              onDomainSelected!(domain);
            }
          },
        );
      },
    );
  }
}

class EntriesSidebarWidget extends StatelessWidget {
  final Entities entries;

  EntriesSidebarWidget({
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entity = entries.elementAt(index);
          return ListTile(
            title: Text(entity.code),
            onTap: () {
              // Handle entity selection
            },
          );
        },
      ),
    );
  }
}
