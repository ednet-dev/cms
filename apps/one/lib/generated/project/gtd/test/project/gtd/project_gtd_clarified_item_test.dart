 
// test/project/gtd/project_gtd_clarified_item_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_gtd/project_gtd.dart"; 
 
void testProjectGtdClarifiedItems( 
    ProjectDomain projectDomain, GtdModel gtdModel, ClarifiedItems clarifiedItems) { 
  DomainSession session; 
  group("Testing Project.Gtd.ClarifiedItem", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      gtdModel.init(); 
    }); 
    tearDown(() { 
      gtdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(gtdModel.isEmpty, isFalse); 
      expect(clarifiedItems.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      expect(clarifiedItems.isEmpty, isTrue); 
      expect(clarifiedItems.exceptions.isEmpty, isTrue); 
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
      var json = gtdModel.fromEntryToJson("ClarifiedItem"); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayEntryJson("ClarifiedItem"); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = gtdModel.fromEntryToJson("ClarifiedItem"); 
      clarifiedItems.clear(); 
      expect(clarifiedItems.isEmpty, isTrue); 
      gtdModel.fromJsonToEntry(json); 
      expect(clarifiedItems.isEmpty, isFalse); 
 
      clarifiedItems.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add clarifiedItem required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add clarifiedItem unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found clarifiedItem by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var clarifiedItem = clarifiedItems.singleWhereOid(ednetOid); 
      expect(clarifiedItem, isNull); 
    }); 
 
    test("Find clarifiedItem by oid", () { 
      var randomClarifiedItem = gtdModel.clarifiedItems.random(); 
      var clarifiedItem = clarifiedItems.singleWhereOid(randomClarifiedItem.oid); 
      expect(clarifiedItem, isNotNull); 
      expect(clarifiedItem, equals(randomClarifiedItem)); 
    }); 
 
    test("Find clarifiedItem by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find clarifiedItem by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find clarifiedItem by attribute", () { 
      var randomClarifiedItem = gtdModel.clarifiedItems.random(); 
      var clarifiedItem = 
          clarifiedItems.firstWhereAttribute("nextAction", randomClarifiedItem.nextAction); 
      expect(clarifiedItem, isNotNull); 
      expect(clarifiedItem.nextAction, equals(randomClarifiedItem.nextAction)); 
    }); 
 
    test("Select clarifiedItems by attribute", () { 
      var randomClarifiedItem = gtdModel.clarifiedItems.random(); 
      var selectedClarifiedItems = 
          clarifiedItems.selectWhereAttribute("nextAction", randomClarifiedItem.nextAction); 
      expect(selectedClarifiedItems.isEmpty, isFalse); 
      selectedClarifiedItems.forEach((se) => 
          expect(se.nextAction, equals(randomClarifiedItem.nextAction))); 
 
      //selectedClarifiedItems.display(title: "Select clarifiedItems by nextAction"); 
    }); 
 
    test("Select clarifiedItems by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select clarifiedItems by attribute, then add", () { 
      var randomClarifiedItem = gtdModel.clarifiedItems.random(); 
      var selectedClarifiedItems = 
          clarifiedItems.selectWhereAttribute("nextAction", randomClarifiedItem.nextAction); 
      expect(selectedClarifiedItems.isEmpty, isFalse); 
      expect(selectedClarifiedItems.source?.isEmpty, isFalse); 
      var clarifiedItemsCount = clarifiedItems.length; 
 
      var clarifiedItem = ClarifiedItem(clarifiedItems.concept); 
      clarifiedItem.nextAction = 'training'; 
      var added = selectedClarifiedItems.add(clarifiedItem); 
      expect(added, isTrue); 
      expect(clarifiedItems.length, equals(++clarifiedItemsCount)); 
 
      //selectedClarifiedItems.display(title: 
      //  "Select clarifiedItems by attribute, then add"); 
      //clarifiedItems.display(title: "All clarifiedItems"); 
    }); 
 
    test("Select clarifiedItems by attribute, then remove", () { 
      var randomClarifiedItem = gtdModel.clarifiedItems.random(); 
      var selectedClarifiedItems = 
          clarifiedItems.selectWhereAttribute("nextAction", randomClarifiedItem.nextAction); 
      expect(selectedClarifiedItems.isEmpty, isFalse); 
      expect(selectedClarifiedItems.source?.isEmpty, isFalse); 
      var clarifiedItemsCount = clarifiedItems.length; 
 
      var removed = selectedClarifiedItems.remove(randomClarifiedItem); 
      expect(removed, isTrue); 
      expect(clarifiedItems.length, equals(--clarifiedItemsCount)); 
 
      randomClarifiedItem.display(prefix: "removed"); 
      //selectedClarifiedItems.display(title: 
      //  "Select clarifiedItems by attribute, then remove"); 
      //clarifiedItems.display(title: "All clarifiedItems"); 
    }); 
 
    test("Sort clarifiedItems", () { 
      // no id attribute 
      // add compareTo method in the specific ClarifiedItem class 
      /* 
      clarifiedItems.sort(); 
 
      //clarifiedItems.display(title: "Sort clarifiedItems"); 
      */ 
    }); 
 
    test("Order clarifiedItems", () { 
      // no id attribute 
      // add compareTo method in the specific ClarifiedItem class 
      /* 
      var orderedClarifiedItems = clarifiedItems.order(); 
      expect(orderedClarifiedItems.isEmpty, isFalse); 
      expect(orderedClarifiedItems.length, equals(clarifiedItems.length)); 
      expect(orderedClarifiedItems.source?.isEmpty, isFalse); 
      expect(orderedClarifiedItems.source?.length, equals(clarifiedItems.length)); 
      expect(orderedClarifiedItems, isNot(same(clarifiedItems))); 
 
      //orderedClarifiedItems.display(title: "Order clarifiedItems"); 
      */ 
    }); 
 
    test("Copy clarifiedItems", () { 
      var copiedClarifiedItems = clarifiedItems.copy(); 
      expect(copiedClarifiedItems.isEmpty, isFalse); 
      expect(copiedClarifiedItems.length, equals(clarifiedItems.length)); 
      expect(copiedClarifiedItems, isNot(same(clarifiedItems))); 
      copiedClarifiedItems.forEach((e) => 
        expect(e, equals(clarifiedItems.singleWhereOid(e.oid)))); 
 
      //copiedClarifiedItems.display(title: "Copy clarifiedItems"); 
    }); 
 
    test("True for every clarifiedItem", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random clarifiedItem", () { 
      var clarifiedItem1 = gtdModel.clarifiedItems.random(); 
      expect(clarifiedItem1, isNotNull); 
      var clarifiedItem2 = gtdModel.clarifiedItems.random(); 
      expect(clarifiedItem2, isNotNull); 
 
      //clarifiedItem1.display(prefix: "random1"); 
      //clarifiedItem2.display(prefix: "random2"); 
    }); 
 
    test("Update clarifiedItem id with try", () { 
      // no id attribute 
    }); 
 
    test("Update clarifiedItem id without try", () { 
      // no id attribute 
    }); 
 
    test("Update clarifiedItem id with success", () { 
      // no id attribute 
    }); 
 
    test("Update clarifiedItem non id attribute with failure", () { 
      var randomClarifiedItem = gtdModel.clarifiedItems.random(); 
      var afterUpdateEntity = randomClarifiedItem.copy(); 
      afterUpdateEntity.nextAction = 'tax'; 
      expect(afterUpdateEntity.nextAction, equals('tax')); 
      // clarifiedItems.update can only be used if oid, code or id is set. 
      expect(() => clarifiedItems.update(randomClarifiedItem, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomClarifiedItem = gtdModel.clarifiedItems.random(); 
      randomClarifiedItem.display(prefix:"before copy: "); 
      var randomClarifiedItemCopy = randomClarifiedItem.copy(); 
      randomClarifiedItemCopy.display(prefix:"after copy: "); 
      expect(randomClarifiedItem, equals(randomClarifiedItemCopy)); 
      expect(randomClarifiedItem.oid, equals(randomClarifiedItemCopy.oid)); 
      expect(randomClarifiedItem.code, equals(randomClarifiedItemCopy.code)); 
      expect(randomClarifiedItem.nextAction, equals(randomClarifiedItemCopy.nextAction)); 
 
    }); 
 
    test("clarifiedItem action undo and redo", () { 
      var clarifiedItemCount = clarifiedItems.length; 
      var clarifiedItem = ClarifiedItem(clarifiedItems.concept); 
        clarifiedItem.nextAction = 'bird'; 
    var clarifiedItemInbox = gtdModel.inboxes.random(); 
    clarifiedItem.inbox = clarifiedItemInbox; 
      clarifiedItems.add(clarifiedItem); 
    clarifiedItemInbox.clarifiedItems.add(clarifiedItem); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
      clarifiedItems.remove(clarifiedItem); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      var action = AddCommand(session, clarifiedItems, clarifiedItem); 
      action.doIt(); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
 
      action.undo(); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      action.redo(); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
    }); 
 
    test("clarifiedItem session undo and redo", () { 
      var clarifiedItemCount = clarifiedItems.length; 
      var clarifiedItem = ClarifiedItem(clarifiedItems.concept); 
        clarifiedItem.nextAction = 'hall'; 
    var clarifiedItemInbox = gtdModel.inboxes.random(); 
    clarifiedItem.inbox = clarifiedItemInbox; 
      clarifiedItems.add(clarifiedItem); 
    clarifiedItemInbox.clarifiedItems.add(clarifiedItem); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
      clarifiedItems.remove(clarifiedItem); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      var action = AddCommand(session, clarifiedItems, clarifiedItem); 
      action.doIt(); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
 
      session.past.undo(); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      session.past.redo(); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
    }); 
 
    test("ClarifiedItem update undo and redo", () { 
      var clarifiedItem = gtdModel.clarifiedItems.random(); 
      var action = SetAttributeCommand(session, clarifiedItem, "nextAction", 'cinema'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(clarifiedItem.nextAction, equals(action.before)); 
 
      session.past.redo(); 
      expect(clarifiedItem.nextAction, equals(action.after)); 
    }); 
 
    test("ClarifiedItem action with multiple undos and redos", () { 
      var clarifiedItemCount = clarifiedItems.length; 
      var clarifiedItem1 = gtdModel.clarifiedItems.random(); 
 
      var action1 = RemoveCommand(session, clarifiedItems, clarifiedItem1); 
      action1.doIt(); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      var clarifiedItem2 = gtdModel.clarifiedItems.random(); 
 
      var action2 = RemoveCommand(session, clarifiedItems, clarifiedItem2); 
      action2.doIt(); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
 
      session.past.undo(); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      session.past.redo(); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var clarifiedItemCount = clarifiedItems.length; 
      var clarifiedItem1 = gtdModel.clarifiedItems.random(); 
      var clarifiedItem2 = gtdModel.clarifiedItems.random(); 
      while (clarifiedItem1 == clarifiedItem2) { 
        clarifiedItem2 = gtdModel.clarifiedItems.random();  
      } 
      var action1 = RemoveCommand(session, clarifiedItems, clarifiedItem1); 
      var action2 = RemoveCommand(session, clarifiedItems, clarifiedItem2); 
 
      var transaction = new Transaction("two removes on clarifiedItems", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      clarifiedItemCount = clarifiedItemCount - 2; 
      expect(clarifiedItems.length, equals(clarifiedItemCount)); 
 
      clarifiedItems.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      clarifiedItemCount = clarifiedItemCount + 2; 
      expect(clarifiedItems.length, equals(clarifiedItemCount)); 
 
      clarifiedItems.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      clarifiedItemCount = clarifiedItemCount - 2; 
      expect(clarifiedItems.length, equals(clarifiedItemCount)); 
 
      clarifiedItems.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var clarifiedItemCount = clarifiedItems.length; 
      var clarifiedItem1 = gtdModel.clarifiedItems.random(); 
      var clarifiedItem2 = clarifiedItem1; 
      var action1 = RemoveCommand(session, clarifiedItems, clarifiedItem1); 
      var action2 = RemoveCommand(session, clarifiedItems, clarifiedItem2); 
 
      var transaction = Transaction( 
        "two removes on clarifiedItems, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(clarifiedItems.length, equals(clarifiedItemCount)); 
 
      //clarifiedItems.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to clarifiedItem actions", () { 
      var clarifiedItemCount = clarifiedItems.length; 
 
      var reaction = ClarifiedItemReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var clarifiedItem = ClarifiedItem(clarifiedItems.concept); 
        clarifiedItem.nextAction = 'text'; 
    var clarifiedItemInbox = gtdModel.inboxes.random(); 
    clarifiedItem.inbox = clarifiedItemInbox; 
      clarifiedItems.add(clarifiedItem); 
    clarifiedItemInbox.clarifiedItems.add(clarifiedItem); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
      clarifiedItems.remove(clarifiedItem); 
      expect(clarifiedItems.length, equals(--clarifiedItemCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, clarifiedItems, clarifiedItem); 
      addCommand.doIt(); 
      expect(clarifiedItems.length, equals(++clarifiedItemCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, clarifiedItem, "nextAction", 'secretary'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ClarifiedItemReaction implements ICommandReaction { 
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
  var clarifiedItems = gtdModel.clarifiedItems; 
  testProjectGtdClarifiedItems(projectDomain, gtdModel, clarifiedItems); 
} 
 
