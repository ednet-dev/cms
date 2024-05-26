 
part of household_project; 
 
// lib/household/project/model.dart 
 
class ProjectModel extends ProjectEntries { 
 
  ProjectModel(Model model) : super(model); 
 
  void fromJsonToProjectEntry() { 
    fromJsonToEntry(householdProjectProjectEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(householdProjectModel); 
  } 
 
  void init() { 
    initProjects(); 
  } 
 
  void initProjects() { 
    var project1 = Project(projects.concept); 
    projects.add(project1); 
 
    var project2 = Project(projects.concept); 
    projects.add(project2); 
 
    var project3 = Project(projects.concept); 
    projects.add(project3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
