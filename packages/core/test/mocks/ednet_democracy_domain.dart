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

    // Delegate concept
    delegateConcept = Concept(model, 'Delegate');
    delegateConcept.entry = true;
    _addDelegateAttributes();

    // Expert concept
    expertConcept = Concept(model, 'Expert');
    expertConcept.entry = true;
    _addExpertAttributes();

    // Referendum concept
    referendumConcept = Concept(model, 'Referendum');
    referendumConcept.entry = true;
    _addReferendumAttributes();

    // Vote concept
    voteConcept = Concept(model, 'Vote');
    _addVoteAttributes();

    // Initiative concept
    initiativeConcept = Concept(model, 'Initiative');
    initiativeConcept.entry = true;
    _addInitiativeAttributes();
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
    // Vote requires a Citizen parent
    final citizenParent = Parent(voteConcept, citizenConcept, 'citizen');
    citizenParent.required = true;
    voteConcept.parents.add(citizenParent);

    // Vote requires a Referendum parent
    final referendumParent = Parent(
      voteConcept,
      referendumConcept,
      'referendum',
    );
    referendumParent.required = true;
    voteConcept.parents.add(referendumParent);

    // Delegate extends Citizen
    final citizenParentForDelegate = Parent(
      delegateConcept,
      citizenConcept,
      'citizen',
    );
    citizenParentForDelegate.required = true;
    delegateConcept.parents.add(citizenParentForDelegate);

    // Expert extends Citizen
    final citizenParentForExpert = Parent(
      expertConcept,
      citizenConcept,
      'citizen',
    );
    citizenParentForExpert.required = true;
    expertConcept.parents.add(citizenParentForExpert);

    // Initiative requires a Citizen parent (creator)
    final citizenParentForInitiative = Parent(
      initiativeConcept,
      citizenConcept,
      'creator',
    );
    citizenParentForInitiative.required = true;
    initiativeConcept.parents.add(citizenParentForInitiative);
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
    int quorum = 0,
  }) {
    final referendum = Referendum();
    referendum.concept = referendumConcept;
    referendum.setAttribute('title', title);
    referendum.setAttribute('description', description);
    referendum.setAttribute('startDate', startDate);
    referendum.setAttribute('endDate', endDate);
    referendum.setAttribute('quorum', quorum);
    return referendum;
  }

  /// Creates a vote with predefined attributes for testing
  Vote createVote({
    required Citizen citizen,
    required Referendum referendum,
    required String choice,
    int weight = 1,
    DateTime? timestamp,
  }) {
    final vote = Vote();
    vote.concept = voteConcept;
    vote.setAttribute('choice', choice);
    vote.setAttribute('weight', weight);
    vote.setAttribute('timestamp', timestamp ?? DateTime.now());
    vote.setParent('citizen', citizen);
    vote.setParent('referendum', referendum);
    return vote;
  }

  /// Creates an initiative with predefined attributes for testing
  Initiative createInitiative({
    required Citizen creator,
    required String title,
    required String description,
    required int requiredSignatures,
    int currentSignatures = 0,
    String status = 'Collecting',
  }) {
    final initiative = Initiative();
    initiative.concept = initiativeConcept;
    initiative.setAttribute('title', title);
    initiative.setAttribute('description', description);
    initiative.setAttribute('requiredSignatures', requiredSignatures);
    initiative.setAttribute('currentSignatures', currentSignatures);
    initiative.setAttribute('status', status);
    initiative.setParent('creator', creator);
    return initiative;
  }
}
