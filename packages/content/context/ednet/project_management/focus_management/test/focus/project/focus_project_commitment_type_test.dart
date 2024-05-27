// test/focus/project/focus_project_commitment_type_test.dart

import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:focus_project/focus_project.dart';

void testFocusProjectCommitmentTypes(FocusDomain focusDomain,
    ProjectModel projectModel, CommitmentTypes commitmentTypes) {
  DomainSession session;
  group('Testing Focus.Project.CommitmentType', () {
    session = focusDomain.newSession();
    setUp(() {
      projectModel.init();
    });
    tearDown(() {
      projectModel.clear();
    });

    test('Not empty model', () {
      expect(projectModel.isEmpty, isFalse);
      expect(commitmentTypes.isEmpty, isFalse);
    });

    test('Empty model', () {
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      expect(commitmentTypes.isEmpty, isTrue);
      expect(commitmentTypes.exceptions.isEmpty, isTrue);
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
      final json = projectModel.fromEntryToJson('CommitmentType');
      expect(json, isNotNull);

      print(json);
      //projectModel.displayEntryJson("CommitmentType");
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model entry', () {
      final json = projectModel.fromEntryToJson('CommitmentType');
      commitmentTypes.clear();
      expect(commitmentTypes.isEmpty, isTrue);
      projectModel.fromJsonToEntry(json);
      expect(commitmentTypes.isEmpty, isFalse);

      commitmentTypes.display(title: 'From JSON to model entry');
    });

    test('Add commitmentType required error', () {
      // no required attribute that is not id
    });

    test('Add commitmentType unique error', () {
      // no id attribute
    });

    test('Not found commitmentType by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final commitmentType = commitmentTypes.singleWhereOid(ednetOid);
      expect(commitmentType, isNull);
    });

    test('Find commitmentType by oid', () {
      final randomCommitmentType = projectModel.commitmentTypes.random();
      final commitmentType =
          commitmentTypes.singleWhereOid(randomCommitmentType.oid);
      expect(commitmentType, isNotNull);
      expect(commitmentType, equals(randomCommitmentType));
    });

    test('Find commitmentType by attribute id', () {
      // no id attribute
    });

    test('Find commitmentType by required attribute', () {
      // no required attribute that is not id
    });

    test('Find commitmentType by attribute', () {
      // no attribute that is not required
    });

    test('Select commitmentTypes by attribute', () {
      // no attribute that is not required
    });

    test('Select commitmentTypes by required attribute', () {
      // no required attribute that is not id
    });

    test('Select commitmentTypes by attribute, then add', () {
      // no attribute that is not id
    });

    test('Select commitmentTypes by attribute, then remove', () {
      // no attribute that is not id
    });

    test('Sort commitmentTypes', () {
      // no id attribute
      // add compareTo method in the specific CommitmentType class
      /* 
      commitmentTypes.sort(); 
 
      //commitmentTypes.display(title: "Sort commitmentTypes"); 
      */
    });

    test('Order commitmentTypes', () {
      // no id attribute
      // add compareTo method in the specific CommitmentType class
      /* 
      var orderedCommitmentTypes = commitmentTypes.order(); 
      expect(orderedCommitmentTypes.isEmpty, isFalse); 
      expect(orderedCommitmentTypes.length, equals(commitmentTypes.length)); 
      expect(orderedCommitmentTypes.source?.isEmpty, isFalse); 
      expect(orderedCommitmentTypes.source?.length, equals(commitmentTypes.length)); 
      expect(orderedCommitmentTypes, isNot(same(commitmentTypes))); 
 
      //orderedCommitmentTypes.display(title: "Order commitmentTypes"); 
      */
    });

    test('Copy commitmentTypes', () {
      final copiedCommitmentTypes = commitmentTypes.copy();
      expect(copiedCommitmentTypes.isEmpty, isFalse);
      expect(copiedCommitmentTypes.length, equals(commitmentTypes.length));
      expect(copiedCommitmentTypes, isNot(same(commitmentTypes)));
      copiedCommitmentTypes.forEach(
          (e) => expect(e, equals(commitmentTypes.singleWhereOid(e.oid))));

      //copiedCommitmentTypes.display(title: "Copy commitmentTypes");
    });

    test('True for every commitmentType', () {
      // no required attribute that is not id
    });

    test('Random commitmentType', () {
      final commitmentType1 = projectModel.commitmentTypes.random();
      expect(commitmentType1, isNotNull);
      final commitmentType2 = projectModel.commitmentTypes.random();
      expect(commitmentType2, isNotNull);

      //commitmentType1.display(prefix: "random1");
      //commitmentType2.display(prefix: "random2");
    });

    test('Update commitmentType id with try', () {
      // no id attribute
    });

    test('Update commitmentType id without try', () {
      // no id attribute
    });

    test('Update commitmentType id with success', () {
      // no id attribute
    });

    test('Update commitmentType non id attribute with failure', () {
      // no attribute that is not id
    });

    test('Copy Equality', () {
      final randomCommitmentType = projectModel.commitmentTypes.random();
      randomCommitmentType.display(prefix: 'before copy: ');
      final randomCommitmentTypeCopy = randomCommitmentType.copy();
      randomCommitmentTypeCopy.display(prefix: 'after copy: ');
      expect(randomCommitmentType, equals(randomCommitmentTypeCopy));
      expect(randomCommitmentType.oid, equals(randomCommitmentTypeCopy.oid));
      expect(randomCommitmentType.code, equals(randomCommitmentTypeCopy.code));
    });

    test('commitmentType action undo and redo', () {
      var commitmentTypeCount = commitmentTypes.length;
      final commitmentType = CommitmentType(commitmentTypes.concept);
      commitmentTypes.add(commitmentType);
      expect(commitmentTypes.length, equals(++commitmentTypeCount));
      commitmentTypes.remove(commitmentType);
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      final action = AddCommand(session, commitmentTypes, commitmentType);
      action.doIt();
      expect(commitmentTypes.length, equals(++commitmentTypeCount));

      action.undo();
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      action.redo();
      expect(commitmentTypes.length, equals(++commitmentTypeCount));
    });

    test('commitmentType session undo and redo', () {
      var commitmentTypeCount = commitmentTypes.length;
      final commitmentType = CommitmentType(commitmentTypes.concept);
      commitmentTypes.add(commitmentType);
      expect(commitmentTypes.length, equals(++commitmentTypeCount));
      commitmentTypes.remove(commitmentType);
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      final action = AddCommand(session, commitmentTypes, commitmentType);
      action.doIt();
      expect(commitmentTypes.length, equals(++commitmentTypeCount));

      session.past.undo();
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      session.past.redo();
      expect(commitmentTypes.length, equals(++commitmentTypeCount));
    });

    test('CommitmentType update undo and redo', () {
      // no attribute that is not id
    });

    test('CommitmentType action with multiple undos and redos', () {
      var commitmentTypeCount = commitmentTypes.length;
      final commitmentType1 = projectModel.commitmentTypes.random();

      final action1 = RemoveCommand(session, commitmentTypes, commitmentType1);
      action1.doIt();
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      final commitmentType2 = projectModel.commitmentTypes.random();

      final action2 = RemoveCommand(session, commitmentTypes, commitmentType2);
      action2.doIt();
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      //session.past.display();

      session.past.undo();
      expect(commitmentTypes.length, equals(++commitmentTypeCount));

      session.past.undo();
      expect(commitmentTypes.length, equals(++commitmentTypeCount));

      //session.past.display();

      session.past.redo();
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      session.past.redo();
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      //session.past.display();
    });

    test('Transaction undo and redo', () {
      var commitmentTypeCount = commitmentTypes.length;
      final commitmentType1 = projectModel.commitmentTypes.random();
      var commitmentType2 = projectModel.commitmentTypes.random();
      while (commitmentType1 == commitmentType2) {
        commitmentType2 = projectModel.commitmentTypes.random();
      }
      final action1 = RemoveCommand(session, commitmentTypes, commitmentType1);
      final action2 = RemoveCommand(session, commitmentTypes, commitmentType2);

      final transaction =
          Transaction('two removes on commitmentTypes', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      commitmentTypeCount = commitmentTypeCount - 2;
      expect(commitmentTypes.length, equals(commitmentTypeCount));

      commitmentTypes.display(title: 'Transaction Done');

      session.past.undo();
      commitmentTypeCount = commitmentTypeCount + 2;
      expect(commitmentTypes.length, equals(commitmentTypeCount));

      commitmentTypes.display(title: 'Transaction Undone');

      session.past.redo();
      commitmentTypeCount = commitmentTypeCount - 2;
      expect(commitmentTypes.length, equals(commitmentTypeCount));

      commitmentTypes.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final commitmentTypeCount = commitmentTypes.length;
      final commitmentType1 = projectModel.commitmentTypes.random();
      final commitmentType2 = commitmentType1;
      final action1 = RemoveCommand(session, commitmentTypes, commitmentType1);
      final action2 = RemoveCommand(session, commitmentTypes, commitmentType2);

      final transaction = Transaction(
          'two removes on commitmentTypes, with an error on the second',
          session);
      transaction.add(action1);
      transaction.add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(commitmentTypes.length, equals(commitmentTypeCount));

      //commitmentTypes.display(title:"Transaction with an error");
    });

    test('Reactions to commitmentType actions', () {
      var commitmentTypeCount = commitmentTypes.length;

      final reaction = CommitmentTypeReaction();
      expect(reaction, isNotNull);

      focusDomain.startCommandReaction(reaction);
      final commitmentType = CommitmentType(commitmentTypes.concept);
      commitmentTypes.add(commitmentType);
      expect(commitmentTypes.length, equals(++commitmentTypeCount));
      commitmentTypes.remove(commitmentType);
      expect(commitmentTypes.length, equals(--commitmentTypeCount));

      final session = focusDomain.newSession();
      final addCommand = AddCommand(session, commitmentTypes, commitmentType);
      addCommand.doIt();
      expect(commitmentTypes.length, equals(++commitmentTypeCount));
      expect(reaction.reactedOnAdd, isTrue);

      // no attribute that is not id
    });
  });
}

class CommitmentTypeReaction implements ICommandReaction {
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
  final commitmentTypes = projectModel.commitmentTypes;
  testFocusProjectCommitmentTypes(focusDomain, projectModel, commitmentTypes);
}
