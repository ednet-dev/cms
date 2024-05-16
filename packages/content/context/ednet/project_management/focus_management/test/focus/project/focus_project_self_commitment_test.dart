 
// test/focus/project/focus_project_self_commitment_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:focus_project/focus_project.dart"; 
 
void testFocusProjectSelfCommitments( 
    FocusDomain focusDomain, ProjectModel projectModel, SelfCommitments selfCommitments) { 
  DomainSession session; 
  group("Testing Focus.Project.SelfCommitment", () { 
    session = focusDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(selfCommitments.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(selfCommitments.isEmpty, isTrue); 
      expect(selfCommitments.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("SelfCommitment"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("SelfCommitment"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("SelfCommitment"); 
      selfCommitments.clear(); 
      expect(selfCommitments.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(selfCommitments.isEmpty, isFalse); 
 
      selfCommitments.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add selfCommitment required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add selfCommitment unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found selfCommitment by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var selfCommitment = selfCommitments.singleWhereOid(ednetOid); 
      expect(selfCommitment, isNull); 
    }); 
 
    test("Find selfCommitment by oid", () { 
      var randomSelfCommitment = projectModel.selfCommitments.random(); 
      var selfCommitment = selfCommitments.singleWhereOid(randomSelfCommitment.oid); 
      expect(selfCommitment, isNotNull); 
      expect(selfCommitment, equals(randomSelfCommitment)); 
    }); 
 
    test("Find selfCommitment by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find selfCommitment by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find selfCommitment by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select selfCommitments by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select selfCommitments by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select selfCommitments by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select selfCommitments by attribute, then remove", () { 
      // no attribute that is not id 
    }); 
 
    test("Sort selfCommitments", () { 
      // no id attribute 
      // add compareTo method in the specific SelfCommitment class 
      /* 
      selfCommitments.sort(); 
 
      //selfCommitments.display(title: "Sort selfCommitments"); 
      */ 
    }); 
 
    test("Order selfCommitments", () { 
      // no id attribute 
      // add compareTo method in the specific SelfCommitment class 
      /* 
      var orderedSelfCommitments = selfCommitments.order(); 
      expect(orderedSelfCommitments.isEmpty, isFalse); 
      expect(orderedSelfCommitments.length, equals(selfCommitments.length)); 
      expect(orderedSelfCommitments.source?.isEmpty, isFalse); 
      expect(orderedSelfCommitments.source?.length, equals(selfCommitments.length)); 
      expect(orderedSelfCommitments, isNot(same(selfCommitments))); 
 
      //orderedSelfCommitments.display(title: "Order selfCommitments"); 
      */ 
    }); 
 
    test("Copy selfCommitments", () { 
      var copiedSelfCommitments = selfCommitments.copy(); 
      expect(copiedSelfCommitments.isEmpty, isFalse); 
      expect(copiedSelfCommitments.length, equals(selfCommitments.length)); 
      expect(copiedSelfCommitments, isNot(same(selfCommitments))); 
      copiedSelfCommitments.forEach((e) => 
        expect(e, equals(selfCommitments.singleWhereOid(e.oid)))); 
 
      //copiedSelfCommitments.display(title: "Copy selfCommitments"); 
    }); 
 
    test("True for every selfCommitment", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random selfCommitment", () { 
      var selfCommitment1 = projectModel.selfCommitments.random(); 
      expect(selfCommitment1, isNotNull); 
      var selfCommitment2 = projectModel.selfCommitments.random(); 
      expect(selfCommitment2, isNotNull); 
 
      //selfCommitment1.display(prefix: "random1"); 
      //selfCommitment2.display(prefix: "random2"); 
    }); 
 
    test("Update selfCommitment id with try", () { 
      // no id attribute 
    }); 
 
    test("Update selfCommitment id without try", () { 
      // no id attribute 
    }); 
 
    test("Update selfCommitment id with success", () { 
      // no id attribute 
    }); 
 
    test("Update selfCommitment non id attribute with failure", () { 
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomSelfCommitment = projectModel.selfCommitments.random(); 
      randomSelfCommitment.display(prefix:"before copy: "); 
      var randomSelfCommitmentCopy = randomSelfCommitment.copy(); 
      randomSelfCommitmentCopy.display(prefix:"after copy: "); 
      expect(randomSelfCommitment, equals(randomSelfCommitmentCopy)); 
      expect(randomSelfCommitment.oid, equals(randomSelfCommitmentCopy.oid)); 
      expect(randomSelfCommitment.code, equals(randomSelfCommitmentCopy.code)); 
 
    }); 
 
    test("selfCommitment action undo and redo", () { 
      var selfCommitmentCount = selfCommitments.length; 
      var selfCommitment = SelfCommitment(selfCommitments.concept); 
        selfCommitments.add(selfCommitment); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
      selfCommitments.remove(selfCommitment); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      var action = AddCommand(session, selfCommitments, selfCommitment); 
      action.doIt(); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
 
      action.undo(); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      action.redo(); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
    }); 
 
    test("selfCommitment session undo and redo", () { 
      var selfCommitmentCount = selfCommitments.length; 
      var selfCommitment = SelfCommitment(selfCommitments.concept); 
        selfCommitments.add(selfCommitment); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
      selfCommitments.remove(selfCommitment); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      var action = AddCommand(session, selfCommitments, selfCommitment); 
      action.doIt(); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
 
      session.past.undo(); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      session.past.redo(); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
    }); 
 
    test("SelfCommitment update undo and redo", () { 
      // no attribute that is not id 
    }); 
 
    test("SelfCommitment action with multiple undos and redos", () { 
      var selfCommitmentCount = selfCommitments.length; 
      var selfCommitment1 = projectModel.selfCommitments.random(); 
 
      var action1 = RemoveCommand(session, selfCommitments, selfCommitment1); 
      action1.doIt(); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      var selfCommitment2 = projectModel.selfCommitments.random(); 
 
      var action2 = RemoveCommand(session, selfCommitments, selfCommitment2); 
      action2.doIt(); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
 
      session.past.undo(); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      session.past.redo(); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var selfCommitmentCount = selfCommitments.length; 
      var selfCommitment1 = projectModel.selfCommitments.random(); 
      var selfCommitment2 = projectModel.selfCommitments.random(); 
      while (selfCommitment1 == selfCommitment2) { 
        selfCommitment2 = projectModel.selfCommitments.random();  
      } 
      var action1 = RemoveCommand(session, selfCommitments, selfCommitment1); 
      var action2 = RemoveCommand(session, selfCommitments, selfCommitment2); 
 
      var transaction = new Transaction("two removes on selfCommitments", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      selfCommitmentCount = selfCommitmentCount - 2; 
      expect(selfCommitments.length, equals(selfCommitmentCount)); 
 
      selfCommitments.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      selfCommitmentCount = selfCommitmentCount + 2; 
      expect(selfCommitments.length, equals(selfCommitmentCount)); 
 
      selfCommitments.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      selfCommitmentCount = selfCommitmentCount - 2; 
      expect(selfCommitments.length, equals(selfCommitmentCount)); 
 
      selfCommitments.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var selfCommitmentCount = selfCommitments.length; 
      var selfCommitment1 = projectModel.selfCommitments.random(); 
      var selfCommitment2 = selfCommitment1; 
      var action1 = RemoveCommand(session, selfCommitments, selfCommitment1); 
      var action2 = RemoveCommand(session, selfCommitments, selfCommitment2); 
 
      var transaction = Transaction( 
        "two removes on selfCommitments, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(selfCommitments.length, equals(selfCommitmentCount)); 
 
      //selfCommitments.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to selfCommitment actions", () { 
      var selfCommitmentCount = selfCommitments.length; 
 
      var reaction = SelfCommitmentReaction(); 
      expect(reaction, isNotNull); 
 
      focusDomain.startCommandReaction(reaction); 
      var selfCommitment = SelfCommitment(selfCommitments.concept); 
        selfCommitments.add(selfCommitment); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
      selfCommitments.remove(selfCommitment); 
      expect(selfCommitments.length, equals(--selfCommitmentCount)); 
 
      var session = focusDomain.newSession(); 
      var addCommand = AddCommand(session, selfCommitments, selfCommitment); 
      addCommand.doIt(); 
      expect(selfCommitments.length, equals(++selfCommitmentCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
    }); 
 
  }); 
} 
 
class SelfCommitmentReaction implements ICommandReaction { 
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
  var selfCommitments = projectModel.selfCommitments; 
  testFocusProjectSelfCommitments(focusDomain, projectModel, selfCommitments); 
} 
 
