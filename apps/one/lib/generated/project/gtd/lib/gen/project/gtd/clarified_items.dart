part of project_gtd; 
 
// lib/gen/project/gtd/clarified_items.dart 
 
abstract class ClarifiedItemGen extends Entity<ClarifiedItem> { 
 
  ClarifiedItemGen(Concept concept) { 
    this.concept = concept; 
    Concept taskConcept = concept.model.concepts.singleWhereCode("Task") as Concept; 
    assert(taskConcept != null); 
    setChild("tasks", Tasks(taskConcept)); 
  } 
 
  Reference get inboxReference => getReference("inbox") as Reference; 
  void set inboxReference(Reference reference) { setReference("inbox", reference); } 
  
  Inbox get inbox => getParent("inbox") as Inbox; 
  void set inbox(Inbox p) { setParent("inbox", p); } 
  
  String get nextAction => getAttribute("nextAction"); 
  void set nextAction(String a) { setAttribute("nextAction", a); } 
  
  Tasks get tasks => getChild("tasks") as Tasks; 
  
  ClarifiedItem newEntity() => ClarifiedItem(concept); 
  ClarifiedItems newEntities() => ClarifiedItems(concept); 
  
} 
 
abstract class ClarifiedItemsGen extends Entities<ClarifiedItem> { 
 
  ClarifiedItemsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ClarifiedItems newEntities() => ClarifiedItems(concept); 
  ClarifiedItem newEntity() => ClarifiedItem(concept); 
  
} 
 
