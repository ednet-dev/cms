// test/focus/project/focus_project_urgency_estimation_test.dart

import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:focus_project/focus_project.dart';

void testFocusProjectUrgencyEstimations(FocusDomain focusDomain,
    ProjectModel projectModel, UrgencyEstimations urgencyEstimations) {
  DomainSession session;
  group('Testing Focus.Project.UrgencyEstimation', () {
    session = focusDomain.newSession();
    setUp(() {
      projectModel.init();
    });
    tearDown(() {
      projectModel.clear();
    });

    test('Not empty model', () {
      expect(projectModel.isEmpty, isFalse);
      expect(urgencyEstimations.isEmpty, isFalse);
    });

    test('Empty model', () {
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      expect(urgencyEstimations.isEmpty, isTrue);
      expect(urgencyEstimations.exceptions.isEmpty, isTrue);
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
      final json = projectModel.fromEntryToJson('UrgencyEstimation');
      expect(json, isNotNull);

      print(json);
      //projectModel.displayEntryJson("UrgencyEstimation");
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model entry', () {
      final json = projectModel.fromEntryToJson('UrgencyEstimation');
      urgencyEstimations.clear();
      expect(urgencyEstimations.isEmpty, isTrue);
      projectModel.fromJsonToEntry(json);
      expect(urgencyEstimations.isEmpty, isFalse);

      urgencyEstimations.display(title: 'From JSON to model entry');
    });

    test('Add urgencyEstimation required error', () {
      // no required attribute that is not id
    });

    test('Add urgencyEstimation unique error', () {
      // no id attribute
    });

    test('Not found urgencyEstimation by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final urgencyEstimation = urgencyEstimations.singleWhereOid(ednetOid);
      expect(urgencyEstimation, isNull);
    });

    test('Find urgencyEstimation by oid', () {
      final randomUrgencyEstimation = projectModel.urgencyEstimations.random();
      final urgencyEstimation =
          urgencyEstimations.singleWhereOid(randomUrgencyEstimation.oid);
      expect(urgencyEstimation, isNotNull);
      expect(urgencyEstimation, equals(randomUrgencyEstimation));
    });

    test('Find urgencyEstimation by attribute id', () {
      // no id attribute
    });

    test('Find urgencyEstimation by required attribute', () {
      // no required attribute that is not id
    });

    test('Find urgencyEstimation by attribute', () {
      // no attribute that is not required
    });

    test('Select urgencyEstimations by attribute', () {
      // no attribute that is not required
    });

    test('Select urgencyEstimations by required attribute', () {
      // no required attribute that is not id
    });

    test('Select urgencyEstimations by attribute, then add', () {
      // no attribute that is not id
    });

    test('Select urgencyEstimations by attribute, then remove', () {
      // no attribute that is not id
    });

    test('Sort urgencyEstimations', () {
      // no id attribute
      // add compareTo method in the specific UrgencyEstimation class
      /* 
      urgencyEstimations.sort(); 
 
      //urgencyEstimations.display(title: "Sort urgencyEstimations"); 
      */
    });

    test('Order urgencyEstimations', () {
      // no id attribute
      // add compareTo method in the specific UrgencyEstimation class
      /* 
      var orderedUrgencyEstimations = urgencyEstimations.order(); 
      expect(orderedUrgencyEstimations.isEmpty, isFalse); 
      expect(orderedUrgencyEstimations.length, equals(urgencyEstimations.length)); 
      expect(orderedUrgencyEstimations.source?.isEmpty, isFalse); 
      expect(orderedUrgencyEstimations.source?.length, equals(urgencyEstimations.length)); 
      expect(orderedUrgencyEstimations, isNot(same(urgencyEstimations))); 
 
      //orderedUrgencyEstimations.display(title: "Order urgencyEstimations"); 
      */
    });

    test('Copy urgencyEstimations', () {
      final copiedUrgencyEstimations = urgencyEstimations.copy();
      expect(copiedUrgencyEstimations.isEmpty, isFalse);
      expect(
          copiedUrgencyEstimations.length, equals(urgencyEstimations.length));
      expect(copiedUrgencyEstimations, isNot(same(urgencyEstimations)));
      copiedUrgencyEstimations.forEach(
          (e) => expect(e, equals(urgencyEstimations.singleWhereOid(e.oid))));

      //copiedUrgencyEstimations.display(title: "Copy urgencyEstimations");
    });

    test('True for every urgencyEstimation', () {
      // no required attribute that is not id
    });

    test('Random urgencyEstimation', () {
      final urgencyEstimation1 = projectModel.urgencyEstimations.random();
      expect(urgencyEstimation1, isNotNull);
      final urgencyEstimation2 = projectModel.urgencyEstimations.random();
      expect(urgencyEstimation2, isNotNull);

      //urgencyEstimation1.display(prefix: "random1");
      //urgencyEstimation2.display(prefix: "random2");
    });

    test('Update urgencyEstimation id with try', () {
      // no id attribute
    });

    test('Update urgencyEstimation id without try', () {
      // no id attribute
    });

    test('Update urgencyEstimation id with success', () {
      // no id attribute
    });

    test('Update urgencyEstimation non id attribute with failure', () {
      // no attribute that is not id
    });

    test('Copy Equality', () {
      final randomUrgencyEstimation = projectModel.urgencyEstimations.random();
      randomUrgencyEstimation.display(prefix: 'before copy: ');
      final randomUrgencyEstimationCopy = randomUrgencyEstimation.copy();
      randomUrgencyEstimationCopy.display(prefix: 'after copy: ');
      expect(randomUrgencyEstimation, equals(randomUrgencyEstimationCopy));
      expect(
          randomUrgencyEstimation.oid, equals(randomUrgencyEstimationCopy.oid));
      expect(randomUrgencyEstimation.code,
          equals(randomUrgencyEstimationCopy.code));
    });

    test('urgencyEstimation action undo and redo', () {
      var urgencyEstimationCount = urgencyEstimations.length;
      final urgencyEstimation = UrgencyEstimation(urgencyEstimations.concept);
      urgencyEstimations.add(urgencyEstimation);
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));
      urgencyEstimations.remove(urgencyEstimation);
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      final action = AddCommand(session, urgencyEstimations, urgencyEstimation);
      action.doIt();
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));

      action.undo();
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      action.redo();
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));
    });

    test('urgencyEstimation session undo and redo', () {
      var urgencyEstimationCount = urgencyEstimations.length;
      final urgencyEstimation = UrgencyEstimation(urgencyEstimations.concept);
      urgencyEstimations.add(urgencyEstimation);
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));
      urgencyEstimations.remove(urgencyEstimation);
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      final action = AddCommand(session, urgencyEstimations, urgencyEstimation);
      action.doIt();
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));

      session.past.undo();
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      session.past.redo();
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));
    });

    test('UrgencyEstimation update undo and redo', () {
      // no attribute that is not id
    });

    test('UrgencyEstimation action with multiple undos and redos', () {
      var urgencyEstimationCount = urgencyEstimations.length;
      final urgencyEstimation1 = projectModel.urgencyEstimations.random();

      final action1 =
          RemoveCommand(session, urgencyEstimations, urgencyEstimation1);
      action1.doIt();
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      final urgencyEstimation2 = projectModel.urgencyEstimations.random();

      final action2 =
          RemoveCommand(session, urgencyEstimations, urgencyEstimation2);
      action2.doIt();
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      //session.past.display();

      session.past.undo();
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));

      session.past.undo();
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));

      //session.past.display();

      session.past.redo();
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      session.past.redo();
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      //session.past.display();
    });

    test('Transaction undo and redo', () {
      var urgencyEstimationCount = urgencyEstimations.length;
      final urgencyEstimation1 = projectModel.urgencyEstimations.random();
      var urgencyEstimation2 = projectModel.urgencyEstimations.random();
      while (urgencyEstimation1 == urgencyEstimation2) {
        urgencyEstimation2 = projectModel.urgencyEstimations.random();
      }
      final action1 =
          RemoveCommand(session, urgencyEstimations, urgencyEstimation1);
      final action2 =
          RemoveCommand(session, urgencyEstimations, urgencyEstimation2);

      final transaction =
          Transaction('two removes on urgencyEstimations', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      urgencyEstimationCount = urgencyEstimationCount - 2;
      expect(urgencyEstimations.length, equals(urgencyEstimationCount));

      urgencyEstimations.display(title: 'Transaction Done');

      session.past.undo();
      urgencyEstimationCount = urgencyEstimationCount + 2;
      expect(urgencyEstimations.length, equals(urgencyEstimationCount));

      urgencyEstimations.display(title: 'Transaction Undone');

      session.past.redo();
      urgencyEstimationCount = urgencyEstimationCount - 2;
      expect(urgencyEstimations.length, equals(urgencyEstimationCount));

      urgencyEstimations.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final urgencyEstimationCount = urgencyEstimations.length;
      final urgencyEstimation1 = projectModel.urgencyEstimations.random();
      final urgencyEstimation2 = urgencyEstimation1;
      final action1 =
          RemoveCommand(session, urgencyEstimations, urgencyEstimation1);
      final action2 =
          RemoveCommand(session, urgencyEstimations, urgencyEstimation2);

      final transaction = Transaction(
          'two removes on urgencyEstimations, with an error on the second',
          session);
      transaction.add(action1);
      transaction.add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(urgencyEstimations.length, equals(urgencyEstimationCount));

      //urgencyEstimations.display(title:"Transaction with an error");
    });

    test('Reactions to urgencyEstimation actions', () {
      var urgencyEstimationCount = urgencyEstimations.length;

      final reaction = UrgencyEstimationReaction();
      expect(reaction, isNotNull);

      focusDomain.startCommandReaction(reaction);
      final urgencyEstimation = UrgencyEstimation(urgencyEstimations.concept);
      urgencyEstimations.add(urgencyEstimation);
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));
      urgencyEstimations.remove(urgencyEstimation);
      expect(urgencyEstimations.length, equals(--urgencyEstimationCount));

      final session = focusDomain.newSession();
      final addCommand =
          AddCommand(session, urgencyEstimations, urgencyEstimation);
      addCommand.doIt();
      expect(urgencyEstimations.length, equals(++urgencyEstimationCount));
      expect(reaction.reactedOnAdd, isTrue);

      // no attribute that is not id
    });
  });
}

class UrgencyEstimationReaction implements ICommandReaction {
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
  final urgencyEstimations = projectModel.urgencyEstimations;
  testFocusProjectUrgencyEstimations(
      focusDomain, projectModel, urgencyEstimations);
}
