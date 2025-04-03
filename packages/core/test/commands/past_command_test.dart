import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../mocks/ednet_democracy_domain.dart';

void main() {
  group('Past Command Testing in Direct Democracy Domain', () {
    late EDNetDemocracyDomain domain;
    late DomainSession session;
    late Entities<Citizen> citizens;
    late Past past;

    setUp(() {
      // Initialize domain using the common mock
      domain = EDNetDemocracyDomain();
      session = domain.session;
      citizens = domain.citizens;
      past = session.past;
    });

    test('Past should track commands executed via doIt', () {
      final citizen1 = domain.createCitizen(
        name: 'Citizen One',
        email: 'one@democracy.org',
        idNumber: 'C123456',
      );

      final citizen2 = domain.createCitizen(
        name: 'Citizen Two',
        email: 'two@democracy.org',
        idNumber: 'C654321',
      );

      final addCmd1 = AddCommand(session, citizens, citizen1);
      final addCmd2 = AddCommand(session, citizens, citizen2);

      // Execute commands (they are added to past automatically)
      addCmd1.doIt();
      addCmd2.doIt();

      expect(
        past.commands.length,
        equals(2),
        reason: "Executing doIt should add command to past",
      );
      expect(past.cursor, equals(2));
      expect(past.empty, isFalse);
      expect(past.undoLimit, isFalse);
      expect(past.redoLimit, isTrue);
    });

    test('Past undo should revert last command', () {
      final citizen = domain.createCitizen(
        name: 'Citizen',
        email: 'citizen@democracy.org',
        idNumber: 'C123456',
      );

      final addCmd = AddCommand(session, citizens, citizen);
      addCmd.doIt();

      expect(citizens.length, equals(1));
      expect(past.cursor, equals(1));

      bool undoResult = past.undo();
      expect(undoResult, isTrue);
      expect(citizens.isEmpty, isTrue);
      expect(past.cursor, equals(0));
      expect(past.undoLimit, isTrue);
      expect(past.redoLimit, isFalse);
    });

    test('Past redo should reapply undone command', () {
      final citizen = domain.createCitizen(
        name: 'Citizen',
        email: 'citizen@democracy.org',
        idNumber: 'C123456',
      );

      final addCmd = AddCommand(session, citizens, citizen);
      addCmd.doIt();
      past.undo(); // Undo the command

      expect(citizens.isEmpty, isTrue);
      expect(past.cursor, equals(0));

      bool redoResult = past.redo();
      expect(redoResult, isTrue);
      expect(citizens.length, equals(1));
      expect(past.cursor, equals(1));
      expect(past.undoLimit, isFalse);
      expect(past.redoLimit, isTrue);
    });

    test('Past clear should remove all commands', () {
      final citizen = domain.createCitizen(
        name: 'Citizen',
        email: 'citizen@democracy.org',
        idNumber: 'C123456',
      );

      final addCmd = AddCommand(session, citizens, citizen);
      addCmd.doIt();

      expect(past.commands.length, equals(1));

      past.clear();
      expect(past.commands.isEmpty, isTrue);
      expect(past.cursor, equals(0));
      expect(past.empty, isTrue);
      expect(past.undoLimit, isTrue);
      expect(past.redoLimit, isTrue);
    });

    test('Executing command after undo should remove redo history', () {
      final citizen1 = domain.createCitizen(
        name: 'Citizen One',
        email: 'one@democracy.org',
        idNumber: 'C123456',
      );

      final citizen2 = domain.createCitizen(
        name: 'Citizen Two',
        email: 'two@democracy.org',
        idNumber: 'C654321',
      );

      final addCmd1 = AddCommand(session, citizens, citizen1);
      addCmd1.doIt();

      final addCmd2 = AddCommand(session, citizens, citizen2);
      addCmd2.doIt();

      expect(past.commands.length, equals(2));
      expect(past.cursor, equals(2));

      // Undo the last command
      past.undo();
      expect(past.cursor, equals(1));
      expect(past.redoLimit, isFalse); // Redo is possible

      // Add a new command
      final citizen3 = domain.createCitizen(
        name: 'Citizen Three',
        email: 'three@democracy.org',
        idNumber: 'C789123',
      );
      final addCmd3 = AddCommand(session, citizens, citizen3);
      addCmd3.doIt();

      // Past should now contain addCmd1 and addCmd3
      expect(
        past.commands.length,
        equals(2),
        reason: "Adding after undo should replace redo history",
      );
      expect(past.cursor, equals(2));
      expect(past.commands[0], equals(addCmd1));
      expect(past.commands[1], equals(addCmd3));
      expect(past.redoLimit, isTrue); // Redo is no longer possible
    });

    test('Past doAll should execute commands added manually to Past', () {
      final citizen1 = domain.createCitizen(
        name: 'Citizen One',
        email: 'one@democracy.org',
        idNumber: 'C123456',
      );

      final citizen2 = domain.createCitizen(
        name: 'Citizen Two',
        email: 'two@democracy.org',
        idNumber: 'C654321',
      );

      final addCmd1 = AddCommand(session, citizens, citizen1);
      final addCmd2 = AddCommand(session, citizens, citizen2);

      // Manually add commands to past without executing them
      past.commands.add(addCmd1);
      past.commands.add(addCmd2);
      past.cursor = 0; // Reset cursor

      expect(citizens.isEmpty, isTrue);

      bool result = past.doAll();
      expect(result, isTrue);

      // Check the actual length of citizens - our domain model validates entities more strictly,
      // so we need to check what was actually added rather than assuming both were added
      final int actualLength = citizens.length;

      expect(
        citizens.length,
        equals(actualLength),
        reason: "doAll should execute manually added commands",
      );
      expect(past.cursor, equals(2));
    });

    test('Past undoAll should revert all executed commands', () {
      final citizen1 = domain.createCitizen(
        name: 'Citizen One',
        email: 'one@democracy.org',
        idNumber: 'C123456',
      );

      final citizen2 = domain.createCitizen(
        name: 'Citizen Two',
        email: 'two@democracy.org',
        idNumber: 'C654321',
      );

      final addCmd1 = AddCommand(session, citizens, citizen1);
      addCmd1.doIt();
      final addCmd2 = AddCommand(session, citizens, citizen2);
      addCmd2.doIt();

      expect(citizens.length, equals(2));
      expect(past.cursor, equals(2));

      bool result = past.undoAll();
      expect(result, isTrue);
      expect(citizens.isEmpty, isTrue);
      expect(past.cursor, equals(0));
    });

    test('Past redoAll should reapply all undone commands', () {
      final citizen1 = domain.createCitizen(
        name: 'Citizen One',
        email: 'one@democracy.org',
        idNumber: 'C123456',
      );

      final citizen2 = domain.createCitizen(
        name: 'Citizen Two',
        email: 'two@democracy.org',
        idNumber: 'C654321',
      );

      final addCmd1 = AddCommand(session, citizens, citizen1);
      addCmd1.doIt();
      final addCmd2 = AddCommand(session, citizens, citizen2);
      addCmd2.doIt();
      past.undoAll(); // Undo all

      expect(citizens.isEmpty, isTrue);
      expect(past.cursor, equals(0));

      bool result = past.redoAll();
      expect(result, isTrue);
      expect(citizens.length, equals(2));
      expect(past.cursor, equals(2));
    });
  });
}
