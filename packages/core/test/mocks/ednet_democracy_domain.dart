import 'package:ednet_core/ednet_core.dart';

/// This file provides a common EDNetOne direct democracy domain model
/// for use across test files, based on the domain-model design document.
///
/// The domain models a global direct democracy platform with concepts like
/// Citizens, Referendums, Votes, and Initiatives.

/// Citizen represents a verified individual with voting rights
class Citizen extends Entity<Citizen> {
  Citizen() : super();
}

/// Delegate is a citizen who can receive delegated voting power
class Delegate extends Entity<Delegate> {
  Delegate() : super();
}

/// Expert is a domain specialist who provides analysis on proposals
class Expert extends Entity<Expert> {
  Expert() : super();
}

/// Referendum represents a specific issue being voted on
class Referendum extends Entity<Referendum> {
  Referendum() : super();
}

/// Vote represents a citizen's vote on a specific referendum
class Vote extends Entity<Vote> {
  Vote() : super();
}

/// Initiative represents a proposal created by citizens
class Initiative extends Entity<Initiative> {
  Initiative() : super();
}

/// Provides a configured domain model for the EDNetOne direct democracy platform
class EDNetDemocracyDomain {
  late Domain domain;
  late Model model;
  late DomainModels domainModels;
  late DomainSession session;

  // Concepts
  late Concept citizenConcept;
  late Concept delegateConcept;
  late Concept expertConcept;
  late Concept referendumConcept;
  late Concept voteConcept;
  late Concept initiativeConcept;

  // Entity collections
  late Entities<Citizen> citizens;
  late Entities<Delegate> delegates;
  late Entities<Expert> experts;
  late Entities<Referendum> referendums;
  late Entities<Vote> votes;
  late Entities<Initiative> initiatives;

  EDNetDemocracyDomain() {
    _initDomain();
    _initModel();
    _initConcepts();
    _initEntities();
    _initRelationships();
    _initDomainModels();
  }

  void _initDomain() {
    domain = Domain('EDNetOne');
  }

  void _initModel() {
    model = Model(domain, 'DirectDemocracy');
  }

  void _initConcepts() {
    // Citizen concept
    citizenConcept = Concept(model, 'Citizen');
    citizenConcept.entry = true;
    _addCitizenAttributes();
    model.concepts.add(citizenConcept);

    // Delegate concept
    delegateConcept = Concept(model, 'Delegate');
    delegateConcept.entry = true;
    _addDelegateAttributes();
    model.concepts.add(delegateConcept);

    // Expert concept
    expertConcept = Concept(model, 'Expert');
    expertConcept.entry = true;
    _addExpertAttributes();
    model.concepts.add(expertConcept);

    // Referendum concept
    referendumConcept = Concept(model, 'Referendum');
    referendumConcept.entry = true;
    _addReferendumAttributes();
    model.concepts.add(referendumConcept);

    // Vote concept
    voteConcept = Concept(model, 'Vote');
    _addVoteAttributes();
    model.concepts.add(voteConcept);

    // Initiative concept
    initiativeConcept = Concept(model, 'Initiative');
    initiativeConcept.entry = true;
    _addInitiativeAttributes();
    model.concepts.add(initiativeConcept);
  }

  void _addCitizenAttributes() {
    final nameAttribute = Attribute(citizenConcept, 'name');
    nameAttribute.type = domain.getType('String');
    nameAttribute.required = true;
    citizenConcept.attributes.add(nameAttribute);

    final emailAttribute = Attribute(citizenConcept, 'email');
    emailAttribute.type = domain.getType('Email');
    emailAttribute.required = true;
    citizenConcept.attributes.add(emailAttribute);

    final idNumberAttribute = Attribute(citizenConcept, 'idNumber');
    idNumberAttribute.type = domain.getType('String');
    idNumberAttribute.required = true;
    citizenConcept.attributes.add(idNumberAttribute);

    final verifiedAttribute = Attribute(citizenConcept, 'verified');
    verifiedAttribute.type = domain.getType('bool');
    verifiedAttribute.required = true;
    verifiedAttribute.init = 'false';
    citizenConcept.attributes.add(verifiedAttribute);

    final registerDateAttribute = Attribute(citizenConcept, 'registerDate');
    registerDateAttribute.type = domain.getType('DateTime');
    registerDateAttribute.required = true;
    citizenConcept.attributes.add(registerDateAttribute);
  }

  void _addDelegateAttributes() {
    final delegatorCountAttribute = Attribute(
      delegateConcept,
      'delegatorCount',
    );
    delegatorCountAttribute.type = domain.getType('int');
    delegatorCountAttribute.init = '0';
    delegateConcept.attributes.add(delegatorCountAttribute);

    final specialtyAttribute = Attribute(delegateConcept, 'specialty');
    specialtyAttribute.type = domain.getType('String');
    delegateConcept.attributes.add(specialtyAttribute);
  }

  void _addExpertAttributes() {
    final areaOfExpertiseAttribute = Attribute(
      expertConcept,
      'areaOfExpertise',
    );
    areaOfExpertiseAttribute.type = domain.getType('String');
    areaOfExpertiseAttribute.required = true;
    expertConcept.attributes.add(areaOfExpertiseAttribute);

    final credentialsAttribute = Attribute(expertConcept, 'credentials');
    credentialsAttribute.type = domain.getType('String');
    expertConcept.attributes.add(credentialsAttribute);
  }

  void _addReferendumAttributes() {
    final titleAttribute = Attribute(referendumConcept, 'title');
    titleAttribute.type = domain.getType('String');
    titleAttribute.required = true;
    referendumConcept.attributes.add(titleAttribute);

    final descriptionAttribute = Attribute(referendumConcept, 'description');
    descriptionAttribute.type = domain.getType('String');
    descriptionAttribute.required = true;
    referendumConcept.attributes.add(descriptionAttribute);

    final startDateAttribute = Attribute(referendumConcept, 'startDate');
    startDateAttribute.type = domain.getType('DateTime');
    startDateAttribute.required = true;
    referendumConcept.attributes.add(startDateAttribute);

    final endDateAttribute = Attribute(referendumConcept, 'endDate');
    endDateAttribute.type = domain.getType('DateTime');
    endDateAttribute.required = true;
    referendumConcept.attributes.add(endDateAttribute);

    final quorumAttribute = Attribute(referendumConcept, 'quorum');
    quorumAttribute.type = domain.getType('int');
    quorumAttribute.init = '0';
    referendumConcept.attributes.add(quorumAttribute);
  }

  void _addVoteAttributes() {
    final choiceAttribute = Attribute(voteConcept, 'choice');
    choiceAttribute.type = domain.getType('String');
    choiceAttribute.required = true;
    voteConcept.attributes.add(choiceAttribute);

    final timestampAttribute = Attribute(voteConcept, 'timestamp');
    timestampAttribute.type = domain.getType('DateTime');
    timestampAttribute.required = true;
    voteConcept.attributes.add(timestampAttribute);

    final weightAttribute = Attribute(voteConcept, 'weight');
    weightAttribute.type = domain.getType('int');
    weightAttribute.init = '1';
    voteConcept.attributes.add(weightAttribute);
  }

  void _addInitiativeAttributes() {
    final titleAttribute = Attribute(initiativeConcept, 'title');
    titleAttribute.type = domain.getType('String');
    titleAttribute.required = true;
    initiativeConcept.attributes.add(titleAttribute);

    final descriptionAttribute = Attribute(initiativeConcept, 'description');
    descriptionAttribute.type = domain.getType('String');
    descriptionAttribute.required = true;
    initiativeConcept.attributes.add(descriptionAttribute);

    final requiredSignaturesAttribute = Attribute(
      initiativeConcept,
      'requiredSignatures',
    );
    requiredSignaturesAttribute.type = domain.getType('int');
    requiredSignaturesAttribute.required = true;
    initiativeConcept.attributes.add(requiredSignaturesAttribute);

    final currentSignaturesAttribute = Attribute(
      initiativeConcept,
      'currentSignatures',
    );
    currentSignaturesAttribute.type = domain.getType('int');
    currentSignaturesAttribute.init = '0';
    initiativeConcept.attributes.add(currentSignaturesAttribute);

    final statusAttribute = Attribute(initiativeConcept, 'status');
    statusAttribute.type = domain.getType('String');
    statusAttribute.init = 'Collecting';
    initiativeConcept.attributes.add(statusAttribute);
  }

  void _initEntities() {
    citizens = Entities<Citizen>();
    citizens.concept = citizenConcept;

    delegates = Entities<Delegate>();
    delegates.concept = delegateConcept;

    experts = Entities<Expert>();
    experts.concept = expertConcept;

    referendums = Entities<Referendum>();
    referendums.concept = referendumConcept;

    votes = Entities<Vote>();
    votes.concept = voteConcept;

    initiatives = Entities<Initiative>();
    initiatives.concept = initiativeConcept;
  }

  void _initRelationships() {
    // Vote relationships
    final citizenParent = Parent(voteConcept, citizenConcept, 'citizen');
    citizenParent.required = true;
    voteConcept.parents.add(citizenParent);

    final referendumParent = Parent(
      voteConcept,
      referendumConcept,
      'referendum',
    );
    referendumParent.required = true;
    voteConcept.parents.add(referendumParent);

    // Citizen-Vote relationship
    final citizenVotes = Child(citizenConcept, voteConcept, 'votes');
    citizenConcept.children.add(citizenVotes);

    // Referendum-Vote relationship
    final referendumVotes = Child(referendumConcept, voteConcept, 'votes');
    referendumConcept.children.add(referendumVotes);

    // Initiative-Citizen relationship (proposer)
    final proposerParent = Parent(
      initiativeConcept,
      citizenConcept,
      'proposer',
    );
    proposerParent.required = true;
    initiativeConcept.parents.add(proposerParent);

    // Delegate-Citizen inheritance
    final delegateCitizenParent = Parent(
      delegateConcept,
      citizenConcept,
      'citizen',
    );
    delegateConcept.parents.add(delegateCitizenParent);

    // Expert-Citizen inheritance
    final expertCitizenParent = Parent(
      expertConcept,
      citizenConcept,
      'citizen',
    );
    expertConcept.parents.add(expertCitizenParent);
  }

  void _initDomainModels() {
    domainModels = DomainModels(domain);
    session = DomainSession(domainModels);
  }

  /// Creates a citizen with predefined attributes for testing
  Citizen createCitizen({
    required String name,
    required String email,
    required String idNumber,
    bool verified = false,
    DateTime? registerDate,
  }) {
    final citizen = Citizen();
    citizen.concept = citizenConcept;

    citizen.setAttribute('name', name);
    citizen.setAttribute('email', email);
    citizen.setAttribute('idNumber', idNumber);
    citizen.setAttribute('verified', verified);
    citizen.setAttribute('registerDate', registerDate ?? DateTime.now());

    return citizen;
  }

  /// Creates a referendum with predefined attributes for testing
  Referendum createReferendum({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final referendum = Referendum();
    referendum.concept = referendumConcept;

    referendum.setAttribute('title', title);
    referendum.setAttribute('description', description);
    referendum.setAttribute('startDate', startDate);
    referendum.setAttribute('endDate', endDate);

    return referendum;
  }

  /// Creates a vote with predefined attributes for testing
  Vote createVote({
    required Citizen citizen,
    required Referendum referendum,
    required String choice,
  }) {
    final vote = Vote();
    vote.concept = voteConcept;

    vote.setAttribute('choice', choice);
    vote.setAttribute('timestamp', DateTime.now());

    // Set up parent relationships
    vote.setParent('citizen', citizen);
    vote.setParent('referendum', referendum);

    return vote;
  }

  /// Creates an initiative with predefined attributes for testing
  Initiative createInitiative({
    required String title,
    required String description,
    required Citizen proposer,
  }) {
    final initiative = Initiative();
    initiative.concept = initiativeConcept;

    initiative.setAttribute('title', title);
    initiative.setAttribute('description', description);
    initiative.setParent('proposer', proposer);

    return initiative;
  }

  /// Creates a delegate (which extends citizen) with predefined attributes
  Delegate createDelegate({
    required String name,
    required String email,
    required String idNumber,
    String? specialty,
    bool verified = false,
    DateTime? registerDate,
    int delegatorCount = 0,
  }) {
    // First create a citizen for the parent relationship
    final citizen = createCitizen(
      name: name,
      email: email,
      idNumber: idNumber,
      verified: verified,
      registerDate: registerDate,
    );

    // Create the delegate entity
    final delegate = Delegate();
    delegate.concept = delegateConcept;

    // Set up parent relationship with citizen
    delegate.setParent('citizen', citizen);

    // Set delegate-specific attributes
    delegate.setAttribute('delegatorCount', delegatorCount);
    if (specialty != null) {
      delegate.setAttribute('specialty', specialty);
    }

    return delegate;
  }

  /// Creates an expert (which extends citizen) with predefined attributes
  Expert createExpert({
    required String name,
    required String email,
    required String idNumber,
    required String areaOfExpertise,
    String? credentials,
    bool verified = false,
    DateTime? registerDate,
  }) {
    // First create a citizen for the parent relationship
    final citizen = createCitizen(
      name: name,
      email: email,
      idNumber: idNumber,
      verified: verified,
      registerDate: registerDate,
    );

    // Create the expert entity
    final expert = Expert();
    expert.concept = expertConcept;

    // Set up parent relationship with citizen
    expert.setParent('citizen', citizen);

    // Set expert-specific attributes
    expert.setAttribute('areaOfExpertise', areaOfExpertise);
    if (credentials != null) {
      expert.setAttribute('credentials', credentials);
    }

    return expert;
  }

  /// Creates a complete voting scenario with citizens, referendum, and votes
  Map<String, dynamic> createVotingScenario({
    int citizenCount = 5,
    String referendumTitle = 'Test Referendum',
    String referendumDescription = 'Test Description',
    DateTime? startDate,
    DateTime? endDate,
    List<String>? choices,
  }) {
    final citizens = <Citizen>[];
    final votes = <Vote>[];
    final voterChoices = choices ?? ['Yes', 'No', 'Abstain'];
    final now = DateTime.now();
    final start = startDate ?? now.subtract(const Duration(days: 1));
    final end = endDate ?? now.add(const Duration(days: 7));

    // Create referendum
    final referendum = createReferendum(
      title: referendumTitle,
      description: referendumDescription,
      startDate: start,
      endDate: end,
    );

    // Create citizens and their votes
    for (int i = 1; i <= citizenCount; i++) {
      final citizen = createCitizen(
        name: 'Voter $i',
        email: 'voter$i@democracy.org',
        idNumber: 'C10000$i',
      );
      citizens.add(citizen);

      // Assign a choice to this citizen based on position
      final choiceIndex = i % voterChoices.length;
      final choice = voterChoices[choiceIndex];

      final vote = createVote(
        citizen: citizen,
        referendum: referendum,
        choice: choice,
      );

      votes.add(vote);
    }

    return {'citizens': citizens, 'referendum': referendum, 'votes': votes};
  }

  /// Creates a complete initiative scenario with creator, initiative, and supporting citizens
  Map<String, dynamic> createInitiativeScenario({
    required String title,
    required String description,
    int requiredSignatures = 10,
    int supporterCount = 5,
    String creatorName = 'Initiative Creator',
  }) {
    // Create initiative creator
    final creator = createCitizen(
      name: creatorName,
      email: 'creator@democracy.org',
      idNumber: 'C999999',
    );

    // Create initiative
    final initiative = createInitiative(
      title: title,
      description: description,
      proposer: creator,
    );

    // Create supporters
    final supporters = <Citizen>[];
    for (int i = 1; i <= supporterCount; i++) {
      final supporter = createCitizen(
        name: 'Supporter $i',
        email: 'supporter$i@democracy.org',
        idNumber: 'S10000$i',
      );
      supporters.add(supporter);
    }

    return {
      'creator': creator,
      'initiative': initiative,
      'supporters': supporters,
    };
  }

  /// Creates a liquid democracy scenario with voters delegating to delegates
  Map<String, dynamic> createLiquidDemocracyScenario({
    int delegateCount = 3,
    int voterCount = 10,
    List<String>? specialties,
  }) {
    final areas = specialties ?? ['Economic', 'Environmental', 'Social'];
    final delegates = <Delegate>[];
    final voters = <Citizen>[];

    // Create delegates for each specialty area
    for (int i = 0; i < delegateCount; i++) {
      final specialty = areas[i % areas.length];
      final delegate = createDelegate(
        name: '$specialty Delegate',
        email: '${specialty.toLowerCase()}@democracy.org',
        idNumber: 'D10000$i',
        specialty: specialty,
      );
      delegates.add(delegate);
    }

    // Create voters who delegate to specialists
    for (int i = 1; i <= voterCount; i++) {
      final voter = createCitizen(
        name: 'Delegating Voter $i',
        email: 'voter$i@democracy.org',
        idNumber: 'V10000$i',
      );
      voters.add(voter);

      // Assign each voter to a delegate based on position
      final delegateIndex = i % delegateCount;
      final assignedDelegate = delegates[delegateIndex];

      // Increase the delegate's count (simulating delegation)
      final currentCount =
          assignedDelegate.getAttribute('delegatorCount') as int;
      assignedDelegate.setAttribute('delegatorCount', currentCount + 1);
    }

    return {'delegates': delegates, 'voters': voters};
  }
}
