part of project_planning; 
 
// lib/gen/project/planning/plans.dart 
 
abstract class PlanGen extends Entity<Plan> { 
 
  PlanGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Plan newEntity() => Plan(concept); 
  Plans newEntities() => Plans(concept); 
  
} 
 
abstract class PlansGen extends Entities<Plan> { 
 
  PlansGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Plans newEntities() => Plans(concept); 
  Plan newEntity() => Plan(concept); 
  
} 
 
