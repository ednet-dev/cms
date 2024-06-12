part of project_planning; 
 
// lib/gen/project/planning/dependencies.dart 
 
abstract class DependencyGen extends Entity<Dependency> { 
 
  DependencyGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  Dependency newEntity() => Dependency(concept); 
  Dependencies newEntities() => Dependencies(concept); 
  
} 
 
abstract class DependenciesGen extends Entities<Dependency> { 
 
  DependenciesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Dependencies newEntities() => Dependencies(concept); 
  Dependency newEntity() => Dependency(concept); 
  
} 
 
