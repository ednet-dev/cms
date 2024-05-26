part of household_project; 
 
// lib/gen/household/project/times.dart 
 
abstract class TimeGen extends Entity<Time> { 
 
  TimeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Time newEntity() => Time(concept); 
  Times newEntities() => Times(concept); 
  
} 
 
abstract class TimesGen extends Entities<Time> { 
 
  TimesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Times newEntities() => Times(concept); 
  Time newEntity() => Time(concept); 
  
} 
 
