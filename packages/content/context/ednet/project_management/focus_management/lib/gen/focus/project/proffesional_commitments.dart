part of focus_project; 
 
// lib/gen/focus/project/proffesional_commitments.dart 
 
abstract class ProffesionalCommitmentGen extends Entity<ProffesionalCommitment> { 
 
  ProffesionalCommitmentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ProffesionalCommitment newEntity() => ProffesionalCommitment(concept); 
  ProffesionalCommitments newEntities() => ProffesionalCommitments(concept); 
  
} 
 
abstract class ProffesionalCommitmentsGen extends Entities<ProffesionalCommitment> { 
 
  ProffesionalCommitmentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ProffesionalCommitments newEntities() => ProffesionalCommitments(concept); 
  ProffesionalCommitment newEntity() => ProffesionalCommitment(concept); 
  
} 
 
