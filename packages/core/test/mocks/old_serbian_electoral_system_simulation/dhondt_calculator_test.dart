import 'package:test/test.dart';
import 'serbian_election_domain.dart';

/// Represents a party's vote count and seat allocation
class PartyResult {
  final String name;
  final int votes;
  bool isMinorityParty;
  int seatsWon = 0;

  PartyResult(this.name, this.votes, {this.isMinorityParty = false});
}

/// Implements the D'Hondt method for seat allocation in Serbian elections
class DhondtCalculator {
  /// Calculates seat allocation using the D'Hondt method
  /// [parties] - List of party results with votes
  /// [totalSeats] - Total number of seats to allocate
  /// [threshold] - Minimum percentage of votes required (0.03 for 3%)
  /// Returns the updated list of party results with allocated seats
  List<PartyResult> calculateSeats(
    List<PartyResult> parties,
    int totalSeats, {
    double threshold = 0.03,
  }) {
    // Calculate total valid votes
    final totalVotes = parties.fold(0, (sum, party) => sum + party.votes);

    // Filter parties that pass the threshold (except minority parties)
    final qualifiedParties =
        parties.where((party) {
          if (party.isMinorityParty) return true;
          return party.votes / totalVotes >= threshold;
        }).toList();

    // Reset seat counts
    for (var party in qualifiedParties) {
      party.seatsWon = 0;
    }

    // Implement D'Hondt method
    for (var seat = 0; seat < totalSeats; seat++) {
      var maxQuotient = 0.0;
      PartyResult? partyToReceiveSeat;

      for (var party in qualifiedParties) {
        // Calculate quotient: votes / (seats_won + 1)
        final quotient = party.votes / (party.seatsWon + 1);
        if (quotient > maxQuotient) {
          maxQuotient = quotient;
          partyToReceiveSeat = party;
        }
      }

      if (partyToReceiveSeat != null) {
        partyToReceiveSeat.seatsWon++;
      }
    }

    return qualifiedParties;
  }
}

void main() {
  group('D\'Hondt Calculator Tests', () {
    late DhondtCalculator calculator;

    setUp(() {
      calculator = DhondtCalculator();
    });

    test('Basic seat allocation with two parties', () {
      final parties = [
        PartyResult('Party A', 60000),
        PartyResult('Party B', 40000),
      ];

      final results = calculator.calculateSeats(parties, 10);

      expect(results.length, equals(2));
      expect(
        results.firstWhere((p) => p.name == 'Party A').seatsWon,
        equals(6),
      );
      expect(
        results.firstWhere((p) => p.name == 'Party B').seatsWon,
        equals(4),
      );
    });

    test('Seat allocation with parties below threshold', () {
      final parties = [
        PartyResult('Major Party', 80000),
        PartyResult('Medium Party', 15000), // Below 3% threshold
        PartyResult('Small Party', 5000), // Below 3% threshold
      ];

      final results = calculator.calculateSeats(parties, 10, threshold: 0.03);

      expect(results.length, equals(1));
      expect(
        results.firstWhere((p) => p.name == 'Major Party').seatsWon,
        equals(10),
      );
    });

    test('Minority party exemption from threshold', () {
      final parties = [
        PartyResult('Major Party', 80000),
        PartyResult('Minority Party', 5000, isMinorityParty: true),
      ];

      final results = calculator.calculateSeats(parties, 10, threshold: 0.03);

      expect(results.length, equals(2));
      expect(results.any((p) => p.name == 'Minority Party'), isTrue);
    });

    test('Real Serbian election scenario 2022', () {
      // Based on 2022 Serbian parliamentary election results
      final parties = [
        PartyResult('SNS-SPS Coalition', 1637003),
        PartyResult('United Opposition', 581385),
        PartyResult('NADA Coalition', 176690),
        PartyResult('SVM', 60000, isMinorityParty: true),
        PartyResult('Small Party', 15000),
      ];

      final results = calculator.calculateSeats(parties, 250, threshold: 0.03);

      // Verify major coalitions got seats
      expect(
        results.firstWhere((p) => p.name == 'SNS-SPS Coalition').seatsWon,
        greaterThan(100),
      );
      expect(
        results.firstWhere((p) => p.name == 'United Opposition').seatsWon,
        greaterThan(50),
      );

      // Verify minority party got seats despite being below threshold
      expect(
        results.firstWhere((p) => p.name == 'SVM').seatsWon,
        greaterThan(0),
      );

      // Verify small party below threshold got no seats
      expect(results.any((p) => p.name == 'Small Party'), isFalse);
    });

    test('Edge case: Single party gets all seats', () {
      final parties = [PartyResult('Single Party', 100000)];

      final results = calculator.calculateSeats(parties, 10);

      expect(results.length, equals(1));
      expect(
        results.firstWhere((p) => p.name == 'Single Party').seatsWon,
        equals(10),
      );
    });

    test('Edge case: Equal votes between parties', () {
      final parties = [
        PartyResult('Party A', 50000),
        PartyResult('Party B', 50000),
      ];

      final results = calculator.calculateSeats(parties, 10);

      expect(results.length, equals(2));
      // Should split seats evenly
      expect(
        results.firstWhere((p) => p.name == 'Party A').seatsWon,
        equals(5),
      );
      expect(
        results.firstWhere((p) => p.name == 'Party B').seatsWon,
        equals(5),
      );
    });

    test('Complex scenario with multiple minority parties', () {
      final parties = [
        PartyResult('Major Party A', 450000),
        PartyResult('Major Party B', 350000),
        PartyResult('Major Party C', 200000),
        PartyResult('Minority Party 1', 25000, isMinorityParty: true),
        PartyResult('Minority Party 2', 15000, isMinorityParty: true),
        PartyResult('Small Party', 20000), // Below threshold
      ];

      final results = calculator.calculateSeats(parties, 250, threshold: 0.03);

      expect(results.length, equals(5)); // All except Small Party
      expect(results.where((p) => p.isMinorityParty).length, equals(2));

      // Verify total seats add up to 250
      final totalSeatsAllocated = results.fold(
        0,
        (sum, party) => sum + party.seatsWon,
      );
      expect(totalSeatsAllocated, equals(250));
    });
  });
}
