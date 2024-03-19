 
// test/focus/project/focus_project_descision_engine_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:focus_project/focus_project.dart"; 
 
void testFocusProjectDescisionEngines( 
    FocusDomain focusDomain, ProjectModel projectModel, DescisionEngines descisionEngines) { 
  DomainSession session; 
  group("Testing Focus.Project.DescisionEngine", () { 
    session = focusDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(descisionEngines.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(descisionEngines.isEmpty, isTrue); 
      expect(descisionEngines.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("DescisionEngine"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("DescisionEngine"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("DescisionEngine"); 
      descisionEngines.clear(); 
      expect(descisionEngines.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(descisionEngines.isEmpty, isFalse); 
 
      descisionEngines.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add descisionEngine required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add descisionEngine unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found descisionEngine by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var descisionEngine = descisionEngines.singleWhereOid(ednetOid); 
      expect(descisionEngine, isNull); 
    }); 
 
    test("Find descisionEngine by oid", () { 
      var randomDescisionEngine = projectModel.descisionEngines.random(); 
      var descisionEngine = descisionEngines.singleWhereOid(randomDescisionEngine.oid); 
      expect(descisionEngine, isNotNull); 
      expect(descisionEngine, equals(randomDescisionEngine)); 
    }); 
 
    test("Find descisionEngine by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find descisionEngine by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find descisionEngine by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select descisionEngines by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select descisionEngines by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select descisionEngines by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select descisionEngines by attribute, then remove", () { 
      // no attribute that is not id 
    }); 
 
    test("Sort descisionEngines", () { 
      // no id attribute 
      // add compareTo method in the specific DescisionEngine class 
      /* 
      descisionEngines.sort(); 
 
      //descisionEngines.display(title: "Sort descisionEngines"); 
      */ 
    }); 
 
    test("Order descisionEngines", () { 
      // no id attribute 
      // add compareTo method in the specific DescisionEngine class 
      /* 
      var orderedDescisionEngines = descisionEngines.order(); 
      expect(orderedDescisionEngines.isEmpty, isFalse); 
      expect(orderedDescisionEngines.length, equals(descisionEngines.length)); 
      expect(orderedDescisionEngines.source?.isEmpty, isFalse); 
      expect(orderedDescisionEngines.source?.length, equals(descisionEngines.length)); 
      expect(orderedDescisionEngines, isNot(same(descisionEngines))); 
 
      //orderedDescisionEngines.display(title: "Order descisionEngines"); 
      */ 
    }); 
 
    test("Copy descisionEngines", () { 
      var copiedDescisionEngines = descisionEngines.copy(); 
      expect(copiedDescisionEngines.isEmpty, isFalse); 
      expect(copiedDescisionEngines.length, equals(descisionEngines.length)); 
      expect(copiedDescisionEngines, isNot(same(descisionEngines))); 
      copiedDescisionEngines.forEach((e) => 
        expect(e, equals(descisionEngines.singleWhereOid(e.oid)))); 
 
      //copiedDescisionEngines.display(title: "Copy descisionEngines"); 
    }); 
 
    test("True for every descisionEngine", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random descisionEngine", () { 
      var descisionEngine1 = projectModel.descisionEngines.random(); 
      expect(descisionEngine1, isNotNull); 
      var descisionEngine2 = projectModel.descisionEngines.random(); 
      expect(descisionEngine2, isNotNull); 
 
      //descisionEngine1.display(prefix: "random1"); 
      //descisionEngine2.display(prefix: "random2"); 
    }); 
 
    test("Update descisionEngine id with try", () { 
      // no id attribute 
    }); 
 
    test("Update descisionEngine id without try", () { 
      // no id attribute 
    }); 
 
    test("Update descisionEngine id with success", () { 
      // no id attribute 
    }); 
 
    test("Update descisionEngine non id attribute with failure", () { 
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomDescisionEngine = projectModel.descisionEngines.random(); 
      randomDescisionEngine.display(prefix:"before copy: "); 
      var randomDescisionEngineCopy = randomDescisionEngine.copy(); 
      randomDescisionEngineCopy.display(prefix:"after copy: "); 
      expect(randomDescisionEngine, equals(randomDescisionEngineCopy)); 
      expect(randomDescisionEngine.oid, equals(randomDescisionEngineCopy.oid)); 
      expect(randomDescisionEngine.code, equals(randomDescisionEngineCopy.code)); 
 
    }); 
 
    test("descisionEngine action undo and redo", () { 
      var descisionEngineCount = descisionEngines.length; 
      var descisionEngine = DescisionEngine(descisionEngines.concept); 
        descisionEngines.add(descisionEngine); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
      descisionEngines.remove(descisionEngine); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      var action = AddCommand(session, descisionEngines, descisionEngine); 
      action.doIt(); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
 
      action.undo(); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      action.redo(); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
    }); 
 
    test("descisionEngine session undo and redo", () { 
      var descisionEngineCount = descisionEngines.length; 
      var descisionEngine = DescisionEngine(descisionEngines.concept); 
        descisionEngines.add(descisionEngine); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
      descisionEngines.remove(descisionEngine); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      var action = AddCommand(session, descisionEngines, descisionEngine); 
      action.doIt(); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
 
      session.past.undo(); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      session.past.redo(); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
    }); 
 
    test("DescisionEngine update undo and redo", () { 
      // no attribute that is not id 
    }); 
 
    test("DescisionEngine action with multiple undos and redos", () { 
      var descisionEngineCount = descisionEngines.length; 
      var descisionEngine1 = projectModel.descisionEngines.random(); 
 
      var action1 = RemoveCommand(session, descisionEngines, descisionEngine1); 
      action1.doIt(); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      var descisionEngine2 = projectModel.descisionEngines.random(); 
 
      var action2 = RemoveCommand(session, descisionEngines, descisionEngine2); 
      action2.doIt(); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
 
      session.past.undo(); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      session.past.redo(); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var descisionEngineCount = descisionEngines.length; 
      var descisionEngine1 = projectModel.descisionEngines.random(); 
      var descisionEngine2 = projectModel.descisionEngines.random(); 
      while (descisionEngine1 == descisionEngine2) { 
        descisionEngine2 = projectModel.descisionEngines.random();  
      } 
      var action1 = RemoveCommand(session, descisionEngines, descisionEngine1); 
      var action2 = RemoveCommand(session, descisionEngines, descisionEngine2); 
 
      var transaction = new Transaction("two removes on descisionEngines", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      descisionEngineCount = descisionEngineCount - 2; 
      expect(descisionEngines.length, equals(descisionEngineCount)); 
 
      descisionEngines.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      descisionEngineCount = descisionEngineCount + 2; 
      expect(descisionEngines.length, equals(descisionEngineCount)); 
 
      descisionEngines.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      descisionEngineCount = descisionEngineCount - 2; 
      expect(descisionEngines.length, equals(descisionEngineCount)); 
 
      descisionEngines.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var descisionEngineCount = descisionEngines.length; 
      var descisionEngine1 = projectModel.descisionEngines.random(); 
      var descisionEngine2 = descisionEngine1; 
      var action1 = RemoveCommand(session, descisionEngines, descisionEngine1); 
      var action2 = RemoveCommand(session, descisionEngines, descisionEngine2); 
 
      var transaction = Transaction( 
        "two removes on descisionEngines, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(descisionEngines.length, equals(descisionEngineCount)); 
 
      //descisionEngines.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to descisionEngine actions", () { 
      var descisionEngineCount = descisionEngines.length; 
 
      var reaction = DescisionEngineReaction(); 
      expect(reaction, isNotNull); 
 
      focusDomain.startCommandReaction(reaction); 
      var descisionEngine = DescisionEngine(descisionEngines.concept); 
        descisionEngines.add(descisionEngine); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
      descisionEngines.remove(descisionEngine); 
      expect(descisionEngines.length, equals(--descisionEngineCount)); 
 
      var session = focusDomain.newSession(); 
      var addCommand = AddCommand(session, descisionEngines, descisionEngine); 
      addCommand.doIt(); 
      expect(descisionEngines.length, equals(++descisionEngineCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
    }); 
 
  }); 
} 
 
class DescisionEngineReaction implements ICommandReaction { 
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
  var descisionEngines = projectModel.descisionEngines; 
  testFocusProjectDescisionEngines(focusDomain, projectModel, descisionEngines); 
} 
 
