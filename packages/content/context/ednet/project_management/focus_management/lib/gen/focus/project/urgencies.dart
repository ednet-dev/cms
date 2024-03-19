part of focus_project; 
 
// lib/gen/focus/project/urgencies.dart 
 
abstract class UrgencyGen extends Entity<Urgency> { 
 
  UrgencyGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Urgency newEntity() => Urgency(concept); 
  Urgencies newEntities() => Urgencies(concept); 
  
} 
 
abstract class UrgenciesGen extends Entities<Urgency> { 
 
  UrgenciesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Urgencies newEntities() => Urgencies(concept); 
  Urgency newEntity() => Urgency(concept); 
  
} 
 
