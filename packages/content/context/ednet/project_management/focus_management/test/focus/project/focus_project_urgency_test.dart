 
// test/focus/project/focus_project_urgency_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:focus_project/focus_project.dart"; 
 
void testFocusProjectUrgencies( 
    FocusDomain focusDomain, ProjectModel projectModel, Urgencies urgencies) { 
  DomainSession session; 
  group("Testing Focus.Project.Urgency", () { 
    session = focusDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(urgencies.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(urgencies.isEmpty, isTrue); 
      expect(urgencies.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("Urgency"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("Urgency"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("Urgency"); 
      urgencies.clear(); 
      expect(urgencies.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(urgencies.isEmpty, isFalse); 
 
      urgencies.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add urgency required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add urgency unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found urgency by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var urgency = urgencies.singleWhereOid(ednetOid); 
      expect(urgency, isNull); 
    }); 
 
    test("Find urgency by oid", () { 
      var randomUrgency = projectModel.urgencies.random(); 
      var urgency = urgencies.singleWhereOid(randomUrgency.oid); 
      expect(urgency, isNotNull); 
      expect(urgency, equals(randomUrgency)); 
    }); 
 
    test("Find urgency by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find urgency by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find urgency by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select urgencies by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select urgencies by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select urgencies by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select urgencies by attribute, then remove", () { 
      // no attribute that is not id 
    }); 
 
    test("Sort urgencies", () { 
      // no id attribute 
      // add compareTo method in the specific Urgency class 
      /* 
      urgencies.sort(); 
 
      //urgencies.display(title: "Sort urgencies"); 
      */ 
    }); 
 
    test("Order urgencies", () { 
      // no id attribute 
      // add compareTo method in the specific Urgency class 
      /* 
      var orderedUrgencies = urgencies.order(); 
      expect(orderedUrgencies.isEmpty, isFalse); 
      expect(orderedUrgencies.length, equals(urgencies.length)); 
      expect(orderedUrgencies.source?.isEmpty, isFalse); 
      expect(orderedUrgencies.source?.length, equals(urgencies.length)); 
      expect(orderedUrgencies, isNot(same(urgencies))); 
 
      //orderedUrgencies.display(title: "Order urgencies"); 
      */ 
    }); 
 
    test("Copy urgencies", () { 
      var copiedUrgencies = urgencies.copy(); 
      expect(copiedUrgencies.isEmpty, isFalse); 
      expect(copiedUrgencies.length, equals(urgencies.length)); 
      expect(copiedUrgencies, isNot(same(urgencies))); 
      copiedUrgencies.forEach((e) => 
        expect(e, equals(urgencies.singleWhereOid(e.oid)))); 
 
      //copiedUrgencies.display(title: "Copy urgencies"); 
    }); 
 
    test("True for every urgency", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random urgency", () { 
      var urgency1 = projectModel.urgencies.random(); 
      expect(urgency1, isNotNull); 
      var urgency2 = projectModel.urgencies.random(); 
      expect(urgency2, isNotNull); 
 
      //urgency1.display(prefix: "random1"); 
      //urgency2.display(prefix: "random2"); 
    }); 
 
    test("Update urgency id with try", () { 
      // no id attribute 
    }); 
 
    test("Update urgency id without try", () { 
      // no id attribute 
    }); 
 
    test("Update urgency id with success", () { 
      // no id attribute 
    }); 
 
    test("Update urgency non id attribute with failure", () { 
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomUrgency = projectModel.urgencies.random(); 
      randomUrgency.display(prefix:"before copy: "); 
      var randomUrgencyCopy = randomUrgency.copy(); 
      randomUrgencyCopy.display(prefix:"after copy: "); 
      expect(randomUrgency, equals(randomUrgencyCopy)); 
      expect(randomUrgency.oid, equals(randomUrgencyCopy.oid)); 
      expect(randomUrgency.code, equals(randomUrgencyCopy.code)); 
 
    }); 
 
    test("urgency action undo and redo", () { 
      var urgencyCount = urgencies.length; 
      var urgency = Urgency(urgencies.concept); 
        urgencies.add(urgency); 
      expect(urgencies.length, equals(++urgencyCount)); 
      urgencies.remove(urgency); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      var action = AddCommand(session, urgencies, urgency); 
      action.doIt(); 
      expect(urgencies.length, equals(++urgencyCount)); 
 
      action.undo(); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      action.redo(); 
      expect(urgencies.length, equals(++urgencyCount)); 
    }); 
 
    test("urgency session undo and redo", () { 
      var urgencyCount = urgencies.length; 
      var urgency = Urgency(urgencies.concept); 
        urgencies.add(urgency); 
      expect(urgencies.length, equals(++urgencyCount)); 
      urgencies.remove(urgency); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      var action = AddCommand(session, urgencies, urgency); 
      action.doIt(); 
      expect(urgencies.length, equals(++urgencyCount)); 
 
      session.past.undo(); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      session.past.redo(); 
      expect(urgencies.length, equals(++urgencyCount)); 
    }); 
 
    test("Urgency update undo and redo", () { 
      // no attribute that is not id 
    }); 
 
    test("Urgency action with multiple undos and redos", () { 
      var urgencyCount = urgencies.length; 
      var urgency1 = projectModel.urgencies.random(); 
 
      var action1 = RemoveCommand(session, urgencies, urgency1); 
      action1.doIt(); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      var urgency2 = projectModel.urgencies.random(); 
 
      var action2 = RemoveCommand(session, urgencies, urgency2); 
      action2.doIt(); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(urgencies.length, equals(++urgencyCount)); 
 
      session.past.undo(); 
      expect(urgencies.length, equals(++urgencyCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      session.past.redo(); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var urgencyCount = urgencies.length; 
      var urgency1 = projectModel.urgencies.random(); 
      var urgency2 = projectModel.urgencies.random(); 
      while (urgency1 == urgency2) { 
        urgency2 = projectModel.urgencies.random();  
      } 
      var action1 = RemoveCommand(session, urgencies, urgency1); 
      var action2 = RemoveCommand(session, urgencies, urgency2); 
 
      var transaction = new Transaction("two removes on urgencies", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      urgencyCount = urgencyCount - 2; 
      expect(urgencies.length, equals(urgencyCount)); 
 
      urgencies.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      urgencyCount = urgencyCount + 2; 
      expect(urgencies.length, equals(urgencyCount)); 
 
      urgencies.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      urgencyCount = urgencyCount - 2; 
      expect(urgencies.length, equals(urgencyCount)); 
 
      urgencies.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var urgencyCount = urgencies.length; 
      var urgency1 = projectModel.urgencies.random(); 
      var urgency2 = urgency1; 
      var action1 = RemoveCommand(session, urgencies, urgency1); 
      var action2 = RemoveCommand(session, urgencies, urgency2); 
 
      var transaction = Transaction( 
        "two removes on urgencies, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(urgencies.length, equals(urgencyCount)); 
 
      //urgencies.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to urgency actions", () { 
      var urgencyCount = urgencies.length; 
 
      var reaction = UrgencyReaction(); 
      expect(reaction, isNotNull); 
 
      focusDomain.startCommandReaction(reaction); 
      var urgency = Urgency(urgencies.concept); 
        urgencies.add(urgency); 
      expect(urgencies.length, equals(++urgencyCount)); 
      urgencies.remove(urgency); 
      expect(urgencies.length, equals(--urgencyCount)); 
 
      var session = focusDomain.newSession(); 
      var addCommand = AddCommand(session, urgencies, urgency); 
      addCommand.doIt(); 
      expect(urgencies.length, equals(++urgencyCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
    }); 
 
  }); 
} 
 
class UrgencyReaction implements ICommandReaction { 
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
  var urgencies = projectModel.urgencies; 
  testFocusProjectUrgencies(focusDomain, projectModel, urgencies); 
} 
 
