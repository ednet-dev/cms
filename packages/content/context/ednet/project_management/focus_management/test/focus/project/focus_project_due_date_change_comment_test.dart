// test/focus/project/focus_project_due_date_change_comment_test.dart

import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:focus_project/focus_project.dart';

void testFocusProjectDueDateChangeComments(FocusDomain focusDomain,
    ProjectModel projectModel, DueDateChangeComments dueDateChangeComments) {
  DomainSession session;
  group('Testing Focus.Project.DueDateChangeComment', () {
    session = focusDomain.newSession();
    setUp(() {
      projectModel.init();
    });
    tearDown(() {
      projectModel.clear();
    });

    test('Not empty model', () {
      expect(projectModel.isEmpty, isFalse);
      expect(dueDateChangeComments.isEmpty, isFalse);
    });

    test('Empty model', () {
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      expect(dueDateChangeComments.isEmpty, isTrue);
      expect(dueDateChangeComments.exceptions.isEmpty, isTrue);
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
      final json = projectModel.fromEntryToJson('DueDateChangeComment');
      expect(json, isNotNull);

      print(json);
      //projectModel.displayEntryJson("DueDateChangeComment");
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model entry', () {
      final json = projectModel.fromEntryToJson('DueDateChangeComment');
      dueDateChangeComments.clear();
      expect(dueDateChangeComments.isEmpty, isTrue);
      projectModel.fromJsonToEntry(json);
      expect(dueDateChangeComments.isEmpty, isFalse);

      dueDateChangeComments.display(title: 'From JSON to model entry');
    });

    test('Add dueDateChangeComment required error', () {
      // no required attribute that is not id
    });

    test('Add dueDateChangeComment unique error', () {
      // no id attribute
    });

    test('Not found dueDateChangeComment by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final dueDateChangeComment = dueDateChangeComments.singleWhereOid(ednetOid);
      expect(dueDateChangeComment, isNull);
    });

    test('Find dueDateChangeComment by oid', () {
      final randomDueDateChangeComment =
          projectModel.dueDateChangeComments.random();
      final dueDateChangeComment =
          dueDateChangeComments.singleWhereOid(randomDueDateChangeComment.oid);
      expect(dueDateChangeComment, isNotNull);
      expect(dueDateChangeComment, equals(randomDueDateChangeComment));
    });

    test('Find dueDateChangeComment by attribute id', () {
      // no id attribute
    });

    test('Find dueDateChangeComment by required attribute', () {
      // no required attribute that is not id
    });

    test('Find dueDateChangeComment by attribute', () {
      // no attribute that is not required
    });

    test('Select dueDateChangeComments by attribute', () {
      // no attribute that is not required
    });

    test('Select dueDateChangeComments by required attribute', () {
      // no required attribute that is not id
    });

    test('Select dueDateChangeComments by attribute, then add', () {
      // no attribute that is not id
    });

    test('Select dueDateChangeComments by attribute, then remove', () {
      // no attribute that is not id
    });

    test('Sort dueDateChangeComments', () {
      // no id attribute
      // add compareTo method in the specific DueDateChangeComment class
      /* 
      dueDateChangeComments.sort(); 
 
      //dueDateChangeComments.display(title: "Sort dueDateChangeComments"); 
      */
    });

    test('Order dueDateChangeComments', () {
      // no id attribute
      // add compareTo method in the specific DueDateChangeComment class
      /* 
      var orderedDueDateChangeComments = dueDateChangeComments.order(); 
      expect(orderedDueDateChangeComments.isEmpty, isFalse); 
      expect(orderedDueDateChangeComments.length, equals(dueDateChangeComments.length)); 
      expect(orderedDueDateChangeComments.source?.isEmpty, isFalse); 
      expect(orderedDueDateChangeComments.source?.length, equals(dueDateChangeComments.length)); 
      expect(orderedDueDateChangeComments, isNot(same(dueDateChangeComments))); 
 
      //orderedDueDateChangeComments.display(title: "Order dueDateChangeComments"); 
      */
    });

    test('Copy dueDateChangeComments', () {
      final copiedDueDateChangeComments = dueDateChangeComments.copy();
      expect(copiedDueDateChangeComments.isEmpty, isFalse);
      expect(copiedDueDateChangeComments.length,
          equals(dueDateChangeComments.length));
      expect(copiedDueDateChangeComments, isNot(same(dueDateChangeComments)));
      copiedDueDateChangeComments.forEach((e) =>
          expect(e, equals(dueDateChangeComments.singleWhereOid(e.oid))));

      //copiedDueDateChangeComments.display(title: "Copy dueDateChangeComments");
    });

    test('True for every dueDateChangeComment', () {
      // no required attribute that is not id
    });

    test('Random dueDateChangeComment', () {
      final dueDateChangeComment1 = projectModel.dueDateChangeComments.random();
      expect(dueDateChangeComment1, isNotNull);
      final dueDateChangeComment2 = projectModel.dueDateChangeComments.random();
      expect(dueDateChangeComment2, isNotNull);

      //dueDateChangeComment1.display(prefix: "random1");
      //dueDateChangeComment2.display(prefix: "random2");
    });

    test('Update dueDateChangeComment id with try', () {
      // no id attribute
    });

    test('Update dueDateChangeComment id without try', () {
      // no id attribute
    });

    test('Update dueDateChangeComment id with success', () {
      // no id attribute
    });

    test('Update dueDateChangeComment non id attribute with failure', () {
      // no attribute that is not id
    });

    test('Copy Equality', () {
      final randomDueDateChangeComment =
          projectModel.dueDateChangeComments.random();
      randomDueDateChangeComment.display(prefix: 'before copy: ');
      final randomDueDateChangeCommentCopy = randomDueDateChangeComment.copy();
      randomDueDateChangeCommentCopy.display(prefix: 'after copy: ');
      expect(
          randomDueDateChangeComment, equals(randomDueDateChangeCommentCopy));
      expect(randomDueDateChangeComment.oid,
          equals(randomDueDateChangeCommentCopy.oid));
      expect(randomDueDateChangeComment.code,
          equals(randomDueDateChangeCommentCopy.code));
    });

    test('dueDateChangeComment action undo and redo', () {
      var dueDateChangeCommentCount = dueDateChangeComments.length;
      final dueDateChangeComment =
          DueDateChangeComment(dueDateChangeComments.concept);
      dueDateChangeComments.add(dueDateChangeComment);
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));
      dueDateChangeComments.remove(dueDateChangeComment);
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      final action =
          AddCommand(session, dueDateChangeComments, dueDateChangeComment);
      action.doIt();
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));

      action.undo();
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      action.redo();
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));
    });

    test('dueDateChangeComment session undo and redo', () {
      var dueDateChangeCommentCount = dueDateChangeComments.length;
      final dueDateChangeComment =
          DueDateChangeComment(dueDateChangeComments.concept);
      dueDateChangeComments.add(dueDateChangeComment);
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));
      dueDateChangeComments.remove(dueDateChangeComment);
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      final action =
          AddCommand(session, dueDateChangeComments, dueDateChangeComment);
      action.doIt();
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));

      session.past.undo();
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      session.past.redo();
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));
    });

    test('DueDateChangeComment update undo and redo', () {
      // no attribute that is not id
    });

    test('DueDateChangeComment action with multiple undos and redos', () {
      var dueDateChangeCommentCount = dueDateChangeComments.length;
      final dueDateChangeComment1 = projectModel.dueDateChangeComments.random();

      final action1 =
          RemoveCommand(session, dueDateChangeComments, dueDateChangeComment1);
      action1.doIt();
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      final dueDateChangeComment2 = projectModel.dueDateChangeComments.random();

      final action2 =
          RemoveCommand(session, dueDateChangeComments, dueDateChangeComment2);
      action2.doIt();
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      //session.past.display();

      session.past.undo();
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));

      session.past.undo();
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));

      //session.past.display();

      session.past.redo();
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      session.past.redo();
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      //session.past.display();
    });

    test('Transaction undo and redo', () {
      var dueDateChangeCommentCount = dueDateChangeComments.length;
      final dueDateChangeComment1 = projectModel.dueDateChangeComments.random();
      var dueDateChangeComment2 = projectModel.dueDateChangeComments.random();
      while (dueDateChangeComment1 == dueDateChangeComment2) {
        dueDateChangeComment2 = projectModel.dueDateChangeComments.random();
      }
      final action1 =
          RemoveCommand(session, dueDateChangeComments, dueDateChangeComment1);
      final action2 =
          RemoveCommand(session, dueDateChangeComments, dueDateChangeComment2);

      final transaction =
          Transaction('two removes on dueDateChangeComments', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      dueDateChangeCommentCount = dueDateChangeCommentCount - 2;
      expect(dueDateChangeComments.length, equals(dueDateChangeCommentCount));

      dueDateChangeComments.display(title: 'Transaction Done');

      session.past.undo();
      dueDateChangeCommentCount = dueDateChangeCommentCount + 2;
      expect(dueDateChangeComments.length, equals(dueDateChangeCommentCount));

      dueDateChangeComments.display(title: 'Transaction Undone');

      session.past.redo();
      dueDateChangeCommentCount = dueDateChangeCommentCount - 2;
      expect(dueDateChangeComments.length, equals(dueDateChangeCommentCount));

      dueDateChangeComments.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final dueDateChangeCommentCount = dueDateChangeComments.length;
      final dueDateChangeComment1 = projectModel.dueDateChangeComments.random();
      final dueDateChangeComment2 = dueDateChangeComment1;
      final action1 =
          RemoveCommand(session, dueDateChangeComments, dueDateChangeComment1);
      final action2 =
          RemoveCommand(session, dueDateChangeComments, dueDateChangeComment2);

      final transaction = Transaction(
          'two removes on dueDateChangeComments, with an error on the second',
          session);
      transaction.add(action1);
      transaction.add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(dueDateChangeComments.length, equals(dueDateChangeCommentCount));

      //dueDateChangeComments.display(title:"Transaction with an error");
    });

    test('Reactions to dueDateChangeComment actions', () {
      var dueDateChangeCommentCount = dueDateChangeComments.length;

      final reaction = DueDateChangeCommentReaction();
      expect(reaction, isNotNull);

      focusDomain.startCommandReaction(reaction);
      final dueDateChangeComment =
          DueDateChangeComment(dueDateChangeComments.concept);
      dueDateChangeComments.add(dueDateChangeComment);
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));
      dueDateChangeComments.remove(dueDateChangeComment);
      expect(dueDateChangeComments.length, equals(--dueDateChangeCommentCount));

      final session = focusDomain.newSession();
      final addCommand =
          AddCommand(session, dueDateChangeComments, dueDateChangeComment);
      addCommand.doIt();
      expect(dueDateChangeComments.length, equals(++dueDateChangeCommentCount));
      expect(reaction.reactedOnAdd, isTrue);

      // no attribute that is not id
    });
  });
}

class DueDateChangeCommentReaction implements ICommandReaction {
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
  final dueDateChangeComments = projectModel.dueDateChangeComments;
  testFocusProjectDueDateChangeComments(
      focusDomain, projectModel, dueDateChangeComments);
}
