part of project_gtd; 
 
// lib/gen/project/gtd/next_actions.dart 
 
abstract class NextActionGen extends Entity<NextAction> { 
 
  NextActionGen(Concept concept) { 
    this.concept = concept; 
    Concept taskConcept = concept.model.concepts.singleWhereCode("Task") as Concept; 
    assert(taskConcept != null); 
    setChild("tasks", Tasks(taskConcept)); 
  } 
 
  String get work => getAttribute("work"); 
  void set work(String a) { setAttribute("work", a); } 
  
  Tasks get tasks => getChild("tasks") as Tasks; 
  
  NextAction newEntity() => NextAction(concept); 
  NextActions newEntities() => NextActions(concept); 
  
} 
 
abstract class NextActionsGen extends Entities<NextAction> { 
 
  NextActionsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  NextActions newEntities() => NextActions(concept); 
  NextAction newEntity() => NextAction(concept); 
  
} 
 
