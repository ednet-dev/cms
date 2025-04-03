import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../mocks/ednet_democracy_domain.dart';

void main() {
  group('OID (Object ID) Tests using EDNetOne Democracy Domain', () {
    late EDNetDemocracyDomain domain;

    setUp(() {
      domain = EDNetDemocracyDomain();
    });

    test('OID generation', () {
      // Generate OID for a new entity
      final citizen1 = domain.createCitizen(
        name: 'Alice Citizen',
        email: 'alice@democracy.org',
        idNumber: 'C123456',
      );

      // Verify OID is generated and not null
      expect(citizen1.oid, isNotNull);
      expect(citizen1.oid.timeStamp, isNotNull);
      expect(citizen1.oid.toString(), isNotEmpty);

      // Generate another OID for comparison
      final citizen2 = domain.createCitizen(
        name: 'Bob Citizen',
        email: 'bob@democracy.org',
        idNumber: 'C654321',
      );

      // Verify OIDs are unique
      expect(citizen1.oid, isNot(equals(citizen2.oid)));
      expect(citizen1.oid.toString(), isNot(equals(citizen2.oid.toString())));
    });

    test('OID comparison', () {
      // Create entities with OIDs
      final citizen1 = domain.createCitizen(
        name: 'Alice Citizen',
        email: 'alice@democracy.org',
        idNumber: 'C123456',
      );

      final citizen2 = domain.createCitizen(
        name: 'Bob Citizen',
        email: 'bob@democracy.org',
        idNumber: 'C654321',
      );

      // Direct OID comparison
      expect(citizen1.oid == citizen2.oid, isFalse);

      // OID equality
      expect(citizen1.oid.equals(citizen1.oid), isTrue);
      expect(citizen1.oid.equals(citizen2.oid), isFalse);

      // Create a copy of an OID using timestamp
      final copyOid = Oid.ts(citizen1.oid.timeStamp);
      expect(copyOid.equals(citizen1.oid), isTrue);
    });

    test('OID string representation', () {
      final citizen = domain.createCitizen(
        name: 'Charlie Citizen',
        email: 'charlie@democracy.org',
        idNumber: 'C987654',
      );

      // Verify OID string is a numeric timestamp
      final oidString = citizen.oid.toString();
      expect(oidString, isNotEmpty);

      // String should be parsable as an integer
      expect(int.tryParse(oidString), isNotNull);
    });

    test('OID compareTo implementation', () {
      // Create OIDs with specific timestamps
      final olderOid = Oid.ts(1000);
      final newerOid = Oid.ts(2000);

      // Test compareTo behavior
      expect(olderOid.compareTo(newerOid), lessThan(0));
      expect(newerOid.compareTo(olderOid), greaterThan(0));
      expect(olderOid.compareTo(olderOid), equals(0));
    });

    test('OID in entity lookup operations', () {
      // Create entities and add to collection
      final citizens = domain.citizens;
      citizens.clear();

      final citizen = domain.createCitizen(
        name: 'Alice Citizen',
        email: 'alice@democracy.org',
        idNumber: 'C123456',
      );

      citizens.add(citizen);

      // Lookup by OID
      final foundEntity = citizens.singleWhereOid(citizen.oid);
      expect(foundEntity, isNotNull);
      expect(foundEntity, equals(citizen));

      // Lookup by non-existent OID
      final nonExistentOid = Oid.ts(999999);
      final notFound = citizens.singleWhereOid(nonExistentOid);
      expect(notFound, isNull);
    });
  });
}
