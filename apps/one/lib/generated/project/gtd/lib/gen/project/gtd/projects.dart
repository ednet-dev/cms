part of project_gtd; 
 
// lib/gen/project/gtd/projects.dart 
 
abstract class ProjectGen extends Entity<Project> { 
 
  ProjectGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get taskReference => getReference("task") as Reference; 
  void set taskReference(Reference reference) { setReference("task", reference); } 
  
  Task get task => getParent("task") as Task; 
  void set task(Task p) { setParent("task", p); } 
  
  String get tasks => getAttribute("tasks"); 
  void set tasks(String a) { setAttribute("tasks", a); } 
  
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
 
