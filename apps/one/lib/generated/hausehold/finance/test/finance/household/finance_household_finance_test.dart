 
// test/finance/household/finance_household_finance_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:finance_household/finance_household.dart"; 
 
void testFinanceHouseholdFinances( 
    FinanceDomain financeDomain, HouseholdModel householdModel, Finances finances) { 
  DomainSession session; 
  group("Testing Finance.Household.Finance", () { 
    session = financeDomain.newSession();  
    setUp(() { 
      householdModel.init(); 
    }); 
    tearDown(() { 
      householdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(householdModel.isEmpty, isFalse); 
      expect(finances.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      expect(finances.isEmpty, isTrue); 
      expect(finances.exceptions.isEmpty, isTrue); 
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
      var json = householdModel.fromEntryToJson("Finance"); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayEntryJson("Finance"); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = householdModel.fromEntryToJson("Finance"); 
      finances.clear(); 
      expect(finances.isEmpty, isTrue); 
      householdModel.fromJsonToEntry(json); 
      expect(finances.isEmpty, isFalse); 
 
      finances.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add finance required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add finance unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found finance by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var finance = finances.singleWhereOid(ednetOid); 
      expect(finance, isNull); 
    }); 
 
    test("Find finance by oid", () { 
      var randomFinance = householdModel.finances.random(); 
      var finance = finances.singleWhereOid(randomFinance.oid); 
      expect(finance, isNotNull); 
      expect(finance, equals(randomFinance)); 
    }); 
 
    test("Find finance by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find finance by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find finance by attribute", () { 
      var randomFinance = householdModel.finances.random(); 
      var finance = 
          finances.firstWhereAttribute("name", randomFinance.name); 
      expect(finance, isNotNull); 
      expect(finance.name, equals(randomFinance.name)); 
    }); 
 
    test("Select finances by attribute", () { 
      var randomFinance = householdModel.finances.random(); 
      var selectedFinances = 
          finances.selectWhereAttribute("name", randomFinance.name); 
      expect(selectedFinances.isEmpty, isFalse); 
      selectedFinances.forEach((se) => 
          expect(se.name, equals(randomFinance.name))); 
 
      //selectedFinances.display(title: "Select finances by name"); 
    }); 
 
    test("Select finances by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select finances by attribute, then add", () { 
      var randomFinance = householdModel.finances.random(); 
      var selectedFinances = 
          finances.selectWhereAttribute("name", randomFinance.name); 
      expect(selectedFinances.isEmpty, isFalse); 
      expect(selectedFinances.source?.isEmpty, isFalse); 
      var financesCount = finances.length; 
 
      var finance = Finance(finances.concept); 
      finance.name = 'course'; 
      var added = selectedFinances.add(finance); 
      expect(added, isTrue); 
      expect(finances.length, equals(++financesCount)); 
 
      //selectedFinances.display(title: 
      //  "Select finances by attribute, then add"); 
      //finances.display(title: "All finances"); 
    }); 
 
    test("Select finances by attribute, then remove", () { 
      var randomFinance = householdModel.finances.random(); 
      var selectedFinances = 
          finances.selectWhereAttribute("name", randomFinance.name); 
      expect(selectedFinances.isEmpty, isFalse); 
      expect(selectedFinances.source?.isEmpty, isFalse); 
      var financesCount = finances.length; 
 
      var removed = selectedFinances.remove(randomFinance); 
      expect(removed, isTrue); 
      expect(finances.length, equals(--financesCount)); 
 
      randomFinance.display(prefix: "removed"); 
      //selectedFinances.display(title: 
      //  "Select finances by attribute, then remove"); 
      //finances.display(title: "All finances"); 
    }); 
 
    test("Sort finances", () { 
      // no id attribute 
      // add compareTo method in the specific Finance class 
      /* 
      finances.sort(); 
 
      //finances.display(title: "Sort finances"); 
      */ 
    }); 
 
    test("Order finances", () { 
      // no id attribute 
      // add compareTo method in the specific Finance class 
      /* 
      var orderedFinances = finances.order(); 
      expect(orderedFinances.isEmpty, isFalse); 
      expect(orderedFinances.length, equals(finances.length)); 
      expect(orderedFinances.source?.isEmpty, isFalse); 
      expect(orderedFinances.source?.length, equals(finances.length)); 
      expect(orderedFinances, isNot(same(finances))); 
 
      //orderedFinances.display(title: "Order finances"); 
      */ 
    }); 
 
    test("Copy finances", () { 
      var copiedFinances = finances.copy(); 
      expect(copiedFinances.isEmpty, isFalse); 
      expect(copiedFinances.length, equals(finances.length)); 
      expect(copiedFinances, isNot(same(finances))); 
      copiedFinances.forEach((e) => 
        expect(e, equals(finances.singleWhereOid(e.oid)))); 
 
      //copiedFinances.display(title: "Copy finances"); 
    }); 
 
    test("True for every finance", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random finance", () { 
      var finance1 = householdModel.finances.random(); 
      expect(finance1, isNotNull); 
      var finance2 = householdModel.finances.random(); 
      expect(finance2, isNotNull); 
 
      //finance1.display(prefix: "random1"); 
      //finance2.display(prefix: "random2"); 
    }); 
 
    test("Update finance id with try", () { 
      // no id attribute 
    }); 
 
    test("Update finance id without try", () { 
      // no id attribute 
    }); 
 
    test("Update finance id with success", () { 
      // no id attribute 
    }); 
 
    test("Update finance non id attribute with failure", () { 
      var randomFinance = householdModel.finances.random(); 
      var afterUpdateEntity = randomFinance.copy(); 
      afterUpdateEntity.name = 'letter'; 
      expect(afterUpdateEntity.name, equals('letter')); 
      // finances.update can only be used if oid, code or id is set. 
      expect(() => finances.update(randomFinance, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomFinance = householdModel.finances.random(); 
      randomFinance.display(prefix:"before copy: "); 
      var randomFinanceCopy = randomFinance.copy(); 
      randomFinanceCopy.display(prefix:"after copy: "); 
      expect(randomFinance, equals(randomFinanceCopy)); 
      expect(randomFinance.oid, equals(randomFinanceCopy.oid)); 
      expect(randomFinance.code, equals(randomFinanceCopy.code)); 
      expect(randomFinance.name, equals(randomFinanceCopy.name)); 
 
    }); 
 
    test("finance action undo and redo", () { 
      var financeCount = finances.length; 
      var finance = Finance(finances.concept); 
        finance.name = 'celebration'; 
      finances.add(finance); 
      expect(finances.length, equals(++financeCount)); 
      finances.remove(finance); 
      expect(finances.length, equals(--financeCount)); 
 
      var action = AddCommand(session, finances, finance); 
      action.doIt(); 
      expect(finances.length, equals(++financeCount)); 
 
      action.undo(); 
      expect(finances.length, equals(--financeCount)); 
 
      action.redo(); 
      expect(finances.length, equals(++financeCount)); 
    }); 
 
    test("finance session undo and redo", () { 
      var financeCount = finances.length; 
      var finance = Finance(finances.concept); 
        finance.name = 'consulting'; 
      finances.add(finance); 
      expect(finances.length, equals(++financeCount)); 
      finances.remove(finance); 
      expect(finances.length, equals(--financeCount)); 
 
      var action = AddCommand(session, finances, finance); 
      action.doIt(); 
      expect(finances.length, equals(++financeCount)); 
 
      session.past.undo(); 
      expect(finances.length, equals(--financeCount)); 
 
      session.past.redo(); 
      expect(finances.length, equals(++financeCount)); 
    }); 
 
    test("Finance update undo and redo", () { 
      var finance = householdModel.finances.random(); 
      var action = SetAttributeCommand(session, finance, "name", 'truck'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(finance.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(finance.name, equals(action.after)); 
    }); 
 
    test("Finance action with multiple undos and redos", () { 
      var financeCount = finances.length; 
      var finance1 = householdModel.finances.random(); 
 
      var action1 = RemoveCommand(session, finances, finance1); 
      action1.doIt(); 
      expect(finances.length, equals(--financeCount)); 
 
      var finance2 = householdModel.finances.random(); 
 
      var action2 = RemoveCommand(session, finances, finance2); 
      action2.doIt(); 
      expect(finances.length, equals(--financeCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(finances.length, equals(++financeCount)); 
 
      session.past.undo(); 
      expect(finances.length, equals(++financeCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(finances.length, equals(--financeCount)); 
 
      session.past.redo(); 
      expect(finances.length, equals(--financeCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var financeCount = finances.length; 
      var finance1 = householdModel.finances.random(); 
      var finance2 = householdModel.finances.random(); 
      while (finance1 == finance2) { 
        finance2 = householdModel.finances.random();  
      } 
      var action1 = RemoveCommand(session, finances, finance1); 
      var action2 = RemoveCommand(session, finances, finance2); 
 
      var transaction = new Transaction("two removes on finances", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      financeCount = financeCount - 2; 
      expect(finances.length, equals(financeCount)); 
 
      finances.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      financeCount = financeCount + 2; 
      expect(finances.length, equals(financeCount)); 
 
      finances.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      financeCount = financeCount - 2; 
      expect(finances.length, equals(financeCount)); 
 
      finances.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var financeCount = finances.length; 
      var finance1 = householdModel.finances.random(); 
      var finance2 = finance1; 
      var action1 = RemoveCommand(session, finances, finance1); 
      var action2 = RemoveCommand(session, finances, finance2); 
 
      var transaction = Transaction( 
        "two removes on finances, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(finances.length, equals(financeCount)); 
 
      //finances.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to finance actions", () { 
      var financeCount = finances.length; 
 
      var reaction = FinanceReaction(); 
      expect(reaction, isNotNull); 
 
      financeDomain.startCommandReaction(reaction); 
      var finance = Finance(finances.concept); 
        finance.name = 'sailing'; 
      finances.add(finance); 
      expect(finances.length, equals(++financeCount)); 
      finances.remove(finance); 
      expect(finances.length, equals(--financeCount)); 
 
      var session = financeDomain.newSession(); 
      var addCommand = AddCommand(session, finances, finance); 
      addCommand.doIt(); 
      expect(finances.length, equals(++financeCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, finance, "name", 'family'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      financeDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class FinanceReaction implements ICommandReaction { 
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
  var repository = FinanceHouseholdRepo(); 
  FinanceDomain financeDomain = repository.getDomainModels("Finance") as FinanceDomain;   
  assert(financeDomain != null); 
  HouseholdModel householdModel = financeDomain.getModelEntries("Household") as HouseholdModel;  
  assert(householdModel != null); 
  var finances = householdModel.finances; 
  testFinanceHouseholdFinances(financeDomain, householdModel, finances); 
} 
 
