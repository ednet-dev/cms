import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_one/generated/hausehold/project/lib/household_project.dart';
import 'package:flutter/material.dart';

class MainContentWidget extends StatelessWidget {
  const MainContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = HouseholdProjectRepo();
    HouseholdDomain householdDomain =
        repository.getDomainModels("Household") as HouseholdDomain;
    ProjectModel projectModel =
        householdDomain.getModelEntries("Project") as ProjectModel;

    projectModel.initProjects();
    var projects = projectModel.projects;
    var project = projects.first;
    print(project.name);
    print(projects.toString());

    return Container(
      color: Colors.orange,
      child: Center(
        child: EntityWidget(
          entity: project,
        ),
      ),
    );
  }
}
