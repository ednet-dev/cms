 
part of household_management_project; 
 
// lib/household_management/project/model.dart 
 
class ProjectModel extends ProjectEntries { 
 
  ProjectModel(Model model) : super(model); 
 
  void fromJsonToProjectEntry() { 
    fromJsonToEntry(household_managementProjectProjectEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(household_managementProjectModel); 
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
 
