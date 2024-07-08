part of project_gtd; 
 
// lib/gen/project/gtd/context_lists.dart 
 
abstract class ContextListGen extends Entity<ContextList> { 
 
  ContextListGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get taskReference => getReference("task") as Reference; 
  void set taskReference(Reference reference) { setReference("task", reference); } 
  
  Task get task => getParent("task") as Task; 
  void set task(Task p) { setParent("task", p); } 
  
  String get contexts => getAttribute("contexts"); 
  void set contexts(String a) { setAttribute("contexts", a); } 
  
  ContextList newEntity() => ContextList(concept); 
  ContextLists newEntities() => ContextLists(concept); 
  
} 
 
abstract class ContextListsGen extends Entities<ContextList> { 
 
  ContextListsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ContextLists newEntities() => ContextLists(concept); 
  ContextList newEntity() => ContextList(concept); 
  
} 
 
