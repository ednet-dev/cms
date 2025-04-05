part of project_gtd; 
 
// lib/gen/project/gtd/inboxes.dart 
 
abstract class InboxGen extends Entity<Inbox> { 
 
  InboxGen(Concept concept) { 
    this.concept = concept; 
    Concept clarifiedItemConcept = concept.model.concepts.singleWhereCode("ClarifiedItem") as Concept; 
    assert(clarifiedItemConcept != null); 
    setChild("clarifiedItems", ClarifiedItems(clarifiedItemConcept)); 
  } 
 
  String get items => getAttribute("items"); 
  void set items(String a) { setAttribute("items", a); } 
  
  ClarifiedItems get clarifiedItems => getChild("clarifiedItems") as ClarifiedItems; 
  
  Inbox newEntity() => Inbox(concept); 
  Inboxes newEntities() => Inboxes(concept); 
  
} 
 
abstract class InboxesGen extends Entities<Inbox> { 
 
  InboxesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Inboxes newEntities() => Inboxes(concept); 
  Inbox newEntity() => Inbox(concept); 
  
} 
 
