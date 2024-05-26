part of household_management_project; 
 
// lib/gen/household_management/project/resources.dart 
 
abstract class ResourceGen extends Entity<Resource> { 
 
  ResourceGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
