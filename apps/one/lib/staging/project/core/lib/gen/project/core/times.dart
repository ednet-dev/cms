part of project_core; 
 
// lib/gen/project/core/times.dart 
 
abstract class TimeGen extends Entity<Time> { 
 
  TimeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get projectReference => getReference("project") as Reference; 
  void set projectReference(Reference reference) { setReference("project", reference); } 
  
  Project get project => getParent("project") as Project; 
  void set project(Project p) { setParent("project", p); } 
  
  int get hours => getAttribute("hours"); 
  void set hours(int a) { setAttribute("hours", a); } 
  
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
 
