import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../mocks/ednet_democracy_domain.dart';

void main() {
  group(
    'Entities Filtering and Sorting Tests using EDNetOne Democracy Domain',
    () {
      late EDNetDemocracyDomain domain;
      late Entities<Citizen> citizens;

      setUp(() {
        domain = EDNetDemocracyDomain();
        citizens = domain.citizens;
        citizens.clear(); // Ensure collection is empty for each test

        // Add a diverse set of test citizens
        final alice = domain.createCitizen(
          name: 'Alice Democracy',
          email: 'alice@democracy.org',
          idNumber: 'C10001',
          verified: true,
        );
        alice.setAttribute('age', 32);
        citizens.add(alice);

        final bob = domain.createCitizen(
          name: 'Bob Citizen',
          email: 'bob@democracy.org',
          idNumber: 'C10002',
          verified: false,
        );
        bob.setAttribute('age', 45);
        citizens.add(bob);

        final charlie = domain.createCitizen(
          name: 'Charlie Voter',
          email: 'charlie@democracy.org',
          idNumber: 'C10003',
          verified: true,
        );
        charlie.setAttribute('age', 29);
        citizens.add(charlie);

        final dave = domain.createCitizen(
          name: 'Dave Representative',
          email: 'dave@democracy.org',
          idNumber: 'C10004',
          verified: true,
        );
        dave.setAttribute('age', 51);
        citizens.add(dave);

        final eve = domain.createCitizen(
          name: 'Eve Activist',
          email: 'eve@democracy.org',
          idNumber: 'C10005',
          verified: false,
        );
        eve.setAttribute('age', 38);
        citizens.add(eve);
      });

      test('Entities selectWhere method basic filtering', () {
        // Select verified citizens only
        final verifiedCitizens = citizens.selectWhere(
          (citizen) => citizen.getAttribute('verified') == true,
        );

        expect(verifiedCitizens, isA<Entities<Citizen>>());
        expect(verifiedCitizens.length, equals(3));

        for (final citizen in verifiedCitizens) {
          expect(citizen.getAttribute('verified'), isTrue);
        }

        // Select unverified citizens only
        final unverifiedCitizens = citizens.selectWhere(
          (citizen) => citizen.getAttribute('verified') == false,
        );

        expect(unverifiedCitizens.length, equals(2));

        for (final citizen in unverifiedCitizens) {
          expect(citizen.getAttribute('verified'), isFalse);
        }
      });

      test('Entities selectWhere method with complex filtering', () {
        // Select citizens who are verified AND under 40
        final youngVerifiedCitizens = citizens.selectWhere(
          (citizen) =>
              citizen.getAttribute('verified') == true &&
              (citizen.getAttribute('age') as int) < 40,
        );

        expect(youngVerifiedCitizens.length, equals(2));

        for (final citizen in youngVerifiedCitizens) {
          expect(citizen.getAttribute('verified'), isTrue);
          expect(citizen.getAttribute('age') as int, lessThan(40));
        }

        // Select citizens who are either unverified OR over 50
        final unverifiedOrSeniorCitizens = citizens.selectWhere(
          (citizen) =>
              citizen.getAttribute('verified') == false ||
              (citizen.getAttribute('age') as int) > 50,
        );

        expect(unverifiedOrSeniorCitizens.length, equals(3));

        for (final citizen in unverifiedOrSeniorCitizens) {
          expect(
            citizen.getAttribute('verified') == false ||
                (citizen.getAttribute('age') as int) > 50,
            isTrue,
          );
        }
      });

      test('Entities selectWhere method with name pattern filtering', () {
        // Select citizens whose names contain "Voter" or "Representative"
        final officialCitizens = citizens.selectWhere(
          (citizen) =>
              (citizen.getAttribute('name') as String).contains('Voter') ||
              (citizen.getAttribute('name') as String).contains(
                'Representative',
              ),
        );

        expect(officialCitizens.length, equals(2));

        final names =
            officialCitizens
                .map((citizen) => citizen.getAttribute('name') as String)
                .toList();

        expect(names, contains('Charlie Voter'));
        expect(names, contains('Dave Representative'));
      });

      test('Entities selectWhereAttribute method', () {
        // Select citizens by verified status
        final verifiedCitizens = citizens.selectWhereAttribute(
          'verified',
          true,
        );

        expect(verifiedCitizens.length, equals(3));

        for (final citizen in verifiedCitizens) {
          expect(citizen.getAttribute('verified'), isTrue);
        }

        // Test with non-existent attribute
        final nonExistentSelection = citizens.selectWhereAttribute(
          'nonExistent',
          'value',
        );
        expect(nonExistentSelection.isEmpty, isTrue);
      });

      test('Entities firstWhereAttribute method', () {
        // Find first citizen by ID number
        final foundCitizen = citizens.firstWhereAttribute('idNumber', 'C10003');

        expect(foundCitizen, isNotNull);
        expect(foundCitizen.getAttribute('name'), equals('Charlie Voter'));

        // Test finding non-existent citizen
        expect(
          () => citizens.firstWhereAttribute('idNumber', 'nonexistent'),
          throwsA(isA<EDNetException>()),
        );
      });

      test('Entities order method for sorting', () {
        // Order citizens by age ascending
        citizens.order(
          (a, b) => (a.getAttribute('age') as int).compareTo(
            b.getAttribute('age') as int,
          ),
        );

        // Verify order
        final ages =
            citizens
                .map((citizen) => citizen.getAttribute('age') as int)
                .toList();

        expect(ages, equals([29, 32, 38, 45, 51]));

        // Order citizens by name descending
        citizens.order(
          (a, b) => (b.getAttribute('name') as String).compareTo(
            a.getAttribute('name') as String,
          ),
        );

        // Verify order
        final names =
            citizens
                .map((citizen) => citizen.getAttribute('name') as String)
                .toList();

        expect(
          names,
          equals([
            'Eve Activist',
            'Dave Representative',
            'Charlie Voter',
            'Bob Citizen',
            'Alice Democracy',
          ]),
        );
      });

      test('Entities order method with default comparator', () {
        // Default order based on entity compareTo method
        // Assuming Entity.compareTo compares OIDs, which are based on creation time
        citizens.order();

        // Verify the order should match insertion order
        final names =
            citizens
                .map((citizen) => citizen.getAttribute('name') as String)
                .toList();

        expect(
          names,
          equals([
            'Alice Democracy',
            'Bob Citizen',
            'Charlie Voter',
            'Dave Representative',
            'Eve Activist',
          ]),
        );
      });

      test('Entities where and map methods', () {
        // Test where method for filtering
        final verifiedCitizens = citizens.where(
          (citizen) => citizen.getAttribute('verified') == true,
        );

        expect(verifiedCitizens.length, equals(3));

        // Test map method to transform
        final citizenNames =
            citizens
                .map((citizen) => citizen.getAttribute('name') as String)
                .toList();

        expect(citizenNames.length, equals(5));
        expect(citizenNames, contains('Alice Democracy'));
        expect(citizenNames, contains('Bob Citizen'));
        expect(citizenNames, contains('Charlie Voter'));
        expect(citizenNames, contains('Dave Representative'));
        expect(citizenNames, contains('Eve Activist'));
      });

      test('Entities chaining filtering and sorting operations', () {
        // Chain multiple operations: filter -> sort -> transform
        final youngVerifiedNames =
            citizens
                .where(
                  (citizen) =>
                      citizen.getAttribute('verified') == true &&
                      (citizen.getAttribute('age') as int) < 40,
                )
                .toList()
              ..sort(
                (a, b) => (a.getAttribute('name') as String).compareTo(
                  b.getAttribute('name') as String,
                ),
              );

        final names =
            youngVerifiedNames
                .map((citizen) => citizen.getAttribute('name') as String)
                .toList();

        expect(names.length, equals(2));
        expect(names, equals(['Alice Democracy', 'Charlie Voter']));
      });
    },
  );
}
