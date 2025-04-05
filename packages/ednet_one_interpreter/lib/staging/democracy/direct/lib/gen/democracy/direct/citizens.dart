part of democracy_direct; 
 
// lib/gen/democracy/direct/citizens.dart 
 
abstract class CitizenGen extends Entity<Citizen> { 
 
  CitizenGen(Concept concept) { 
    this.concept = concept; 
    Concept proposalConcept = concept.model.concepts.singleWhereCode("Proposal") as Concept; 
    assert(proposalConcept != null); 
    setChild("proposed", Proposals(proposalConcept)); 
    Concept voteConcept = concept.model.concepts.singleWhereCode("Vote") as Concept; 
    assert(voteConcept != null); 
    setChild("castedVote", Votes(voteConcept)); 
  } 
 
  String get citizenId => getAttribute("citizenId"); 
  void set citizenId(String a) { setAttribute("citizenId", a); } 
  
  String get firstName => getAttribute("firstName"); 
  void set firstName(String a) { setAttribute("firstName", a); } 
  
  String get lastName => getAttribute("lastName"); 
  void set lastName(String a) { setAttribute("lastName", a); } 
  
  Proposals get proposed => getChild("proposed") as Proposals; 
  
  Votes get castedVote => getChild("castedVote") as Votes; 
  
  Citizen newEntity() => Citizen(concept); 
  Citizens newEntities() => Citizens(concept); 
  
} 
 
abstract class CitizensGen extends Entities<Citizen> { 
 
  CitizensGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Citizens newEntities() => Citizens(concept); 
  Citizen newEntity() => Citizen(concept); 
  
} 
 
