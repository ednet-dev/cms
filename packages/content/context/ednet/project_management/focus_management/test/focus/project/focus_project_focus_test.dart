// test/focus/project/focus_project_focus_test.dart

import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:focus_project/focus_project.dart';

void testFocusProjectFocuss(
    FocusDomain focusDomain, ProjectModel projectModel, Focuss focuss) {
  DomainSession session;
  group('Testing Focus.Project.Focus', () {
    session = focusDomain.newSession();
    setUp(() {
      projectModel.init();
    });
    tearDown(() {
      projectModel.clear();
    });

    test('Not empty model', () {
      expect(projectModel.isEmpty, isFalse);
      expect(focuss.isEmpty, isFalse);
    });

    test('Empty model', () {
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      expect(focuss.isEmpty, isTrue);
      expect(focuss.exceptions.isEmpty, isTrue);
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
      final json = projectModel.fromEntryToJson('Focus');
      expect(json, isNotNull);

      print(json);
      //projectModel.displayEntryJson("Focus");
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model entry', () {
      final json = projectModel.fromEntryToJson('Focus');
      focuss.clear();
      expect(focuss.isEmpty, isTrue);
      projectModel.fromJsonToEntry(json);
      expect(focuss.isEmpty, isFalse);

      focuss.display(title: 'From JSON to model entry');
    });

    test('Add focus required error', () {
      // no required attribute that is not id
    });

    test('Add focus unique error', () {
      // no id attribute
    });

    test('Not found focus by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final focus = focuss.singleWhereOid(ednetOid);
      expect(focus, isNull);
    });

    test('Find focus by oid', () {
      final randomFocus = projectModel.focuss.random();
      final focus = focuss.singleWhereOid(randomFocus.oid);
      expect(focus, isNotNull);
      expect(focus, equals(randomFocus));
    });

    test('Find focus by attribute id', () {
      // no id attribute
    });

    test('Find focus by required attribute', () {
      // no required attribute that is not id
    });

    test('Find focus by attribute', () {
      // no attribute that is not required
    });

    test('Select focuss by attribute', () {
      // no attribute that is not required
    });

    test('Select focuss by required attribute', () {
      // no required attribute that is not id
    });

    test('Select focuss by attribute, then add', () {
      // no attribute that is not id
    });

    test('Select focuss by attribute, then remove', () {
      // no attribute that is not id
    });

    test('Sort focuss', () {
      // no id attribute
      // add compareTo method in the specific Focus class
      /* 
      focuss.sort(); 
 
      //focuss.display(title: "Sort focuss"); 
      */
    });

    test('Order focuss', () {
      // no id attribute
      // add compareTo method in the specific Focus class
      /* 
      var orderedFocuss = focuss.order(); 
      expect(orderedFocuss.isEmpty, isFalse); 
      expect(orderedFocuss.length, equals(focuss.length)); 
      expect(orderedFocuss.source?.isEmpty, isFalse); 
      expect(orderedFocuss.source?.length, equals(focuss.length)); 
      expect(orderedFocuss, isNot(same(focuss))); 
 
      //orderedFocuss.display(title: "Order focuss"); 
      */
    });

    test('Copy focuss', () {
      final copiedFocuss = focuss.copy();
      expect(copiedFocuss.isEmpty, isFalse);
      expect(copiedFocuss.length, equals(focuss.length));
      expect(copiedFocuss, isNot(same(focuss)));
      copiedFocuss
          .forEach((e) => expect(e, equals(focuss.singleWhereOid(e.oid))));

      //copiedFocuss.display(title: "Copy focuss");
    });

    test('True for every focus', () {
      // no required attribute that is not id
    });

    test('Random focus', () {
      final focus1 = projectModel.focuss.random();
      expect(focus1, isNotNull);
      final focus2 = projectModel.focuss.random();
      expect(focus2, isNotNull);

      //focus1.display(prefix: "random1");
      //focus2.display(prefix: "random2");
    });

    test('Update focus id with try', () {
      // no id attribute
    });

    test('Update focus id without try', () {
      // no id attribute
    });

    test('Update focus id with success', () {
      // no id attribute
    });

    test('Update focus non id attribute with failure', () {
      // no attribute that is not id
    });

    test('Copy Equality', () {
      final randomFocus = projectModel.focuss.random();
      randomFocus.display(prefix: 'before copy: ');
      final randomFocusCopy = randomFocus.copy();
      randomFocusCopy.display(prefix: 'after copy: ');
      expect(randomFocus, equals(randomFocusCopy));
      expect(randomFocus.oid, equals(randomFocusCopy.oid));
      expect(randomFocus.code, equals(randomFocusCopy.code));
    });

    test('focus action undo and redo', () {
      var focusCount = focuss.length;
      final focus = Focus(focuss.concept);
      focuss.add(focus);
      expect(focuss.length, equals(++focusCount));
      focuss.remove(focus);
      expect(focuss.length, equals(--focusCount));

      final action = AddCommand(session, focuss, focus);
      action.doIt();
      expect(focuss.length, equals(++focusCount));

      action.undo();
      expect(focuss.length, equals(--focusCount));

      action.redo();
      expect(focuss.length, equals(++focusCount));
    });

    test('focus session undo and redo', () {
      var focusCount = focuss.length;
      final focus = Focus(focuss.concept);
      focuss.add(focus);
      expect(focuss.length, equals(++focusCount));
      focuss.remove(focus);
      expect(focuss.length, equals(--focusCount));

      final action = AddCommand(session, focuss, focus);
      action.doIt();
      expect(focuss.length, equals(++focusCount));

      session.past.undo();
      expect(focuss.length, equals(--focusCount));

      session.past.redo();
      expect(focuss.length, equals(++focusCount));
    });

    test('Focus update undo and redo', () {
      // no attribute that is not id
    });

    test('Focus action with multiple undos and redos', () {
      var focusCount = focuss.length;
      final focus1 = projectModel.focuss.random();

      final action1 = RemoveCommand(session, focuss, focus1);
      action1.doIt();
      expect(focuss.length, equals(--focusCount));

      final focus2 = projectModel.focuss.random();

      final action2 = RemoveCommand(session, focuss, focus2);
      action2.doIt();
      expect(focuss.length, equals(--focusCount));

      //session.past.display();

      session.past.undo();
      expect(focuss.length, equals(++focusCount));

      session.past.undo();
      expect(focuss.length, equals(++focusCount));

      //session.past.display();

      session.past.redo();
      expect(focuss.length, equals(--focusCount));

      session.past.redo();
      expect(focuss.length, equals(--focusCount));

      //session.past.display();
    });

    test('Transaction undo and redo', () {
      var focusCount = focuss.length;
      final focus1 = projectModel.focuss.random();
      var focus2 = projectModel.focuss.random();
      while (focus1 == focus2) {
        focus2 = projectModel.focuss.random();
      }
      final action1 = RemoveCommand(session, focuss, focus1);
      final action2 = RemoveCommand(session, focuss, focus2);

      final transaction = Transaction('two removes on focuss', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      focusCount = focusCount - 2;
      expect(focuss.length, equals(focusCount));

      focuss.display(title: 'Transaction Done');

      session.past.undo();
      focusCount = focusCount + 2;
      expect(focuss.length, equals(focusCount));

      focuss.display(title: 'Transaction Undone');

      session.past.redo();
      focusCount = focusCount - 2;
      expect(focuss.length, equals(focusCount));

      focuss.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final focusCount = focuss.length;
      final focus1 = projectModel.focuss.random();
      final focus2 = focus1;
      final action1 = RemoveCommand(session, focuss, focus1);
      final action2 = RemoveCommand(session, focuss, focus2);

      final transaction = Transaction(
          'two removes on focuss, with an error on the second', session);
      transaction.add(action1);
      transaction.add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(focuss.length, equals(focusCount));

      //focuss.display(title:"Transaction with an error");
    });

    test('Reactions to focus actions', () {
      var focusCount = focuss.length;

      final reaction = FocusReaction();
      expect(reaction, isNotNull);

      focusDomain.startCommandReaction(reaction);
      final focus = Focus(focuss.concept);
      focuss.add(focus);
      expect(focuss.length, equals(++focusCount));
      focuss.remove(focus);
      expect(focuss.length, equals(--focusCount));

      final session = focusDomain.newSession();
      final addCommand = AddCommand(session, focuss, focus);
      addCommand.doIt();
      expect(focuss.length, equals(++focusCount));
      expect(reaction.reactedOnAdd, isTrue);

      // no attribute that is not id
    });
  });
}

class FocusReaction implements ICommandReaction {
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
  final focuss = projectModel.focuss;
  testFocusProjectFocuss(focusDomain, projectModel, focuss);
}
