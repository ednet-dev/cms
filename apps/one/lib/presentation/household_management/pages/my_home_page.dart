// my_home_page.dart
// ednet core
// ednet cms
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/user/library/lib/user_library.dart';
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var householdProjectRepo = HouseholdProjectRepo();
    // var householdFinancesRepo = HouseholdFinancesRepo();
    // var householdMemberRepo = HouseholdMemberRepo();
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
    // var allRepos = OneCoreRepository();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: BlocProvider(
        create: (context) => LayoutBloc(),
        child: BlocBuilder<LayoutBloc, LayoutState>(
          builder: (context, state) {
            return LayoutTemplate(
              header: HeaderWidget(
                  path: [],
                  onPathSegmentTapped: (index) {
                    // Handle Home path tap, if needed
                  }),
              leftSidebar: LeftSidebarWidget(
                items: projects,
                onEntitySelected: (entity) {
                  BlocProvider.of<LayoutBloc>(context)
                      .add(SelectEntityEvent(entity: entity));
                },
                model: projectModel.model,
                domain: householdDomain.domain,
              ),
              rightSidebar: RightSidebarWidget(
                domains: domains,
                // domains: allRepos.domains,
                onDomainSelected: (domain) {
                  // Handle domain selection, navigate to DomainDetailScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DomainDetailScreen(domain: domain),
                    ),
                  );
                },
                onModelSelected: (model) {
                  // Handle model selection, navigate to ModelDetailScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModelDetailScreen(
                        domain: model.domain,
                        model: model,
                        path: [model.domain.code, model.code],
                      ),
                    ),
                  );
                },
              ),
              mainContent: MainContentWidget(
                entity: state.selectedEntity ?? projects.first,
                onEntitySelected: (entity) {
                  BlocProvider.of<LayoutBloc>(context)
                      .add(SelectEntityEvent(entity: entity));
                },
              ),
              footer: const FooterWidget(),
            );
          },
        ),
      ),
    );
  }
}

class DomainDetailScreen extends StatelessWidget {
  final Domain domain;
  final List<String> path;

  DomainDetailScreen({required this.domain}) : path = [domain.code];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: path,
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: ModelsWidget(
        models: domain.models,
        onModelSelected: (model) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModelDetailScreen(
                  domain: domain, model: model, path: path + [model.code]),
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

  ModelDetailScreen(
      {required this.domain, required this.model, required this.path});

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
      body: EntitiesWidget(
        entities: model.concepts,
        domain: domain,
        model: model,
        onEntitySelected: (entity) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntityDetailScreen(
                  entity: entity,
                  path: path +
                      [entity.getStringFromAttribute('name') ?? 'Entity']),
            ),
          );
        },
      ),
    );
  }
}

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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var repository = CoreRepository();
    var domains = repository.domains;

    return Scaffold(
      appBar: AppBar(
        title: HeaderWidget(
          path: ['Home'],
          onPathSegmentTapped: (index) {
            // Handle Home path tap, if needed
          },
        ),
      ),
      body: DomainsWidget(
        domains: domains,
        onDomainSelected: (domain) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DomainDetailScreen(domain: domain),
            ),
          );
        },
      ),
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

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     var repository = CoreRepository();
//     var domains = repository.domains;
//
//     var householdDomain = domains.singleWhereCode("Household") as HouseholdDomain;
//     var projectModel = householdDomain.getModelEntries("Project") as ProjectModel;
//     projectModel.init();
//     var projects = projectModel.projects;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(title),
//       ),
//       body: BlocProvider(
//         create: (context) => LayoutBloc(),
//         child: BlocBuilder<LayoutBloc, LayoutState>(
//           builder: (context, state) {
//             return LayoutTemplate(
//               header: HeaderWidget(
//                   path: [],
//                   onPathSegmentTapped: (index) {
//                     // Handle Home path tap, if needed
//                   }
//               ),
//               leftSidebar: LeftSidebarWidget(
//                 items: projects,
//                 onEntitySelected: (entity) {
//                   BlocProvider.of<LayoutBloc>(context)
//                       .add(SelectEntityEvent(entity: entity));
//                 },
//                 model: projectModel.model,
//                 domain: householdDomain.domain,
//               ),
//               rightSidebar: RightSidebarWidget(
//                 domains: domains,
//                 onDomainSelected: (domain) {
//                   // Handle domain selection, navigate to DomainDetailScreen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DomainDetailScreen(domain: domain),
//                     ),
//                   );
//                 },
//                 onModelSelected: (model) {
//                   // Handle model selection, navigate to ModelDetailScreen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ModelDetailScreen(
//                         domain: model.domain,
//                         model: model,
//                         path: [model.domain.code, model.code],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               mainContent: MainContentWidget(
//                 entity: state.selectedEntity ?? projects.first,
//                 onEntitySelected: (entity) {
//                   BlocProvider.of<LayoutBloc>(context)
//                       .add(SelectEntityEvent(entity: entity));
//                 },
//               ),
//               footer: const FooterWidget(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
