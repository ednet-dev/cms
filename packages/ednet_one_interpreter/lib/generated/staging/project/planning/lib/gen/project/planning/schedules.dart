part of project_planning; 
 
// lib/gen/project/planning/schedules.dart 
 
abstract class ScheduleGen extends Entity<Schedule> { 
 
  ScheduleGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get tasks => getAttribute("tasks"); 
  void set tasks(String a) { setAttribute("tasks", a); } 
  
  String get executionType => getAttribute("executionType"); 
  void set executionType(String a) { setAttribute("executionType", a); } 
  
  String get StartDate => getAttribute("StartDate"); 
  void set StartDate(String a) { setAttribute("StartDate", a); } 
  
  String get EndDate => getAttribute("EndDate"); 
  void set EndDate(String a) { setAttribute("EndDate", a); } 
  
  Schedule newEntity() => Schedule(concept); 
  Schedules newEntities() => Schedules(concept); 
  
} 
 
abstract class SchedulesGen extends Entities<Schedule> { 
 
  SchedulesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Schedules newEntities() => Schedules(concept); 
  Schedule newEntity() => Schedule(concept); 
  
} 
 
