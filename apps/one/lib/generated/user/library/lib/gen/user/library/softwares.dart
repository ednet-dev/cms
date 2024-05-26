part of user_library; 
 
// lib/gen/user/library/softwares.dart 
 
abstract class SoftwareGen extends Entity<Software> { 
 
  SoftwareGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Software newEntity() => Software(concept); 
  Softwares newEntities() => Softwares(concept); 
  
} 
 
abstract class SoftwaresGen extends Entities<Software> { 
 
  SoftwaresGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Softwares newEntities() => Softwares(concept); 
  Software newEntity() => Software(concept); 
  
} 
 
