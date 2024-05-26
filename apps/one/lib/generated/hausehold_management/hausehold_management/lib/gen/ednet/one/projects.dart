part of ednet_one; 
 
// lib/gen/ednet/one/projects.dart 
 
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
 
