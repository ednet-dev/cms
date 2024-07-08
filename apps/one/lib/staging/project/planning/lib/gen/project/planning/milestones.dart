part of project_planning; 
 
// lib/gen/project/planning/milestones.dart 
 
abstract class MilestoneGen extends Entity<Milestone> { 
 
  MilestoneGen(Concept concept) { 
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
  
  Milestone newEntity() => Milestone(concept); 
  Milestones newEntities() => Milestones(concept); 
  
} 
 
abstract class MilestonesGen extends Entities<Milestone> { 
 
  MilestonesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Milestones newEntities() => Milestones(concept); 
  Milestone newEntity() => Milestone(concept); 
  
} 
 
