part of project_planning; 
 
// lib/gen/project/planning/deliverables.dart 
 
abstract class DeliverableGen extends Entity<Deliverable> { 
 
  DeliverableGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get dueDate => getAttribute("dueDate"); 
  void set dueDate(String a) { setAttribute("dueDate", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  Deliverable newEntity() => Deliverable(concept); 
  Deliverables newEntities() => Deliverables(concept); 
  
} 
 
abstract class DeliverablesGen extends Entities<Deliverable> { 
 
  DeliverablesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Deliverables newEntities() => Deliverables(concept); 
  Deliverable newEntity() => Deliverable(concept); 
  
} 
 
