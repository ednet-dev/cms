 
// test/democracy/direct/democracy_direct_election_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:democracy_direct/democracy_direct.dart"; 
 
void testDemocracyDirectElections( 
    DemocracyDomain democracyDomain, DirectModel directModel, Elections elections) { 
  DomainSession session; 
  group("Testing Democracy.Direct.Election", () { 
    session = democracyDomain.newSession();  
    setUp(() { 
      directModel.init(); 
    }); 
    tearDown(() { 
      directModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(directModel.isEmpty, isFalse); 
      expect(elections.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      directModel.clear(); 
      expect(directModel.isEmpty, isTrue); 
      expect(elections.isEmpty, isTrue); 
      expect(elections.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = directModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //directModel.displayJson(); 
      //directModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = directModel.toJson(); 
      directModel.clear(); 
      expect(directModel.isEmpty, isTrue); 
      directModel.fromJson(json); 
      expect(directModel.isEmpty, isFalse); 
 
      directModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = directModel.fromEntryToJson("Election"); 
      expect(json, isNotNull); 
 
      print(json); 
      //directModel.displayEntryJson("Election"); 
      //directModel.displayJson(); 
      //directModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = directModel.fromEntryToJson("Election"); 
      elections.clear(); 
      expect(elections.isEmpty, isTrue); 
      directModel.fromJsonToEntry(json); 
      expect(elections.isEmpty, isFalse); 
 
      elections.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add election required error", () { 
      var electionConcept = elections.concept; 
      var electionCount = elections.length; 
      var election = Election(electionConcept); 
      var isAdded = elections.add(election); 
      expect(isAdded, isFalse); 
      expect(elections.length, equals(electionCount)); 
      expect(elections.exceptions.length, greaterThan(0)); 
      expect(elections.exceptions.toList()[0].category, equals("required")); 
 
      elections.exceptions.display(title: "Add election required error"); 
    }); 
 
    test("Add election unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found election by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var election = elections.singleWhereOid(ednetOid); 
      expect(election, isNull); 
    }); 
 
    test("Find election by oid", () { 
      var randomElection = directModel.elections.random(); 
      var election = elections.singleWhereOid(randomElection.oid); 
      expect(election, isNotNull); 
      expect(election, equals(randomElection)); 
    }); 
 
    test("Find election by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find election by required attribute", () { 
      var randomElection = directModel.elections.random(); 
      var election = 
          elections.firstWhereAttribute("title", randomElection.title); 
      expect(election, isNotNull); 
      expect(election.title, equals(randomElection.title)); 
    }); 
 
    test("Find election by attribute", () { 
      var randomElection = directModel.elections.random(); 
      var election = 
          elections.firstWhereAttribute("description", randomElection.description); 
      expect(election, isNotNull); 
      expect(election.description, equals(randomElection.description)); 
    }); 
 
    test("Select elections by attribute", () { 
      var randomElection = directModel.elections.random(); 
      var selectedElections = 
          elections.selectWhereAttribute("description", randomElection.description); 
      expect(selectedElections.isEmpty, isFalse); 
      selectedElections.forEach((se) => 
          expect(se.description, equals(randomElection.description))); 
 
      //selectedElections.display(title: "Select elections by description"); 
    }); 
 
    test("Select elections by required attribute", () { 
      var randomElection = directModel.elections.random(); 
      var selectedElections = 
          elections.selectWhereAttribute("title", randomElection.title); 
      expect(selectedElections.isEmpty, isFalse); 
      selectedElections.forEach((se) => 
          expect(se.title, equals(randomElection.title))); 
 
      //selectedElections.display(title: "Select elections by title"); 
    }); 
 
    test("Select elections by attribute, then add", () { 
      var randomElection = directModel.elections.random(); 
      var selectedElections = 
          elections.selectWhereAttribute("title", randomElection.title); 
      expect(selectedElections.isEmpty, isFalse); 
      expect(selectedElections.source?.isEmpty, isFalse); 
      var electionsCount = elections.length; 
 
      var election = Election(elections.concept); 
      election.title = 'chemist'; 
      election.description = 'heating'; 
      var added = selectedElections.add(election); 
      expect(added, isTrue); 
      expect(elections.length, equals(++electionsCount)); 
 
      //selectedElections.display(title: 
      //  "Select elections by attribute, then add"); 
      //elections.display(title: "All elections"); 
    }); 
 
    test("Select elections by attribute, then remove", () { 
      var randomElection = directModel.elections.random(); 
      var selectedElections = 
          elections.selectWhereAttribute("title", randomElection.title); 
      expect(selectedElections.isEmpty, isFalse); 
      expect(selectedElections.source?.isEmpty, isFalse); 
      var electionsCount = elections.length; 
 
      var removed = selectedElections.remove(randomElection); 
      expect(removed, isTrue); 
      expect(elections.length, equals(--electionsCount)); 
 
      randomElection.display(prefix: "removed"); 
      //selectedElections.display(title: 
      //  "Select elections by attribute, then remove"); 
      //elections.display(title: "All elections"); 
    }); 
 
    test("Sort elections", () { 
      // no id attribute 
      // add compareTo method in the specific Election class 
      /* 
      elections.sort(); 
 
      //elections.display(title: "Sort elections"); 
      */ 
    }); 
 
    test("Order elections", () { 
      // no id attribute 
      // add compareTo method in the specific Election class 
      /* 
      var orderedElections = elections.order(); 
      expect(orderedElections.isEmpty, isFalse); 
      expect(orderedElections.length, equals(elections.length)); 
      expect(orderedElections.source?.isEmpty, isFalse); 
      expect(orderedElections.source?.length, equals(elections.length)); 
      expect(orderedElections, isNot(same(elections))); 
 
      //orderedElections.display(title: "Order elections"); 
      */ 
    }); 
 
    test("Copy elections", () { 
      var copiedElections = elections.copy(); 
      expect(copiedElections.isEmpty, isFalse); 
      expect(copiedElections.length, equals(elections.length)); 
      expect(copiedElections, isNot(same(elections))); 
      copiedElections.forEach((e) => 
        expect(e, equals(elections.singleWhereOid(e.oid)))); 
 
      //copiedElections.display(title: "Copy elections"); 
    }); 
 
    test("True for every election", () { 
      expect(elections.every((e) => e.title != null), isTrue); 
    }); 
 
    test("Random election", () { 
      var election1 = directModel.elections.random(); 
      expect(election1, isNotNull); 
      var election2 = directModel.elections.random(); 
      expect(election2, isNotNull); 
 
      //election1.display(prefix: "random1"); 
      //election2.display(prefix: "random2"); 
    }); 
 
    test("Update election id with try", () { 
      // no id attribute 
    }); 
 
    test("Update election id without try", () { 
      // no id attribute 
    }); 
 
    test("Update election id with success", () { 
      // no id attribute 
    }); 
 
    test("Update election non id attribute with failure", () { 
      var randomElection = directModel.elections.random(); 
      var afterUpdateEntity = randomElection.copy(); 
      afterUpdateEntity.title = 'consulting'; 
      expect(afterUpdateEntity.title, equals('consulting')); 
      // elections.update can only be used if oid, code or id is set. 
      expect(() => elections.update(randomElection, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomElection = directModel.elections.random(); 
      randomElection.display(prefix:"before copy: "); 
      var randomElectionCopy = randomElection.copy(); 
      randomElectionCopy.display(prefix:"after copy: "); 
      expect(randomElection, equals(randomElectionCopy)); 
      expect(randomElection.oid, equals(randomElectionCopy.oid)); 
      expect(randomElection.code, equals(randomElectionCopy.code)); 
      expect(randomElection.title, equals(randomElectionCopy.title)); 
      expect(randomElection.description, equals(randomElectionCopy.description)); 
 
    }); 
 
    test("election action undo and redo", () { 
      var electionCount = elections.length; 
      var election = Election(elections.concept); 
        election.title = 'book'; 
      election.description = 'cash'; 
    var electionCandidate = directModel.citizens.random(); 
    election.candidate = electionCandidate; 
      elections.add(election); 
    electionCandidate.elections.add(election); 
      expect(elections.length, equals(++electionCount)); 
      elections.remove(election); 
      expect(elections.length, equals(--electionCount)); 
 
      var action = AddCommand(session, elections, election); 
      action.doIt(); 
      expect(elections.length, equals(++electionCount)); 
 
      action.undo(); 
      expect(elections.length, equals(--electionCount)); 
 
      action.redo(); 
      expect(elections.length, equals(++electionCount)); 
    }); 
 
    test("election session undo and redo", () { 
      var electionCount = elections.length; 
      var election = Election(elections.concept); 
        election.title = 'pub'; 
      election.description = 'heating'; 
    var electionCandidate = directModel.citizens.random(); 
    election.candidate = electionCandidate; 
      elections.add(election); 
    electionCandidate.elections.add(election); 
      expect(elections.length, equals(++electionCount)); 
      elections.remove(election); 
      expect(elections.length, equals(--electionCount)); 
 
      var action = AddCommand(session, elections, election); 
      action.doIt(); 
      expect(elections.length, equals(++electionCount)); 
 
      session.past.undo(); 
      expect(elections.length, equals(--electionCount)); 
 
      session.past.redo(); 
      expect(elections.length, equals(++electionCount)); 
    }); 
 
    test("Election update undo and redo", () { 
      var election = directModel.elections.random(); 
      var action = SetAttributeCommand(session, election, "title", 'umbrella'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(election.title, equals(action.before)); 
 
      session.past.redo(); 
      expect(election.title, equals(action.after)); 
    }); 
 
    test("Election action with multiple undos and redos", () { 
      var electionCount = elections.length; 
      var election1 = directModel.elections.random(); 
 
      var action1 = RemoveCommand(session, elections, election1); 
      action1.doIt(); 
      expect(elections.length, equals(--electionCount)); 
 
      var election2 = directModel.elections.random(); 
 
      var action2 = RemoveCommand(session, elections, election2); 
      action2.doIt(); 
      expect(elections.length, equals(--electionCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(elections.length, equals(++electionCount)); 
 
      session.past.undo(); 
      expect(elections.length, equals(++electionCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(elections.length, equals(--electionCount)); 
 
      session.past.redo(); 
      expect(elections.length, equals(--electionCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var electionCount = elections.length; 
      var election1 = directModel.elections.random(); 
      var election2 = directModel.elections.random(); 
      while (election1 == election2) { 
        election2 = directModel.elections.random();  
      } 
      var action1 = RemoveCommand(session, elections, election1); 
      var action2 = RemoveCommand(session, elections, election2); 
 
      var transaction = new Transaction("two removes on elections", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      electionCount = electionCount - 2; 
      expect(elections.length, equals(electionCount)); 
 
      elections.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      electionCount = electionCount + 2; 
      expect(elections.length, equals(electionCount)); 
 
      elections.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      electionCount = electionCount - 2; 
      expect(elections.length, equals(electionCount)); 
 
      elections.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var electionCount = elections.length; 
      var election1 = directModel.elections.random(); 
      var election2 = election1; 
      var action1 = RemoveCommand(session, elections, election1); 
      var action2 = RemoveCommand(session, elections, election2); 
 
      var transaction = Transaction( 
        "two removes on elections, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(elections.length, equals(electionCount)); 
 
      //elections.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to election actions", () { 
      var electionCount = elections.length; 
 
      var reaction = ElectionReaction(); 
      expect(reaction, isNotNull); 
 
      democracyDomain.startCommandReaction(reaction); 
      var election = Election(elections.concept); 
        election.title = 'opinion'; 
      election.description = 'plate'; 
    var electionCandidate = directModel.citizens.random(); 
    election.candidate = electionCandidate; 
      elections.add(election); 
    electionCandidate.elections.add(election); 
      expect(elections.length, equals(++electionCount)); 
      elections.remove(election); 
      expect(elections.length, equals(--electionCount)); 
 
      var session = democracyDomain.newSession(); 
      var addCommand = AddCommand(session, elections, election); 
      addCommand.doIt(); 
      expect(elections.length, equals(++electionCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, election, "title", 'thing'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      democracyDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ElectionReaction implements ICommandReaction { 
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
  var repository = DemocracyDirectRepo(); 
  DemocracyDomain democracyDomain = repository.getDomainModels("Democracy") as DemocracyDomain;   
  assert(democracyDomain != null); 
  DirectModel directModel = democracyDomain.getModelEntries("Direct") as DirectModel;  
  assert(directModel != null); 
  var elections = directModel.elections; 
  testDemocracyDirectElections(democracyDomain, directModel, elections); 
} 
 
