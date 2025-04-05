part of democracy_direct; 
 
// lib/gen/democracy/direct/proposals.dart 
 
abstract class ProposalGen extends Entity<Proposal> { 
 
  ProposalGen(Concept concept) { 
    this.concept = concept; 
    Concept voteConcept = concept.model.concepts.singleWhereCode("Vote") as Concept; 
    assert(voteConcept != null); 
    setChild("receivedVote", Votes(voteConcept)); 
  } 
 
  Reference get proposerReference => getReference("proposer") as Reference; 
  void set proposerReference(Reference reference) { setReference("proposer", reference); } 
  
  Citizen get proposer => getParent("proposer") as Citizen; 
  void set proposer(Citizen p) { setParent("proposer", p); } 
  
  String get proposalId => getAttribute("proposalId"); 
  void set proposalId(String a) { setAttribute("proposalId", a); } 
  
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Votes get receivedVote => getChild("receivedVote") as Votes; 
  
  Proposal newEntity() => Proposal(concept); 
  Proposals newEntities() => Proposals(concept); 
  
} 
 
abstract class ProposalsGen extends Entities<Proposal> { 
 
  ProposalsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Proposals newEntities() => Proposals(concept); 
  Proposal newEntity() => Proposal(concept); 
  
} 
 
