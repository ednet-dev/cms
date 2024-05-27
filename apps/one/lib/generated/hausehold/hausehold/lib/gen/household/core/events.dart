part of household_core; 
 
// lib/gen/household/core/events.dart 
 
abstract class EventGen extends Entity<Event> { 
 
  EventGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Event newEntity() => Event(concept); 
  Events newEntities() => Events(concept); 
  
} 
 
abstract class EventsGen extends Entities<Event> { 
 
  EventsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Events newEntities() => Events(concept); 
  Event newEntity() => Event(concept); 
  
} 
 