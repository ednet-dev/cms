 
// test/project/gtd/project_gtd_context_list_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_gtd/project_gtd.dart"; 
 
void testProjectGtdContextLists( 
    ProjectDomain projectDomain, GtdModel gtdModel, ContextLists contextLists) { 
  DomainSession session; 
  group("Testing Project.Gtd.ContextList", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      gtdModel.init(); 
    }); 
    tearDown(() { 
      gtdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(gtdModel.isEmpty, isFalse); 
      expect(contextLists.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      expect(contextLists.isEmpty, isTrue); 
      expect(contextLists.exceptions.isEmpty, isTrue); 
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
      var json = gtdModel.fromEntryToJson("ContextList"); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayEntryJson("ContextList"); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = gtdModel.fromEntryToJson("ContextList"); 
      contextLists.clear(); 
      expect(contextLists.isEmpty, isTrue); 
      gtdModel.fromJsonToEntry(json); 
      expect(contextLists.isEmpty, isFalse); 
 
      contextLists.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add contextList required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add contextList unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found contextList by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var contextList = contextLists.singleWhereOid(ednetOid); 
      expect(contextList, isNull); 
    }); 
 
    test("Find contextList by oid", () { 
      var randomContextList = gtdModel.contextLists.random(); 
      var contextList = contextLists.singleWhereOid(randomContextList.oid); 
      expect(contextList, isNotNull); 
      expect(contextList, equals(randomContextList)); 
    }); 
 
    test("Find contextList by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find contextList by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find contextList by attribute", () { 
      var randomContextList = gtdModel.contextLists.random(); 
      var contextList = 
          contextLists.firstWhereAttribute("contexts", randomContextList.contexts); 
      expect(contextList, isNotNull); 
      expect(contextList.contexts, equals(randomContextList.contexts)); 
    }); 
 
    test("Select contextLists by attribute", () { 
      var randomContextList = gtdModel.contextLists.random(); 
      var selectedContextLists = 
          contextLists.selectWhereAttribute("contexts", randomContextList.contexts); 
      expect(selectedContextLists.isEmpty, isFalse); 
      selectedContextLists.forEach((se) => 
          expect(se.contexts, equals(randomContextList.contexts))); 
 
      //selectedContextLists.display(title: "Select contextLists by contexts"); 
    }); 
 
    test("Select contextLists by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select contextLists by attribute, then add", () { 
      var randomContextList = gtdModel.contextLists.random(); 
      var selectedContextLists = 
          contextLists.selectWhereAttribute("contexts", randomContextList.contexts); 
      expect(selectedContextLists.isEmpty, isFalse); 
      expect(selectedContextLists.source?.isEmpty, isFalse); 
      var contextListsCount = contextLists.length; 
 
      var contextList = ContextList(contextLists.concept); 
      contextList.contexts = 'dog'; 
      var added = selectedContextLists.add(contextList); 
      expect(added, isTrue); 
      expect(contextLists.length, equals(++contextListsCount)); 
 
      //selectedContextLists.display(title: 
      //  "Select contextLists by attribute, then add"); 
      //contextLists.display(title: "All contextLists"); 
    }); 
 
    test("Select contextLists by attribute, then remove", () { 
      var randomContextList = gtdModel.contextLists.random(); 
      var selectedContextLists = 
          contextLists.selectWhereAttribute("contexts", randomContextList.contexts); 
      expect(selectedContextLists.isEmpty, isFalse); 
      expect(selectedContextLists.source?.isEmpty, isFalse); 
      var contextListsCount = contextLists.length; 
 
      var removed = selectedContextLists.remove(randomContextList); 
      expect(removed, isTrue); 
      expect(contextLists.length, equals(--contextListsCount)); 
 
      randomContextList.display(prefix: "removed"); 
      //selectedContextLists.display(title: 
      //  "Select contextLists by attribute, then remove"); 
      //contextLists.display(title: "All contextLists"); 
    }); 
 
    test("Sort contextLists", () { 
      // no id attribute 
      // add compareTo method in the specific ContextList class 
      /* 
      contextLists.sort(); 
 
      //contextLists.display(title: "Sort contextLists"); 
      */ 
    }); 
 
    test("Order contextLists", () { 
      // no id attribute 
      // add compareTo method in the specific ContextList class 
      /* 
      var orderedContextLists = contextLists.order(); 
      expect(orderedContextLists.isEmpty, isFalse); 
      expect(orderedContextLists.length, equals(contextLists.length)); 
      expect(orderedContextLists.source?.isEmpty, isFalse); 
      expect(orderedContextLists.source?.length, equals(contextLists.length)); 
      expect(orderedContextLists, isNot(same(contextLists))); 
 
      //orderedContextLists.display(title: "Order contextLists"); 
      */ 
    }); 
 
    test("Copy contextLists", () { 
      var copiedContextLists = contextLists.copy(); 
      expect(copiedContextLists.isEmpty, isFalse); 
      expect(copiedContextLists.length, equals(contextLists.length)); 
      expect(copiedContextLists, isNot(same(contextLists))); 
      copiedContextLists.forEach((e) => 
        expect(e, equals(contextLists.singleWhereOid(e.oid)))); 
 
      //copiedContextLists.display(title: "Copy contextLists"); 
    }); 
 
    test("True for every contextList", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random contextList", () { 
      var contextList1 = gtdModel.contextLists.random(); 
      expect(contextList1, isNotNull); 
      var contextList2 = gtdModel.contextLists.random(); 
      expect(contextList2, isNotNull); 
 
      //contextList1.display(prefix: "random1"); 
      //contextList2.display(prefix: "random2"); 
    }); 
 
    test("Update contextList id with try", () { 
      // no id attribute 
    }); 
 
    test("Update contextList id without try", () { 
      // no id attribute 
    }); 
 
    test("Update contextList id with success", () { 
      // no id attribute 
    }); 
 
    test("Update contextList non id attribute with failure", () { 
      var randomContextList = gtdModel.contextLists.random(); 
      var afterUpdateEntity = randomContextList.copy(); 
      afterUpdateEntity.contexts = 'craving'; 
      expect(afterUpdateEntity.contexts, equals('craving')); 
      // contextLists.update can only be used if oid, code or id is set. 
      expect(() => contextLists.update(randomContextList, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomContextList = gtdModel.contextLists.random(); 
      randomContextList.display(prefix:"before copy: "); 
      var randomContextListCopy = randomContextList.copy(); 
      randomContextListCopy.display(prefix:"after copy: "); 
      expect(randomContextList, equals(randomContextListCopy)); 
      expect(randomContextList.oid, equals(randomContextListCopy.oid)); 
      expect(randomContextList.code, equals(randomContextListCopy.code)); 
      expect(randomContextList.contexts, equals(randomContextListCopy.contexts)); 
 
    }); 
 
    test("contextList action undo and redo", () { 
      var contextListCount = contextLists.length; 
      var contextList = ContextList(contextLists.concept); 
        contextList.contexts = 'opinion'; 
    var contextListTask = gtdModel.tasks.random(); 
    contextList.task = contextListTask; 
      contextLists.add(contextList); 
    contextListTask.contextLists.add(contextList); 
      expect(contextLists.length, equals(++contextListCount)); 
      contextLists.remove(contextList); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      var action = AddCommand(session, contextLists, contextList); 
      action.doIt(); 
      expect(contextLists.length, equals(++contextListCount)); 
 
      action.undo(); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      action.redo(); 
      expect(contextLists.length, equals(++contextListCount)); 
    }); 
 
    test("contextList session undo and redo", () { 
      var contextListCount = contextLists.length; 
      var contextList = ContextList(contextLists.concept); 
        contextList.contexts = 'hat'; 
    var contextListTask = gtdModel.tasks.random(); 
    contextList.task = contextListTask; 
      contextLists.add(contextList); 
    contextListTask.contextLists.add(contextList); 
      expect(contextLists.length, equals(++contextListCount)); 
      contextLists.remove(contextList); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      var action = AddCommand(session, contextLists, contextList); 
      action.doIt(); 
      expect(contextLists.length, equals(++contextListCount)); 
 
      session.past.undo(); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      session.past.redo(); 
      expect(contextLists.length, equals(++contextListCount)); 
    }); 
 
    test("ContextList update undo and redo", () { 
      var contextList = gtdModel.contextLists.random(); 
      var action = SetAttributeCommand(session, contextList, "contexts", 'kids'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(contextList.contexts, equals(action.before)); 
 
      session.past.redo(); 
      expect(contextList.contexts, equals(action.after)); 
    }); 
 
    test("ContextList action with multiple undos and redos", () { 
      var contextListCount = contextLists.length; 
      var contextList1 = gtdModel.contextLists.random(); 
 
      var action1 = RemoveCommand(session, contextLists, contextList1); 
      action1.doIt(); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      var contextList2 = gtdModel.contextLists.random(); 
 
      var action2 = RemoveCommand(session, contextLists, contextList2); 
      action2.doIt(); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(contextLists.length, equals(++contextListCount)); 
 
      session.past.undo(); 
      expect(contextLists.length, equals(++contextListCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      session.past.redo(); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var contextListCount = contextLists.length; 
      var contextList1 = gtdModel.contextLists.random(); 
      var contextList2 = gtdModel.contextLists.random(); 
      while (contextList1 == contextList2) { 
        contextList2 = gtdModel.contextLists.random();  
      } 
      var action1 = RemoveCommand(session, contextLists, contextList1); 
      var action2 = RemoveCommand(session, contextLists, contextList2); 
 
      var transaction = new Transaction("two removes on contextLists", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      contextListCount = contextListCount - 2; 
      expect(contextLists.length, equals(contextListCount)); 
 
      contextLists.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      contextListCount = contextListCount + 2; 
      expect(contextLists.length, equals(contextListCount)); 
 
      contextLists.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      contextListCount = contextListCount - 2; 
      expect(contextLists.length, equals(contextListCount)); 
 
      contextLists.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var contextListCount = contextLists.length; 
      var contextList1 = gtdModel.contextLists.random(); 
      var contextList2 = contextList1; 
      var action1 = RemoveCommand(session, contextLists, contextList1); 
      var action2 = RemoveCommand(session, contextLists, contextList2); 
 
      var transaction = Transaction( 
        "two removes on contextLists, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(contextLists.length, equals(contextListCount)); 
 
      //contextLists.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to contextList actions", () { 
      var contextListCount = contextLists.length; 
 
      var reaction = ContextListReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var contextList = ContextList(contextLists.concept); 
        contextList.contexts = 'book'; 
    var contextListTask = gtdModel.tasks.random(); 
    contextList.task = contextListTask; 
      contextLists.add(contextList); 
    contextListTask.contextLists.add(contextList); 
      expect(contextLists.length, equals(++contextListCount)); 
      contextLists.remove(contextList); 
      expect(contextLists.length, equals(--contextListCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, contextLists, contextList); 
      addCommand.doIt(); 
      expect(contextLists.length, equals(++contextListCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, contextList, "contexts", 'cream'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ContextListReaction implements ICommandReaction { 
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
  var contextLists = gtdModel.contextLists; 
  testProjectGtdContextLists(projectDomain, gtdModel, contextLists); 
} 
 
