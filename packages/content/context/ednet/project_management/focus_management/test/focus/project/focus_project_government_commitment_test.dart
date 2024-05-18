// test/focus/project/focus_project_government_commitment_test.dart

import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:focus_project/focus_project.dart';

void testFocusProjectGovernmentCommitments(FocusDomain focusDomain,
    ProjectModel projectModel, GovernmentCommitments governmentCommitments) {
  DomainSession session;
  group('Testing Focus.Project.GovernmentCommitment', () {
    session = focusDomain.newSession();
    setUp(() {
      projectModel.init();
    });
    tearDown(() {
      projectModel.clear();
    });

    test('Not empty model', () {
      expect(projectModel.isEmpty, isFalse);
      expect(governmentCommitments.isEmpty, isFalse);
    });

    test('Empty model', () {
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      expect(governmentCommitments.isEmpty, isTrue);
      expect(governmentCommitments.exceptions.isEmpty, isTrue);
    });

    test('From model to JSON', () {
      final json = projectModel.toJson();
      expect(json, isNotNull);

      print(json);
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model', () {
      final json = projectModel.toJson();
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      projectModel.fromJson(json);
      expect(projectModel.isEmpty, isFalse);

      projectModel.display();
    });

    test('From model entry to JSON', () {
      final json = projectModel.fromEntryToJson('GovernmentCommitment');
      expect(json, isNotNull);

      print(json);
      //projectModel.displayEntryJson("GovernmentCommitment");
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model entry', () {
      final json = projectModel.fromEntryToJson('GovernmentCommitment');
      governmentCommitments.clear();
      expect(governmentCommitments.isEmpty, isTrue);
      projectModel.fromJsonToEntry(json);
      expect(governmentCommitments.isEmpty, isFalse);

      governmentCommitments.display(title: 'From JSON to model entry');
    });

    test('Add governmentCommitment required error', () {
      // no required attribute that is not id
    });

    test('Add governmentCommitment unique error', () {
      // no id attribute
    });

    test('Not found governmentCommitment by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final governmentCommitment = governmentCommitments.singleWhereOid(ednetOid);
      expect(governmentCommitment, isNull);
    });

    test('Find governmentCommitment by oid', () {
      final randomGovernmentCommitment =
          projectModel.governmentCommitments.random();
      final governmentCommitment =
          governmentCommitments.singleWhereOid(randomGovernmentCommitment.oid);
      expect(governmentCommitment, isNotNull);
      expect(governmentCommitment, equals(randomGovernmentCommitment));
    });

    test('Find governmentCommitment by attribute id', () {
      // no id attribute
    });

    test('Find governmentCommitment by required attribute', () {
      // no required attribute that is not id
    });

    test('Find governmentCommitment by attribute', () {
      // no attribute that is not required
    });

    test('Select governmentCommitments by attribute', () {
      // no attribute that is not required
    });

    test('Select governmentCommitments by required attribute', () {
      // no required attribute that is not id
    });

    test('Select governmentCommitments by attribute, then add', () {
      // no attribute that is not id
    });

    test('Select governmentCommitments by attribute, then remove', () {
      // no attribute that is not id
    });

    test('Sort governmentCommitments', () {
      // no id attribute
      // add compareTo method in the specific GovernmentCommitment class
      /* 
      governmentCommitments.sort(); 
 
      //governmentCommitments.display(title: "Sort governmentCommitments"); 
      */
    });

    test('Order governmentCommitments', () {
      // no id attribute
      // add compareTo method in the specific GovernmentCommitment class
      /* 
      var orderedGovernmentCommitments = governmentCommitments.order(); 
      expect(orderedGovernmentCommitments.isEmpty, isFalse); 
      expect(orderedGovernmentCommitments.length, equals(governmentCommitments.length)); 
      expect(orderedGovernmentCommitments.source?.isEmpty, isFalse); 
      expect(orderedGovernmentCommitments.source?.length, equals(governmentCommitments.length)); 
      expect(orderedGovernmentCommitments, isNot(same(governmentCommitments))); 
 
      //orderedGovernmentCommitments.display(title: "Order governmentCommitments"); 
      */
    });

    test('Copy governmentCommitments', () {
      final copiedGovernmentCommitments = governmentCommitments.copy();
      expect(copiedGovernmentCommitments.isEmpty, isFalse);
      expect(copiedGovernmentCommitments.length,
          equals(governmentCommitments.length));
      expect(copiedGovernmentCommitments, isNot(same(governmentCommitments)));
      copiedGovernmentCommitments.forEach((e) =>
          expect(e, equals(governmentCommitments.singleWhereOid(e.oid))));

      //copiedGovernmentCommitments.display(title: "Copy governmentCommitments");
    });

    test('True for every governmentCommitment', () {
      // no required attribute that is not id
    });

    test('Random governmentCommitment', () {
      final governmentCommitment1 = projectModel.governmentCommitments.random();
      expect(governmentCommitment1, isNotNull);
      final governmentCommitment2 = projectModel.governmentCommitments.random();
      expect(governmentCommitment2, isNotNull);

      //governmentCommitment1.display(prefix: "random1");
      //governmentCommitment2.display(prefix: "random2");
    });

    test('Update governmentCommitment id with try', () {
      // no id attribute
    });

    test('Update governmentCommitment id without try', () {
      // no id attribute
    });

    test('Update governmentCommitment id with success', () {
      // no id attribute
    });

    test('Update governmentCommitment non id attribute with failure', () {
      // no attribute that is not id
    });

    test('Copy Equality', () {
      final randomGovernmentCommitment =
          projectModel.governmentCommitments.random();
      randomGovernmentCommitment.display(prefix: 'before copy: ');
      final randomGovernmentCommitmentCopy = randomGovernmentCommitment.copy();
      randomGovernmentCommitmentCopy.display(prefix: 'after copy: ');
      expect(
          randomGovernmentCommitment, equals(randomGovernmentCommitmentCopy));
      expect(randomGovernmentCommitment.oid,
          equals(randomGovernmentCommitmentCopy.oid));
      expect(randomGovernmentCommitment.code,
          equals(randomGovernmentCommitmentCopy.code));
    });

    test('governmentCommitment action undo and redo', () {
      var governmentCommitmentCount = governmentCommitments.length;
      final governmentCommitment =
          GovernmentCommitment(governmentCommitments.concept);
      governmentCommitments.add(governmentCommitment);
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));
      governmentCommitments.remove(governmentCommitment);
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      final action =
          AddCommand(session, governmentCommitments, governmentCommitment);
      action.doIt();
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));

      action.undo();
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      action.redo();
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));
    });

    test('governmentCommitment session undo and redo', () {
      var governmentCommitmentCount = governmentCommitments.length;
      final governmentCommitment =
          GovernmentCommitment(governmentCommitments.concept);
      governmentCommitments.add(governmentCommitment);
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));
      governmentCommitments.remove(governmentCommitment);
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      final action =
          AddCommand(session, governmentCommitments, governmentCommitment);
      action.doIt();
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));

      session.past.undo();
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      session.past.redo();
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));
    });

    test('GovernmentCommitment update undo and redo', () {
      // no attribute that is not id
    });

    test('GovernmentCommitment action with multiple undos and redos', () {
      var governmentCommitmentCount = governmentCommitments.length;
      final governmentCommitment1 = projectModel.governmentCommitments.random();

      final action1 =
          RemoveCommand(session, governmentCommitments, governmentCommitment1);
      action1.doIt();
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      final governmentCommitment2 = projectModel.governmentCommitments.random();

      final action2 =
          RemoveCommand(session, governmentCommitments, governmentCommitment2);
      action2.doIt();
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      //session.past.display();

      session.past.undo();
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));

      session.past.undo();
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));

      //session.past.display();

      session.past.redo();
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      session.past.redo();
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      //session.past.display();
    });

    test('Transaction undo and redo', () {
      var governmentCommitmentCount = governmentCommitments.length;
      final governmentCommitment1 = projectModel.governmentCommitments.random();
      var governmentCommitment2 = projectModel.governmentCommitments.random();
      while (governmentCommitment1 == governmentCommitment2) {
        governmentCommitment2 = projectModel.governmentCommitments.random();
      }
      final action1 =
          RemoveCommand(session, governmentCommitments, governmentCommitment1);
      final action2 =
          RemoveCommand(session, governmentCommitments, governmentCommitment2);

      final transaction =
          Transaction('two removes on governmentCommitments', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      governmentCommitmentCount = governmentCommitmentCount - 2;
      expect(governmentCommitments.length, equals(governmentCommitmentCount));

      governmentCommitments.display(title: 'Transaction Done');

      session.past.undo();
      governmentCommitmentCount = governmentCommitmentCount + 2;
      expect(governmentCommitments.length, equals(governmentCommitmentCount));

      governmentCommitments.display(title: 'Transaction Undone');

      session.past.redo();
      governmentCommitmentCount = governmentCommitmentCount - 2;
      expect(governmentCommitments.length, equals(governmentCommitmentCount));

      governmentCommitments.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final governmentCommitmentCount = governmentCommitments.length;
      final governmentCommitment1 = projectModel.governmentCommitments.random();
      final governmentCommitment2 = governmentCommitment1;
      final action1 =
          RemoveCommand(session, governmentCommitments, governmentCommitment1);
      final action2 =
          RemoveCommand(session, governmentCommitments, governmentCommitment2);

      final transaction = Transaction(
          'two removes on governmentCommitments, with an error on the second',
          session);
      transaction.add(action1);
      transaction.add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(governmentCommitments.length, equals(governmentCommitmentCount));

      //governmentCommitments.display(title:"Transaction with an error");
    });

    test('Reactions to governmentCommitment actions', () {
      var governmentCommitmentCount = governmentCommitments.length;

      final reaction = GovernmentCommitmentReaction();
      expect(reaction, isNotNull);

      focusDomain.startCommandReaction(reaction);
      final governmentCommitment =
          GovernmentCommitment(governmentCommitments.concept);
      governmentCommitments.add(governmentCommitment);
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));
      governmentCommitments.remove(governmentCommitment);
      expect(governmentCommitments.length, equals(--governmentCommitmentCount));

      final session = focusDomain.newSession();
      final addCommand =
          AddCommand(session, governmentCommitments, governmentCommitment);
      addCommand.doIt();
      expect(governmentCommitments.length, equals(++governmentCommitmentCount));
      expect(reaction.reactedOnAdd, isTrue);

      // no attribute that is not id
    });
  });
}

class GovernmentCommitmentReaction implements ICommandReaction {
  bool reactedOnAdd = false;
  bool reactedOnUpdate = false;

  @override
  void react(ICommand action) {
    if (action is IEntitiesCommand) {
      reactedOnAdd = true;
    } else if (action is IEntityCommand) {
      reactedOnUpdate = true;
    }
  }
}

void main() {
  final repository = Repository();
  final focusDomain = repository.getDomainModels('Focus') as FocusDomain;
  final projectModel =
      focusDomain.getModelEntries('Project') as ProjectModel;
  final governmentCommitments = projectModel.governmentCommitments;
  testFocusProjectGovernmentCommitments(
      focusDomain, projectModel, governmentCommitments);
}
