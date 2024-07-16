import 'package:ednet_core/ednet_core.dart';

abstract class TestEntityBase extends Entity<TestEntity> {
  TestEntityBase(Concept concept) {
    this.concept = concept;
  }

  String get name => getAttribute('name');

  void set name(String a) => setAttribute('name', a);

  String get description => getAttribute('description');

  void set description(String a) => setAttribute('description', a);

  TestEntity newEntity() => TestEntity(concept);

  ConcreteEntities newEntities() => ConcreteEntities(concept);
}

abstract class TestEntitiesBase extends Entities<TestEntity> {
  TestEntitiesBase(Concept concept) {
    this.concept = concept;
  }

  ConcreteEntities newEntities() => ConcreteEntities(concept);

  TestEntity newEntity() => TestEntity(concept);
}

class TestEntity extends TestEntityBase {
  TestEntity(super.concept);
}

class ConcreteEntities extends TestEntitiesBase {
  ConcreteEntities(super.concept);
}

class Citizen extends TestEntityBase {
  Citizen(Concept concept) : super(concept);

  String get citizenId => getAttribute('citizenId');

  void set citizenId(String a) => setAttribute('citizenId', a);

  String get firstName => getAttribute('firstName');

  void set firstName(String a) => setAttribute('firstName', a);

  String get lastName => getAttribute('lastName');

  void set lastName(String a) => setAttribute('lastName', a);
}

class Candidate extends TestEntityBase {
  Candidate(Concept concept) : super(concept);

  String get candidateId => getAttribute('candidateId');

  void set candidateId(String a) => setAttribute('candidateId', a);

  String get firstName => getAttribute('firstName');

  void set firstName(String a) => setAttribute('firstName', a);

  String get lastName => getAttribute('lastName');

  void set lastName(String a) => setAttribute('lastName', a);

  int get signatures => getAttribute('signatures');

  void set signatures(int a) => setAttribute('signatures', a);

  String get party => getAttribute('party');

  void set party(String a) => setAttribute('party', a);

  String get district => getAttribute('district');

  void set district(String a) => setAttribute('district', a);
}

class TestDomain {
  final Domain domain;
  late final Model testModel;
  late final Concept parentConcept;
  late final Concept testConcept;
  late final Concept childConcept;
  late final Concept userConcept;
  late final Concept postConcept;
  late final Concept commentConcept;
  late final Concept citizenConcept;
  late final Concept electionConcept;
  late final Concept districtConcept;
  late final Concept voteConcept;
  late final Concept candidateConcept;
  late Citizen citizen;
  late Candidate candidate;

  TestDomain(this.domain) {
    _initializeDomain();
    _initializeModel();
    _initializeConcepts();
    _initializeAttributes();
    _setRelationships();
    _initEntities();
  }

  void _initializeDomain() {
    // Initialize the domain if necessary.
    // This is just a placeholder for any domain-specific initialization.
  }

  void _initializeModel() {
    testModel = Model(domain, 'Test');
  }

  void _initializeConcepts() {
    parentConcept = _createConcept('ParentConcept');
    testConcept = _createConcept('TestConcept');
    childConcept = _createConcept('ChildConcept');
    userConcept = _createConcept('User');
    postConcept = _createConcept('Post');
    commentConcept = _createConcept('Comment');
    citizenConcept = _createConcept('Citizen');
    electionConcept = _createConcept('Election');
    districtConcept = _createConcept('District');
    voteConcept = _createConcept('Vote');
    candidateConcept = _createConcept('Candidate');
  }

  void _initializeAttributes() {
    var TString = AttributeType(domain, 'String');
    var TInt = AttributeType(domain, 'int');
    var TBool = AttributeType(domain, 'bool');

    Attribute(parentConcept, 'parentType')..type = TString;

    Attribute(testConcept, 'age')..type = TInt;
    Attribute(testConcept, 'name')..type = TString;
    Attribute(testConcept, 'email')..type = TString;
    Attribute(testConcept, 'parentType')..type = TString;

    Attribute(childConcept, 'email')..type = TString;

    Attribute(userConcept, 'age')..type = TInt;
    Attribute(userConcept, 'name')..type = TString;
    Attribute(userConcept, 'email')..type = TString;

    Attribute(postConcept, 'content')..type = TString;

    Attribute(commentConcept, 'content')..type = TString;

    Attribute(citizenConcept, 'age')..type = TInt;
    Attribute(citizenConcept, 'nationality')..type = TString;
    Attribute(citizenConcept, 'yearsInDistrict')..type = TInt;
    Attribute(citizenConcept, 'hasDebts')..type = TBool;
    Attribute(citizenConcept, 'hasCourtCases')..type = TBool;
    Attribute(citizenConcept, 'courtCaseType')..type = TString;

    Attribute(electionConcept, 'name')..type = TString;

    Attribute(districtConcept, 'districtCode')..type = TString;
    Attribute(districtConcept, 'location')..type = TString;

    Attribute(voteConcept, 'candidate')..type = TString;

    Attribute(candidateConcept, 'signatures')..type = TInt;

    Attribute(candidateConcept, 'age')..type = TInt;
    Attribute(candidateConcept, 'nationality')..type = TString;
    Attribute(candidateConcept, 'yearsInDistrict')..type = TInt;
    Attribute(candidateConcept, 'hasDebts')..type = TBool;
    Attribute(candidateConcept, 'hasCourtCases')..type = TBool;
  }

  void _setRelationships() {
    testConcept.parents.add(Parent(testConcept, parentConcept, 'parentType'));
    testConcept.children.add(Child(testConcept, childConcept, 'children'));

    userConcept.children.add(Child(userConcept, postConcept, 'posts'));
    postConcept.parents.add(Parent(postConcept, userConcept, 'author'));
    postConcept.children.add(Child(postConcept, commentConcept, 'comments'));
    commentConcept.parents.add(Parent(commentConcept, postConcept, 'post'));
    commentConcept.children
        .add(Child(commentConcept, commentConcept, 'replies'));

    citizenConcept.children.add(Child(citizenConcept, voteConcept, 'votes'));
    voteConcept.parents.add(Parent(voteConcept, citizenConcept, 'citizen'));
    voteConcept.parents.add(Parent(voteConcept, electionConcept, 'election'));
    voteConcept.parents.add(Parent(voteConcept, districtConcept, 'district'));
    candidateConcept.parents
        .add(Parent(candidateConcept, electionConcept, 'election'));
  }

  Concept _createConcept(String name) {
    return Concept(testModel, name);
  }

  void _initEntities() {
    citizen = Citizen(citizenConcept);
    candidate = Candidate(candidateConcept);
  }
}
