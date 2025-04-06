import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../mocks/ednet_democracy_domain.dart';

void main() {
  group('Remove Command in Direct Democracy Domain', () {
    late EDNetDemocracyDomain domain;
    late DomainSession session;
    late Entities<Citizen> citizens;
    late Citizen citizen;
    late Citizen citizen2;

    setUp(() {
      // Initialize domain using the common mock
      domain = EDNetDemocracyDomain();
      session = domain.session;
      citizens = domain.citizens;

      // Create citizens
      citizen = domain.createCitizen(
        name: 'Jane Citizen',
        email: 'jane@democracy.org',
        idNumber: 'C123456',
      );

      citizen2 = domain.createCitizen(
        name: 'John Citizen',
        email: 'john@democracy.org',
        idNumber: 'C654321',
      );

      // Add citizens to collection for testing removal
      citizens.add(citizen);
      citizens.add(citizen2);
    });

    test('Remove Command should remove citizen from citizens', () {
      // Verify citizens has 2 entities initially
      expect(citizens.length, equals(2));

      // Create and execute remove command
      final removeCommand = RemoveCommand(session, citizens, citizen);

      // Command state should be 'started'
      expect(removeCommand.state, equals('started'));

      // Execute the command
      bool result = removeCommand.doIt();

      // Command should succeed
      expect(result, isTrue);

      // Command state should be 'done'
      expect(removeCommand.state, equals('done'));

      // Citizen should be removed from citizens
      expect(citizens.length, equals(1));

      // Check that the remaining citizen is citizen2
      final remainingCitizen = citizens.first;
      expect(remainingCitizen.getAttribute('name'), equals('John Citizen'));
      expect(
        remainingCitizen.getAttribute('email'),
        equals('john@democracy.org'),
      );

      // Command should be added to session past
      expect(session.past.commands.length, equals(1));
      expect(session.past.commands.first, equals(removeCommand));
    });

    test('Remove Command should be undoable', () {
      // Create and execute remove command
      final removeCommand = RemoveCommand(session, citizens, citizen);
      removeCommand.doIt();

      // Verify citizen was removed
      expect(citizens.length, equals(1));

      // Undo the command
      bool undoResult = removeCommand.undo();

      // Undo should succeed
      expect(undoResult, isTrue);

      // Command state should be 'undone'
      expect(removeCommand.state, equals('undone'));

      // Citizen should be added back to citizens
      expect(citizens.length, equals(2));

      // Check that both citizens are present by checking their names
      final citizenNames = citizens.map((c) => c.getAttribute('name')).toList();
      expect(citizenNames.contains('Jane Citizen'), isTrue);
      expect(citizenNames.contains('John Citizen'), isTrue);
    });

    test('Remove Command should be redoable after undo', () {
      // Create and execute remove command
      final removeCommand = RemoveCommand(session, citizens, citizen);
      removeCommand.doIt();

      // Undo the command
      removeCommand.undo();

      // Redo the command
      bool redoResult = removeCommand.redo();

      // Redo should succeed
      expect(redoResult, isTrue);

      // Command state should be 'redone'
      expect(removeCommand.state, equals('redone'));

      // Citizen should be removed again from citizens
      expect(citizens.length, equals(1));

      // Check that the remaining citizen is citizen2
      final remainingCitizen = citizens.first;
      expect(remainingCitizen.getAttribute('name'), equals('John Citizen'));
    });

    test('Transaction can group multiple remove commands', () {
      // Create a transaction with name and session
      final transaction = Transaction('RemoveCitizensTransaction', session);

      // Add commands to transaction
      final removeCommand1 = RemoveCommand(session, citizens, citizen);
      removeCommand1.partOfTransaction = true;
      transaction.add(removeCommand1);

      final removeCommand2 = RemoveCommand(session, citizens, citizen2);
      removeCommand2.partOfTransaction = true;
      transaction.add(removeCommand2);

      // Execute the transaction
      bool result = transaction.doIt();

      // Transaction should succeed
      expect(result, isTrue);

      // Both citizens should be removed
      expect(citizens.isEmpty, isTrue);

      // Only the transaction should be in the past (not individual commands)
      expect(session.past.commands.length, equals(1));
      expect(session.past.commands.first, equals(transaction));

      // Undo the transaction should add both citizens back
      transaction.undo();
      expect(citizens.length, equals(2));

      // Redo the transaction should remove both citizens again
      transaction.redo();
      expect(citizens.isEmpty, isTrue);
    });

    test('Removing nonexistent entity should fail', () {
      // First, clear the existing citizens
      citizens.clear();

      // Create a new citizen that is not in the collection
      final nonexistentCitizen = domain.createCitizen(
        name: 'Unknown Citizen',
        email: 'unknown@democracy.org',
        idNumber: 'C999999',
      );

      // Create and execute remove command
      final removeCommand = RemoveCommand(
        session,
        citizens,
        nonexistentCitizen,
      );

      // Execute the command
      bool result = removeCommand.doIt();

      // Command should fail (trying to remove a non-existent entity)
      expect(result, isFalse);

      // Command state should remain 'started' (not done)
      expect(removeCommand.state, equals('started'));
    });

    test('Remove-Add-Remove sequence should work correctly', () {
      // Remove citizen
      final removeCommand1 = RemoveCommand(session, citizens, citizen);
      bool removed = removeCommand1.doIt();
      expect(removed, isTrue);
      expect(citizens.length, equals(1));

      // Add citizen back
      final addCommand = AddCommand(session, citizens, citizen);
      bool added = addCommand.doIt();
      expect(added, isTrue);
      expect(citizens.length, equals(2));

      // Remove again
      final removeCommand2 = RemoveCommand(session, citizens, citizen);
      bool removedAgain = removeCommand2.doIt();
      expect(removedAgain, isTrue);
      expect(citizens.length, equals(1));

      // Undo the second removal
      bool undoRemoval = removeCommand2.undo();
      expect(undoRemoval, isTrue);
      expect(citizens.length, equals(2));
    });
  });
}
