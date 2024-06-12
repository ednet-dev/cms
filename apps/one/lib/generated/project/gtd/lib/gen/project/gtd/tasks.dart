part of project_gtd; 
 
// lib/gen/project/gtd/tasks.dart 
 
abstract class TaskGen extends Entity<Task> { 
 
  TaskGen(Concept concept) { 
    this.concept = concept; 
    Concept projectConcept = concept.model.concepts.singleWhereCode("Project") as Concept; 
    assert(projectConcept != null); 
    setChild("projects", Projects(projectConcept)); 
    Concept calendarConcept = concept.model.concepts.singleWhereCode("Calendar") as Concept; 
    assert(calendarConcept != null); 
    setChild("calendar", Calendars(calendarConcept)); 
    Concept contextListConcept = concept.model.concepts.singleWhereCode("ContextList") as Concept; 
    assert(contextListConcept != null); 
    setChild("contextLists", ContextLists(contextListConcept)); 
  } 
 
  Reference get clarifiedItemReference => getReference("clarifiedItem") as Reference; 
  void set clarifiedItemReference(Reference reference) { setReference("clarifiedItem", reference); } 
  
  ClarifiedItem get clarifiedItem => getParent("clarifiedItem") as ClarifiedItem; 
  void set clarifiedItem(ClarifiedItem p) { setParent("clarifiedItem", p); } 
  
  Reference get reviewReference => getReference("review") as Reference; 
  void set reviewReference(Reference reference) { setReference("review", reference); } 
  
  Review get review => getParent("review") as Review; 
  void set review(Review p) { setParent("review", p); } 
  
  Reference get actionReference => getReference("action") as Reference; 
  void set actionReference(Reference reference) { setReference("action", reference); } 
  
  NextAction get action => getParent("action") as NextAction; 
  void set action(NextAction p) { setParent("action", p); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Projects get projects => getChild("projects") as Projects; 
  
  Calendars get calendar => getChild("calendar") as Calendars; 
  
  ContextLists get contextLists => getChild("contextLists") as ContextLists; 
  
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
 
