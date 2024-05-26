part of user_library; 
 
// lib/gen/user/library/c_ds.dart 
 
abstract class CDGen extends Entity<CD> { 
 
  CDGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CD newEntity() => CD(concept); 
  CDs newEntities() => CDs(concept); 
  
} 
 
abstract class CDsGen extends Entities<CD> { 
 
  CDsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CDs newEntities() => CDs(concept); 
  CD newEntity() => CD(concept); 
  
} 
 
