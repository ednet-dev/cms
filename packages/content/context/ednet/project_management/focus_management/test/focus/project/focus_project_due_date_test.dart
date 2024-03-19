 
// test/focus/project/focus_project_due_date_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:focus_project/focus_project.dart"; 
 
void testFocusProjectDueDates( 
    FocusDomain focusDomain, ProjectModel projectModel, DueDates dueDates) { 
  DomainSession session; 
  group("Testing Focus.Project.DueDate", () { 
    session = focusDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(dueDates.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(dueDates.isEmpty, isTrue); 
      expect(dueDates.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("DueDate"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("DueDate"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("DueDate"); 
      dueDates.clear(); 
      expect(dueDates.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(dueDates.isEmpty, isFalse); 
 
      dueDates.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add dueDate required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add dueDate unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found dueDate by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var dueDate = dueDates.singleWhereOid(ednetOid); 
      expect(dueDate, isNull); 
    }); 
 
    test("Find dueDate by oid", () { 
      var randomDueDate = projectModel.dueDates.random(); 
      var dueDate = dueDates.singleWhereOid(randomDueDate.oid); 
      expect(dueDate, isNotNull); 
      expect(dueDate, equals(randomDueDate)); 
    }); 
 
    test("Find dueDate by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find dueDate by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find dueDate by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select dueDates by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select dueDates by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select dueDates by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select dueDates by attribute, then remove", () { 
      // no attribute that is not id 
    }); 
 
    test("Sort dueDates", () { 
      // no id attribute 
      // add compareTo method in the specific DueDate class 
      /* 
      dueDates.sort(); 
 
      //dueDates.display(title: "Sort dueDates"); 
      */ 
    }); 
 
    test("Order dueDates", () { 
      // no id attribute 
      // add compareTo method in the specific DueDate class 
      /* 
      var orderedDueDates = dueDates.order(); 
      expect(orderedDueDates.isEmpty, isFalse); 
      expect(orderedDueDates.length, equals(dueDates.length)); 
      expect(orderedDueDates.source?.isEmpty, isFalse); 
      expect(orderedDueDates.source?.length, equals(dueDates.length)); 
      expect(orderedDueDates, isNot(same(dueDates))); 
 
      //orderedDueDates.display(title: "Order dueDates"); 
      */ 
    }); 
 
    test("Copy dueDates", () { 
      var copiedDueDates = dueDates.copy(); 
      expect(copiedDueDates.isEmpty, isFalse); 
      expect(copiedDueDates.length, equals(dueDates.length)); 
      expect(copiedDueDates, isNot(same(dueDates))); 
      copiedDueDates.forEach((e) => 
        expect(e, equals(dueDates.singleWhereOid(e.oid)))); 
 
      //copiedDueDates.display(title: "Copy dueDates"); 
    }); 
 
    test("True for every dueDate", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random dueDate", () { 
      var dueDate1 = projectModel.dueDates.random(); 
      expect(dueDate1, isNotNull); 
      var dueDate2 = projectModel.dueDates.random(); 
      expect(dueDate2, isNotNull); 
 
      //dueDate1.display(prefix: "random1"); 
      //dueDate2.display(prefix: "random2"); 
    }); 
 
    test("Update dueDate id with try", () { 
      // no id attribute 
    }); 
 
    test("Update dueDate id without try", () { 
      // no id attribute 
    }); 
 
    test("Update dueDate id with success", () { 
      // no id attribute 
    }); 
 
    test("Update dueDate non id attribute with failure", () { 
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomDueDate = projectModel.dueDates.random(); 
      randomDueDate.display(prefix:"before copy: "); 
      var randomDueDateCopy = randomDueDate.copy(); 
      randomDueDateCopy.display(prefix:"after copy: "); 
      expect(randomDueDate, equals(randomDueDateCopy)); 
      expect(randomDueDate.oid, equals(randomDueDateCopy.oid)); 
      expect(randomDueDate.code, equals(randomDueDateCopy.code)); 
 
    }); 
 
    test("dueDate action undo and redo", () { 
      var dueDateCount = dueDates.length; 
      var dueDate = DueDate(dueDates.concept); 
        dueDates.add(dueDate); 
      expect(dueDates.length, equals(++dueDateCount)); 
      dueDates.remove(dueDate); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      var action = AddCommand(session, dueDates, dueDate); 
      action.doIt(); 
      expect(dueDates.length, equals(++dueDateCount)); 
 
      action.undo(); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      action.redo(); 
      expect(dueDates.length, equals(++dueDateCount)); 
    }); 
 
    test("dueDate session undo and redo", () { 
      var dueDateCount = dueDates.length; 
      var dueDate = DueDate(dueDates.concept); 
        dueDates.add(dueDate); 
      expect(dueDates.length, equals(++dueDateCount)); 
      dueDates.remove(dueDate); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      var action = AddCommand(session, dueDates, dueDate); 
      action.doIt(); 
      expect(dueDates.length, equals(++dueDateCount)); 
 
      session.past.undo(); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      session.past.redo(); 
      expect(dueDates.length, equals(++dueDateCount)); 
    }); 
 
    test("DueDate update undo and redo", () { 
      // no attribute that is not id 
    }); 
 
    test("DueDate action with multiple undos and redos", () { 
      var dueDateCount = dueDates.length; 
      var dueDate1 = projectModel.dueDates.random(); 
 
      var action1 = RemoveCommand(session, dueDates, dueDate1); 
      action1.doIt(); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      var dueDate2 = projectModel.dueDates.random(); 
 
      var action2 = RemoveCommand(session, dueDates, dueDate2); 
      action2.doIt(); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(dueDates.length, equals(++dueDateCount)); 
 
      session.past.undo(); 
      expect(dueDates.length, equals(++dueDateCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      session.past.redo(); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var dueDateCount = dueDates.length; 
      var dueDate1 = projectModel.dueDates.random(); 
      var dueDate2 = projectModel.dueDates.random(); 
      while (dueDate1 == dueDate2) { 
        dueDate2 = projectModel.dueDates.random();  
      } 
      var action1 = RemoveCommand(session, dueDates, dueDate1); 
      var action2 = RemoveCommand(session, dueDates, dueDate2); 
 
      var transaction = new Transaction("two removes on dueDates", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      dueDateCount = dueDateCount - 2; 
      expect(dueDates.length, equals(dueDateCount)); 
 
      dueDates.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      dueDateCount = dueDateCount + 2; 
      expect(dueDates.length, equals(dueDateCount)); 
 
      dueDates.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      dueDateCount = dueDateCount - 2; 
      expect(dueDates.length, equals(dueDateCount)); 
 
      dueDates.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var dueDateCount = dueDates.length; 
      var dueDate1 = projectModel.dueDates.random(); 
      var dueDate2 = dueDate1; 
      var action1 = RemoveCommand(session, dueDates, dueDate1); 
      var action2 = RemoveCommand(session, dueDates, dueDate2); 
 
      var transaction = Transaction( 
        "two removes on dueDates, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(dueDates.length, equals(dueDateCount)); 
 
      //dueDates.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to dueDate actions", () { 
      var dueDateCount = dueDates.length; 
 
      var reaction = DueDateReaction(); 
      expect(reaction, isNotNull); 
 
      focusDomain.startCommandReaction(reaction); 
      var dueDate = DueDate(dueDates.concept); 
        dueDates.add(dueDate); 
      expect(dueDates.length, equals(++dueDateCount)); 
      dueDates.remove(dueDate); 
      expect(dueDates.length, equals(--dueDateCount)); 
 
      var session = focusDomain.newSession(); 
      var addCommand = AddCommand(session, dueDates, dueDate); 
      addCommand.doIt(); 
      expect(dueDates.length, equals(++dueDateCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
    }); 
 
  }); 
} 
 
class DueDateReaction implements ICommandReaction { 
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
  var dueDates = projectModel.dueDates; 
  testFocusProjectDueDates(focusDomain, projectModel, dueDates); 
} 
 
