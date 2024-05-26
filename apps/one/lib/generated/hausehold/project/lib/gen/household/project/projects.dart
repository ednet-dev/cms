part of household_project;

// lib/gen/household/project/projects.dart

abstract class ProjectGen extends Entity<Project> {
  ProjectGen(Concept concept) {
    this.concept = concept;
  }

  String get name => getAttribute("name");

  void set name(String a) {
    setAttribute("name", a);
  }

  Project newEntity() => Project(concept);

  Projects newEntities() => Projects(concept);
}

abstract class ProjectsGen extends Entities<Project> {
  ProjectsGen(Concept concept) {
    this.concept = concept;
  }

  Projects newEntities() => Projects(concept);

  Project newEntity() => Project(concept);
}
