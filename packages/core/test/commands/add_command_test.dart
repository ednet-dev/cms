import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

class Citizen extends Entity<Citizen> {
  Citizen() : super();
}

void main() {
  group('Add Command in Direct Democracy Domain', () {
    late Domain domain;
    late Model model;
    late Concept citizenConcept;
    late Entities<Citizen> citizens;
    late DomainModels domainModels;
    late DomainSession session;
    late Citizen citizen;

    setUp(() {
      // Initialize domain, model, and concepts
      domain = Domain('DirectDemocracy');
      model = Model(domain, 'EDNetModel');

      // Create citizen concept
      citizenConcept = Concept(model, 'Citizen');
      citizenConcept.entry = true;

      // Add attributes to Citizen concept
      final nameAttribute = Attribute(citizenConcept, 'name');
      nameAttribute.type = domain.getType('String');
      citizenConcept.attributes.add(nameAttribute);

      final emailAttribute = Attribute(citizenConcept, 'email');
      emailAttribute.type = domain.getType('Email');
      citizenConcept.attributes.add(emailAttribute);

      // Setup entities collection
      citizens = Entities<Citizen>();
      citizens.concept = citizenConcept;

      // Initialize domain models and session
      domainModels = DomainModels(domain);
      session = DomainSession(domainModels);

      // Create a citizen to add
      citizen = Citizen();
      citizen.concept = citizenConcept;
      citizen.setAttribute('name', 'Jane Citizen');
      citizen.setAttribute('email', 'jane@democracy.org');
    });

    test('Add Command should add citizen to citizens', () {
      // Verify citizens is empty initially
      expect(citizens.isEmpty, isTrue);

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
      // Create a second citizen
      final citizen2 = Citizen();
      citizen2.concept = citizenConcept;
      citizen2.setAttribute('name', 'John Citizen');
      citizen2.setAttribute('email', 'john@democracy.org');

      // Create a transaction with name and session
      final transaction = Transaction('AddCitizensTransaction', session);

      // Add commands to transaction
      final addCommand1 = AddCommand(session, citizens, citizen);
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
      expect(citizens.contains(citizen), isTrue);
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
      // Create an invalid citizen (missing required email)
      final invalidCitizen = Citizen();
      invalidCitizen.concept = citizenConcept;

      // Make email required
      final emailAttr = citizenConcept.attributes.singleWhereCode('email');
      emailAttr?.required = true;

      // Try to add invalid citizen
      citizens.add(invalidCitizen);

      // Should fail validation
      expect(citizens.isEmpty, isTrue);

      // Should have validation exceptions
      expect(citizens.exceptions.length, greaterThan(0));

      // Expected exception message
      expect(citizens.exceptions.toString().contains('required'), isTrue);
    });

    test('Past can be used to execute commands', () {
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
