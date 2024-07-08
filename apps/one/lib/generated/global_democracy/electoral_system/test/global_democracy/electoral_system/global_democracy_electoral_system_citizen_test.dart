 
// test/global_democracy/electoral_system/global_democracy_electoral_system_citizen_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:global_democracy_electoral_system/global_democracy_electoral_system.dart"; 
 
void testGlobal_democracyElectoral_systemCitizens( 
    Global_democracyDomain global_democracyDomain, Electoral_systemModel electoral_systemModel, Citizens citizens) { 
  DomainSession session; 
  group("Testing Global_democracy.Electoral_system.Citizen", () { 
    session = global_democracyDomain.newSession();  
    setUp(() { 
      electoral_systemModel.init(); 
    }); 
    tearDown(() { 
      electoral_systemModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(electoral_systemModel.isEmpty, isFalse); 
      expect(citizens.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      electoral_systemModel.clear(); 
      expect(electoral_systemModel.isEmpty, isTrue); 
      expect(citizens.isEmpty, isTrue); 
      expect(citizens.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = electoral_systemModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //electoral_systemModel.displayJson(); 
      //electoral_systemModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = electoral_systemModel.toJson(); 
      electoral_systemModel.clear(); 
      expect(electoral_systemModel.isEmpty, isTrue); 
      electoral_systemModel.fromJson(json); 
      expect(electoral_systemModel.isEmpty, isFalse); 
 
      electoral_systemModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = electoral_systemModel.fromEntryToJson("Citizen"); 
      expect(json, isNotNull); 
 
      print(json); 
      //electoral_systemModel.displayEntryJson("Citizen"); 
      //electoral_systemModel.displayJson(); 
      //electoral_systemModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = electoral_systemModel.fromEntryToJson("Citizen"); 
      citizens.clear(); 
      expect(citizens.isEmpty, isTrue); 
      electoral_systemModel.fromJsonToEntry(json); 
      expect(citizens.isEmpty, isFalse); 
 
      citizens.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add citizen required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add citizen unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found citizen by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var citizen = citizens.singleWhereOid(ednetOid); 
      expect(citizen, isNull); 
    }); 
 
    test("Find citizen by oid", () { 
      var randomCitizen = electoral_systemModel.citizens.random(); 
      var citizen = citizens.singleWhereOid(randomCitizen.oid); 
      expect(citizen, isNotNull); 
      expect(citizen, equals(randomCitizen)); 
    }); 
 
    test("Find citizen by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find citizen by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find citizen by attribute", () { 
      var randomCitizen = electoral_systemModel.citizens.random(); 
      var citizen = 
          citizens.firstWhereAttribute("citizenId", randomCitizen.citizenId); 
      expect(citizen, isNotNull); 
      expect(citizen.citizenId, equals(randomCitizen.citizenId)); 
    }); 
 
    test("Select citizens by attribute", () { 
      var randomCitizen = electoral_systemModel.citizens.random(); 
      var selectedCitizens = 
          citizens.selectWhereAttribute("citizenId", randomCitizen.citizenId); 
      expect(selectedCitizens.isEmpty, isFalse); 
      selectedCitizens.forEach((se) => 
          expect(se.citizenId, equals(randomCitizen.citizenId))); 
 
      //selectedCitizens.display(title: "Select citizens by citizenId"); 
    }); 
 
    test("Select citizens by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select citizens by attribute, then add", () { 
      var randomCitizen = electoral_systemModel.citizens.random(); 
      var selectedCitizens = 
          citizens.selectWhereAttribute("citizenId", randomCitizen.citizenId); 
      expect(selectedCitizens.isEmpty, isFalse); 
      expect(selectedCitizens.source?.isEmpty, isFalse); 
      var citizensCount = citizens.length; 
 
      var citizen = Citizen(citizens.concept); 
      citizen.citizenId = 'hall'; 
      citizen.name = 'agile'; 
      var added = selectedCitizens.add(citizen); 
      expect(added, isTrue); 
      expect(citizens.length, equals(++citizensCount)); 
 
      //selectedCitizens.display(title: 
      //  "Select citizens by attribute, then add"); 
      //citizens.display(title: "All citizens"); 
    }); 
 
    test("Select citizens by attribute, then remove", () { 
      var randomCitizen = electoral_systemModel.citizens.random(); 
      var selectedCitizens = 
          citizens.selectWhereAttribute("citizenId", randomCitizen.citizenId); 
      expect(selectedCitizens.isEmpty, isFalse); 
      expect(selectedCitizens.source?.isEmpty, isFalse); 
      var citizensCount = citizens.length; 
 
      var removed = selectedCitizens.remove(randomCitizen); 
      expect(removed, isTrue); 
      expect(citizens.length, equals(--citizensCount)); 
 
      randomCitizen.display(prefix: "removed"); 
      //selectedCitizens.display(title: 
      //  "Select citizens by attribute, then remove"); 
      //citizens.display(title: "All citizens"); 
    }); 
 
    test("Sort citizens", () { 
      // no id attribute 
      // add compareTo method in the specific Citizen class 
      /* 
      citizens.sort(); 
 
      //citizens.display(title: "Sort citizens"); 
      */ 
    }); 
 
    test("Order citizens", () { 
      // no id attribute 
      // add compareTo method in the specific Citizen class 
      /* 
      var orderedCitizens = citizens.order(); 
      expect(orderedCitizens.isEmpty, isFalse); 
      expect(orderedCitizens.length, equals(citizens.length)); 
      expect(orderedCitizens.source?.isEmpty, isFalse); 
      expect(orderedCitizens.source?.length, equals(citizens.length)); 
      expect(orderedCitizens, isNot(same(citizens))); 
 
      //orderedCitizens.display(title: "Order citizens"); 
      */ 
    }); 
 
    test("Copy citizens", () { 
      var copiedCitizens = citizens.copy(); 
      expect(copiedCitizens.isEmpty, isFalse); 
      expect(copiedCitizens.length, equals(citizens.length)); 
      expect(copiedCitizens, isNot(same(citizens))); 
      copiedCitizens.forEach((e) => 
        expect(e, equals(citizens.singleWhereOid(e.oid)))); 
 
      //copiedCitizens.display(title: "Copy citizens"); 
    }); 
 
    test("True for every citizen", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random citizen", () { 
      var citizen1 = electoral_systemModel.citizens.random(); 
      expect(citizen1, isNotNull); 
      var citizen2 = electoral_systemModel.citizens.random(); 
      expect(citizen2, isNotNull); 
 
      //citizen1.display(prefix: "random1"); 
      //citizen2.display(prefix: "random2"); 
    }); 
 
    test("Update citizen id with try", () { 
      // no id attribute 
    }); 
 
    test("Update citizen id without try", () { 
      // no id attribute 
    }); 
 
    test("Update citizen id with success", () { 
      // no id attribute 
    }); 
 
    test("Update citizen non id attribute with failure", () { 
      var randomCitizen = electoral_systemModel.citizens.random(); 
      var afterUpdateEntity = randomCitizen.copy(); 
      afterUpdateEntity.citizenId = 'debt'; 
      expect(afterUpdateEntity.citizenId, equals('debt')); 
      // citizens.update can only be used if oid, code or id is set. 
      expect(() => citizens.update(randomCitizen, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomCitizen = electoral_systemModel.citizens.random(); 
      randomCitizen.display(prefix:"before copy: "); 
      var randomCitizenCopy = randomCitizen.copy(); 
      randomCitizenCopy.display(prefix:"after copy: "); 
      expect(randomCitizen, equals(randomCitizenCopy)); 
      expect(randomCitizen.oid, equals(randomCitizenCopy.oid)); 
      expect(randomCitizen.code, equals(randomCitizenCopy.code)); 
      expect(randomCitizen.citizenId, equals(randomCitizenCopy.citizenId)); 
      expect(randomCitizen.name, equals(randomCitizenCopy.name)); 
 
    }); 
 
    test("citizen action undo and redo", () { 
      var citizenCount = citizens.length; 
      var citizen = Citizen(citizens.concept); 
        citizen.citizenId = 'heating'; 
      citizen.name = 'ship'; 
      citizens.add(citizen); 
      expect(citizens.length, equals(++citizenCount)); 
      citizens.remove(citizen); 
      expect(citizens.length, equals(--citizenCount)); 
 
      var action = AddCommand(session, citizens, citizen); 
      action.doIt(); 
      expect(citizens.length, equals(++citizenCount)); 
 
      action.undo(); 
      expect(citizens.length, equals(--citizenCount)); 
 
      action.redo(); 
      expect(citizens.length, equals(++citizenCount)); 
    }); 
 
    test("citizen session undo and redo", () { 
      var citizenCount = citizens.length; 
      var citizen = Citizen(citizens.concept); 
        citizen.citizenId = 'agreement'; 
      citizen.name = 'family'; 
      citizens.add(citizen); 
      expect(citizens.length, equals(++citizenCount)); 
      citizens.remove(citizen); 
      expect(citizens.length, equals(--citizenCount)); 
 
      var action = AddCommand(session, citizens, citizen); 
      action.doIt(); 
      expect(citizens.length, equals(++citizenCount)); 
 
      session.past.undo(); 
      expect(citizens.length, equals(--citizenCount)); 
 
      session.past.redo(); 
      expect(citizens.length, equals(++citizenCount)); 
    }); 
 
    test("Citizen update undo and redo", () { 
      var citizen = electoral_systemModel.citizens.random(); 
      var action = SetAttributeCommand(session, citizen, "citizenId", 'text'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(citizen.citizenId, equals(action.before)); 
 
      session.past.redo(); 
      expect(citizen.citizenId, equals(action.after)); 
    }); 
 
    test("Citizen action with multiple undos and redos", () { 
      var citizenCount = citizens.length; 
      var citizen1 = electoral_systemModel.citizens.random(); 
 
      var action1 = RemoveCommand(session, citizens, citizen1); 
      action1.doIt(); 
      expect(citizens.length, equals(--citizenCount)); 
 
      var citizen2 = electoral_systemModel.citizens.random(); 
 
      var action2 = RemoveCommand(session, citizens, citizen2); 
      action2.doIt(); 
      expect(citizens.length, equals(--citizenCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(citizens.length, equals(++citizenCount)); 
 
      session.past.undo(); 
      expect(citizens.length, equals(++citizenCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(citizens.length, equals(--citizenCount)); 
 
      session.past.redo(); 
      expect(citizens.length, equals(--citizenCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var citizenCount = citizens.length; 
      var citizen1 = electoral_systemModel.citizens.random(); 
      var citizen2 = electoral_systemModel.citizens.random(); 
      while (citizen1 == citizen2) { 
        citizen2 = electoral_systemModel.citizens.random();  
      } 
      var action1 = RemoveCommand(session, citizens, citizen1); 
      var action2 = RemoveCommand(session, citizens, citizen2); 
 
      var transaction = new Transaction("two removes on citizens", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      citizenCount = citizenCount - 2; 
      expect(citizens.length, equals(citizenCount)); 
 
      citizens.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      citizenCount = citizenCount + 2; 
      expect(citizens.length, equals(citizenCount)); 
 
      citizens.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      citizenCount = citizenCount - 2; 
      expect(citizens.length, equals(citizenCount)); 
 
      citizens.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var citizenCount = citizens.length; 
      var citizen1 = electoral_systemModel.citizens.random(); 
      var citizen2 = citizen1; 
      var action1 = RemoveCommand(session, citizens, citizen1); 
      var action2 = RemoveCommand(session, citizens, citizen2); 
 
      var transaction = Transaction( 
        "two removes on citizens, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(citizens.length, equals(citizenCount)); 
 
      //citizens.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to citizen actions", () { 
      var citizenCount = citizens.length; 
 
      var reaction = CitizenReaction(); 
      expect(reaction, isNotNull); 
 
      global_democracyDomain.startCommandReaction(reaction); 
      var citizen = Citizen(citizens.concept); 
        citizen.citizenId = 'circle'; 
      citizen.name = 'hunting'; 
      citizens.add(citizen); 
      expect(citizens.length, equals(++citizenCount)); 
      citizens.remove(citizen); 
      expect(citizens.length, equals(--citizenCount)); 
 
      var session = global_democracyDomain.newSession(); 
      var addCommand = AddCommand(session, citizens, citizen); 
      addCommand.doIt(); 
      expect(citizens.length, equals(++citizenCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, citizen, "citizenId", 'future'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      global_democracyDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class CitizenReaction implements ICommandReaction { 
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
  var repository = GlobalDemocracyElectoralSystemRepo();
  Global_democracyDomain global_democracyDomain = repository.getDomainModels("Global_democracy") as Global_democracyDomain;   
  assert(global_democracyDomain != null); 
  Electoral_systemModel electoral_systemModel = global_democracyDomain.getModelEntries("Electoral_system") as Electoral_systemModel;  
  assert(electoral_systemModel != null); 
  var citizens = electoral_systemModel.citizens; 
  testGlobal_democracyElectoral_systemCitizens(global_democracyDomain, electoral_systemModel, citizens); 
} 
 
