import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../mocks/ednet_democracy_domain.dart';

void main() {
  group('Add Command in Direct Democracy Domain', () {
    late EDNetDemocracyDomain domain;
    late DomainSession session;
    late Entities<Citizen> citizens;

    setUp(() {
      // Initialize domain using the common mock
      domain = EDNetDemocracyDomain();
      session = domain.session;
      citizens = domain.citizens;
    });

    test('Add Command should add citizen to citizens', () {
      // Verify citizens is empty initially
      expect(citizens.isEmpty, isTrue);

      // Create citizen to add
      final citizen = domain.createCitizen(
        name: 'Jane Citizen',
        email: 'jane@democracy.org',
        idNumber: 'C123456',
      );

      // Create and execute add command
      final addCommand = AddCommand(session, citizens, citizen);

      // Command state should be 'started'
      expect(addCommand.state, equals('started'));

      // Execute the command
      bool result = addCommand.doIt();

      // Command should succeed
      expect(result, isTrue);

      // Command state should be 'done'
      expect(addCommand.state, equals('done'));

      // Citizen should be added to citizens
      expect(citizens.length, equals(1));
      expect(citizens.first, equals(citizen));

      // Command should be added to session past
      expect(session.past.commands.length, equals(1));
      expect(session.past.commands.first, equals(addCommand));
    });

    test('Add Command should be undoable', () {
      // Create citizen to add
      final citizen = domain.createCitizen(
        name: 'Jane Citizen',
        email: 'jane@democracy.org',
        idNumber: 'C123456',
      );

      // Create and execute add command
      final addCommand = AddCommand(session, citizens, citizen);
      addCommand.doIt();

      // Verify citizen was added
      expect(citizens.length, equals(1));

      // Undo the command
      bool undoResult = addCommand.undo();

      // Undo should succeed
      expect(undoResult, isTrue);

      // Command state should be 'undone'
      expect(addCommand.state, equals('undone'));

      // Citizen should be removed from citizens
      expect(citizens.isEmpty, isTrue);
    });

    test('Add Command should be redoable after undo', () {
      // Create citizen to add
      final citizen = domain.createCitizen(
        name: 'Jane Citizen',
        email: 'jane@democracy.org',
        idNumber: 'C123456',
      );

      // Create and execute add command
      final addCommand = AddCommand(session, citizens, citizen);
      addCommand.doIt();

      // Undo the command
      addCommand.undo();

      // Redo the command
      bool redoResult = addCommand.redo();

      // Redo should succeed
      expect(redoResult, isTrue);

      // Command state should be 'redone'
      expect(addCommand.state, equals('redone'));

      // Citizen should be added back to citizens
      expect(citizens.length, equals(1));
      expect(citizens.first, equals(citizen));
    });

    test('Transaction can group multiple add commands', () {
      // Create citizens to add
      final citizen1 = domain.createCitizen(
        name: 'Jane Citizen',
        email: 'jane@democracy.org',
        idNumber: 'C123456',
      );

      final citizen2 = domain.createCitizen(
        name: 'John Citizen',
        email: 'john@democracy.org',
        idNumber: 'C654321',
      );

      // Create a transaction with name and session
      final transaction = Transaction('AddCitizensTransaction', session);

      // Add commands to transaction
      final addCommand1 = AddCommand(session, citizens, citizen1);
      addCommand1.partOfTransaction = true;
      transaction.add(addCommand1);

      final addCommand2 = AddCommand(session, citizens, citizen2);
      addCommand2.partOfTransaction = true;
      transaction.add(addCommand2);

      // Execute the transaction
      bool result = transaction.doIt();

      // Transaction should succeed
      expect(result, isTrue);

      // Both citizens should be added
      expect(citizens.length, equals(2));
      expect(citizens.contains(citizen1), isTrue);
      expect(citizens.contains(citizen2), isTrue);

      // Only the transaction should be in the past (not individual commands)
      expect(session.past.commands.length, equals(1));
      expect(session.past.commands.first, equals(transaction));

      // Undo the transaction should remove both citizens
      transaction.undo();
      expect(citizens.isEmpty, isTrue);

      // Redo the transaction should add both citizens back
      transaction.redo();
      expect(citizens.length, equals(2));
    });

    test('Adding invalid entity should fail validation', () {
      // Create an invalid citizen (missing required idNumber)
      final invalidCitizen = Citizen();
      invalidCitizen.concept = domain.citizenConcept;
      invalidCitizen.setAttribute('name', 'Invalid Citizen');
      invalidCitizen.setAttribute('email', 'invalid@democracy.org');
      // Intentionally not setting the required idNumber attribute

      // Try to add invalid citizen
      final addCommand = AddCommand(session, citizens, invalidCitizen);
      bool result = addCommand.doIt();

      // Should fail validation
      expect(result, isFalse);
      expect(citizens.isEmpty, isTrue);

      // Should have validation exceptions
      expect(citizens.exceptions.length, greaterThan(0));

      // Command should not be added to past when failing
      expect(session.past.commands.isEmpty, isTrue);
    });

    test('Past can be used to execute commands', () {
      // Create citizen to add
      final citizen = domain.createCitizen(
        name: 'Jane Citizen',
        email: 'jane@democracy.org',
        idNumber: 'C123456',
      );

      // Create add command
      final addCommand = AddCommand(session, citizens, citizen);

      // Add command to past
      session.past.add(addCommand);

      // Check the past state
      expect(session.past.commands.length, equals(1));

      // Execute the command directly
      bool result = addCommand.doIt();

      // Command should succeed
      expect(result, isTrue);

      // Citizen should be added
      expect(citizens.length, equals(1));

      // Undo the command directly
      bool undoResult = addCommand.undo();
      expect(undoResult, isTrue);
      expect(citizens.isEmpty, isTrue);

      // Redo the command directly
      bool redoResult = addCommand.redo();
      expect(redoResult, isTrue);
      expect(citizens.length, equals(1));
    });
  });
}
