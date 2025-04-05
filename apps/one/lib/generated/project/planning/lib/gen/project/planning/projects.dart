part of project_planning; 
 
// lib/gen/project/planning/projects.dart 
 
abstract class ProjectGen extends Entity<Project> { 
 
  ProjectGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get startDate => getAttribute("startDate"); 
  void set startDate(String a) { setAttribute("startDate", a); } 
  
  String get endDate => getAttribute("endDate"); 
  void set endDate(String a) { setAttribute("endDate", a); } 
  
  String get budget => getAttribute("budget"); 
  void set budget(String a) { setAttribute("budget", a); } 
  
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
 
