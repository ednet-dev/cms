part of focus_project; 
 
// lib/gen/focus/project/due_dates.dart 
 
abstract class DueDateGen extends Entity<DueDate> { 
 
  DueDateGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  DueDate newEntity() => DueDate(concept); 
  DueDates newEntities() => DueDates(concept); 
  
} 
 
abstract class DueDatesGen extends Entities<DueDate> { 
 
  DueDatesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  DueDates newEntities() => DueDates(concept); 
  DueDate newEntity() => DueDate(concept); 
  
} 
 
