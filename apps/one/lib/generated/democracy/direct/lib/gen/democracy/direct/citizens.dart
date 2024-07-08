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
    setChild("castedVotes", Votes(voteConcept));
    Concept commentConcept = concept.model.concepts.singleWhereCode("Comment") as Concept;
    assert(commentConcept != null);
    setChild("commented", Comments(commentConcept));
    Concept messageConcept = concept.model.concepts.singleWhereCode("Message") as Concept;
    assert(messageConcept != null);
    setChild("sentMessages", Messages(messageConcept));
    setChild("receivedMessages", Messages(messageConcept));
    Concept electionConcept = concept.model.concepts.singleWhereCode("Election") as Concept;
    assert(electionConcept != null);
    setChild("elections", Elections(electionConcept));

  }

  

  

    String get firstName => getAttribute("firstName");
  void set firstName(String a) => setAttribute("firstName", a);

  String get lastName => getAttribute("lastName");
  void set lastName(String a) => setAttribute("lastName", a);

  String get email => getAttribute("email");
  void set email(String a) => setAttribute("email", a);


    Proposals get proposed => getChild("proposed") as Proposals;

  Votes get castedVotes => getChild("castedVotes") as Votes;

  Comments get commented => getChild("commented") as Comments;

  Messages get sentMessages => getChild("sentMessages") as Messages;

  Messages get receivedMessages => getChild("receivedMessages") as Messages;

  Elections get elections => getChild("elections") as Elections;


  @override
  Citizen newEntity() => Citizen(concept);

  Citizens newEntities() => Citizens(concept);

  
}

abstract class CitizensGen extends Entities<Citizen> {

  CitizensGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Citizens newEntities() => Citizens(concept);

  @override
  Citizen newEntity() => Citizen(concept);
}

// Commands for Citizen will be generated here
// Events for Citizen will be generated here
// Policies for Citizen will be generated here
