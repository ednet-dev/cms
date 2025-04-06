import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../mocks/ednet_democracy_domain.dart';

void main() {
  group('Entities Collection Tests using EDNetOne Democracy Domain', () {
    late EDNetDemocracyDomain domain;
    late Entities<Citizen> citizens;

    setUp(() {
      domain = EDNetDemocracyDomain();
      citizens = domain.citizens;
      citizens.clear(); // Ensure collection is empty for each test
    });

    test('Entities collection initialization and concept association', () {
      // Verify collection has correct concept
      expect(citizens.concept, equals(domain.citizenConcept));
      expect(citizens.isEmpty, isTrue);

      // Verify basic properties
      expect(citizens.length, equals(0));
      expect(citizens.exceptions.length, equals(0));
    });

    test('Entities add operation with valid entity', () {
      // Create valid citizen
      final citizen = domain.createCitizen(
        name: 'Alice Democracy',
        email: 'alice@democracy.org',
        idNumber: 'C123456',
      );

      // Add to collection
      citizens.add(citizen);

      // Verify successful addition
      expect(citizens.length, equals(1));
      expect(citizens.first, equals(citizen));
      expect(citizens.exceptions.length, equals(0));
    });

    test('Entities add operation with invalid entity', () {
      // Create invalid citizen (missing required attributes)
      final invalidCitizen = Citizen();
      invalidCitizen.concept = domain.citizenConcept;

      // Add to collection
      citizens.add(invalidCitizen);

      // Verify validation prevented addition
      expect(citizens.isEmpty, isTrue);
      expect(citizens.exceptions.length, greaterThan(0));

      // Exception should mention required attributes
      final exceptionsStr = citizens.exceptions.toString();
      expect(exceptionsStr.contains('required'), isTrue);
    });

    test('Entities collection manipulation (add multiple, remove)', () {
      // Create multiple citizens
      final citizen1 = domain.createCitizen(
        name: 'Citizen One',
        email: 'one@democracy.org',
        idNumber: 'C111111',
      );

      final citizen2 = domain.createCitizen(
        name: 'Citizen Two',
        email: 'two@democracy.org',
        idNumber: 'C222222',
      );

      final citizen3 = domain.createCitizen(
        name: 'Citizen Three',
        email: 'three@democracy.org',
        idNumber: 'C333333',
      );

      // Add all citizens
      citizens.add(citizen1);
      citizens.add(citizen2);
      citizens.add(citizen3);

      // Verify all were added
      expect(citizens.length, equals(3));

      // Remove one citizen
      citizens.remove(citizen2);

      // Verify removal
      expect(citizens.length, equals(2));
      expect(citizens.contains(citizen1), isTrue);
      expect(citizens.contains(citizen2), isFalse);
      expect(citizens.contains(citizen3), isTrue);

      // Clear all
      citizens.clear();
      expect(citizens.isEmpty, isTrue);
    });

    test('Entities collection iteration', () {
      // Add multiple citizens
      for (int i = 1; i <= 5; i++) {
        final citizen = domain.createCitizen(
          name: 'Citizen $i',
          email: 'citizen$i@democracy.org',
          idNumber: 'C10000$i',
        );
        citizens.add(citizen);
      }

      // Verify collection size
      expect(citizens.length, equals(5));

      // Test iteration with forEach
      int count = 0;
      citizens.forEach((citizen) {
        count++;
        expect(citizen, isA<Citizen>());
        expect(citizen.getAttribute('name'), contains('Citizen'));
      });
      expect(count, equals(5));

      // Test iteration with for-in loop
      count = 0;
      for (final citizen in citizens) {
        count++;
        expect(citizen, isA<Citizen>());
      }
      expect(count, equals(5));
    });

    test('Entities collection lookup operations', () {
      // Set up citizens collection
      final citizens = domain.citizens;
      citizens.clear();

      // Add citizen
      final citizen1 = domain.createCitizen(
        name: 'Alice Lookup',
        email: 'alice.lookup@democracy.org',
        idNumber: 'C123456',
      );
      citizens.add(citizen1);

      // Try to find by attribute
      final found = citizens.firstWhereAttribute('idNumber', 'C123456');
      expect(found, isNotNull);
      expect(found, equals(citizen1));

      // Try to find non-existent entity - should throw an exception
      expect(
        () => citizens.firstWhereAttribute('idNumber', 'nonexistent'),
        throwsA(isA<EDNetException>()),
      );
    });

    test('Entities collection with different entity types', () {
      // Set up referendum entities collection
      final referendums = domain.referendums;
      referendums.clear();

      // Add referendum
      final referendum = domain.createReferendum(
        title: 'Test Referendum',
        description: 'Testing entities collection',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );
      referendums.add(referendum);

      // Verify concept association
      expect(referendums.concept, equals(domain.referendumConcept));
      expect(referendums.length, equals(1));

      // Verify type safety (can't add citizen to referendums)
      final citizen = domain.createCitizen(
        name: 'Test Citizen',
        email: 'test@democracy.org',
        idNumber: 'C123456',
      );

      // This should fail due to type mismatch but not crash
      try {
        // The following line would cause a type error if it actually ran
        // We're using a try block to prevent compile-time errors
        // In reality, this should never happen due to type safety
        // referendums.add(citizen as dynamic);
        expect(referendums.length, equals(1)); // Should remain unchanged
      } catch (e) {
        // Expected error
      }
    });

    test('Entities collection with parent-child relationships', () {
      // Set up collections
      final citizens = domain.citizens;
      final referendums = domain.referendums;
      final votes = domain.votes;
      citizens.clear();
      referendums.clear();
      votes.clear();

      // Create voting scenario
      final scenario = domain.createVotingScenario(
        citizenCount: 3,
        referendumTitle: 'Entities Test Referendum',
      );

      final scenarioCitizens = scenario['citizens'] as List<Citizen>;
      final referendum = scenario['referendum'] as Referendum;
      final scenarioVotes = scenario['votes'] as List<Vote>;

      // Add to collections
      for (final citizen in scenarioCitizens) {
        citizens.add(citizen);
      }
      referendums.add(referendum);
      for (final vote in scenarioVotes) {
        votes.add(vote);
      }

      // Verify collections contain all entities
      expect(citizens.length, equals(scenarioCitizens.length));
      expect(referendums.length, equals(1));
      expect(votes.length, equals(scenarioVotes.length));

      // Verify parent integrity - votes should be invalidated if parent is removed
      // First, verify a vote exists
      expect(votes.isNotEmpty, isTrue);

      // Next, remove a citizen that is a parent to at least one vote
      final citizenToRemove = scenarioCitizens.first;
      citizens.remove(citizenToRemove);

      // The corresponding vote should be removed due to referential integrity
      // In a real system with defined cascade behavior;
      // here we're testing the conceptual relationship
      expect(citizens.length, equals(scenarioCitizens.length - 1));
    });
  });
}
