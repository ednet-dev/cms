part of project_gtd; 
 
// lib/gen/project/gtd/calendars.dart 
 
abstract class CalendarGen extends Entity<Calendar> { 
 
  CalendarGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get taskReference => getReference("task") as Reference; 
  void set taskReference(Reference reference) { setReference("task", reference); } 
  
  Task get task => getParent("task") as Task; 
  void set task(Task p) { setParent("task", p); } 
  
  String get events => getAttribute("events"); 
  void set events(String a) { setAttribute("events", a); } 
  
  Calendar newEntity() => Calendar(concept); 
  Calendars newEntities() => Calendars(concept); 
  
} 
 
abstract class CalendarsGen extends Entities<Calendar> { 
 
  CalendarsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Calendars newEntities() => Calendars(concept); 
  Calendar newEntity() => Calendar(concept); 
  
} 
 
