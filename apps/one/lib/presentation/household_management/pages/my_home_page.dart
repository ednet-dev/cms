// my_home_page.dart
// ednet core
// ednet cms
import 'package:app_links/app_links.dart';
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/presentation/household_management/blocs/theme_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/layout_block.dart';
import '../blocs/layout_event.dart';
import '../blocs/layout_state.dart';
import '../one_application.dart';
import '../widgets/layout/alternative_layout.dart';
import '../widgets/layout/footer_widget.dart';
import '../widgets/layout/header_widget.dart';
import '../widgets/layout/layout_template.dart';
import '../widgets/layout/left_sidebar_widget.dart';
import '../widgets/layout/main_content_widget.dart';
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
  late Domain selectedDomain;
  late Model selectedModel;
  Entity? selectedEntity;

  List<Bookmark> bookmarks = [];
  BookmarkManager bookmarkManager = BookmarkManager();

  @override
  void initState() {
    super.initState();
    app = OneApplication();

    if (app.domains.isNotEmpty) {
      selectedDomain = app.domains.first;
      if (selectedDomain.models.isNotEmpty) {
        selectedModel = selectedDomain.models.first;
        if (selectedModel.concepts.isNotEmpty) {
          selectedEntity = null;
        }
      }
    }

    _loadBookmarks();
    widget.appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleBookmarkSelected(uri.toString());
      }
    });
  }

  void _loadBookmarks() async {
    final loadedBookmarks = await bookmarkManager.getBookmarks();
    setState(() {
      bookmarks = loadedBookmarks;
    });
  }

  void _handleBookmarkCreated(Bookmark bookmark) {
    setState(() {
      bookmarks.add(bookmark);
    });
  }

  void _handleBookmarkSelected(String bookmark) {
    final uri = Uri.parse(bookmark);
    final filters = uri.queryParameters['filters']?.split(',') ?? [];
    // Restore filters, domain, and model based on the bookmark
    // This part needs implementation based on your specific logic
  }

  void _handleRemoveBookmark(Bookmark bookmark) async {
    await bookmarkManager.removeBookmark(bookmark.url);
    setState(() {
      bookmarks.remove(bookmark);
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
            if (state.layoutType == LayoutType.defaultLayout) {
              return LayoutTemplate(
                header: HeaderWidget(
                  path: path,
                  onPathSegmentTapped: (index) {
                    _handlePathSegmentTapped(context, index);
                  },
                  filters: [],
                  onAddFilter: (FilterCriteria filter) {},
                  onBookmark: () {},
                ),
                leftSidebar: LeftSidebarWidget(
                  items: selectedModel.concepts,
                  onEntitySelected: (entity) {
                    setState(() {
                      path.add(
                          entity.getStringFromAttribute('name') ?? 'Entity');
                    });
                    BlocProvider.of<LayoutBloc>(context)
                        .add(SelectEntityEvent(entity: entity));
                  },
                  model: selectedModel,
                  domain: selectedDomain,
                ),
                rightSidebar: RightSidebarWidget(
                  domains: app.domains,
                  onDomainSelected: (domain) {
                    setState(() {
                      path = ['Home', domain.code];
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DomainDetailScreen(
                          domain: domain,
                          onModelSelected: _handleModelSelected,
                        ),
                      ),
                    );
                  },
                  onModelSelected: (model) {
                    setState(() {
                      path = ['Home', model.domain.code, model.code];
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModelDetailScreen(
                          domain: model.domain,
                          model: model,
                          path: path,
                          onEntitySelected: _handleEntitySelected,
                        ),
                      ),
                    );
                  },
                ),
                mainContent: !selectedModel.concepts.isEmpty
                    ? MainContentWidget(
                        entity: state.selectedEntity ??
                            selectedModel.concepts.first,
                        onEntitySelected: (entity) {
                          setState(() {
                            path.add(entity.getStringFromAttribute('name') ??
                                'Entity');
                          });
                          BlocProvider.of<LayoutBloc>(context)
                              .add(SelectEntityEvent(entity: entity));
                        },
                      )
                    : Text('Empty collection.'),
                footer: const FooterWidget(),
              );
            } else {
              return AlternativeLayout(
                domains: app.domains,
                selectedEntity: state.selectedEntity,
                onEntitySelected: (entity) {
                  setState(() {
                    path.add(entity.getStringFromAttribute('name') ?? 'Entity');
                  });
                  BlocProvider.of<LayoutBloc>(context)
                      .add(SelectEntityEvent(entity: entity));
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Wrap(
          children: bookmarks
              .map((bookmark) => ListTile(
                    title: Text(bookmark.title ?? ''),
                    onTap: () => _handleBookmarkSelected(bookmark.url),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _handleRemoveBookmark(bookmark),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _handlePathSegmentTapped(BuildContext context, int index) {
    if (index < path.length - 1) {
      setState(() {
        path = path.sublist(0, index + 1);
      });
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  void _handleModelSelected(Model model) {
    setState(() {
      path.add(model.code);
    });
  }

  void _handleEntitySelected(Entity entity) {
    setState(() {
      path.add(entity.getStringFromAttribute('name') ?? 'Entity');
    });
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

// class EntitiesWidget extends StatefulWidget {
//   final Entities<Concept> entities;
//   final void Function(Bookmark bookmark) onBookmarkCreated;
//   final BookmarkManager bookmarkManager;
//
//   EntitiesWidget(
//       {required this.entities,
//       required this.onBookmarkCreated,
//       required this.bookmarkManager,
//       required void Function(Entity<Entity> entity) onEntitySelected});
//
//   @override
//   _EntitiesWidgetState createState() => _EntitiesWidgetState();
// }
//
// class _EntitiesWidgetState extends State<EntitiesWidget> {
//   List<FilterCriteria> _filters = [];
//   List<Entity> _filteredEntities = [];
//   ScrollController _scrollController = ScrollController();
//   bool _isBookmarking = false;
//   TextEditingController _bookmarkTitleController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _applyFilters();
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       _loadMoreEntities();
//     }
//   }
//
//   void _applyFilters() {
//     setState(() {
//       _filteredEntities = widget.entities.where((entity) {
//         for (var filter in _filters) {
//           if (!_matchesFilter(entity, filter)) {
//             return false;
//           }
//         }
//         return true;
//       }).toList();
//     });
//   }
//
//   bool _matchesFilter(Entity entity, FilterCriteria filter) {
//     final attributeValue = entity.getAttribute(filter.attribute)?.getValue();
//     switch (filter.operator) {
//       case '=':
//         return attributeValue == filter.value;
//       case '!=':
//         return attributeValue != filter.value;
//       case '>':
//         return attributeValue > filter.value;
//       case '<':
//         return attributeValue < filter.value;
//       // Add more operators as needed
//       default:
//         return false;
//     }
//   }
//
//   void _loadMoreEntities() {
//     // Implement logic to load more entities if available
//   }
//
//   void _addFilter(FilterCriteria filter) {
//     setState(() {
//       _filters.add(filter);
//       _applyFilters();
//     });
//   }
//
//   void _createBookmark() async {
//     setState(() {
//       _isBookmarking = true;
//     });
//   }
//
//   void _saveBookmark() async {
//     final bookmarkTitle = _bookmarkTitleController.text;
//     if (bookmarkTitle.isNotEmpty) {
//       final bookmark = Bookmark(
//           title: bookmarkTitle,
//           url: '/entities?filters=' +
//               _filters
//                   .map((filter) =>
//                       '${filter.attribute}:${filter.operator}:${filter.value}')
//                   .join(','));
//
//       await widget.bookmarkManager.addBookmark(bookmark);
//       widget.onBookmarkCreated(bookmark);
//     }
//     setState(() {
//       _isBookmarking = false;
//       _bookmarkTitleController.clear();
//     });
//   }
//
//   void _cancelBookmark() {
//     setState(() {
//       _isBookmarking = false;
//       _bookmarkTitleController.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           HeaderWidget(
//             filters: _filters,
//             onAddFilter: _addFilter,
//             onBookmark: _createBookmark,
//             path: [
//               'Home',
//             ],
//             onPathSegmentTapped: (index) {
//               // Handle path segment tap
//             },
//           ),
//           if (_isBookmarking)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _bookmarkTitleController,
//                       decoration: InputDecoration(hintText: 'Bookmark Title'),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.check),
//                     onPressed: _saveBookmark,
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.cancel),
//                     onPressed: _cancelBookmark,
//                   ),
//                 ],
//               ),
//             ),
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _filteredEntities.length,
//               itemBuilder: (context, index) {
//                 final entity = _filteredEntities[index];
//                 return ListTile(
//                   title: Text(entity.getStringFromAttribute('name') ??
//                       'Unnamed Entity'),
//                   subtitle: Text(entity.toString()),
//                   onTap: () {
//                     // Handle entity selection if needed
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
