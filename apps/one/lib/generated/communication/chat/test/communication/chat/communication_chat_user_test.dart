 
// test/communication/chat/communication_chat_user_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:communication_chat/communication_chat.dart"; 
 
void testCommunicationChatUsers( 
    CommunicationDomain communicationDomain, ChatModel chatModel, Users users) { 
  DomainSession session; 
  group("Testing Communication.Chat.User", () { 
    session = communicationDomain.newSession();  
    setUp(() { 
      chatModel.init(); 
    }); 
    tearDown(() { 
      chatModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(chatModel.isEmpty, isFalse); 
      expect(users.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      chatModel.clear(); 
      expect(chatModel.isEmpty, isTrue); 
      expect(users.isEmpty, isTrue); 
      expect(users.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = chatModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //chatModel.displayJson(); 
      //chatModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = chatModel.toJson(); 
      chatModel.clear(); 
      expect(chatModel.isEmpty, isTrue); 
      chatModel.fromJson(json); 
      expect(chatModel.isEmpty, isFalse); 
 
      chatModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = chatModel.fromEntryToJson("User"); 
      expect(json, isNotNull); 
 
      print(json); 
      //chatModel.displayEntryJson("User"); 
      //chatModel.displayJson(); 
      //chatModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = chatModel.fromEntryToJson("User"); 
      users.clear(); 
      expect(users.isEmpty, isTrue); 
      chatModel.fromJsonToEntry(json); 
      expect(users.isEmpty, isFalse); 
 
      users.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add user required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add user unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found user by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var user = users.singleWhereOid(ednetOid); 
      expect(user, isNull); 
    }); 
 
    test("Find user by oid", () { 
      var randomUser = chatModel.users.random(); 
      var user = users.singleWhereOid(randomUser.oid); 
      expect(user, isNotNull); 
      expect(user, equals(randomUser)); 
    }); 
 
    test("Find user by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find user by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find user by attribute", () { 
      var randomUser = chatModel.users.random(); 
      var user = 
          users.firstWhereAttribute("name", randomUser.name); 
      expect(user, isNotNull); 
      expect(user.name, equals(randomUser.name)); 
    }); 
 
    test("Select users by attribute", () { 
      var randomUser = chatModel.users.random(); 
      var selectedUsers = 
          users.selectWhereAttribute("name", randomUser.name); 
      expect(selectedUsers.isEmpty, isFalse); 
      selectedUsers.forEach((se) => 
          expect(se.name, equals(randomUser.name))); 
 
      //selectedUsers.display(title: "Select users by name"); 
    }); 
 
    test("Select users by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select users by attribute, then add", () { 
      var randomUser = chatModel.users.random(); 
      var selectedUsers = 
          users.selectWhereAttribute("name", randomUser.name); 
      expect(selectedUsers.isEmpty, isFalse); 
      expect(selectedUsers.source?.isEmpty, isFalse); 
      var usersCount = users.length; 
 
      var user = User(users.concept); 
      user.name = 'ocean'; 
      user.email = 'umbrella'; 
      var added = selectedUsers.add(user); 
      expect(added, isTrue); 
      expect(users.length, equals(++usersCount)); 
 
      //selectedUsers.display(title: 
      //  "Select users by attribute, then add"); 
      //users.display(title: "All users"); 
    }); 
 
    test("Select users by attribute, then remove", () { 
      var randomUser = chatModel.users.random(); 
      var selectedUsers = 
          users.selectWhereAttribute("name", randomUser.name); 
      expect(selectedUsers.isEmpty, isFalse); 
      expect(selectedUsers.source?.isEmpty, isFalse); 
      var usersCount = users.length; 
 
      var removed = selectedUsers.remove(randomUser); 
      expect(removed, isTrue); 
      expect(users.length, equals(--usersCount)); 
 
      randomUser.display(prefix: "removed"); 
      //selectedUsers.display(title: 
      //  "Select users by attribute, then remove"); 
      //users.display(title: "All users"); 
    }); 
 
    test("Sort users", () { 
      // no id attribute 
      // add compareTo method in the specific User class 
      /* 
      users.sort(); 
 
      //users.display(title: "Sort users"); 
      */ 
    }); 
 
    test("Order users", () { 
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
 
    test("Copy users", () { 
      var copiedUsers = users.copy(); 
      expect(copiedUsers.isEmpty, isFalse); 
      expect(copiedUsers.length, equals(users.length)); 
      expect(copiedUsers, isNot(same(users))); 
      copiedUsers.forEach((e) => 
        expect(e, equals(users.singleWhereOid(e.oid)))); 
 
      //copiedUsers.display(title: "Copy users"); 
    }); 
 
    test("True for every user", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random user", () { 
      var user1 = chatModel.users.random(); 
      expect(user1, isNotNull); 
      var user2 = chatModel.users.random(); 
      expect(user2, isNotNull); 
 
      //user1.display(prefix: "random1"); 
      //user2.display(prefix: "random2"); 
    }); 
 
    test("Update user id with try", () { 
      // no id attribute 
    }); 
 
    test("Update user id without try", () { 
      // no id attribute 
    }); 
 
    test("Update user id with success", () { 
      // no id attribute 
    }); 
 
    test("Update user non id attribute with failure", () { 
      var randomUser = chatModel.users.random(); 
      var afterUpdateEntity = randomUser.copy(); 
      afterUpdateEntity.name = 'performance'; 
      expect(afterUpdateEntity.name, equals('performance')); 
      // users.update can only be used if oid, code or id is set. 
      expect(() => users.update(randomUser, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomUser = chatModel.users.random(); 
      randomUser.display(prefix:"before copy: "); 
      var randomUserCopy = randomUser.copy(); 
      randomUserCopy.display(prefix:"after copy: "); 
      expect(randomUser, equals(randomUserCopy)); 
      expect(randomUser.oid, equals(randomUserCopy.oid)); 
      expect(randomUser.code, equals(randomUserCopy.code)); 
      expect(randomUser.name, equals(randomUserCopy.name)); 
      expect(randomUser.email, equals(randomUserCopy.email)); 
 
    }); 
 
    test("user action undo and redo", () { 
      var userCount = users.length; 
      var user = User(users.concept); 
        user.name = 'top'; 
      user.email = 'tree'; 
      users.add(user); 
      expect(users.length, equals(++userCount)); 
      users.remove(user); 
      expect(users.length, equals(--userCount)); 
 
      var action = AddCommand(session, users, user); 
      action.doIt(); 
      expect(users.length, equals(++userCount)); 
 
      action.undo(); 
      expect(users.length, equals(--userCount)); 
 
      action.redo(); 
      expect(users.length, equals(++userCount)); 
    }); 
 
    test("user session undo and redo", () { 
      var userCount = users.length; 
      var user = User(users.concept); 
        user.name = 'hell'; 
      user.email = 'secretary'; 
      users.add(user); 
      expect(users.length, equals(++userCount)); 
      users.remove(user); 
      expect(users.length, equals(--userCount)); 
 
      var action = AddCommand(session, users, user); 
      action.doIt(); 
      expect(users.length, equals(++userCount)); 
 
      session.past.undo(); 
      expect(users.length, equals(--userCount)); 
 
      session.past.redo(); 
      expect(users.length, equals(++userCount)); 
    }); 
 
    test("User update undo and redo", () { 
      var user = chatModel.users.random(); 
      var action = SetAttributeCommand(session, user, "name", 'life'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(user.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(user.name, equals(action.after)); 
    }); 
 
    test("User action with multiple undos and redos", () { 
      var userCount = users.length; 
      var user1 = chatModel.users.random(); 
 
      var action1 = RemoveCommand(session, users, user1); 
      action1.doIt(); 
      expect(users.length, equals(--userCount)); 
 
      var user2 = chatModel.users.random(); 
 
      var action2 = RemoveCommand(session, users, user2); 
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
 
    test("Transaction undo and redo", () { 
      var userCount = users.length; 
      var user1 = chatModel.users.random(); 
      var user2 = chatModel.users.random(); 
      while (user1 == user2) { 
        user2 = chatModel.users.random();  
      } 
      var action1 = RemoveCommand(session, users, user1); 
      var action2 = RemoveCommand(session, users, user2); 
 
      var transaction = new Transaction("two removes on users", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      userCount = userCount - 2; 
      expect(users.length, equals(userCount)); 
 
      users.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      userCount = userCount + 2; 
      expect(users.length, equals(userCount)); 
 
      users.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      userCount = userCount - 2; 
      expect(users.length, equals(userCount)); 
 
      users.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var userCount = users.length; 
      var user1 = chatModel.users.random(); 
      var user2 = user1; 
      var action1 = RemoveCommand(session, users, user1); 
      var action2 = RemoveCommand(session, users, user2); 
 
      var transaction = Transaction( 
        "two removes on users, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(users.length, equals(userCount)); 
 
      //users.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to user actions", () { 
      var userCount = users.length; 
 
      var reaction = UserReaction(); 
      expect(reaction, isNotNull); 
 
      communicationDomain.startCommandReaction(reaction); 
      var user = User(users.concept); 
        user.name = 'winter'; 
      user.email = 'organization'; 
      users.add(user); 
      expect(users.length, equals(++userCount)); 
      users.remove(user); 
      expect(users.length, equals(--userCount)); 
 
      var session = communicationDomain.newSession(); 
      var addCommand = AddCommand(session, users, user); 
      addCommand.doIt(); 
      expect(users.length, equals(++userCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, user, "name", 'call'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      communicationDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class UserReaction implements ICommandReaction { 
  bool reactedOnAdd    = false; 
  bool reactedOnUpdate = false; 
 
  void react(ICommand action) { 
    if (action is IEntitiesCommand) { 
      reactedOnAdd = true; 
    } else if (action is IEntityCommand) { 
      reactedOnUpdate = true; 
    } 
  } 
} 
 
void main() { 
  var repository = CommunicationChatRepo(); 
  CommunicationDomain communicationDomain = repository.getDomainModels("Communication") as CommunicationDomain;   
  assert(communicationDomain != null); 
  ChatModel chatModel = communicationDomain.getModelEntries("Chat") as ChatModel;  
  assert(chatModel != null); 
  var users = chatModel.users; 
  testCommunicationChatUsers(communicationDomain, chatModel, users); 
} 
 
