part of democracy_direct;

// lib/democracy/direct/model.dart

class DirectModel extends DirectEntries {
  DirectModel(Model model) : super(model);

  void fromJsonToCitizenEntry() {
    fromJsonToEntry(democracyDirectCitizenEntry);
  }

  void fromJsonToElectionEntry() {
    fromJsonToEntry(democracyDirectElectionEntry);
  }

  void fromJsonToModel() {
    fromJson(democracyDirectModel);
  }

  void init() {
    initCitizens();
    initElections();
  }

  void initCitizens() {
    var citizen1 = Citizen(citizens.concept);
    citizen1.firstName = 'debt';
    citizen1.lastName = 'slate';
    citizen1.email = 'notch';
    citizens.add(citizen1);

    var proposalConcept = model.concepts.singleWhereCode('Proposal');
    var proposalForRegularMeetings = Proposal(proposalConcept!)
      ..description = 'Regular meetings on each first Monday of the month';
    citizen1.proposed.add(proposalForRegularMeetings);
    var proposalForBudget = Proposal(proposalConcept)
      ..description = 'Budget for the next year';
    citizen1.proposed.add(proposalForBudget);

    var citizen2 = Citizen(citizens.concept);
    citizen2.firstName = 'picture';
    citizen2.lastName = 'beans';
    citizen2.email = 'lifespan';
    citizens.add(citizen2);
  }

  void initElections() {
    var election1 = Election(elections.concept);
    election1.title = 'family';
    election1.description = 'discount';
    var election1Candidate = citizens.random();
    election1.candidate = election1Candidate;
    elections.add(election1);
    election1Candidate.elections.add(election1);

    var election2 = Election(elections.concept);
    election2.title = 'agreement';
    election2.description = 'judge';
    var election2Candidate = citizens.random();
    election2.candidate = election2Candidate;
    elections.add(election2);
    election2Candidate.elections.add(election2);
  }

// added after code gen - begin

// added after code gen - end
}
