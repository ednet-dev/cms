part of democracy_direct;

// lib/gen/democracy/direct/elections.dart

abstract class ElectionGen extends Entity<Election> {

  ElectionGen(Concept concept) {
    this.concept = concept;
        Concept voteConcept = concept.model.concepts.singleWhereCode("Vote") as Concept;
    assert(voteConcept != null);
    setChild("castedVote", Votes(voteConcept));

  }

  

    Reference get candidateReference => getReference("candidate") as Reference;
  void set candidateReference(Reference reference) => setReference("candidate", reference);

  Citizen get candidate => getParent("candidate") as Citizen;
  void set candidate(Citizen p) => setParent("candidate", p);


    String get title => getAttribute("title");
  void set title(String a) => setAttribute("title", a);

  String get description => getAttribute("description");
  void set description(String a) => setAttribute("description", a);


    Votes get castedVote => getChild("castedVote") as Votes;


  @override
  Election newEntity() => Election(concept);

  Elections newEntities() => Elections(concept);

  
}

abstract class ElectionsGen extends Entities<Election> {

  ElectionsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Elections newEntities() => Elections(concept);

  @override
  Election newEntity() => Election(concept);
}

// Commands for Election will be generated here
// Events for Election will be generated here
// Policies for Election will be generated here
