part of household_project; 
 
// lib/gen/household/project/milestones.dart 
 
abstract class MilestoneGen extends Entity<Milestone> { 
 
  MilestoneGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get projectReference => getReference("project") as Reference; 
  void set projectReference(Reference reference) { setReference("project", reference); } 
  
  Project get project => getParent("project") as Project; 
  void set project(Project p) { setParent("project", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  DateTime get date => getAttribute("date"); 
  void set date(DateTime a) { setAttribute("date", a); } 
  
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
 
