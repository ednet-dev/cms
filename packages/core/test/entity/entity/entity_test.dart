import 'package:test/test.dart';
import '../../mocks/ednet_democracy_domain.dart';

void main() {
  group('Entity Tests using EDNetOne Democracy Domain', () {
    late EDNetDemocracyDomain domain;

    setUp(() {
      domain = EDNetDemocracyDomain();
    });

    test('Entity creation with required attributes', () {
      // Create citizen with all required attributes
      final citizen = domain.createCitizen(
        name: 'Alice Citizen',
        email: 'alice@democracy.org',
        idNumber: 'C123456',
      );

      // Check that entity exists and has expected type
      expect(citizen, isNotNull);
      expect(citizen, isA<Citizen>());
      expect(citizen.concept, equals(domain.citizenConcept));

      // Check attributes are set correctly
      expect(citizen.getAttribute('name'), equals('Alice Citizen'));
      expect(citizen.getAttribute('email'), equals('alice@democracy.org'));
      expect(citizen.getAttribute('idNumber'), equals('C123456'));
      expect(citizen.getAttribute('verified'), equals(false)); // Default value
      expect(citizen.getAttribute('registerDate'), isNotNull);
    });

    test('Entity attribute getters and setters', () {
      final citizen = domain.createCitizen(
        name: 'Bob Citizen',
        email: 'bob@democracy.org',
        idNumber: 'C654321',
      );

      // Verify initial attribute values
      expect(citizen.getAttribute('name'), equals('Bob Citizen'));

      // Set attribute to new value
      citizen.setAttribute('name', 'Bob Democracy');
      expect(citizen.getAttribute('name'), equals('Bob Democracy'));

      // Set boolean attribute
      citizen.setAttribute('verified', true);
      expect(citizen.getAttribute('verified'), equals(true));

      // Verify attribute existence by checking if getAttribute returns non-null
      expect(citizen.getAttribute('name'), isNotNull);
      expect(citizen.getAttribute('nonexistent'), isNull);
    });

    test('Entity code generation and string representation', () {
      final citizen = domain.createCitizen(
        name: 'Charlie Citizen',
        email: 'charlie@democracy.org',
        idNumber: 'C987654',
      );

      // Entity should have non-empty oid
      expect(citizen.oid, isNotNull);
      expect(citizen.oid.toString().isNotEmpty, isTrue);

      // toString should contain basic entity info
      final entityString = citizen.toString();
      expect(entityString, contains('Citizen'));
      expect(entityString, contains('oid'));
    });

    test('Entity parent-child relationships', () {
      // Create referendum and citizen for voting relationship
      final citizen = domain.createCitizen(
        name: 'Voter',
        email: 'voter@democracy.org',
        idNumber: 'V123456',
      );
      print('Citizen concept: ${citizen.concept != null ? 'set' : 'null'}');

      final referendum = domain.createReferendum(
        title: 'Test Referendum',
        description: 'A test referendum for entity relationships',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      print(
        'Referendum concept: ${referendum.concept != null ? 'set' : 'null'}',
      );

      // Create vote with parent relationships
      final vote = domain.createVote(
        citizen: citizen,
        referendum: referendum,
        choice: 'Yes',
      );
      print('Vote concept: ${vote.concept != null ? 'set' : 'null'}');

      // Verify parent relationships
      final citizenParentFromVote = vote.getParent('citizen');
      final referendumParentFromVote = vote.getParent('referendum');

      expect(
        citizenParentFromVote,
        isNotNull,
        reason: 'Citizen parent from vote should not be null',
      );
      expect(
        referendumParentFromVote,
        isNotNull,
        reason: 'Referendum parent from vote should not be null',
      );

      expect(citizenParentFromVote, equals(citizen));
      expect(referendumParentFromVote, equals(referendum));

      // Verify parent links in concept model - manual safety checks
      final voteParents = domain.voteConcept.parents;
      print('Vote parents length: ${voteParents.length}');

      // Manual verification of parent concepts
      bool foundCitizenParent = false;
      bool foundReferendumParent = false;

      // Manually iterate and check for expected parents by code only
      for (var parent in voteParents) {
        try {
          print('Checking parent with code: ${parent.code}');
          if (parent.code == 'citizen') {
            foundCitizenParent = true;
            print('Found citizen parent');
          }
          if (parent.code == 'referendum') {
            foundReferendumParent = true;
            print('Found referendum parent');
          }
        } catch (e) {
          print('Error examining parent: $e');
        }
      }

      expect(
        foundCitizenParent,
        isTrue,
        reason: 'Should find citizen parent in vote concept by code',
      );
      expect(
        foundReferendumParent,
        isTrue,
        reason: 'Should find referendum parent in vote concept by code',
      );
    });

    test('Entity inheritance relationship', () {
      // Create delegate which extends citizen
      final delegate = domain.createDelegate(
        name: 'Delegate Person',
        email: 'delegate@democracy.org',
        idNumber: 'D123456',
        specialty: 'Environmental',
      );

      // Verify delegate has its own attributes
      expect(delegate.getAttribute('specialty'), equals('Environmental'));
      expect(delegate.getAttribute('delegatorCount'), equals(0));

      // Verify delegate has access to citizen parent
      final citizenParent = delegate.getParent('citizen');
      expect(citizenParent, isNotNull);

      if (citizenParent is Citizen) {
        expect(citizenParent, isA<Citizen>());
        expect(citizenParent.getAttribute('name'), equals('Delegate Person'));

        // Attribute changes in parent should be accessible through child
        citizenParent.setAttribute('verified', true);
        expect(citizenParent.getAttribute('verified'), equals(true));
      }
    });

    test('Entity validation with missing required attributes', () {
      // Create citizen without required attributes
      final invalidCitizen = Citizen();
      invalidCitizen.concept = domain.citizenConcept;

      // Set up collection for validation
      final citizens = domain.citizens;

      // Try to add invalid entity
      citizens.add(invalidCitizen);

      // Verify entity was not added due to validation errors
      expect(citizens.isEmpty, isTrue);
      expect(citizens.exceptions.length > 0, isTrue);

      // Check for specific validation errors
      final exceptionsString = citizens.exceptions.toString();
      expect(exceptionsString.contains('required'), isTrue);
      expect(exceptionsString.contains('name'), isTrue);
      expect(exceptionsString.contains('email'), isTrue);
      expect(exceptionsString.contains('idNumber'), isTrue);
    });

    test('Entity validation with invalid attribute types', () {
      // Create citizen with valid required attributes
      final citizen = domain.createCitizen(
        name: 'Dana Citizen',
        email: 'dana@democracy.org',
        idNumber: 'C123456',
      );

      // Set up collection for validation
      final citizens = domain.citizens;
      citizens.clear();

      // Try to set invalid attribute type
      citizen.setAttribute('verified', 'not-a-boolean');

      // Try to add entity with invalid attribute type
      citizens.add(citizen);

      // Verify entity was not added due to validation errors
      expect(citizens.isEmpty, isTrue);
      expect(citizens.exceptions.length > 0, isTrue);

      // Check for specific validation errors
      final exceptionsString = citizens.exceptions.toString();
      expect(exceptionsString.contains('type'), isTrue);
      expect(exceptionsString.contains('verified'), isTrue);
    });

    test('Entity creation via vote scenario', () {
      // Create a voting scenario using our helper method
      final scenario = domain.createVotingScenario(
        citizenCount: 3,
        referendumTitle: 'Entity Test Referendum',
      );

      final citizens = scenario['citizens'] as List<Citizen>;
      final referendum = scenario['referendum'] as Referendum;
      final votes = scenario['votes'] as List<Vote>;

      // Verify scenario created expected entities
      expect(citizens.length, equals(3));
      expect(
        referendum.getAttribute('title'),
        equals('Entity Test Referendum'),
      );
      expect(votes.length, equals(3));

      // Verify votes have correct parent relationships
      for (int i = 0; i < votes.length; i++) {
        final vote = votes[i];
        final citizen = citizens[i];

        expect(vote.getParent('citizen'), equals(citizen));
        expect(vote.getParent('referendum'), equals(referendum));
      }
    });
  });
}
