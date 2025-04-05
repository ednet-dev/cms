part of democracy_direct; 
 
// lib/gen/democracy/direct/votes.dart 
 
abstract class VoteGen extends Entity<Vote> { 
 
  VoteGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get voterReference => getReference("voter") as Reference; 
  void set voterReference(Reference reference) { setReference("voter", reference); } 
  
  Citizen get voter => getParent("voter") as Citizen; 
  void set voter(Citizen p) { setParent("voter", p); } 
  
  Reference get proposalReference => getReference("proposal") as Reference; 
  void set proposalReference(Reference reference) { setReference("proposal", reference); } 
  
  Proposal get proposal => getParent("proposal") as Proposal; 
  void set proposal(Proposal p) { setParent("proposal", p); } 
  
  String get voteId => getAttribute("voteId"); 
  void set voteId(String a) { setAttribute("voteId", a); } 
  
  String get voteValue => getAttribute("voteValue"); 
  void set voteValue(String a) { setAttribute("voteValue", a); } 
  
  Vote newEntity() => Vote(concept); 
  Votes newEntities() => Votes(concept); 
  
} 
 
abstract class VotesGen extends Entities<Vote> { 
 
  VotesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Votes newEntities() => Votes(concept); 
  Vote newEntity() => Vote(concept); 
  
} 
 
