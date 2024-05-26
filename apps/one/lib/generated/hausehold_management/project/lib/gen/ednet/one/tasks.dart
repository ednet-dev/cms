part of ednet_one; 
 
// lib/gen/ednet/one/tasks.dart 
 
abstract class TaskGen extends Entity<Task> { 
 
  TaskGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
