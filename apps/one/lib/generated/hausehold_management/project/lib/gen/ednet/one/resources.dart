part of ednet_one; 
 
// lib/gen/ednet/one/resources.dart 
 
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
 
