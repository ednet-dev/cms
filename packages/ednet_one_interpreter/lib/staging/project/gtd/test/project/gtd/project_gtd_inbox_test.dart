 
// test/project/gtd/project_gtd_inbox_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_gtd/project_gtd.dart"; 
 
void testProjectGtdInboxes( 
    ProjectDomain projectDomain, GtdModel gtdModel, Inboxes inboxes) { 
  DomainSession session; 
  group("Testing Project.Gtd.Inbox", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      gtdModel.init(); 
    }); 
    tearDown(() { 
      gtdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(gtdModel.isEmpty, isFalse); 
      expect(inboxes.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      expect(inboxes.isEmpty, isTrue); 
      expect(inboxes.exceptions.isEmpty, isTrue); 
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
      var json = gtdModel.fromEntryToJson("Inbox"); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayEntryJson("Inbox"); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = gtdModel.fromEntryToJson("Inbox"); 
      inboxes.clear(); 
      expect(inboxes.isEmpty, isTrue); 
      gtdModel.fromJsonToEntry(json); 
      expect(inboxes.isEmpty, isFalse); 
 
      inboxes.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add inbox required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add inbox unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found inbox by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var inbox = inboxes.singleWhereOid(ednetOid); 
      expect(inbox, isNull); 
    }); 
 
    test("Find inbox by oid", () { 
      var randomInbox = gtdModel.inboxes.random(); 
      var inbox = inboxes.singleWhereOid(randomInbox.oid); 
      expect(inbox, isNotNull); 
      expect(inbox, equals(randomInbox)); 
    }); 
 
    test("Find inbox by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find inbox by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find inbox by attribute", () { 
      var randomInbox = gtdModel.inboxes.random(); 
      var inbox = 
          inboxes.firstWhereAttribute("items", randomInbox.items); 
      expect(inbox, isNotNull); 
      expect(inbox.items, equals(randomInbox.items)); 
    }); 
 
    test("Select inboxes by attribute", () { 
      var randomInbox = gtdModel.inboxes.random(); 
      var selectedInboxes = 
          inboxes.selectWhereAttribute("items", randomInbox.items); 
      expect(selectedInboxes.isEmpty, isFalse); 
      selectedInboxes.forEach((se) => 
          expect(se.items, equals(randomInbox.items))); 
 
      //selectedInboxes.display(title: "Select inboxes by items"); 
    }); 
 
    test("Select inboxes by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select inboxes by attribute, then add", () { 
      var randomInbox = gtdModel.inboxes.random(); 
      var selectedInboxes = 
          inboxes.selectWhereAttribute("items", randomInbox.items); 
      expect(selectedInboxes.isEmpty, isFalse); 
      expect(selectedInboxes.source?.isEmpty, isFalse); 
      var inboxesCount = inboxes.length; 
 
      var inbox = Inbox(inboxes.concept); 
      inbox.items = 'message'; 
      var added = selectedInboxes.add(inbox); 
      expect(added, isTrue); 
      expect(inboxes.length, equals(++inboxesCount)); 
 
      //selectedInboxes.display(title: 
      //  "Select inboxes by attribute, then add"); 
      //inboxes.display(title: "All inboxes"); 
    }); 
 
    test("Select inboxes by attribute, then remove", () { 
      var randomInbox = gtdModel.inboxes.random(); 
      var selectedInboxes = 
          inboxes.selectWhereAttribute("items", randomInbox.items); 
      expect(selectedInboxes.isEmpty, isFalse); 
      expect(selectedInboxes.source?.isEmpty, isFalse); 
      var inboxesCount = inboxes.length; 
 
      var removed = selectedInboxes.remove(randomInbox); 
      expect(removed, isTrue); 
      expect(inboxes.length, equals(--inboxesCount)); 
 
      randomInbox.display(prefix: "removed"); 
      //selectedInboxes.display(title: 
      //  "Select inboxes by attribute, then remove"); 
      //inboxes.display(title: "All inboxes"); 
    }); 
 
    test("Sort inboxes", () { 
      // no id attribute 
      // add compareTo method in the specific Inbox class 
      /* 
      inboxes.sort(); 
 
      //inboxes.display(title: "Sort inboxes"); 
      */ 
    }); 
 
    test("Order inboxes", () { 
      // no id attribute 
      // add compareTo method in the specific Inbox class 
      /* 
      var orderedInboxes = inboxes.order(); 
      expect(orderedInboxes.isEmpty, isFalse); 
      expect(orderedInboxes.length, equals(inboxes.length)); 
      expect(orderedInboxes.source?.isEmpty, isFalse); 
      expect(orderedInboxes.source?.length, equals(inboxes.length)); 
      expect(orderedInboxes, isNot(same(inboxes))); 
 
      //orderedInboxes.display(title: "Order inboxes"); 
      */ 
    }); 
 
    test("Copy inboxes", () { 
      var copiedInboxes = inboxes.copy(); 
      expect(copiedInboxes.isEmpty, isFalse); 
      expect(copiedInboxes.length, equals(inboxes.length)); 
      expect(copiedInboxes, isNot(same(inboxes))); 
      copiedInboxes.forEach((e) => 
        expect(e, equals(inboxes.singleWhereOid(e.oid)))); 
 
      //copiedInboxes.display(title: "Copy inboxes"); 
    }); 
 
    test("True for every inbox", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random inbox", () { 
      var inbox1 = gtdModel.inboxes.random(); 
      expect(inbox1, isNotNull); 
      var inbox2 = gtdModel.inboxes.random(); 
      expect(inbox2, isNotNull); 
 
      //inbox1.display(prefix: "random1"); 
      //inbox2.display(prefix: "random2"); 
    }); 
 
    test("Update inbox id with try", () { 
      // no id attribute 
    }); 
 
    test("Update inbox id without try", () { 
      // no id attribute 
    }); 
 
    test("Update inbox id with success", () { 
      // no id attribute 
    }); 
 
    test("Update inbox non id attribute with failure", () { 
      var randomInbox = gtdModel.inboxes.random(); 
      var afterUpdateEntity = randomInbox.copy(); 
      afterUpdateEntity.items = 'hall'; 
      expect(afterUpdateEntity.items, equals('hall')); 
      // inboxes.update can only be used if oid, code or id is set. 
      expect(() => inboxes.update(randomInbox, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomInbox = gtdModel.inboxes.random(); 
      randomInbox.display(prefix:"before copy: "); 
      var randomInboxCopy = randomInbox.copy(); 
      randomInboxCopy.display(prefix:"after copy: "); 
      expect(randomInbox, equals(randomInboxCopy)); 
      expect(randomInbox.oid, equals(randomInboxCopy.oid)); 
      expect(randomInbox.code, equals(randomInboxCopy.code)); 
      expect(randomInbox.items, equals(randomInboxCopy.items)); 
 
    }); 
 
    test("inbox action undo and redo", () { 
      var inboxCount = inboxes.length; 
      var inbox = Inbox(inboxes.concept); 
        inbox.items = 'crisis'; 
      inboxes.add(inbox); 
      expect(inboxes.length, equals(++inboxCount)); 
      inboxes.remove(inbox); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      var action = AddCommand(session, inboxes, inbox); 
      action.doIt(); 
      expect(inboxes.length, equals(++inboxCount)); 
 
      action.undo(); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      action.redo(); 
      expect(inboxes.length, equals(++inboxCount)); 
    }); 
 
    test("inbox session undo and redo", () { 
      var inboxCount = inboxes.length; 
      var inbox = Inbox(inboxes.concept); 
        inbox.items = 'water'; 
      inboxes.add(inbox); 
      expect(inboxes.length, equals(++inboxCount)); 
      inboxes.remove(inbox); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      var action = AddCommand(session, inboxes, inbox); 
      action.doIt(); 
      expect(inboxes.length, equals(++inboxCount)); 
 
      session.past.undo(); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      session.past.redo(); 
      expect(inboxes.length, equals(++inboxCount)); 
    }); 
 
    test("Inbox update undo and redo", () { 
      var inbox = gtdModel.inboxes.random(); 
      var action = SetAttributeCommand(session, inbox, "items", 'seed'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(inbox.items, equals(action.before)); 
 
      session.past.redo(); 
      expect(inbox.items, equals(action.after)); 
    }); 
 
    test("Inbox action with multiple undos and redos", () { 
      var inboxCount = inboxes.length; 
      var inbox1 = gtdModel.inboxes.random(); 
 
      var action1 = RemoveCommand(session, inboxes, inbox1); 
      action1.doIt(); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      var inbox2 = gtdModel.inboxes.random(); 
 
      var action2 = RemoveCommand(session, inboxes, inbox2); 
      action2.doIt(); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(inboxes.length, equals(++inboxCount)); 
 
      session.past.undo(); 
      expect(inboxes.length, equals(++inboxCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      session.past.redo(); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var inboxCount = inboxes.length; 
      var inbox1 = gtdModel.inboxes.random(); 
      var inbox2 = gtdModel.inboxes.random(); 
      while (inbox1 == inbox2) { 
        inbox2 = gtdModel.inboxes.random();  
      } 
      var action1 = RemoveCommand(session, inboxes, inbox1); 
      var action2 = RemoveCommand(session, inboxes, inbox2); 
 
      var transaction = new Transaction("two removes on inboxes", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      inboxCount = inboxCount - 2; 
      expect(inboxes.length, equals(inboxCount)); 
 
      inboxes.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      inboxCount = inboxCount + 2; 
      expect(inboxes.length, equals(inboxCount)); 
 
      inboxes.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      inboxCount = inboxCount - 2; 
      expect(inboxes.length, equals(inboxCount)); 
 
      inboxes.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var inboxCount = inboxes.length; 
      var inbox1 = gtdModel.inboxes.random(); 
      var inbox2 = inbox1; 
      var action1 = RemoveCommand(session, inboxes, inbox1); 
      var action2 = RemoveCommand(session, inboxes, inbox2); 
 
      var transaction = Transaction( 
        "two removes on inboxes, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(inboxes.length, equals(inboxCount)); 
 
      //inboxes.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to inbox actions", () { 
      var inboxCount = inboxes.length; 
 
      var reaction = InboxReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var inbox = Inbox(inboxes.concept); 
        inbox.items = 'wheat'; 
      inboxes.add(inbox); 
      expect(inboxes.length, equals(++inboxCount)); 
      inboxes.remove(inbox); 
      expect(inboxes.length, equals(--inboxCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, inboxes, inbox); 
      addCommand.doIt(); 
      expect(inboxes.length, equals(++inboxCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, inbox, "items", 'email'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class InboxReaction implements ICommandReaction { 
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
  var inboxes = gtdModel.inboxes; 
  testProjectGtdInboxes(projectDomain, gtdModel, inboxes); 
} 
 
