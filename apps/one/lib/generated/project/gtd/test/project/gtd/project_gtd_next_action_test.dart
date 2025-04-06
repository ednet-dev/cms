 
// test/project/gtd/project_gtd_next_action_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_gtd/project_gtd.dart"; 
 
void testProjectGtdNextActions( 
    ProjectDomain projectDomain, GtdModel gtdModel, NextActions nextActions) { 
  DomainSession session; 
  group("Testing Project.Gtd.NextAction", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      gtdModel.init(); 
    }); 
    tearDown(() { 
      gtdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(gtdModel.isEmpty, isFalse); 
      expect(nextActions.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      expect(nextActions.isEmpty, isTrue); 
      expect(nextActions.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = gtdModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = gtdModel.toJson(); 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      gtdModel.fromJson(json); 
      expect(gtdModel.isEmpty, isFalse); 
 
      gtdModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = gtdModel.fromEntryToJson("NextAction"); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayEntryJson("NextAction"); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = gtdModel.fromEntryToJson("NextAction"); 
      nextActions.clear(); 
      expect(nextActions.isEmpty, isTrue); 
      gtdModel.fromJsonToEntry(json); 
      expect(nextActions.isEmpty, isFalse); 
 
      nextActions.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add nextAction required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add nextAction unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found nextAction by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var nextAction = nextActions.singleWhereOid(ednetOid); 
      expect(nextAction, isNull); 
    }); 
 
    test("Find nextAction by oid", () { 
      var randomNextAction = gtdModel.nextActions.random(); 
      var nextAction = nextActions.singleWhereOid(randomNextAction.oid); 
      expect(nextAction, isNotNull); 
      expect(nextAction, equals(randomNextAction)); 
    }); 
 
    test("Find nextAction by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find nextAction by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find nextAction by attribute", () { 
      var randomNextAction = gtdModel.nextActions.random(); 
      var nextAction = 
          nextActions.firstWhereAttribute("work", randomNextAction.work); 
      expect(nextAction, isNotNull); 
      expect(nextAction.work, equals(randomNextAction.work)); 
    }); 
 
    test("Select nextActions by attribute", () { 
      var randomNextAction = gtdModel.nextActions.random(); 
      var selectedNextActions = 
          nextActions.selectWhereAttribute("work", randomNextAction.work); 
      expect(selectedNextActions.isEmpty, isFalse); 
      selectedNextActions.forEach((se) => 
          expect(se.work, equals(randomNextAction.work))); 
 
      //selectedNextActions.display(title: "Select nextActions by work"); 
    }); 
 
    test("Select nextActions by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select nextActions by attribute, then add", () { 
      var randomNextAction = gtdModel.nextActions.random(); 
      var selectedNextActions = 
          nextActions.selectWhereAttribute("work", randomNextAction.work); 
      expect(selectedNextActions.isEmpty, isFalse); 
      expect(selectedNextActions.source?.isEmpty, isFalse); 
      var nextActionsCount = nextActions.length; 
 
      var nextAction = NextAction(nextActions.concept); 
      nextAction.work = 'beginning'; 
      var added = selectedNextActions.add(nextAction); 
      expect(added, isTrue); 
      expect(nextActions.length, equals(++nextActionsCount)); 
 
      //selectedNextActions.display(title: 
      //  "Select nextActions by attribute, then add"); 
      //nextActions.display(title: "All nextActions"); 
    }); 
 
    test("Select nextActions by attribute, then remove", () { 
      var randomNextAction = gtdModel.nextActions.random(); 
      var selectedNextActions = 
          nextActions.selectWhereAttribute("work", randomNextAction.work); 
      expect(selectedNextActions.isEmpty, isFalse); 
      expect(selectedNextActions.source?.isEmpty, isFalse); 
      var nextActionsCount = nextActions.length; 
 
      var removed = selectedNextActions.remove(randomNextAction); 
      expect(removed, isTrue); 
      expect(nextActions.length, equals(--nextActionsCount)); 
 
      randomNextAction.display(prefix: "removed"); 
      //selectedNextActions.display(title: 
      //  "Select nextActions by attribute, then remove"); 
      //nextActions.display(title: "All nextActions"); 
    }); 
 
    test("Sort nextActions", () { 
      // no id attribute 
      // add compareTo method in the specific NextAction class 
      /* 
      nextActions.sort(); 
 
      //nextActions.display(title: "Sort nextActions"); 
      */ 
    }); 
 
    test("Order nextActions", () { 
      // no id attribute 
      // add compareTo method in the specific NextAction class 
      /* 
      var orderedNextActions = nextActions.order(); 
      expect(orderedNextActions.isEmpty, isFalse); 
      expect(orderedNextActions.length, equals(nextActions.length)); 
      expect(orderedNextActions.source?.isEmpty, isFalse); 
      expect(orderedNextActions.source?.length, equals(nextActions.length)); 
      expect(orderedNextActions, isNot(same(nextActions))); 
 
      //orderedNextActions.display(title: "Order nextActions"); 
      */ 
    }); 
 
    test("Copy nextActions", () { 
      var copiedNextActions = nextActions.copy(); 
      expect(copiedNextActions.isEmpty, isFalse); 
      expect(copiedNextActions.length, equals(nextActions.length)); 
      expect(copiedNextActions, isNot(same(nextActions))); 
      copiedNextActions.forEach((e) => 
        expect(e, equals(nextActions.singleWhereOid(e.oid)))); 
 
      //copiedNextActions.display(title: "Copy nextActions"); 
    }); 
 
    test("True for every nextAction", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random nextAction", () { 
      var nextAction1 = gtdModel.nextActions.random(); 
      expect(nextAction1, isNotNull); 
      var nextAction2 = gtdModel.nextActions.random(); 
      expect(nextAction2, isNotNull); 
 
      //nextAction1.display(prefix: "random1"); 
      //nextAction2.display(prefix: "random2"); 
    }); 
 
    test("Update nextAction id with try", () { 
      // no id attribute 
    }); 
 
    test("Update nextAction id without try", () { 
      // no id attribute 
    }); 
 
    test("Update nextAction id with success", () { 
      // no id attribute 
    }); 
 
    test("Update nextAction non id attribute with failure", () { 
      var randomNextAction = gtdModel.nextActions.random(); 
      var afterUpdateEntity = randomNextAction.copy(); 
      afterUpdateEntity.work = 'pencil'; 
      expect(afterUpdateEntity.work, equals('pencil')); 
      // nextActions.update can only be used if oid, code or id is set. 
      expect(() => nextActions.update(randomNextAction, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomNextAction = gtdModel.nextActions.random(); 
      randomNextAction.display(prefix:"before copy: "); 
      var randomNextActionCopy = randomNextAction.copy(); 
      randomNextActionCopy.display(prefix:"after copy: "); 
      expect(randomNextAction, equals(randomNextActionCopy)); 
      expect(randomNextAction.oid, equals(randomNextActionCopy.oid)); 
      expect(randomNextAction.code, equals(randomNextActionCopy.code)); 
      expect(randomNextAction.work, equals(randomNextActionCopy.work)); 
 
    }); 
 
    test("nextAction action undo and redo", () { 
      var nextActionCount = nextActions.length; 
      var nextAction = NextAction(nextActions.concept); 
        nextAction.work = 'line'; 
      nextActions.add(nextAction); 
      expect(nextActions.length, equals(++nextActionCount)); 
      nextActions.remove(nextAction); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      var action = AddCommand(session, nextActions, nextAction); 
      action.doIt(); 
      expect(nextActions.length, equals(++nextActionCount)); 
 
      action.undo(); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      action.redo(); 
      expect(nextActions.length, equals(++nextActionCount)); 
    }); 
 
    test("nextAction session undo and redo", () { 
      var nextActionCount = nextActions.length; 
      var nextAction = NextAction(nextActions.concept); 
        nextAction.work = 'job'; 
      nextActions.add(nextAction); 
      expect(nextActions.length, equals(++nextActionCount)); 
      nextActions.remove(nextAction); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      var action = AddCommand(session, nextActions, nextAction); 
      action.doIt(); 
      expect(nextActions.length, equals(++nextActionCount)); 
 
      session.past.undo(); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      session.past.redo(); 
      expect(nextActions.length, equals(++nextActionCount)); 
    }); 
 
    test("NextAction update undo and redo", () { 
      var nextAction = gtdModel.nextActions.random(); 
      var action = SetAttributeCommand(session, nextAction, "work", 'auto'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(nextAction.work, equals(action.before)); 
 
      session.past.redo(); 
      expect(nextAction.work, equals(action.after)); 
    }); 
 
    test("NextAction action with multiple undos and redos", () { 
      var nextActionCount = nextActions.length; 
      var nextAction1 = gtdModel.nextActions.random(); 
 
      var action1 = RemoveCommand(session, nextActions, nextAction1); 
      action1.doIt(); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      var nextAction2 = gtdModel.nextActions.random(); 
 
      var action2 = RemoveCommand(session, nextActions, nextAction2); 
      action2.doIt(); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(nextActions.length, equals(++nextActionCount)); 
 
      session.past.undo(); 
      expect(nextActions.length, equals(++nextActionCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      session.past.redo(); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var nextActionCount = nextActions.length; 
      var nextAction1 = gtdModel.nextActions.random(); 
      var nextAction2 = gtdModel.nextActions.random(); 
      while (nextAction1 == nextAction2) { 
        nextAction2 = gtdModel.nextActions.random();  
      } 
      var action1 = RemoveCommand(session, nextActions, nextAction1); 
      var action2 = RemoveCommand(session, nextActions, nextAction2); 
 
      var transaction = new Transaction("two removes on nextActions", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      nextActionCount = nextActionCount - 2; 
      expect(nextActions.length, equals(nextActionCount)); 
 
      nextActions.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      nextActionCount = nextActionCount + 2; 
      expect(nextActions.length, equals(nextActionCount)); 
 
      nextActions.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      nextActionCount = nextActionCount - 2; 
      expect(nextActions.length, equals(nextActionCount)); 
 
      nextActions.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var nextActionCount = nextActions.length; 
      var nextAction1 = gtdModel.nextActions.random(); 
      var nextAction2 = nextAction1; 
      var action1 = RemoveCommand(session, nextActions, nextAction1); 
      var action2 = RemoveCommand(session, nextActions, nextAction2); 
 
      var transaction = Transaction( 
        "two removes on nextActions, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(nextActions.length, equals(nextActionCount)); 
 
      //nextActions.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to nextAction actions", () { 
      var nextActionCount = nextActions.length; 
 
      var reaction = NextActionReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var nextAction = NextAction(nextActions.concept); 
        nextAction.work = 'television'; 
      nextActions.add(nextAction); 
      expect(nextActions.length, equals(++nextActionCount)); 
      nextActions.remove(nextAction); 
      expect(nextActions.length, equals(--nextActionCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, nextActions, nextAction); 
      addCommand.doIt(); 
      expect(nextActions.length, equals(++nextActionCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, nextAction, "work", 'teaching'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class NextActionReaction implements ICommandReaction { 
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
  var repository = ProjectGtdRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  GtdModel gtdModel = projectDomain.getModelEntries("Gtd") as GtdModel;  
  assert(gtdModel != null); 
  var nextActions = gtdModel.nextActions; 
  testProjectGtdNextActions(projectDomain, gtdModel, nextActions); 
} 
 
