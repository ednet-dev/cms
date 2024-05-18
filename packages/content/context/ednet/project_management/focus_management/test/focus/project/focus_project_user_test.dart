// test/focus/project/focus_project_user_test.dart

import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:focus_project/focus_project.dart';

void testFocusProjectUsers(
    FocusDomain focusDomain, ProjectModel projectModel, Users users) {
  DomainSession session;
  group('Testing Focus.Project.User', () {
    session = focusDomain.newSession();
    setUp(() {
      projectModel.init();
    });
    tearDown(() {
      projectModel.clear();
    });

    test('Not empty model', () {
      expect(projectModel.isEmpty, isFalse);
      expect(users.isEmpty, isFalse);
    });

    test('Empty model', () {
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      expect(users.isEmpty, isTrue);
      expect(users.exceptions.isEmpty, isTrue);
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
      final json = projectModel.fromEntryToJson('User');
      expect(json, isNotNull);

      print(json);
      //projectModel.displayEntryJson("User");
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model entry', () {
      final json = projectModel.fromEntryToJson('User');
      users.clear();
      expect(users.isEmpty, isTrue);
      projectModel.fromJsonToEntry(json);
      expect(users.isEmpty, isFalse);

      users.display(title: 'From JSON to model entry');
    });

    test('Add user required error', () {
      // no required attribute that is not id
    });

    test('Add user unique error', () {
      // no id attribute
    });

    test('Not found user by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final user = users.singleWhereOid(ednetOid);
      expect(user, isNull);
    });

    test('Find user by oid', () {
      final randomUser = projectModel.users.random();
      final user = users.singleWhereOid(randomUser.oid);
      expect(user, isNotNull);
      expect(user, equals(randomUser));
    });

    test('Find user by attribute id', () {
      // no id attribute
    });

    test('Find user by required attribute', () {
      // no required attribute that is not id
    });

    test('Find user by attribute', () {
      // no attribute that is not required
    });

    test('Select users by attribute', () {
      // no attribute that is not required
    });

    test('Select users by required attribute', () {
      // no required attribute that is not id
    });

    test('Select users by attribute, then add', () {
      // no attribute that is not id
    });

    test('Select users by attribute, then remove', () {
      // no attribute that is not id
    });

    test('Sort users', () {
      // no id attribute
      // add compareTo method in the specific User class
      /* 
      users.sort(); 
 
      //users.display(title: "Sort users"); 
      */
    });

    test('Order users', () {
      // no id attribute
      // add compareTo method in the specific User class
      /* 
      var orderedUsers = users.order(); 
      expect(orderedUsers.isEmpty, isFalse); 
      expect(orderedUsers.length, equals(users.length)); 
      expect(orderedUsers.source?.isEmpty, isFalse); 
      expect(orderedUsers.source?.length, equals(users.length)); 
      expect(orderedUsers, isNot(same(users))); 
 
      //orderedUsers.display(title: "Order users"); 
      */
    });

    test('Copy users', () {
      final copiedUsers = users.copy();
      expect(copiedUsers.isEmpty, isFalse);
      expect(copiedUsers.length, equals(users.length));
      expect(copiedUsers, isNot(same(users)));
      copiedUsers
          .forEach((e) => expect(e, equals(users.singleWhereOid(e.oid))));

      //copiedUsers.display(title: "Copy users");
    });

    test('True for every user', () {
      // no required attribute that is not id
    });

    test('Random user', () {
      final user1 = projectModel.users.random();
      expect(user1, isNotNull);
      final user2 = projectModel.users.random();
      expect(user2, isNotNull);

      //user1.display(prefix: "random1");
      //user2.display(prefix: "random2");
    });

    test('Update user id with try', () {
      // no id attribute
    });

    test('Update user id without try', () {
      // no id attribute
    });

    test('Update user id with success', () {
      // no id attribute
    });

    test('Update user non id attribute with failure', () {
      // no attribute that is not id
    });

    test('Copy Equality', () {
      final randomUser = projectModel.users.random();
      randomUser.display(prefix: 'before copy: ');
      final randomUserCopy = randomUser.copy();
      randomUserCopy.display(prefix: 'after copy: ');
      expect(randomUser, equals(randomUserCopy));
      expect(randomUser.oid, equals(randomUserCopy.oid));
      expect(randomUser.code, equals(randomUserCopy.code));
    });

    test('user action undo and redo', () {
      var userCount = users.length;
      final user = User(users.concept);
      users.add(user);
      expect(users.length, equals(++userCount));
      users.remove(user);
      expect(users.length, equals(--userCount));

      final action = AddCommand(session, users, user);
      action.doIt();
      expect(users.length, equals(++userCount));

      action.undo();
      expect(users.length, equals(--userCount));

      action.redo();
      expect(users.length, equals(++userCount));
    });

    test('user session undo and redo', () {
      var userCount = users.length;
      final user = User(users.concept);
      users.add(user);
      expect(users.length, equals(++userCount));
      users.remove(user);
      expect(users.length, equals(--userCount));

      final action = AddCommand(session, users, user);
      action.doIt();
      expect(users.length, equals(++userCount));

      session.past.undo();
      expect(users.length, equals(--userCount));

      session.past.redo();
      expect(users.length, equals(++userCount));
    });

    test('User update undo and redo', () {
      // no attribute that is not id
    });

    test('User action with multiple undos and redos', () {
      var userCount = users.length;
      final user1 = projectModel.users.random();

      final action1 = RemoveCommand(session, users, user1);
      action1.doIt();
      expect(users.length, equals(--userCount));

      final user2 = projectModel.users.random();

      final action2 = RemoveCommand(session, users, user2);
      action2.doIt();
      expect(users.length, equals(--userCount));

      //session.past.display();

      session.past.undo();
      expect(users.length, equals(++userCount));

      session.past.undo();
      expect(users.length, equals(++userCount));

      //session.past.display();

      session.past.redo();
      expect(users.length, equals(--userCount));

      session.past.redo();
      expect(users.length, equals(--userCount));

      //session.past.display();
    });

    test('Transaction undo and redo', () {
      var userCount = users.length;
      final user1 = projectModel.users.random();
      var user2 = projectModel.users.random();
      while (user1 == user2) {
        user2 = projectModel.users.random();
      }
      final action1 = RemoveCommand(session, users, user1);
      final action2 = RemoveCommand(session, users, user2);

      final transaction = Transaction('two removes on users', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      userCount = userCount - 2;
      expect(users.length, equals(userCount));

      users.display(title: 'Transaction Done');

      session.past.undo();
      userCount = userCount + 2;
      expect(users.length, equals(userCount));

      users.display(title: 'Transaction Undone');

      session.past.redo();
      userCount = userCount - 2;
      expect(users.length, equals(userCount));

      users.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final userCount = users.length;
      final user1 = projectModel.users.random();
      final user2 = user1;
      final action1 = RemoveCommand(session, users, user1);
      final action2 = RemoveCommand(session, users, user2);

      final transaction = Transaction(
          'two removes on users, with an error on the second', session);
      transaction.add(action1);
      transaction.add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(users.length, equals(userCount));

      //users.display(title:"Transaction with an error");
    });

    test('Reactions to user actions', () {
      var userCount = users.length;

      final reaction = UserReaction();
      expect(reaction, isNotNull);

      focusDomain.startCommandReaction(reaction);
      final user = User(users.concept);
      users.add(user);
      expect(users.length, equals(++userCount));
      users.remove(user);
      expect(users.length, equals(--userCount));

      final session = focusDomain.newSession();
      final addCommand = AddCommand(session, users, user);
      addCommand.doIt();
      expect(users.length, equals(++userCount));
      expect(reaction.reactedOnAdd, isTrue);

      // no attribute that is not id
    });
  });
}

class UserReaction implements ICommandReaction {
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
  final users = projectModel.users;
  testFocusProjectUsers(focusDomain, projectModel, users);
}
