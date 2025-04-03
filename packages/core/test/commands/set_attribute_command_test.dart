import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

class Citizen extends Entity<Citizen> {
  Citizen() : super();
}

void main() {
  group('Set Attribute Command in Direct Democracy Domain', () {
    late Domain domain;
    late Model model;
    late Concept citizenConcept;
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

      final statusAttribute = Attribute(citizenConcept, 'status');
      statusAttribute.type = domain.getType('String');
      citizenConcept.attributes.add(statusAttribute);

      final votingRightsAttribute = Attribute(citizenConcept, 'votingRights');
      votingRightsAttribute.type = domain.getType('bool');
      citizenConcept.attributes.add(votingRightsAttribute);

      // Initialize domain models and session
      domainModels = DomainModels(domain);
      session = DomainSession(domainModels);

      // Create a citizen to modify
      citizen = Citizen();
      citizen.concept = citizenConcept;
      citizen.setAttribute('name', 'Jane Citizen');
      citizen.setAttribute('email', 'jane@democracy.org');
      citizen.setAttribute('status', 'Active');
      citizen.setAttribute('votingRights', true);
    });

    test('Set Attribute Command should update citizen attribute', () {
      // Verify initial attribute value
      expect(citizen.getAttribute('name'), equals('Jane Citizen'));

      // Create Set Attribute command
      final setAttributeCommand = SetAttributeCommand(
        session,
        citizen,
        'name',
        'Jane Democracy',
      );

      // Command state should be 'started'
      expect(setAttributeCommand.state, equals('started'));

      // Execute the command
      bool result = setAttributeCommand.doIt();

      // Command should succeed
      expect(result, isTrue);

      // Command state should be 'done'
      expect(setAttributeCommand.state, equals('done'));

      // Attribute should be updated
      expect(citizen.getAttribute('name'), equals('Jane Democracy'));

      // Command should be added to session past
      expect(session.past.commands.length, equals(1));
      expect(session.past.commands.first, equals(setAttributeCommand));
    });

    test('Set Attribute Command should preserve before value', () {
      // Verify initial attribute value
      expect(citizen.getAttribute('status'), equals('Active'));

      // Create and execute set attribute command
      final setAttributeCommand = SetAttributeCommand(
        session,
        citizen,
        'status',
        'Verified',
      );

      // Check the before value before executing
      expect(setAttributeCommand.before, equals('Active'));

      // Execute the command
      setAttributeCommand.doIt();

      // Attribute should be updated
      expect(citizen.getAttribute('status'), equals('Verified'));

      // Before value should still be preserved
      expect(setAttributeCommand.before, equals('Active'));
    });

    test('Set Attribute Command should be undoable', () {
      // Create and execute set attribute command
      final setAttributeCommand = SetAttributeCommand(
        session,
        citizen,
        'email',
        'jane.citizen@democracy.org',
      );
      setAttributeCommand.doIt();

      // Verify attribute was updated
      expect(
        citizen.getAttribute('email'),
        equals('jane.citizen@democracy.org'),
      );

      // Undo the command
      bool undoResult = setAttributeCommand.undo();

      // Undo should succeed
      expect(undoResult, isTrue);

      // Command state should be 'undone'
      expect(setAttributeCommand.state, equals('undone'));

      // Attribute should be reverted to original value
      expect(citizen.getAttribute('email'), equals('jane@democracy.org'));
    });

    test('Set Attribute Command should be redoable after undo', () {
      // Create and execute set attribute command
      final setAttributeCommand = SetAttributeCommand(
        session,
        citizen,
        'votingRights',
        false,
      );
      setAttributeCommand.doIt();

      // Undo the command
      setAttributeCommand.undo();

      // Redo the command
      bool redoResult = setAttributeCommand.redo();

      // Redo should succeed
      expect(redoResult, isTrue);

      // Command state should be 'redone'
      expect(setAttributeCommand.state, equals('redone'));

      // Attribute should be set to new value again
      expect(citizen.getAttribute('votingRights'), equals(false));
    });

    test('Transaction can group multiple attribute changes', () {
      // Create a transaction
      final transaction = Transaction('UpdateCitizenTransaction', session);

      // Add commands to transaction
      final nameCommand = SetAttributeCommand(
        session,
        citizen,
        'name',
        'Jane Updated',
      );
      nameCommand.partOfTransaction = true;
      transaction.add(nameCommand);

      final emailCommand = SetAttributeCommand(
        session,
        citizen,
        'email',
        'updated@democracy.org',
      );
      emailCommand.partOfTransaction = true;
      transaction.add(emailCommand);

      final statusCommand = SetAttributeCommand(
        session,
        citizen,
        'status',
        'Verified',
      );
      statusCommand.partOfTransaction = true;
      transaction.add(statusCommand);

      // Execute the transaction
      bool result = transaction.doIt();

      // Transaction should succeed
      expect(result, isTrue);

      // All attributes should be updated
      expect(citizen.getAttribute('name'), equals('Jane Updated'));
      expect(citizen.getAttribute('email'), equals('updated@democracy.org'));
      expect(citizen.getAttribute('status'), equals('Verified'));

      // Only the transaction should be in the past (not individual commands)
      expect(session.past.commands.length, equals(1));
      expect(session.past.commands.first, equals(transaction));

      // Undo the transaction should revert all attribute changes
      transaction.undo();
      expect(citizen.getAttribute('name'), equals('Jane Citizen'));
      expect(citizen.getAttribute('email'), equals('jane@democracy.org'));
      expect(citizen.getAttribute('status'), equals('Active'));

      // Redo the transaction should apply all attribute changes again
      transaction.redo();
      expect(citizen.getAttribute('name'), equals('Jane Updated'));
      expect(citizen.getAttribute('email'), equals('updated@democracy.org'));
      expect(citizen.getAttribute('status'), equals('Verified'));
    });

    test('Setting attribute to same value should still succeed', () {
      // Create and execute set attribute command with same value
      final setAttributeCommand = SetAttributeCommand(
        session,
        citizen,
        'name',
        'Jane Citizen', // Same value as current
      );

      // Execute the command
      bool result = setAttributeCommand.doIt();

      // Command should succeed even with same value
      expect(result, isTrue);

      // Value remains unchanged
      expect(citizen.getAttribute('name'), equals('Jane Citizen'));
    });

    test('Setting attribute to empty value should clear it', () {
      // Create and execute set attribute command with empty string
      final setAttributeCommand = SetAttributeCommand(
        session,
        citizen,
        'status',
        '', // Empty string instead of null
      );

      // Execute the command
      bool result = setAttributeCommand.doIt();

      // Command should succeed
      expect(result, isTrue);

      // Value should be set to empty string
      expect(citizen.getAttribute('status'), equals(''));

      // Undo should restore original value
      setAttributeCommand.undo();
      expect(citizen.getAttribute('status'), equals('Active'));
    });

    test('Multiple SetAttribute operations should show sequential changes', () {
      // Initial value
      expect(citizen.getAttribute('name'), equals('Jane Citizen'));

      // First change
      final setCommand1 = SetAttributeCommand(
        session,
        citizen,
        'name',
        'Jane Democracy',
      );
      setCommand1.doIt();
      expect(citizen.getAttribute('name'), equals('Jane Democracy'));

      // Second change
      final setCommand2 = SetAttributeCommand(
        session,
        citizen,
        'name',
        'Jane Republic',
      );
      setCommand2.doIt();
      expect(citizen.getAttribute('name'), equals('Jane Republic'));

      // Third change
      final setCommand3 = SetAttributeCommand(
        session,
        citizen,
        'name',
        'Jane Nation',
      );
      setCommand3.doIt();
      expect(citizen.getAttribute('name'), equals('Jane Nation'));

      // Commands should all be in session past
      expect(session.past.commands.length, equals(3));

      // Undo them in reverse order
      setCommand3.undo();
      expect(citizen.getAttribute('name'), equals('Jane Republic'));

      setCommand2.undo();
      expect(citizen.getAttribute('name'), equals('Jane Democracy'));

      setCommand1.undo();
      expect(citizen.getAttribute('name'), equals('Jane Citizen'));
    });
  });
}
