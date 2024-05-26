 
part of ednet_one; 
 
// lib/ednet/one/model.dart 
 
class OneModel extends OneEntries { 
 
  OneModel(Model model) : super(model); 
 
  void fromJsonToProjectEntry() { 
    fromJsonToEntry(ednetOneProjectEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(ednetOneModel); 
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
 
