part of focus_project; 
 
// lib/gen/focus/project/commitment_types.dart 
 
abstract class CommitmentTypeGen extends Entity<CommitmentType> { 
 
  CommitmentTypeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CommitmentType newEntity() => CommitmentType(concept); 
  CommitmentTypes newEntities() => CommitmentTypes(concept); 
  
} 
 
abstract class CommitmentTypesGen extends Entities<CommitmentType> { 
 
  CommitmentTypesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CommitmentTypes newEntities() => CommitmentTypes(concept); 
  CommitmentType newEntity() => CommitmentType(concept); 
  
} 
 
