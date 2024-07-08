part of democracy_direct;

// lib/gen/democracy/direct/proposals.dart

abstract class ProposalGen extends Entity<Proposal> {

  ProposalGen(Concept concept) {
    this.concept = concept;
        Concept voteConcept = concept.model.concepts.singleWhereCode("Vote") as Concept;
    assert(voteConcept != null);
    setChild("receivedVotes", Votes(voteConcept));
    Concept commentConcept = concept.model.concepts.singleWhereCode("Comment") as Concept;
    assert(commentConcept != null);
    setChild("comments", Comments(commentConcept));

  }

  

    Reference get proposerReference => getReference("proposer") as Reference;
  void set proposerReference(Reference reference) => setReference("proposer", reference);

  Citizen get proposer => getParent("proposer") as Citizen;
  void set proposer(Citizen p) => setParent("proposer", p);


    String get title => getAttribute("title");
  void set title(String a) => setAttribute("title", a);

  String get description => getAttribute("description");
  void set description(String a) => setAttribute("description", a);


    Votes get receivedVotes => getChild("receivedVotes") as Votes;

  Comments get comments => getChild("comments") as Comments;


  @override
  Proposal newEntity() => Proposal(concept);

  Proposals newEntities() => Proposals(concept);

  
}

abstract class ProposalsGen extends Entities<Proposal> {

  ProposalsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Proposals newEntities() => Proposals(concept);

  @override
  Proposal newEntity() => Proposal(concept);
}

// Commands for Proposal will be generated here
// Events for Proposal will be generated here
// Policies for Proposal will be generated here
