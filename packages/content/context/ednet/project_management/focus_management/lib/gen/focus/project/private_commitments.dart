part of focus_project; 
 
// lib/gen/focus/project/private_commitments.dart 
 
abstract class PrivateCommitmentGen extends Entity<PrivateCommitment> { 
 
  PrivateCommitmentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  PrivateCommitment newEntity() => PrivateCommitment(concept); 
  PrivateCommitments newEntities() => PrivateCommitments(concept); 
  
} 
 
abstract class PrivateCommitmentsGen extends Entities<PrivateCommitment> { 
 
  PrivateCommitmentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  PrivateCommitments newEntities() => PrivateCommitments(concept); 
  PrivateCommitment newEntity() => PrivateCommitment(concept); 
  
} 
 
