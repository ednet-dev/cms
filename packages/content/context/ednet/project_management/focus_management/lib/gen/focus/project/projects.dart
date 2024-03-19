part of focus_project; 
 
// lib/gen/focus/project/projects.dart 
 
abstract class ProjectGen extends Entity<Project> { 
 
  ProjectGen(Concept concept) { 
    this.concept = concept; 
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
 
