part of focus_project; 
 
// lib/gen/focus/project/priorities.dart 
 
abstract class PriorityGen extends Entity<Priority> { 
 
  PriorityGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Priority newEntity() => Priority(concept); 
  Priorities newEntities() => Priorities(concept); 
  
} 
 
abstract class PrioritiesGen extends Entities<Priority> { 
 
  PrioritiesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Priorities newEntities() => Priorities(concept); 
  Priority newEntity() => Priority(concept); 
  
} 
 
