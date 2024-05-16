part of focus_project; 
 
// lib/gen/focus/project/self_commitments.dart 
 
abstract class SelfCommitmentGen extends Entity<SelfCommitment> { 
 
  SelfCommitmentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  SelfCommitment newEntity() => SelfCommitment(concept); 
  SelfCommitments newEntities() => SelfCommitments(concept); 
  
} 
 
abstract class SelfCommitmentsGen extends Entities<SelfCommitment> { 
 
  SelfCommitmentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  SelfCommitments newEntities() => SelfCommitments(concept); 
  SelfCommitment newEntity() => SelfCommitment(concept); 
  
} 
 
