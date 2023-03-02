part of ednetcore_tasks; 
 
// lib/gen/ednetcore/tasks/tasks.dart 
 
abstract class TaskGen extends Entity<Task> { 
 
  TaskGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get projectReference => getReference("project") as Reference; 
  void set projectReference(Reference reference) { setReference("project", reference); } 
  
  Project get project => getParent("project") as Project; 
  void set project(Project p) { setParent("project", p); } 
  
  Reference get employeeReference => getReference("employee") as Reference; 
  void set employeeReference(Reference reference) { setReference("employee", reference); } 
  
  Employee get employee => getParent("employee") as Employee; 
  void set employee(Employee p) { setParent("employee", p); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
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
 
