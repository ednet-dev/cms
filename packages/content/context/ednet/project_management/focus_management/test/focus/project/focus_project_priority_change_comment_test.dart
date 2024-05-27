// test/focus/project/focus_project_priority_change_comment_test.dart

import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:focus_project/focus_project.dart';

void testFocusProjectPriorityChangeComments(FocusDomain focusDomain,
    ProjectModel projectModel, PriorityChangeComments priorityChangeComments) {
  DomainSession session;
  group('Testing Focus.Project.PriorityChangeComment', () {
    session = focusDomain.newSession();
    setUp(() {
      projectModel.init();
    });
    tearDown(() {
      projectModel.clear();
    });

    test('Not empty model', () {
      expect(projectModel.isEmpty, isFalse);
      expect(priorityChangeComments.isEmpty, isFalse);
    });

    test('Empty model', () {
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      expect(priorityChangeComments.isEmpty, isTrue);
      expect(priorityChangeComments.exceptions.isEmpty, isTrue);
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
      final json = projectModel.fromEntryToJson('PriorityChangeComment');
      expect(json, isNotNull);

      print(json);
      //projectModel.displayEntryJson("PriorityChangeComment");
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model entry', () {
      final json = projectModel.fromEntryToJson('PriorityChangeComment');
      priorityChangeComments.clear();
      expect(priorityChangeComments.isEmpty, isTrue);
      projectModel.fromJsonToEntry(json);
      expect(priorityChangeComments.isEmpty, isFalse);

      priorityChangeComments.display(title: 'From JSON to model entry');
    });

    test('Add priorityChangeComment required error', () {
      // no required attribute that is not id
    });

    test('Add priorityChangeComment unique error', () {
      // no id attribute
    });

    test('Not found priorityChangeComment by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final priorityChangeComment =
          priorityChangeComments.singleWhereOid(ednetOid);
      expect(priorityChangeComment, isNull);
    });

    test('Find priorityChangeComment by oid', () {
      final randomPriorityChangeComment =
          projectModel.priorityChangeComments.random();
      final priorityChangeComment = priorityChangeComments
          .singleWhereOid(randomPriorityChangeComment.oid);
      expect(priorityChangeComment, isNotNull);
      expect(priorityChangeComment, equals(randomPriorityChangeComment));
    });

    test('Find priorityChangeComment by attribute id', () {
      // no id attribute
    });

    test('Find priorityChangeComment by required attribute', () {
      // no required attribute that is not id
    });

    test('Find priorityChangeComment by attribute', () {
      // no attribute that is not required
    });

    test('Select priorityChangeComments by attribute', () {
      // no attribute that is not required
    });

    test('Select priorityChangeComments by required attribute', () {
      // no required attribute that is not id
    });

    test('Select priorityChangeComments by attribute, then add', () {
      // no attribute that is not id
    });

    test('Select priorityChangeComments by attribute, then remove', () {
      // no attribute that is not id
    });

    test('Sort priorityChangeComments', () {
      // no id attribute
      // add compareTo method in the specific PriorityChangeComment class
      /* 
      priorityChangeComments.sort(); 
 
      //priorityChangeComments.display(title: "Sort priorityChangeComments"); 
      */
    });

    test('Order priorityChangeComments', () {
      // no id attribute
      // add compareTo method in the specific PriorityChangeComment class
      /* 
      var orderedPriorityChangeComments = priorityChangeComments.order(); 
      expect(orderedPriorityChangeComments.isEmpty, isFalse); 
      expect(orderedPriorityChangeComments.length, equals(priorityChangeComments.length)); 
      expect(orderedPriorityChangeComments.source?.isEmpty, isFalse); 
      expect(orderedPriorityChangeComments.source?.length, equals(priorityChangeComments.length)); 
      expect(orderedPriorityChangeComments, isNot(same(priorityChangeComments))); 
 
      //orderedPriorityChangeComments.display(title: "Order priorityChangeComments"); 
      */
    });

    test('Copy priorityChangeComments', () {
      final copiedPriorityChangeComments = priorityChangeComments.copy();
      expect(copiedPriorityChangeComments.isEmpty, isFalse);
      expect(copiedPriorityChangeComments.length,
          equals(priorityChangeComments.length));
      expect(copiedPriorityChangeComments, isNot(same(priorityChangeComments)));
      copiedPriorityChangeComments.forEach((e) =>
          expect(e, equals(priorityChangeComments.singleWhereOid(e.oid))));

      //copiedPriorityChangeComments.display(title: "Copy priorityChangeComments");
    });

    test('True for every priorityChangeComment', () {
      // no required attribute that is not id
    });

    test('Random priorityChangeComment', () {
      final priorityChangeComment1 = projectModel.priorityChangeComments.random();
      expect(priorityChangeComment1, isNotNull);
      final priorityChangeComment2 = projectModel.priorityChangeComments.random();
      expect(priorityChangeComment2, isNotNull);

      //priorityChangeComment1.display(prefix: "random1");
      //priorityChangeComment2.display(prefix: "random2");
    });

    test('Update priorityChangeComment id with try', () {
      // no id attribute
    });

    test('Update priorityChangeComment id without try', () {
      // no id attribute
    });

    test('Update priorityChangeComment id with success', () {
      // no id attribute
    });

    test('Update priorityChangeComment non id attribute with failure', () {
      // no attribute that is not id
    });

    test('Copy Equality', () {
      final randomPriorityChangeComment =
          projectModel.priorityChangeComments.random();
      randomPriorityChangeComment.display(prefix: 'before copy: ');
      final randomPriorityChangeCommentCopy = randomPriorityChangeComment.copy();
      randomPriorityChangeCommentCopy.display(prefix: 'after copy: ');
      expect(
          randomPriorityChangeComment, equals(randomPriorityChangeCommentCopy));
      expect(randomPriorityChangeComment.oid,
          equals(randomPriorityChangeCommentCopy.oid));
      expect(randomPriorityChangeComment.code,
          equals(randomPriorityChangeCommentCopy.code));
    });

    test('priorityChangeComment action undo and redo', () {
      var priorityChangeCommentCount = priorityChangeComments.length;
      final priorityChangeComment =
          PriorityChangeComment(priorityChangeComments.concept);
      priorityChangeComments.add(priorityChangeComment);
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));
      priorityChangeComments.remove(priorityChangeComment);
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      final action =
          AddCommand(session, priorityChangeComments, priorityChangeComment);
      action.doIt();
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));

      action.undo();
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      action.redo();
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));
    });

    test('priorityChangeComment session undo and redo', () {
      var priorityChangeCommentCount = priorityChangeComments.length;
      final priorityChangeComment =
          PriorityChangeComment(priorityChangeComments.concept);
      priorityChangeComments.add(priorityChangeComment);
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));
      priorityChangeComments.remove(priorityChangeComment);
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      final action =
          AddCommand(session, priorityChangeComments, priorityChangeComment);
      action.doIt();
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));

      session.past.undo();
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      session.past.redo();
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));
    });

    test('PriorityChangeComment update undo and redo', () {
      // no attribute that is not id
    });

    test('PriorityChangeComment action with multiple undos and redos', () {
      var priorityChangeCommentCount = priorityChangeComments.length;
      final priorityChangeComment1 = projectModel.priorityChangeComments.random();

      final action1 = RemoveCommand(
          session, priorityChangeComments, priorityChangeComment1);
      action1.doIt();
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      final priorityChangeComment2 = projectModel.priorityChangeComments.random();

      final action2 = RemoveCommand(
          session, priorityChangeComments, priorityChangeComment2);
      action2.doIt();
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      //session.past.display();

      session.past.undo();
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));

      session.past.undo();
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));

      //session.past.display();

      session.past.redo();
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      session.past.redo();
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      //session.past.display();
    });

    test('Transaction undo and redo', () {
      var priorityChangeCommentCount = priorityChangeComments.length;
      final priorityChangeComment1 = projectModel.priorityChangeComments.random();
      var priorityChangeComment2 = projectModel.priorityChangeComments.random();
      while (priorityChangeComment1 == priorityChangeComment2) {
        priorityChangeComment2 = projectModel.priorityChangeComments.random();
      }
      final action1 = RemoveCommand(
          session, priorityChangeComments, priorityChangeComment1);
      final action2 = RemoveCommand(
          session, priorityChangeComments, priorityChangeComment2);

      final transaction =
          Transaction('two removes on priorityChangeComments', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      priorityChangeCommentCount = priorityChangeCommentCount - 2;
      expect(priorityChangeComments.length, equals(priorityChangeCommentCount));

      priorityChangeComments.display(title: 'Transaction Done');

      session.past.undo();
      priorityChangeCommentCount = priorityChangeCommentCount + 2;
      expect(priorityChangeComments.length, equals(priorityChangeCommentCount));

      priorityChangeComments.display(title: 'Transaction Undone');

      session.past.redo();
      priorityChangeCommentCount = priorityChangeCommentCount - 2;
      expect(priorityChangeComments.length, equals(priorityChangeCommentCount));

      priorityChangeComments.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final priorityChangeCommentCount = priorityChangeComments.length;
      final priorityChangeComment1 = projectModel.priorityChangeComments.random();
      final priorityChangeComment2 = priorityChangeComment1;
      final action1 = RemoveCommand(
          session, priorityChangeComments, priorityChangeComment1);
      final action2 = RemoveCommand(
          session, priorityChangeComments, priorityChangeComment2);

      final transaction = Transaction(
          'two removes on priorityChangeComments, with an error on the second',
          session);
      transaction.add(action1);
      transaction.add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(priorityChangeComments.length, equals(priorityChangeCommentCount));

      //priorityChangeComments.display(title:"Transaction with an error");
    });

    test('Reactions to priorityChangeComment actions', () {
      var priorityChangeCommentCount = priorityChangeComments.length;

      final reaction = PriorityChangeCommentReaction();
      expect(reaction, isNotNull);

      focusDomain.startCommandReaction(reaction);
      final priorityChangeComment =
          PriorityChangeComment(priorityChangeComments.concept);
      priorityChangeComments.add(priorityChangeComment);
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));
      priorityChangeComments.remove(priorityChangeComment);
      expect(
          priorityChangeComments.length, equals(--priorityChangeCommentCount));

      final session = focusDomain.newSession();
      final addCommand =
          AddCommand(session, priorityChangeComments, priorityChangeComment);
      addCommand.doIt();
      expect(
          priorityChangeComments.length, equals(++priorityChangeCommentCount));
      expect(reaction.reactedOnAdd, isTrue);

      // no attribute that is not id
    });
  });
}

class PriorityChangeCommentReaction implements ICommandReaction {
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
  final priorityChangeComments = projectModel.priorityChangeComments;
  testFocusProjectPriorityChangeComments(
      focusDomain, projectModel, priorityChangeComments);
}
