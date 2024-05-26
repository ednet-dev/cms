 
// test/household_management/household/household_management_household_household_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_management_household/household_management_household.dart"; 
 
void testHousehold_managementHouseholdHouseholds( 
    Household_managementDomain household_managementDomain, HouseholdModel householdModel, Households households) { 
  DomainSession session; 
  group("Testing Household_management.Household.Household", () { 
    session = household_managementDomain.newSession();  
    setUp(() { 
      householdModel.init(); 
    }); 
    tearDown(() { 
      householdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(householdModel.isEmpty, isFalse); 
      expect(households.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      expect(households.isEmpty, isTrue); 
      expect(households.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = householdModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = householdModel.toJson(); 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      householdModel.fromJson(json); 
      expect(householdModel.isEmpty, isFalse); 
 
      householdModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = householdModel.fromEntryToJson("Household"); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayEntryJson("Household"); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = householdModel.fromEntryToJson("Household"); 
      households.clear(); 
      expect(households.isEmpty, isTrue); 
      householdModel.fromJsonToEntry(json); 
      expect(households.isEmpty, isFalse); 
 
      households.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add household required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add household unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found household by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var household = households.singleWhereOid(ednetOid); 
      expect(household, isNull); 
    }); 
 
    test("Find household by oid", () { 
      var randomHousehold = householdModel.households.random(); 
      var household = households.singleWhereOid(randomHousehold.oid); 
      expect(household, isNotNull); 
      expect(household, equals(randomHousehold)); 
    }); 
 
    test("Find household by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find household by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find household by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select households by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select households by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select households by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select households by attribute, then remove", () { 
      // no attribute that is not id 
    }); 
 
    test("Sort households", () { 
      // no id attribute 
      // add compareTo method in the specific Household class 
      /* 
      households.sort(); 
 
      //households.display(title: "Sort households"); 
      */ 
    }); 
 
    test("Order households", () { 
      // no id attribute 
      // add compareTo method in the specific Household class 
      /* 
      var orderedHouseholds = households.order(); 
      expect(orderedHouseholds.isEmpty, isFalse); 
      expect(orderedHouseholds.length, equals(households.length)); 
      expect(orderedHouseholds.source?.isEmpty, isFalse); 
      expect(orderedHouseholds.source?.length, equals(households.length)); 
      expect(orderedHouseholds, isNot(same(households))); 
 
      //orderedHouseholds.display(title: "Order households"); 
      */ 
    }); 
 
    test("Copy households", () { 
      var copiedHouseholds = households.copy(); 
      expect(copiedHouseholds.isEmpty, isFalse); 
      expect(copiedHouseholds.length, equals(households.length)); 
      expect(copiedHouseholds, isNot(same(households))); 
      copiedHouseholds.forEach((e) => 
        expect(e, equals(households.singleWhereOid(e.oid)))); 
 
      //copiedHouseholds.display(title: "Copy households"); 
    }); 
 
    test("True for every household", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random household", () { 
      var household1 = householdModel.households.random(); 
      expect(household1, isNotNull); 
      var household2 = householdModel.households.random(); 
      expect(household2, isNotNull); 
 
      //household1.display(prefix: "random1"); 
      //household2.display(prefix: "random2"); 
    }); 
 
    test("Update household id with try", () { 
      // no id attribute 
    }); 
 
    test("Update household id without try", () { 
      // no id attribute 
    }); 
 
    test("Update household id with success", () { 
      // no id attribute 
    }); 
 
    test("Update household non id attribute with failure", () { 
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomHousehold = householdModel.households.random(); 
      randomHousehold.display(prefix:"before copy: "); 
      var randomHouseholdCopy = randomHousehold.copy(); 
      randomHouseholdCopy.display(prefix:"after copy: "); 
      expect(randomHousehold, equals(randomHouseholdCopy)); 
      expect(randomHousehold.oid, equals(randomHouseholdCopy.oid)); 
      expect(randomHousehold.code, equals(randomHouseholdCopy.code)); 
 
    }); 
 
    test("household action undo and redo", () { 
      var householdCount = households.length; 
      var household = Household(households.concept); 
        households.add(household); 
      expect(households.length, equals(++householdCount)); 
      households.remove(household); 
      expect(households.length, equals(--householdCount)); 
 
      var action = AddCommand(session, households, household); 
      action.doIt(); 
      expect(households.length, equals(++householdCount)); 
 
      action.undo(); 
      expect(households.length, equals(--householdCount)); 
 
      action.redo(); 
      expect(households.length, equals(++householdCount)); 
    }); 
 
    test("household session undo and redo", () { 
      var householdCount = households.length; 
      var household = Household(households.concept); 
        households.add(household); 
      expect(households.length, equals(++householdCount)); 
      households.remove(household); 
      expect(households.length, equals(--householdCount)); 
 
      var action = AddCommand(session, households, household); 
      action.doIt(); 
      expect(households.length, equals(++householdCount)); 
 
      session.past.undo(); 
      expect(households.length, equals(--householdCount)); 
 
      session.past.redo(); 
      expect(households.length, equals(++householdCount)); 
    }); 
 
    test("Household update undo and redo", () { 
      // no attribute that is not id 
    }); 
 
    test("Household action with multiple undos and redos", () { 
      var householdCount = households.length; 
      var household1 = householdModel.households.random(); 
 
      var action1 = RemoveCommand(session, households, household1); 
      action1.doIt(); 
      expect(households.length, equals(--householdCount)); 
 
      var household2 = householdModel.households.random(); 
 
      var action2 = RemoveCommand(session, households, household2); 
      action2.doIt(); 
      expect(households.length, equals(--householdCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(households.length, equals(++householdCount)); 
 
      session.past.undo(); 
      expect(households.length, equals(++householdCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(households.length, equals(--householdCount)); 
 
      session.past.redo(); 
      expect(households.length, equals(--householdCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var householdCount = households.length; 
      var household1 = householdModel.households.random(); 
      var household2 = householdModel.households.random(); 
      while (household1 == household2) { 
        household2 = householdModel.households.random();  
      } 
      var action1 = RemoveCommand(session, households, household1); 
      var action2 = RemoveCommand(session, households, household2); 
 
      var transaction = new Transaction("two removes on households", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      householdCount = householdCount - 2; 
      expect(households.length, equals(householdCount)); 
 
      households.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      householdCount = householdCount + 2; 
      expect(households.length, equals(householdCount)); 
 
      households.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      householdCount = householdCount - 2; 
      expect(households.length, equals(householdCount)); 
 
      households.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var householdCount = households.length; 
      var household1 = householdModel.households.random(); 
      var household2 = household1; 
      var action1 = RemoveCommand(session, households, household1); 
      var action2 = RemoveCommand(session, households, household2); 
 
      var transaction = Transaction( 
        "two removes on households, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(households.length, equals(householdCount)); 
 
      //households.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to household actions", () { 
      var householdCount = households.length; 
 
      var reaction = HouseholdReaction(); 
      expect(reaction, isNotNull); 
 
      household_managementDomain.startCommandReaction(reaction); 
      var household = Household(households.concept); 
        households.add(household); 
      expect(households.length, equals(++householdCount)); 
      households.remove(household); 
      expect(households.length, equals(--householdCount)); 
 
      var session = household_managementDomain.newSession(); 
      var addCommand = AddCommand(session, households, household); 
      addCommand.doIt(); 
      expect(households.length, equals(++householdCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
    }); 
 
  }); 
} 
 
class HouseholdReaction implements ICommandReaction { 
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
  Household_managementDomain household_managementDomain = repository.getDomainModels("Household_management") as Household_managementDomain;   
  assert(household_managementDomain != null); 
  HouseholdModel householdModel = household_managementDomain.getModelEntries("Household") as HouseholdModel;  
  assert(householdModel != null); 
  var households = householdModel.households; 
  testHousehold_managementHouseholdHouseholds(household_managementDomain, householdModel, households); 
} 
 