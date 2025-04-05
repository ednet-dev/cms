 
// test/democracy/direct/democracy_direct_citizen_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:democracy_direct/democracy_direct.dart"; 
 
void testDemocracyDirectCitizens( 
    DemocracyDomain democracyDomain, DirectModel directModel, Citizens citizens) { 
  DomainSession session; 
  group("Testing Democracy.Direct.Citizen", () { 
    session = democracyDomain.newSession();  
    setUp(() { 
      directModel.init(); 
    }); 
    tearDown(() { 
      directModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(directModel.isEmpty, isFalse); 
      expect(citizens.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      directModel.clear(); 
      expect(directModel.isEmpty, isTrue); 
      expect(citizens.isEmpty, isTrue); 
      expect(citizens.exceptions.isEmpty, isTrue); 
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
      var json = directModel.fromEntryToJson("Citizen"); 
      expect(json, isNotNull); 
 
      print(json); 
      //directModel.displayEntryJson("Citizen"); 
      //directModel.displayJson(); 
      //directModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = directModel.fromEntryToJson("Citizen"); 
      citizens.clear(); 
      expect(citizens.isEmpty, isTrue); 
      directModel.fromJsonToEntry(json); 
      expect(citizens.isEmpty, isFalse); 
 
      citizens.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add citizen required error", () { 
      var citizenConcept = citizens.concept; 
      var citizenCount = citizens.length; 
      var citizen = Citizen(citizenConcept); 
      var isAdded = citizens.add(citizen); 
      expect(isAdded, isFalse); 
      expect(citizens.length, equals(citizenCount)); 
      expect(citizens.exceptions.length, greaterThan(0)); 
      expect(citizens.exceptions.toList()[0].category, equals("required")); 
 
      citizens.exceptions.display(title: "Add citizen required error"); 
    }); 
 
    test("Add citizen unique error", () { 
      var citizenConcept = citizens.concept; 
      var citizenCount = citizens.length; 
      var citizen = Citizen(citizenConcept); 
      var randomCitizen = directModel.citizens.random(); 
      citizen.citizenId = randomCitizen.citizenId; 
      var added = citizens.add(citizen); 
      expect(added, isFalse); 
      expect(citizens.length, equals(citizenCount)); 
      expect(citizens.exceptions.length, greaterThan(0)); 
 
      citizens.exceptions.display(title: "Add citizen unique error"); 
    }); 
 
    test("Not found citizen by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var citizen = citizens.singleWhereOid(ednetOid); 
      expect(citizen, isNull); 
    }); 
 
    test("Find citizen by oid", () { 
      var randomCitizen = directModel.citizens.random(); 
      var citizen = citizens.singleWhereOid(randomCitizen.oid); 
      expect(citizen, isNotNull); 
      expect(citizen, equals(randomCitizen)); 
    }); 
 
    test("Find citizen by attribute id", () { 
      var randomCitizen = directModel.citizens.random(); 
      var citizen = 
          citizens.singleWhereAttributeId("citizenId", randomCitizen.citizenId); 
      expect(citizen, isNotNull); 
      expect(citizen!.citizenId, equals(randomCitizen.citizenId)); 
    }); 
 
    test("Find citizen by required attribute", () { 
      var randomCitizen = directModel.citizens.random(); 
      var citizen = 
          citizens.firstWhereAttribute("firstName", randomCitizen.firstName); 
      expect(citizen, isNotNull); 
      expect(citizen.firstName, equals(randomCitizen.firstName)); 
    }); 
 
    test("Find citizen by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select citizens by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select citizens by required attribute", () { 
      var randomCitizen = directModel.citizens.random(); 
      var selectedCitizens = 
          citizens.selectWhereAttribute("firstName", randomCitizen.firstName); 
      expect(selectedCitizens.isEmpty, isFalse); 
      selectedCitizens.forEach((se) => 
          expect(se.firstName, equals(randomCitizen.firstName))); 
 
      //selectedCitizens.display(title: "Select citizens by firstName"); 
    }); 
 
    test("Select citizens by attribute, then add", () { 
      var randomCitizen = directModel.citizens.random(); 
      var selectedCitizens = 
          citizens.selectWhereAttribute("firstName", randomCitizen.firstName); 
      expect(selectedCitizens.isEmpty, isFalse); 
      expect(selectedCitizens.source?.isEmpty, isFalse); 
      var citizensCount = citizens.length; 
 
      var citizen = Citizen(citizens.concept); 
      citizen.citizenId = 'baby'; 
      citizen.firstName = 'dinner'; 
      citizen.lastName = 'beginning'; 
      var added = selectedCitizens.add(citizen); 
      expect(added, isTrue); 
      expect(citizens.length, equals(++citizensCount)); 
 
      //selectedCitizens.display(title: 
      //  "Select citizens by attribute, then add"); 
      //citizens.display(title: "All citizens"); 
    }); 
 
    test("Select citizens by attribute, then remove", () { 
      var randomCitizen = directModel.citizens.random(); 
      var selectedCitizens = 
          citizens.selectWhereAttribute("firstName", randomCitizen.firstName); 
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
      citizens.sort(); 
 
      //citizens.display(title: "Sort citizens"); 
    }); 
 
    test("Order citizens", () { 
      var orderedCitizens = citizens.order(); 
      expect(orderedCitizens.isEmpty, isFalse); 
      expect(orderedCitizens.length, equals(citizens.length)); 
      expect(orderedCitizens.source?.isEmpty, isFalse); 
      expect(orderedCitizens.source?.length, equals(citizens.length)); 
      expect(orderedCitizens, isNot(same(citizens))); 
 
      //orderedCitizens.display(title: "Order citizens"); 
    }); 
 
    test("Copy citizens", () { 
      var copiedCitizens = citizens.copy(); 
      expect(copiedCitizens.isEmpty, isFalse); 
      expect(copiedCitizens.length, equals(citizens.length)); 
      expect(copiedCitizens, isNot(same(citizens))); 
      copiedCitizens.forEach((e) => 
        expect(e, equals(citizens.singleWhereOid(e.oid)))); 
      copiedCitizens.forEach((e) => 
        expect(e, isNot(same(citizens.singleWhereId(e.id!))))); 
 
      //copiedCitizens.display(title: "Copy citizens"); 
    }); 
 
    test("True for every citizen", () { 
      expect(citizens.every((e) => e.firstName != null), isTrue); 
    }); 
 
    test("Random citizen", () { 
      var citizen1 = directModel.citizens.random(); 
      expect(citizen1, isNotNull); 
      var citizen2 = directModel.citizens.random(); 
      expect(citizen2, isNotNull); 
 
      //citizen1.display(prefix: "random1"); 
      //citizen2.display(prefix: "random2"); 
    }); 
 
    test("Update citizen id with try", () { 
      var randomCitizen = directModel.citizens.random(); 
      var beforeUpdate = randomCitizen.citizenId; 
      try { 
        randomCitizen.citizenId = 'salary'; 
      } on UpdateException catch (e) { 
        expect(randomCitizen.citizenId, equals(beforeUpdate)); 
      } 
    }); 
 
    test("Update citizen id without try", () { 
      var randomCitizen = directModel.citizens.random(); 
      var beforeUpdateValue = randomCitizen.citizenId; 
      expect(() => randomCitizen.citizenId = 'lunch', throws); 
      expect(randomCitizen.citizenId, equals(beforeUpdateValue)); 
    }); 
 
    test("Update citizen id with success", () { 
      var randomCitizen = directModel.citizens.random(); 
      var afterUpdateEntity = randomCitizen.copy(); 
      var attribute = randomCitizen.concept.attributes.singleWhereCode("citizenId"); 
      expect(attribute?.update, isFalse); 
      attribute?.update = true; 
      afterUpdateEntity.citizenId = 'consulting'; 
      expect(afterUpdateEntity.citizenId, equals('consulting')); 
      attribute?.update = false; 
      var updated = citizens.update(randomCitizen, afterUpdateEntity); 
      expect(updated, isTrue); 
 
      var entity = citizens.singleWhereAttributeId("citizenId", 'consulting'); 
      expect(entity, isNotNull); 
      expect(entity!.citizenId, equals('consulting')); 
 
      //citizens.display("After update citizen id"); 
    }); 
 
    test("Update citizen non id attribute with failure", () { 
      var randomCitizen = directModel.citizens.random(); 
      var afterUpdateEntity = randomCitizen.copy(); 
      afterUpdateEntity.firstName = 'park'; 
      expect(afterUpdateEntity.firstName, equals('park')); 
      // citizens.update can only be used if oid, code or id is set. 
      expect(() => citizens.update(randomCitizen, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomCitizen = directModel.citizens.random(); 
      randomCitizen.display(prefix:"before copy: "); 
      var randomCitizenCopy = randomCitizen.copy(); 
      randomCitizenCopy.display(prefix:"after copy: "); 
      expect(randomCitizen, equals(randomCitizenCopy)); 
      expect(randomCitizen.oid, equals(randomCitizenCopy.oid)); 
      expect(randomCitizen.code, equals(randomCitizenCopy.code)); 
      expect(randomCitizen.citizenId, equals(randomCitizenCopy.citizenId)); 
      expect(randomCitizen.firstName, equals(randomCitizenCopy.firstName)); 
      expect(randomCitizen.lastName, equals(randomCitizenCopy.lastName)); 
 
      expect(randomCitizen.id, isNotNull); 
      expect(randomCitizenCopy.id, isNotNull); 
      expect(randomCitizen.id, equals(randomCitizenCopy.id)); 
 
      var idsEqual = false; 
      if (randomCitizen.id == randomCitizenCopy.id) { 
        idsEqual = true; 
      } 
      expect(idsEqual, isTrue); 
 
      idsEqual = false; 
      if (randomCitizen.id!.equals(randomCitizenCopy.id!)) { 
        idsEqual = true; 
      } 
      expect(idsEqual, isTrue); 
    }); 
 
    test("citizen action undo and redo", () { 
      var citizenCount = citizens.length; 
      var citizen = Citizen(citizens.concept); 
        citizen.citizenId = 'oil'; 
      citizen.firstName = 'lifespan'; 
      citizen.lastName = 'architecture'; 
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
        citizen.citizenId = 'left'; 
      citizen.firstName = 'interest'; 
      citizen.lastName = 'parfem'; 
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
      var citizen = directModel.citizens.random(); 
      var action = SetAttributeCommand(session, citizen, "firstName", 'paper'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(citizen.firstName, equals(action.before)); 
 
      session.past.redo(); 
      expect(citizen.firstName, equals(action.after)); 
    }); 
 
    test("Citizen action with multiple undos and redos", () { 
      var citizenCount = citizens.length; 
      var citizen1 = directModel.citizens.random(); 
 
      var action1 = RemoveCommand(session, citizens, citizen1); 
      action1.doIt(); 
      expect(citizens.length, equals(--citizenCount)); 
 
      var citizen2 = directModel.citizens.random(); 
 
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
      var citizen1 = directModel.citizens.random(); 
      var citizen2 = directModel.citizens.random(); 
      while (citizen1 == citizen2) { 
        citizen2 = directModel.citizens.random();  
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
      var citizen1 = directModel.citizens.random(); 
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
 
      democracyDomain.startCommandReaction(reaction); 
      var citizen = Citizen(citizens.concept); 
        citizen.citizenId = 'text'; 
      citizen.firstName = 'place'; 
      citizen.lastName = 'test'; 
      citizens.add(citizen); 
      expect(citizens.length, equals(++citizenCount)); 
      citizens.remove(citizen); 
      expect(citizens.length, equals(--citizenCount)); 
 
      var session = democracyDomain.newSession(); 
      var addCommand = AddCommand(session, citizens, citizen); 
      addCommand.doIt(); 
      expect(citizens.length, equals(++citizenCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, citizen, "firstName", 'auto'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      democracyDomain.cancelCommandReaction(reaction); 
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
  var repository = DemocracyDirectRepo(); 
  DemocracyDomain democracyDomain = repository.getDomainModels("Democracy") as DemocracyDomain;   
  assert(democracyDomain != null); 
  DirectModel directModel = democracyDomain.getModelEntries("Direct") as DirectModel;  
  assert(directModel != null); 
  var citizens = directModel.citizens; 
  testDemocracyDirectCitizens(democracyDomain, directModel, citizens); 
} 
 
