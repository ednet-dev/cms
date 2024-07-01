 
// test/project/brainstorming/project_brainstorming_mind_map_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_brainstorming/project_brainstorming.dart"; 
 
void testProjectBrainstormingMindMaps( 
    ProjectDomain projectDomain, BrainstormingModel brainstormingModel, MindMaps mindMaps) { 
  DomainSession session; 
  group("Testing Project.Brainstorming.MindMap", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      brainstormingModel.init(); 
    }); 
    tearDown(() { 
      brainstormingModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(brainstormingModel.isEmpty, isFalse); 
      expect(mindMaps.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      brainstormingModel.clear(); 
      expect(brainstormingModel.isEmpty, isTrue); 
      expect(mindMaps.isEmpty, isTrue); 
      expect(mindMaps.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = brainstormingModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //brainstormingModel.displayJson(); 
      //brainstormingModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = brainstormingModel.toJson(); 
      brainstormingModel.clear(); 
      expect(brainstormingModel.isEmpty, isTrue); 
      brainstormingModel.fromJson(json); 
      expect(brainstormingModel.isEmpty, isFalse); 
 
      brainstormingModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = brainstormingModel.fromEntryToJson("MindMap"); 
      expect(json, isNotNull); 
 
      print(json); 
      //brainstormingModel.displayEntryJson("MindMap"); 
      //brainstormingModel.displayJson(); 
      //brainstormingModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = brainstormingModel.fromEntryToJson("MindMap"); 
      mindMaps.clear(); 
      expect(mindMaps.isEmpty, isTrue); 
      brainstormingModel.fromJsonToEntry(json); 
      expect(mindMaps.isEmpty, isFalse); 
 
      mindMaps.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add mindMap required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add mindMap unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found mindMap by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var mindMap = mindMaps.singleWhereOid(ednetOid); 
      expect(mindMap, isNull); 
    }); 
 
    test("Find mindMap by oid", () { 
      var randomMindMap = brainstormingModel.mindMaps.random(); 
      var mindMap = mindMaps.singleWhereOid(randomMindMap.oid); 
      expect(mindMap, isNotNull); 
      expect(mindMap, equals(randomMindMap)); 
    }); 
 
    test("Find mindMap by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find mindMap by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find mindMap by attribute", () { 
      var randomMindMap = brainstormingModel.mindMaps.random(); 
      var mindMap = 
          mindMaps.firstWhereAttribute("name", randomMindMap.name); 
      expect(mindMap, isNotNull); 
      expect(mindMap.name, equals(randomMindMap.name)); 
    }); 
 
    test("Select mindMaps by attribute", () { 
      var randomMindMap = brainstormingModel.mindMaps.random(); 
      var selectedMindMaps = 
          mindMaps.selectWhereAttribute("name", randomMindMap.name); 
      expect(selectedMindMaps.isEmpty, isFalse); 
      selectedMindMaps.forEach((se) => 
          expect(se.name, equals(randomMindMap.name))); 
 
      //selectedMindMaps.display(title: "Select mindMaps by name"); 
    }); 
 
    test("Select mindMaps by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select mindMaps by attribute, then add", () { 
      var randomMindMap = brainstormingModel.mindMaps.random(); 
      var selectedMindMaps = 
          mindMaps.selectWhereAttribute("name", randomMindMap.name); 
      expect(selectedMindMaps.isEmpty, isFalse); 
      expect(selectedMindMaps.source?.isEmpty, isFalse); 
      var mindMapsCount = mindMaps.length; 
 
      var mindMap = MindMap(mindMaps.concept); 
      mindMap.name = 'measuremewnt'; 
      mindMap.description = 'health'; 
      var added = selectedMindMaps.add(mindMap); 
      expect(added, isTrue); 
      expect(mindMaps.length, equals(++mindMapsCount)); 
 
      //selectedMindMaps.display(title: 
      //  "Select mindMaps by attribute, then add"); 
      //mindMaps.display(title: "All mindMaps"); 
    }); 
 
    test("Select mindMaps by attribute, then remove", () { 
      var randomMindMap = brainstormingModel.mindMaps.random(); 
      var selectedMindMaps = 
          mindMaps.selectWhereAttribute("name", randomMindMap.name); 
      expect(selectedMindMaps.isEmpty, isFalse); 
      expect(selectedMindMaps.source?.isEmpty, isFalse); 
      var mindMapsCount = mindMaps.length; 
 
      var removed = selectedMindMaps.remove(randomMindMap); 
      expect(removed, isTrue); 
      expect(mindMaps.length, equals(--mindMapsCount)); 
 
      randomMindMap.display(prefix: "removed"); 
      //selectedMindMaps.display(title: 
      //  "Select mindMaps by attribute, then remove"); 
      //mindMaps.display(title: "All mindMaps"); 
    }); 
 
    test("Sort mindMaps", () { 
      // no id attribute 
      // add compareTo method in the specific MindMap class 
      /* 
      mindMaps.sort(); 
 
      //mindMaps.display(title: "Sort mindMaps"); 
      */ 
    }); 
 
    test("Order mindMaps", () { 
      // no id attribute 
      // add compareTo method in the specific MindMap class 
      /* 
      var orderedMindMaps = mindMaps.order(); 
      expect(orderedMindMaps.isEmpty, isFalse); 
      expect(orderedMindMaps.length, equals(mindMaps.length)); 
      expect(orderedMindMaps.source?.isEmpty, isFalse); 
      expect(orderedMindMaps.source?.length, equals(mindMaps.length)); 
      expect(orderedMindMaps, isNot(same(mindMaps))); 
 
      //orderedMindMaps.display(title: "Order mindMaps"); 
      */ 
    }); 
 
    test("Copy mindMaps", () { 
      var copiedMindMaps = mindMaps.copy(); 
      expect(copiedMindMaps.isEmpty, isFalse); 
      expect(copiedMindMaps.length, equals(mindMaps.length)); 
      expect(copiedMindMaps, isNot(same(mindMaps))); 
      copiedMindMaps.forEach((e) => 
        expect(e, equals(mindMaps.singleWhereOid(e.oid)))); 
 
      //copiedMindMaps.display(title: "Copy mindMaps"); 
    }); 
 
    test("True for every mindMap", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random mindMap", () { 
      var mindMap1 = brainstormingModel.mindMaps.random(); 
      expect(mindMap1, isNotNull); 
      var mindMap2 = brainstormingModel.mindMaps.random(); 
      expect(mindMap2, isNotNull); 
 
      //mindMap1.display(prefix: "random1"); 
      //mindMap2.display(prefix: "random2"); 
    }); 
 
    test("Update mindMap id with try", () { 
      // no id attribute 
    }); 
 
    test("Update mindMap id without try", () { 
      // no id attribute 
    }); 
 
    test("Update mindMap id with success", () { 
      // no id attribute 
    }); 
 
    test("Update mindMap non id attribute with failure", () { 
      var randomMindMap = brainstormingModel.mindMaps.random(); 
      var afterUpdateEntity = randomMindMap.copy(); 
      afterUpdateEntity.name = 'selfdo'; 
      expect(afterUpdateEntity.name, equals('selfdo')); 
      // mindMaps.update can only be used if oid, code or id is set. 
      expect(() => mindMaps.update(randomMindMap, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomMindMap = brainstormingModel.mindMaps.random(); 
      randomMindMap.display(prefix:"before copy: "); 
      var randomMindMapCopy = randomMindMap.copy(); 
      randomMindMapCopy.display(prefix:"after copy: "); 
      expect(randomMindMap, equals(randomMindMapCopy)); 
      expect(randomMindMap.oid, equals(randomMindMapCopy.oid)); 
      expect(randomMindMap.code, equals(randomMindMapCopy.code)); 
      expect(randomMindMap.name, equals(randomMindMapCopy.name)); 
      expect(randomMindMap.description, equals(randomMindMapCopy.description)); 
 
    }); 
 
    test("mindMap action undo and redo", () { 
      var mindMapCount = mindMaps.length; 
      var mindMap = MindMap(mindMaps.concept); 
        mindMap.name = 'small'; 
      mindMap.description = 'architecture'; 
      mindMaps.add(mindMap); 
      expect(mindMaps.length, equals(++mindMapCount)); 
      mindMaps.remove(mindMap); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      var action = AddCommand(session, mindMaps, mindMap); 
      action.doIt(); 
      expect(mindMaps.length, equals(++mindMapCount)); 
 
      action.undo(); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      action.redo(); 
      expect(mindMaps.length, equals(++mindMapCount)); 
    }); 
 
    test("mindMap session undo and redo", () { 
      var mindMapCount = mindMaps.length; 
      var mindMap = MindMap(mindMaps.concept); 
        mindMap.name = 'bank'; 
      mindMap.description = 'observation'; 
      mindMaps.add(mindMap); 
      expect(mindMaps.length, equals(++mindMapCount)); 
      mindMaps.remove(mindMap); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      var action = AddCommand(session, mindMaps, mindMap); 
      action.doIt(); 
      expect(mindMaps.length, equals(++mindMapCount)); 
 
      session.past.undo(); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      session.past.redo(); 
      expect(mindMaps.length, equals(++mindMapCount)); 
    }); 
 
    test("MindMap update undo and redo", () { 
      var mindMap = brainstormingModel.mindMaps.random(); 
      var action = SetAttributeCommand(session, mindMap, "name", 'present'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(mindMap.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(mindMap.name, equals(action.after)); 
    }); 
 
    test("MindMap action with multiple undos and redos", () { 
      var mindMapCount = mindMaps.length; 
      var mindMap1 = brainstormingModel.mindMaps.random(); 
 
      var action1 = RemoveCommand(session, mindMaps, mindMap1); 
      action1.doIt(); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      var mindMap2 = brainstormingModel.mindMaps.random(); 
 
      var action2 = RemoveCommand(session, mindMaps, mindMap2); 
      action2.doIt(); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(mindMaps.length, equals(++mindMapCount)); 
 
      session.past.undo(); 
      expect(mindMaps.length, equals(++mindMapCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      session.past.redo(); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var mindMapCount = mindMaps.length; 
      var mindMap1 = brainstormingModel.mindMaps.random(); 
      var mindMap2 = brainstormingModel.mindMaps.random(); 
      while (mindMap1 == mindMap2) { 
        mindMap2 = brainstormingModel.mindMaps.random();  
      } 
      var action1 = RemoveCommand(session, mindMaps, mindMap1); 
      var action2 = RemoveCommand(session, mindMaps, mindMap2); 
 
      var transaction = new Transaction("two removes on mindMaps", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      mindMapCount = mindMapCount - 2; 
      expect(mindMaps.length, equals(mindMapCount)); 
 
      mindMaps.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      mindMapCount = mindMapCount + 2; 
      expect(mindMaps.length, equals(mindMapCount)); 
 
      mindMaps.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      mindMapCount = mindMapCount - 2; 
      expect(mindMaps.length, equals(mindMapCount)); 
 
      mindMaps.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var mindMapCount = mindMaps.length; 
      var mindMap1 = brainstormingModel.mindMaps.random(); 
      var mindMap2 = mindMap1; 
      var action1 = RemoveCommand(session, mindMaps, mindMap1); 
      var action2 = RemoveCommand(session, mindMaps, mindMap2); 
 
      var transaction = Transaction( 
        "two removes on mindMaps, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(mindMaps.length, equals(mindMapCount)); 
 
      //mindMaps.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to mindMap actions", () { 
      var mindMapCount = mindMaps.length; 
 
      var reaction = MindMapReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var mindMap = MindMap(mindMaps.concept); 
        mindMap.name = 'offence'; 
      mindMap.description = 'tree'; 
      mindMaps.add(mindMap); 
      expect(mindMaps.length, equals(++mindMapCount)); 
      mindMaps.remove(mindMap); 
      expect(mindMaps.length, equals(--mindMapCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, mindMaps, mindMap); 
      addCommand.doIt(); 
      expect(mindMaps.length, equals(++mindMapCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, mindMap, "name", 'paper'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class MindMapReaction implements ICommandReaction { 
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
  var repository = ProjectBrainstormingRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  BrainstormingModel brainstormingModel = projectDomain.getModelEntries("Brainstorming") as BrainstormingModel;  
  assert(brainstormingModel != null); 
  var mindMaps = brainstormingModel.mindMaps; 
  testProjectBrainstormingMindMaps(projectDomain, brainstormingModel, mindMaps); 
} 
 
