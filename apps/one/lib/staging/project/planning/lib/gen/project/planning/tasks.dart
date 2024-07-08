part of project_planning; 
 
// lib/gen/project/planning/tasks.dart 
 
abstract class TaskGen extends Entity<Task> { 
 
  TaskGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get priority => getAttribute("priority"); 
  void set priority(String a) { setAttribute("priority", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  String get StartDate => getAttribute("StartDate"); 
  void set StartDate(String a) { setAttribute("StartDate", a); } 
  
  String get EndDate => getAttribute("EndDate"); 
  void set EndDate(String a) { setAttribute("EndDate", a); } 
  
  Task newEntity() => Task(concept); 
  Tasks newEntities() => Tasks(concept); 
  
} 
 
abstract class TasksGen extends Entities<Task> { 
 
  TasksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Tasks newEntities() => Tasks(concept); 
  Task newEntity() => Task(concept); 
  
} 
 
