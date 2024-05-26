part of ednet_one; 
 
// lib/gen/ednet/one/milestones.dart 
 
abstract class MilestoneGen extends Entity<Milestone> { 
 
  MilestoneGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
