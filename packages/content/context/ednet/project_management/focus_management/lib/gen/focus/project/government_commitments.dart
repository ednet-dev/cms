part of focus_project; 
 
// lib/gen/focus/project/government_commitments.dart 
 
abstract class GovernmentCommitmentGen extends Entity<GovernmentCommitment> { 
 
  GovernmentCommitmentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  GovernmentCommitment newEntity() => GovernmentCommitment(concept); 
  GovernmentCommitments newEntities() => GovernmentCommitments(concept); 
  
} 
 
abstract class GovernmentCommitmentsGen extends Entities<GovernmentCommitment> { 
 
  GovernmentCommitmentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  GovernmentCommitments newEntities() => GovernmentCommitments(concept); 
  GovernmentCommitment newEntity() => GovernmentCommitment(concept); 
  
} 
 
