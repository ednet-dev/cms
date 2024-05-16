part of focus_project; 
 
// lib/gen/focus/project/focuss.dart 
 
abstract class FocusGen extends Entity<Focus> { 
 
  FocusGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Focus newEntity() => Focus(concept); 
  Focuss newEntities() => Focuss(concept); 
  
} 
 
abstract class FocussGen extends Entities<Focus> { 
 
  FocussGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Focuss newEntities() => Focuss(concept); 
  Focus newEntity() => Focus(concept); 
  
} 
 
