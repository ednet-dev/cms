 
// test/project/household/project_household_budget_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_household/project_household.dart"; 
 
void testProjectHouseholdBudgets( 
    ProjectDomain projectDomain, HouseholdModel householdModel, Budgets budgets) { 
  DomainSession session; 
  group("Testing Project.Household.Budget", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      householdModel.simulate();
    }); 
    tearDown(() { 
      householdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(householdModel.isEmpty, isFalse); 
      expect(budgets.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      expect(budgets.isEmpty, isTrue); 
      expect(budgets.exceptions.isEmpty, isTrue); 
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
      var json = householdModel.fromEntryToJson("Budget"); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayEntryJson("Budget"); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = householdModel.fromEntryToJson("Budget"); 
      budgets.clear(); 
      expect(budgets.isEmpty, isTrue); 
      householdModel.fromJsonToEntry(json); 
      expect(budgets.isEmpty, isFalse); 
 
      budgets.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add budget required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add budget unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found budget by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var budget = budgets.singleWhereOid(ednetOid); 
      expect(budget, isNull); 
    }); 
 
    test("Find budget by oid", () { 
      var randomBudget = householdModel.budgets.random(); 
      var budget = budgets.singleWhereOid(randomBudget.oid); 
      expect(budget, isNotNull); 
      expect(budget, equals(randomBudget)); 
    }); 
 
    test("Find budget by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find budget by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find budget by attribute", () { 
      var randomBudget = householdModel.budgets.random(); 
      var budget = 
          budgets.firstWhereAttribute("amount", randomBudget.amount); 
      expect(budget, isNotNull); 
      expect(budget.amount, equals(randomBudget.amount)); 
    }); 
 
    test("Select budgets by attribute", () { 
      var randomBudget = householdModel.budgets.random(); 
      var selectedBudgets = 
          budgets.selectWhereAttribute("amount", randomBudget.amount); 
      expect(selectedBudgets.isEmpty, isFalse); 
      selectedBudgets.forEach((se) => 
          expect(se.amount, equals(randomBudget.amount))); 
 
      //selectedBudgets.display(title: "Select budgets by amount"); 
    }); 
 
    test("Select budgets by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select budgets by attribute, then add", () { 
      var randomBudget = householdModel.budgets.random(); 
      var selectedBudgets = 
          budgets.selectWhereAttribute("amount", randomBudget.amount); 
      expect(selectedBudgets.isEmpty, isFalse); 
      expect(selectedBudgets.source?.isEmpty, isFalse); 
      var budgetsCount = budgets.length; 
 
      var budget = Budget(budgets.concept); 
      budget.amount = 88.69548861086938; 
      budget.currency = 'marriage'; 
      var added = selectedBudgets.add(budget); 
      expect(added, isTrue); 
      expect(budgets.length, equals(++budgetsCount)); 
 
      //selectedBudgets.display(title: 
      //  "Select budgets by attribute, then add"); 
      //budgets.display(title: "All budgets"); 
    }); 
 
    test("Select budgets by attribute, then remove", () { 
      var randomBudget = householdModel.budgets.random(); 
      var selectedBudgets = 
          budgets.selectWhereAttribute("amount", randomBudget.amount); 
      expect(selectedBudgets.isEmpty, isFalse); 
      expect(selectedBudgets.source?.isEmpty, isFalse); 
      var budgetsCount = budgets.length; 
 
      var removed = selectedBudgets.remove(randomBudget); 
      expect(removed, isTrue); 
      expect(budgets.length, equals(--budgetsCount)); 
 
      randomBudget.display(prefix: "removed"); 
      //selectedBudgets.display(title: 
      //  "Select budgets by attribute, then remove"); 
      //budgets.display(title: "All budgets"); 
    }); 
 
    test("Sort budgets", () { 
      // no id attribute 
      // add compareTo method in the specific Budget class 
      /* 
      budgets.sort(); 
 
      //budgets.display(title: "Sort budgets"); 
      */ 
    }); 
 
    test("Order budgets", () { 
      // no id attribute 
      // add compareTo method in the specific Budget class 
      /* 
      var orderedBudgets = budgets.order(); 
      expect(orderedBudgets.isEmpty, isFalse); 
      expect(orderedBudgets.length, equals(budgets.length)); 
      expect(orderedBudgets.source?.isEmpty, isFalse); 
      expect(orderedBudgets.source?.length, equals(budgets.length)); 
      expect(orderedBudgets, isNot(same(budgets))); 
 
      //orderedBudgets.display(title: "Order budgets"); 
      */ 
    }); 
 
    test("Copy budgets", () { 
      var copiedBudgets = budgets.copy(); 
      expect(copiedBudgets.isEmpty, isFalse); 
      expect(copiedBudgets.length, equals(budgets.length)); 
      expect(copiedBudgets, isNot(same(budgets))); 
      copiedBudgets.forEach((e) => 
        expect(e, equals(budgets.singleWhereOid(e.oid)))); 
 
      //copiedBudgets.display(title: "Copy budgets"); 
    }); 
 
    test("True for every budget", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random budget", () { 
      var budget1 = householdModel.budgets.random(); 
      expect(budget1, isNotNull); 
      var budget2 = householdModel.budgets.random(); 
      expect(budget2, isNotNull); 
 
      //budget1.display(prefix: "random1"); 
      //budget2.display(prefix: "random2"); 
    }); 
 
    test("Update budget id with try", () { 
      // no id attribute 
    }); 
 
    test("Update budget id without try", () { 
      // no id attribute 
    }); 
 
    test("Update budget id with success", () { 
      // no id attribute 
    }); 
 
    test("Update budget non id attribute with failure", () { 
      var randomBudget = householdModel.budgets.random(); 
      var afterUpdateEntity = randomBudget.copy(); 
      afterUpdateEntity.amount = 59.74963054143553; 
      expect(afterUpdateEntity.amount, equals(59.74963054143553)); 
      // budgets.update can only be used if oid, code or id is set. 
      expect(() => budgets.update(randomBudget, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomBudget = householdModel.budgets.random(); 
      randomBudget.display(prefix:"before copy: "); 
      var randomBudgetCopy = randomBudget.copy(); 
      randomBudgetCopy.display(prefix:"after copy: "); 
      expect(randomBudget, equals(randomBudgetCopy)); 
      expect(randomBudget.oid, equals(randomBudgetCopy.oid)); 
      expect(randomBudget.code, equals(randomBudgetCopy.code)); 
      expect(randomBudget.amount, equals(randomBudgetCopy.amount)); 
      expect(randomBudget.currency, equals(randomBudgetCopy.currency)); 
 
    }); 
 
    test("budget action undo and redo", () { 
      var budgetCount = budgets.length; 
      var budget = Budget(budgets.concept); 
        budget.amount = 50.2099280230102; 
      budget.currency = 'photo'; 
    var budgetProject = householdModel.projects.random(); 
    budget.project = budgetProject; 
      budgets.add(budget); 
    budgetProject.budgets.add(budget); 
      expect(budgets.length, equals(++budgetCount)); 
      budgets.remove(budget); 
      expect(budgets.length, equals(--budgetCount)); 
 
      var action = AddCommand(session, budgets, budget); 
      action.doIt(); 
      expect(budgets.length, equals(++budgetCount)); 
 
      action.undo(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      action.redo(); 
      expect(budgets.length, equals(++budgetCount)); 
    }); 
 
    test("budget session undo and redo", () { 
      var budgetCount = budgets.length; 
      var budget = Budget(budgets.concept); 
        budget.amount = 8.904966889491206; 
      budget.currency = 'job'; 
    var budgetProject = householdModel.projects.random(); 
    budget.project = budgetProject; 
      budgets.add(budget); 
    budgetProject.budgets.add(budget); 
      expect(budgets.length, equals(++budgetCount)); 
      budgets.remove(budget); 
      expect(budgets.length, equals(--budgetCount)); 
 
      var action = AddCommand(session, budgets, budget); 
      action.doIt(); 
      expect(budgets.length, equals(++budgetCount)); 
 
      session.past.undo(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      session.past.redo(); 
      expect(budgets.length, equals(++budgetCount)); 
    }); 
 
    test("Budget update undo and redo", () { 
      var budget = householdModel.budgets.random(); 
      var action = SetAttributeCommand(session, budget, "amount", 79.2178624514156); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(budget.amount, equals(action.before)); 
 
      session.past.redo(); 
      expect(budget.amount, equals(action.after)); 
    }); 
 
    test("Budget action with multiple undos and redos", () { 
      var budgetCount = budgets.length; 
      var budget1 = householdModel.budgets.random(); 
 
      var action1 = RemoveCommand(session, budgets, budget1); 
      action1.doIt(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      var budget2 = householdModel.budgets.random(); 
 
      var action2 = RemoveCommand(session, budgets, budget2); 
      action2.doIt(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(budgets.length, equals(++budgetCount)); 
 
      session.past.undo(); 
      expect(budgets.length, equals(++budgetCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      session.past.redo(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var budgetCount = budgets.length; 
      var budget1 = householdModel.budgets.random(); 
      var budget2 = householdModel.budgets.random(); 
      while (budget1 == budget2) { 
        budget2 = householdModel.budgets.random();  
      } 
      var action1 = RemoveCommand(session, budgets, budget1); 
      var action2 = RemoveCommand(session, budgets, budget2); 
 
      var transaction = new Transaction("two removes on budgets", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      budgetCount = budgetCount - 2; 
      expect(budgets.length, equals(budgetCount)); 
 
      budgets.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      budgetCount = budgetCount + 2; 
      expect(budgets.length, equals(budgetCount)); 
 
      budgets.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      budgetCount = budgetCount - 2; 
      expect(budgets.length, equals(budgetCount)); 
 
      budgets.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var budgetCount = budgets.length; 
      var budget1 = householdModel.budgets.random(); 
      var budget2 = budget1; 
      var action1 = RemoveCommand(session, budgets, budget1); 
      var action2 = RemoveCommand(session, budgets, budget2); 
 
      var transaction = Transaction( 
        "two removes on budgets, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(budgets.length, equals(budgetCount)); 
 
      //budgets.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to budget actions", () { 
      var budgetCount = budgets.length; 
 
      var reaction = BudgetReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var budget = Budget(budgets.concept); 
        budget.amount = 56.4517520261122; 
      budget.currency = 'dog'; 
    var budgetProject = householdModel.projects.random(); 
    budget.project = budgetProject; 
      budgets.add(budget); 
    budgetProject.budgets.add(budget); 
      expect(budgets.length, equals(++budgetCount)); 
      budgets.remove(budget); 
      expect(budgets.length, equals(--budgetCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, budgets, budget); 
      addCommand.doIt(); 
      expect(budgets.length, equals(++budgetCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, budget, "amount", 41.79275282486624); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class BudgetReaction implements ICommandReaction { 
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
  var repository = ProjectHouseholdRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  HouseholdModel householdModel = projectDomain.getModelEntries("Household") as HouseholdModel;  
  assert(householdModel != null); 
  var budgets = householdModel.budgets; 
  testProjectHouseholdBudgets(projectDomain, householdModel, budgets); 
} 
 
