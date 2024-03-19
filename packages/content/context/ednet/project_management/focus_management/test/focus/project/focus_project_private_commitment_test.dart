 
// test/focus/project/focus_project_private_commitment_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:focus_project/focus_project.dart"; 
 
void testFocusProjectPrivateCommitments( 
    FocusDomain focusDomain, ProjectModel projectModel, PrivateCommitments privateCommitments) { 
  DomainSession session; 
  group("Testing Focus.Project.PrivateCommitment", () { 
    session = focusDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(privateCommitments.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(privateCommitments.isEmpty, isTrue); 
      expect(privateCommitments.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = projectModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = projectModel.toJson(); 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      projectModel.fromJson(json); 
      expect(projectModel.isEmpty, isFalse); 
 
      projectModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = projectModel.fromEntryToJson("PrivateCommitment"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("PrivateCommitment"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("PrivateCommitment"); 
      privateCommitments.clear(); 
      expect(privateCommitments.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(privateCommitments.isEmpty, isFalse); 
 
      privateCommitments.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add privateCommitment required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add privateCommitment unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found privateCommitment by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var privateCommitment = privateCommitments.singleWhereOid(ednetOid); 
      expect(privateCommitment, isNull); 
    }); 
 
    test("Find privateCommitment by oid", () { 
      var randomPrivateCommitment = projectModel.privateCommitments.random(); 
      var privateCommitment = privateCommitments.singleWhereOid(randomPrivateCommitment.oid); 
      expect(privateCommitment, isNotNull); 
      expect(privateCommitment, equals(randomPrivateCommitment)); 
    }); 
 
    test("Find privateCommitment by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find privateCommitment by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find privateCommitment by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select privateCommitments by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select privateCommitments by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select privateCommitments by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select privateCommitments by attribute, then remove", () { 
      // no attribute that is not id 
    }); 
 
    test("Sort privateCommitments", () { 
      // no id attribute 
      // add compareTo method in the specific PrivateCommitment class 
      /* 
      privateCommitments.sort(); 
 
      //privateCommitments.display(title: "Sort privateCommitments"); 
      */ 
    }); 
 
    test("Order privateCommitments", () { 
      // no id attribute 
      // add compareTo method in the specific PrivateCommitment class 
      /* 
      var orderedPrivateCommitments = privateCommitments.order(); 
      expect(orderedPrivateCommitments.isEmpty, isFalse); 
      expect(orderedPrivateCommitments.length, equals(privateCommitments.length)); 
      expect(orderedPrivateCommitments.source?.isEmpty, isFalse); 
      expect(orderedPrivateCommitments.source?.length, equals(privateCommitments.length)); 
      expect(orderedPrivateCommitments, isNot(same(privateCommitments))); 
 
      //orderedPrivateCommitments.display(title: "Order privateCommitments"); 
      */ 
    }); 
 
    test("Copy privateCommitments", () { 
      var copiedPrivateCommitments = privateCommitments.copy(); 
      expect(copiedPrivateCommitments.isEmpty, isFalse); 
      expect(copiedPrivateCommitments.length, equals(privateCommitments.length)); 
      expect(copiedPrivateCommitments, isNot(same(privateCommitments))); 
      copiedPrivateCommitments.forEach((e) => 
        expect(e, equals(privateCommitments.singleWhereOid(e.oid)))); 
 
      //copiedPrivateCommitments.display(title: "Copy privateCommitments"); 
    }); 
 
    test("True for every privateCommitment", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random privateCommitment", () { 
      var privateCommitment1 = projectModel.privateCommitments.random(); 
      expect(privateCommitment1, isNotNull); 
      var privateCommitment2 = projectModel.privateCommitments.random(); 
      expect(privateCommitment2, isNotNull); 
 
      //privateCommitment1.display(prefix: "random1"); 
      //privateCommitment2.display(prefix: "random2"); 
    }); 
 
    test("Update privateCommitment id with try", () { 
      // no id attribute 
    }); 
 
    test("Update privateCommitment id without try", () { 
      // no id attribute 
    }); 
 
    test("Update privateCommitment id with success", () { 
      // no id attribute 
    }); 
 
    test("Update privateCommitment non id attribute with failure", () { 
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomPrivateCommitment = projectModel.privateCommitments.random(); 
      randomPrivateCommitment.display(prefix:"before copy: "); 
      var randomPrivateCommitmentCopy = randomPrivateCommitment.copy(); 
      randomPrivateCommitmentCopy.display(prefix:"after copy: "); 
      expect(randomPrivateCommitment, equals(randomPrivateCommitmentCopy)); 
      expect(randomPrivateCommitment.oid, equals(randomPrivateCommitmentCopy.oid)); 
      expect(randomPrivateCommitment.code, equals(randomPrivateCommitmentCopy.code)); 
 
    }); 
 
    test("privateCommitment action undo and redo", () { 
      var privateCommitmentCount = privateCommitments.length; 
      var privateCommitment = PrivateCommitment(privateCommitments.concept); 
        privateCommitments.add(privateCommitment); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
      privateCommitments.remove(privateCommitment); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      var action = AddCommand(session, privateCommitments, privateCommitment); 
      action.doIt(); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
 
      action.undo(); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      action.redo(); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
    }); 
 
    test("privateCommitment session undo and redo", () { 
      var privateCommitmentCount = privateCommitments.length; 
      var privateCommitment = PrivateCommitment(privateCommitments.concept); 
        privateCommitments.add(privateCommitment); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
      privateCommitments.remove(privateCommitment); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      var action = AddCommand(session, privateCommitments, privateCommitment); 
      action.doIt(); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
 
      session.past.undo(); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      session.past.redo(); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
    }); 
 
    test("PrivateCommitment update undo and redo", () { 
      // no attribute that is not id 
    }); 
 
    test("PrivateCommitment action with multiple undos and redos", () { 
      var privateCommitmentCount = privateCommitments.length; 
      var privateCommitment1 = projectModel.privateCommitments.random(); 
 
      var action1 = RemoveCommand(session, privateCommitments, privateCommitment1); 
      action1.doIt(); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      var privateCommitment2 = projectModel.privateCommitments.random(); 
 
      var action2 = RemoveCommand(session, privateCommitments, privateCommitment2); 
      action2.doIt(); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
 
      session.past.undo(); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      session.past.redo(); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var privateCommitmentCount = privateCommitments.length; 
      var privateCommitment1 = projectModel.privateCommitments.random(); 
      var privateCommitment2 = projectModel.privateCommitments.random(); 
      while (privateCommitment1 == privateCommitment2) { 
        privateCommitment2 = projectModel.privateCommitments.random();  
      } 
      var action1 = RemoveCommand(session, privateCommitments, privateCommitment1); 
      var action2 = RemoveCommand(session, privateCommitments, privateCommitment2); 
 
      var transaction = new Transaction("two removes on privateCommitments", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      privateCommitmentCount = privateCommitmentCount - 2; 
      expect(privateCommitments.length, equals(privateCommitmentCount)); 
 
      privateCommitments.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      privateCommitmentCount = privateCommitmentCount + 2; 
      expect(privateCommitments.length, equals(privateCommitmentCount)); 
 
      privateCommitments.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      privateCommitmentCount = privateCommitmentCount - 2; 
      expect(privateCommitments.length, equals(privateCommitmentCount)); 
 
      privateCommitments.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var privateCommitmentCount = privateCommitments.length; 
      var privateCommitment1 = projectModel.privateCommitments.random(); 
      var privateCommitment2 = privateCommitment1; 
      var action1 = RemoveCommand(session, privateCommitments, privateCommitment1); 
      var action2 = RemoveCommand(session, privateCommitments, privateCommitment2); 
 
      var transaction = Transaction( 
        "two removes on privateCommitments, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(privateCommitments.length, equals(privateCommitmentCount)); 
 
      //privateCommitments.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to privateCommitment actions", () { 
      var privateCommitmentCount = privateCommitments.length; 
 
      var reaction = PrivateCommitmentReaction(); 
      expect(reaction, isNotNull); 
 
      focusDomain.startCommandReaction(reaction); 
      var privateCommitment = PrivateCommitment(privateCommitments.concept); 
        privateCommitments.add(privateCommitment); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
      privateCommitments.remove(privateCommitment); 
      expect(privateCommitments.length, equals(--privateCommitmentCount)); 
 
      var session = focusDomain.newSession(); 
      var addCommand = AddCommand(session, privateCommitments, privateCommitment); 
      addCommand.doIt(); 
      expect(privateCommitments.length, equals(++privateCommitmentCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
    }); 
 
  }); 
} 
 
class PrivateCommitmentReaction implements ICommandReaction { 
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
  var repository = Repository(); 
  FocusDomain focusDomain = repository.getDomainModels("Focus") as FocusDomain;   
  assert(focusDomain != null); 
  ProjectModel projectModel = focusDomain.getModelEntries("Project") as ProjectModel;  
  assert(projectModel != null); 
  var privateCommitments = projectModel.privateCommitments; 
  testFocusProjectPrivateCommitments(focusDomain, projectModel, privateCommitments); 
} 
 
