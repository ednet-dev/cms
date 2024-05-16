 
// test/focus/project/focus_project_proffesional_commitment_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:focus_project/focus_project.dart"; 
 
void testFocusProjectProffesionalCommitments( 
    FocusDomain focusDomain, ProjectModel projectModel, ProffesionalCommitments proffesionalCommitments) { 
  DomainSession session; 
  group("Testing Focus.Project.ProffesionalCommitment", () { 
    session = focusDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(proffesionalCommitments.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(proffesionalCommitments.isEmpty, isTrue); 
      expect(proffesionalCommitments.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("ProffesionalCommitment"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("ProffesionalCommitment"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("ProffesionalCommitment"); 
      proffesionalCommitments.clear(); 
      expect(proffesionalCommitments.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(proffesionalCommitments.isEmpty, isFalse); 
 
      proffesionalCommitments.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add proffesionalCommitment required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add proffesionalCommitment unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found proffesionalCommitment by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var proffesionalCommitment = proffesionalCommitments.singleWhereOid(ednetOid); 
      expect(proffesionalCommitment, isNull); 
    }); 
 
    test("Find proffesionalCommitment by oid", () { 
      var randomProffesionalCommitment = projectModel.proffesionalCommitments.random(); 
      var proffesionalCommitment = proffesionalCommitments.singleWhereOid(randomProffesionalCommitment.oid); 
      expect(proffesionalCommitment, isNotNull); 
      expect(proffesionalCommitment, equals(randomProffesionalCommitment)); 
    }); 
 
    test("Find proffesionalCommitment by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find proffesionalCommitment by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find proffesionalCommitment by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select proffesionalCommitments by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select proffesionalCommitments by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select proffesionalCommitments by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select proffesionalCommitments by attribute, then remove", () { 
      // no attribute that is not id 
    }); 
 
    test("Sort proffesionalCommitments", () { 
      // no id attribute 
      // add compareTo method in the specific ProffesionalCommitment class 
      /* 
      proffesionalCommitments.sort(); 
 
      //proffesionalCommitments.display(title: "Sort proffesionalCommitments"); 
      */ 
    }); 
 
    test("Order proffesionalCommitments", () { 
      // no id attribute 
      // add compareTo method in the specific ProffesionalCommitment class 
      /* 
      var orderedProffesionalCommitments = proffesionalCommitments.order(); 
      expect(orderedProffesionalCommitments.isEmpty, isFalse); 
      expect(orderedProffesionalCommitments.length, equals(proffesionalCommitments.length)); 
      expect(orderedProffesionalCommitments.source?.isEmpty, isFalse); 
      expect(orderedProffesionalCommitments.source?.length, equals(proffesionalCommitments.length)); 
      expect(orderedProffesionalCommitments, isNot(same(proffesionalCommitments))); 
 
      //orderedProffesionalCommitments.display(title: "Order proffesionalCommitments"); 
      */ 
    }); 
 
    test("Copy proffesionalCommitments", () { 
      var copiedProffesionalCommitments = proffesionalCommitments.copy(); 
      expect(copiedProffesionalCommitments.isEmpty, isFalse); 
      expect(copiedProffesionalCommitments.length, equals(proffesionalCommitments.length)); 
      expect(copiedProffesionalCommitments, isNot(same(proffesionalCommitments))); 
      copiedProffesionalCommitments.forEach((e) => 
        expect(e, equals(proffesionalCommitments.singleWhereOid(e.oid)))); 
 
      //copiedProffesionalCommitments.display(title: "Copy proffesionalCommitments"); 
    }); 
 
    test("True for every proffesionalCommitment", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random proffesionalCommitment", () { 
      var proffesionalCommitment1 = projectModel.proffesionalCommitments.random(); 
      expect(proffesionalCommitment1, isNotNull); 
      var proffesionalCommitment2 = projectModel.proffesionalCommitments.random(); 
      expect(proffesionalCommitment2, isNotNull); 
 
      //proffesionalCommitment1.display(prefix: "random1"); 
      //proffesionalCommitment2.display(prefix: "random2"); 
    }); 
 
    test("Update proffesionalCommitment id with try", () { 
      // no id attribute 
    }); 
 
    test("Update proffesionalCommitment id without try", () { 
      // no id attribute 
    }); 
 
    test("Update proffesionalCommitment id with success", () { 
      // no id attribute 
    }); 
 
    test("Update proffesionalCommitment non id attribute with failure", () { 
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomProffesionalCommitment = projectModel.proffesionalCommitments.random(); 
      randomProffesionalCommitment.display(prefix:"before copy: "); 
      var randomProffesionalCommitmentCopy = randomProffesionalCommitment.copy(); 
      randomProffesionalCommitmentCopy.display(prefix:"after copy: "); 
      expect(randomProffesionalCommitment, equals(randomProffesionalCommitmentCopy)); 
      expect(randomProffesionalCommitment.oid, equals(randomProffesionalCommitmentCopy.oid)); 
      expect(randomProffesionalCommitment.code, equals(randomProffesionalCommitmentCopy.code)); 
 
    }); 
 
    test("proffesionalCommitment action undo and redo", () { 
      var proffesionalCommitmentCount = proffesionalCommitments.length; 
      var proffesionalCommitment = ProffesionalCommitment(proffesionalCommitments.concept); 
        proffesionalCommitments.add(proffesionalCommitment); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
      proffesionalCommitments.remove(proffesionalCommitment); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      var action = AddCommand(session, proffesionalCommitments, proffesionalCommitment); 
      action.doIt(); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
 
      action.undo(); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      action.redo(); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
    }); 
 
    test("proffesionalCommitment session undo and redo", () { 
      var proffesionalCommitmentCount = proffesionalCommitments.length; 
      var proffesionalCommitment = ProffesionalCommitment(proffesionalCommitments.concept); 
        proffesionalCommitments.add(proffesionalCommitment); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
      proffesionalCommitments.remove(proffesionalCommitment); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      var action = AddCommand(session, proffesionalCommitments, proffesionalCommitment); 
      action.doIt(); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
 
      session.past.undo(); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      session.past.redo(); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
    }); 
 
    test("ProffesionalCommitment update undo and redo", () { 
      // no attribute that is not id 
    }); 
 
    test("ProffesionalCommitment action with multiple undos and redos", () { 
      var proffesionalCommitmentCount = proffesionalCommitments.length; 
      var proffesionalCommitment1 = projectModel.proffesionalCommitments.random(); 
 
      var action1 = RemoveCommand(session, proffesionalCommitments, proffesionalCommitment1); 
      action1.doIt(); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      var proffesionalCommitment2 = projectModel.proffesionalCommitments.random(); 
 
      var action2 = RemoveCommand(session, proffesionalCommitments, proffesionalCommitment2); 
      action2.doIt(); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
 
      session.past.undo(); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      session.past.redo(); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var proffesionalCommitmentCount = proffesionalCommitments.length; 
      var proffesionalCommitment1 = projectModel.proffesionalCommitments.random(); 
      var proffesionalCommitment2 = projectModel.proffesionalCommitments.random(); 
      while (proffesionalCommitment1 == proffesionalCommitment2) { 
        proffesionalCommitment2 = projectModel.proffesionalCommitments.random();  
      } 
      var action1 = RemoveCommand(session, proffesionalCommitments, proffesionalCommitment1); 
      var action2 = RemoveCommand(session, proffesionalCommitments, proffesionalCommitment2); 
 
      var transaction = new Transaction("two removes on proffesionalCommitments", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      proffesionalCommitmentCount = proffesionalCommitmentCount - 2; 
      expect(proffesionalCommitments.length, equals(proffesionalCommitmentCount)); 
 
      proffesionalCommitments.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      proffesionalCommitmentCount = proffesionalCommitmentCount + 2; 
      expect(proffesionalCommitments.length, equals(proffesionalCommitmentCount)); 
 
      proffesionalCommitments.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      proffesionalCommitmentCount = proffesionalCommitmentCount - 2; 
      expect(proffesionalCommitments.length, equals(proffesionalCommitmentCount)); 
 
      proffesionalCommitments.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var proffesionalCommitmentCount = proffesionalCommitments.length; 
      var proffesionalCommitment1 = projectModel.proffesionalCommitments.random(); 
      var proffesionalCommitment2 = proffesionalCommitment1; 
      var action1 = RemoveCommand(session, proffesionalCommitments, proffesionalCommitment1); 
      var action2 = RemoveCommand(session, proffesionalCommitments, proffesionalCommitment2); 
 
      var transaction = Transaction( 
        "two removes on proffesionalCommitments, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(proffesionalCommitments.length, equals(proffesionalCommitmentCount)); 
 
      //proffesionalCommitments.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to proffesionalCommitment actions", () { 
      var proffesionalCommitmentCount = proffesionalCommitments.length; 
 
      var reaction = ProffesionalCommitmentReaction(); 
      expect(reaction, isNotNull); 
 
      focusDomain.startCommandReaction(reaction); 
      var proffesionalCommitment = ProffesionalCommitment(proffesionalCommitments.concept); 
        proffesionalCommitments.add(proffesionalCommitment); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
      proffesionalCommitments.remove(proffesionalCommitment); 
      expect(proffesionalCommitments.length, equals(--proffesionalCommitmentCount)); 
 
      var session = focusDomain.newSession(); 
      var addCommand = AddCommand(session, proffesionalCommitments, proffesionalCommitment); 
      addCommand.doIt(); 
      expect(proffesionalCommitments.length, equals(++proffesionalCommitmentCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
    }); 
 
  }); 
} 
 
class ProffesionalCommitmentReaction implements ICommandReaction { 
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
  var proffesionalCommitments = projectModel.proffesionalCommitments; 
  testFocusProjectProffesionalCommitments(focusDomain, projectModel, proffesionalCommitments); 
} 
 
