import 'package:ednet_one/generated/hausehold/project/lib/household_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/layout_block.dart';
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
    var repository = HouseholdProjectRepo();
    HouseholdDomain householdDomain =
        repository.getDomainModels("Household") as HouseholdDomain;
    ProjectModel projectModel =
        householdDomain.getModelEntries("Project") as ProjectModel;

    projectModel.initProjects();
    var projects = projectModel.projects;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: BlocBuilder<LayoutBloc, LayoutState>(
        builder: (context, state) {
          return LayoutTemplate(
            header: const HeaderWidget(),
            leftSidebar: LeftSidebarWidget(items: projects),
            rightSidebar: const RightSidebarWidget(),
            mainContent: MainContentWidget(
              entity: projects.first,
            ),
            footer: const FooterWidget(),
          );
        },
      ),
    );
  }
}
