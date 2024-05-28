// my_home_page.dart
// ednet core
// ednet cms
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/user/library/lib/user_library.dart';
import 'package:ednet_one/presentation/household_management/blocs/theme_block.dart';
import 'package:ednet_one/presentation/household_management/widgets/layout/alternative_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/hausehold/project/lib/household_project.dart';
import '../blocs/layout_block.dart';
import '../blocs/layout_event.dart';
import '../blocs/layout_state.dart';
import '../widgets/layout/footer_widget.dart';
import '../widgets/layout/header_widget.dart';
import '../widgets/layout/layout_template.dart';
import '../widgets/layout/left_sidebar_widget.dart';
import '../widgets/layout/main_content_widget.dart';
import '../widgets/layout/right_sidebar_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> path = ['Home'];

  @override
  Widget build(BuildContext context) {
    var householdProjectRepo = HouseholdProjectRepo();
    var userLibraryRepo = UserLibraryRepo();

    HouseholdDomain householdDomain =
        householdProjectRepo.getDomainModels("Household") as HouseholdDomain;
    UserDomain userDomain =
        userLibraryRepo.getDomainModels("User") as UserDomain;

    ProjectModel projectModel =
        householdDomain.getModelEntries("Project") as ProjectModel;
    LibraryModel libraryModel =
        userDomain.getModelEntries("Library") as LibraryModel;

    projectModel.init();
    libraryModel.init();

    var domains = Domains()
      ..add(householdDomain.domain)
      ..add(userDomain.domain);

    var projects = projectModel.projects;

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
            return state.layoutType == LayoutType.defaultLayout
                ? LayoutTemplate(
                    header: HeaderWidget(
                      path: path,
                      onPathSegmentTapped: (index) {
                        _handlePathSegmentTapped(context, index);
                      },
                    ),
                    leftSidebar: LeftSidebarWidget(
                      items: projects,
                      onEntitySelected: (entity) {
                        setState(() {
                          path.add(entity.getStringFromAttribute('name') ??
                              'Entity');
                        });
                        BlocProvider.of<LayoutBloc>(context)
                            .add(SelectEntityEvent(entity: entity));
                      },
                      model: projectModel.model,
                      domain: householdDomain.domain,
                    ),
                    rightSidebar: RightSidebarWidget(
                      domains: domains,
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
                    mainContent: MainContentWidget(
                      entity: state.selectedEntity ?? projects.first,
                      onEntitySelected: (entity) {
                        setState(() {
                          path.add(entity.getStringFromAttribute('name') ??
                              'Entity');
                        });
                        BlocProvider.of<LayoutBloc>(context)
                            .add(SelectEntityEvent(entity: entity));
                      },
                    ),
                    footer: const FooterWidget(),
                  )
                : AlternativeLayout(
                    domains: domains,
                    selectedEntity: state.selectedEntity,
                    onEntitySelected: (entity) {
                      setState(() {
                        path.add(
                            entity.getStringFromAttribute('name') ?? 'Entity');
                      });
                      BlocProvider.of<LayoutBloc>(context)
                          .add(SelectEntityEvent(entity: entity));
                    },
                  );
          },
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

// domain_detail_screen.dart
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
                  // Implement entity selection handling here
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// model_detail_screen.dart
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
        ),
      ),
      body: EntitiesWidget(
        entities: model.concepts,
        domain: domain,
        model: model,
        onEntitySelected: (entity) {
          onEntitySelected(entity);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntityDetailScreen(
                entity: entity,
                path:
                    path + [entity.getStringFromAttribute('name') ?? 'Entity'],
              ),
            ),
          );
        },
      ),
    );
  }
}

// entity_detail_screen.dart
class EntityDetailScreen extends StatelessWidget {
  final Entity entity;
  final List<String> path;

  EntityDetailScreen({required this.entity, required this.path});

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
        ),
      ),
      body: EntityWidget(entity: entity),
    );
  }
}

// Widget for Domains
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

// Widget for Models within a Domain
class ModelsWidget extends StatelessWidget {
  final Models models;
  final void Function(Model model)? onModelSelected;

  ModelsWidget({required this.models, this.onModelSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) {
        var model = models.elementAt(index);
        return ListTile(
          title: Text(model.code),
          onTap: () {
            if (onModelSelected != null) {
              onModelSelected!(model);
            }
          },
        );
      },
    );
  }
}
