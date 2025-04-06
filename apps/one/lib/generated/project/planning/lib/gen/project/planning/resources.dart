part of project_planning; 
 
// lib/gen/project/planning/resources.dart 
 
abstract class ResourceGen extends Entity<Resource> { 
 
  ResourceGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  Resource newEntity() => Resource(concept); 
  Resources newEntities() => Resources(concept); 
  
} 
 
abstract class ResourcesGen extends Entities<Resource> { 
 
  ResourcesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Resources newEntities() => Resources(concept); 
  Resource newEntity() => Resource(concept); 
  
} 
 
