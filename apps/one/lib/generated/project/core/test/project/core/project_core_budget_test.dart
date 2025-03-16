 
// test/project/core/project_core_budget_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreBudgets( 
    ProjectDomain projectDomain, CoreModel coreModel, Budgets budgets) { 
  DomainSession session; 
  group('Testing Project.Core.Budget', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(budgets.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(budgets.isEmpty, isTrue); 
      expect(budgets.exceptions.isEmpty, isTrue); 
    }); 
 
    test('From model to JSON', () { 
      final json = coreModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model', () { 
      final json = coreModel.toJson(); 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      coreModel.fromJson(json); 
      expect(coreModel.isEmpty, isFalse); 
 
      coreModel.display(); 
    }); 
 
    test('From model entry to JSON', () { 
      final json = coreModel.fromEntryToJson('Budget'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Budget'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Budget'); 
      budgets.clear(); 
      expect(budgets.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(budgets.isEmpty, isFalse); 
 
      budgets.display(title: 'From JSON to model entry'); 
    }); 
 
    test('Add budget required error', () { 
      // no required attribute that is not id 
    }); 
 
    test('Add budget unique error', () { 
      // no id attribute 
    }); 
 
    test('Not found budget by oid', () { 
      final ednetOid = Oid.ts(1345648254063); 
      final budget = budgets.singleWhereOid(ednetOid); 
      expect(budget, isNull); 
    }); 
 
    test('Find budget by oid', () { 
      final randomBudget = coreModel.budgets.random(); 
      final budget = budgets.singleWhereOid(randomBudget.oid); 
      expect(budget, isNotNull); 
      expect(budget, equals(randomBudget)); 
    }); 
 
    test('Find budget by attribute id', () { 
      // no id attribute 
    }); 
 
    test('Find budget by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Find budget by attribute', () { 
      final randomBudget = coreModel.budgets.random(); 
      final budget = 
          budgets.firstWhereAttribute('amount', randomBudget.amount); 
      expect(budget, isNotNull); 
      expect(budget.amount, equals(randomBudget.amount)); 
    }); 
 
    test('Select budgets by attribute', () { 
      final randomBudget = coreModel.budgets.random(); 
      final selectedBudgets = 
          budgets.selectWhereAttribute('amount', randomBudget.amount); 
      expect(selectedBudgets.isEmpty, isFalse); 
      for (final se in selectedBudgets) {        expect(se.amount, equals(randomBudget.amount));      } 
      //selectedBudgets.display(title: 'Select budgets by amount'); 
    }); 
 
    test('Select budgets by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select budgets by attribute, then add', () { 
      final randomBudget = coreModel.budgets.random(); 
      final selectedBudgets = 
          budgets.selectWhereAttribute('amount', randomBudget.amount); 
      expect(selectedBudgets.isEmpty, isFalse); 
      expect(selectedBudgets.source?.isEmpty, isFalse); 
      var budgetsCount = budgets.length; 
 
      final budget = Budget(budgets.concept) 

      ..amount = 28.844203932411293
      ..currency = 'email';      final added = selectedBudgets.add(budget); 
      expect(added, isTrue); 
      expect(budgets.length, equals(++budgetsCount)); 
 
      //selectedBudgets.display(title: 
      //  'Select budgets by attribute, then add'); 
      //budgets.display(title: 'All budgets'); 
    }); 
 
    test('Select budgets by attribute, then remove', () { 
      final randomBudget = coreModel.budgets.random(); 
      final selectedBudgets = 
          budgets.selectWhereAttribute('amount', randomBudget.amount); 
      expect(selectedBudgets.isEmpty, isFalse); 
      expect(selectedBudgets.source?.isEmpty, isFalse); 
      var budgetsCount = budgets.length; 
 
      final removed = selectedBudgets.remove(randomBudget); 
      expect(removed, isTrue); 
      expect(budgets.length, equals(--budgetsCount)); 
 
      randomBudget.display(prefix: 'removed'); 
      //selectedBudgets.display(title: 
      //  'Select budgets by attribute, then remove'); 
      //budgets.display(title: 'All budgets'); 
    }); 
 
    test('Sort budgets', () { 
      // no id attribute 
      // add compareTo method in the specific Budget class 
      /* 
      budgets.sort(); 
 
      //budgets.display(title: 'Sort budgets'); 
      */ 
    }); 
 
    test('Order budgets', () { 
      // no id attribute 
      // add compareTo method in the specific Budget class 
      /* 
      final orderedBudgets = budgets.order(); 
      expect(orderedBudgets.isEmpty, isFalse); 
      expect(orderedBudgets.length, equals(budgets.length)); 
      expect(orderedBudgets.source?.isEmpty, isFalse); 
      expect(orderedBudgets.source?.length, equals(budgets.length)); 
      expect(orderedBudgets, isNot(same(budgets))); 
 
      //orderedBudgets.display(title: 'Order budgets'); 
      */ 
    }); 
 
    test('Copy budgets', () { 
      final copiedBudgets = budgets.copy(); 
      expect(copiedBudgets.isEmpty, isFalse); 
      expect(copiedBudgets.length, equals(budgets.length)); 
      expect(copiedBudgets, isNot(same(budgets))); 
      for (final e in copiedBudgets) {        expect(e, equals(budgets.singleWhereOid(e.oid)));      } 
 
      //copiedBudgets.display(title: "Copy budgets"); 
    }); 
 
    test('True for every budget', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random budget', () { 
      final budget1 = coreModel.budgets.random(); 
      expect(budget1, isNotNull); 
      final budget2 = coreModel.budgets.random(); 
      expect(budget2, isNotNull); 
 
      //budget1.display(prefix: 'random1'); 
      //budget2.display(prefix: 'random2'); 
    }); 
 
    test('Update budget id with try', () { 
      // no id attribute 
    }); 
 
    test('Update budget id without try', () { 
      // no id attribute 
    }); 
 
    test('Update budget id with success', () { 
      // no id attribute 
    }); 
 
    test('Update budget non id attribute with failure', () { 
      final randomBudget = coreModel.budgets.random(); 
      final afterUpdateEntity = randomBudget.copy()..amount = 43.205625161675265; 
      expect(afterUpdateEntity.amount, equals(43.205625161675265)); 
      // budgets.update can only be used if oid, code or id is set. 
      expect(() => budgets.update(randomBudget, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomBudget = coreModel.budgets.random()..display(prefix:'before copy: '); 
      final randomBudgetCopy = randomBudget.copy()..display(prefix:'after copy: '); 
      expect(randomBudget, equals(randomBudgetCopy)); 
      expect(randomBudget.oid, equals(randomBudgetCopy.oid)); 
      expect(randomBudget.code, equals(randomBudgetCopy.code)); 
      expect(randomBudget.amount, equals(randomBudgetCopy.amount)); 
      expect(randomBudget.currency, equals(randomBudgetCopy.currency)); 
 
    }); 
 
    test('budget action undo and redo', () { 
      var budgetCount = budgets.length; 
      final budget = Budget(budgets.concept) 
  
      ..amount = 21.050403019052943
      ..currency = 'water';    final budgetProject = coreModel.projects.random(); 
    budget.project = budgetProject; 
      budgets.add(budget); 
    budgetProject.budgets.add(budget); 
      expect(budgets.length, equals(++budgetCount)); 
      budgets.remove(budget); 
      expect(budgets.length, equals(--budgetCount)); 
 
      final action = AddCommand(session, budgets, budget)..doIt(); 
      expect(budgets.length, equals(++budgetCount)); 
 
      action.undo(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      action.redo(); 
      expect(budgets.length, equals(++budgetCount)); 
    }); 
 
    test('budget session undo and redo', () { 
      var budgetCount = budgets.length; 
      final budget = Budget(budgets.concept) 
  
      ..amount = 80.46809816476366
      ..currency = 'center';    final budgetProject = coreModel.projects.random(); 
    budget.project = budgetProject; 
      budgets.add(budget); 
    budgetProject.budgets.add(budget); 
      expect(budgets.length, equals(++budgetCount)); 
      budgets.remove(budget); 
      expect(budgets.length, equals(--budgetCount)); 
 
      AddCommand(session, budgets, budget).doIt();; 
      expect(budgets.length, equals(++budgetCount)); 
 
      session.past.undo(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      session.past.redo(); 
      expect(budgets.length, equals(++budgetCount)); 
    }); 
 
    test('Budget update undo and redo', () { 
      final budget = coreModel.budgets.random(); 
      final action = SetAttributeCommand(session, budget, 'amount', 20.026141649329745)..doIt(); 
 
      session.past.undo(); 
      expect(budget.amount, equals(action.before)); 
 
      session.past.redo(); 
      expect(budget.amount, equals(action.after)); 
    }); 
 
    test('Budget action with multiple undos and redos', () { 
      var budgetCount = budgets.length; 
      final budget1 = coreModel.budgets.random(); 
 
      RemoveCommand(session, budgets, budget1).doIt(); 
      expect(budgets.length, equals(--budgetCount)); 
 
      final budget2 = coreModel.budgets.random(); 
 
      RemoveCommand(session, budgets, budget2).doIt(); 
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
 
    test('Transaction undo and redo', () { 
      var budgetCount = budgets.length; 
      final budget1 = coreModel.budgets.random(); 
      var budget2 = coreModel.budgets.random(); 
      while (budget1 == budget2) { 
        budget2 = coreModel.budgets.random();  
      } 
      final action1 = RemoveCommand(session, budgets, budget1); 
      final action2 = RemoveCommand(session, budgets, budget2); 
 
      Transaction('two removes on budgets', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      budgetCount = budgetCount - 2; 
      expect(budgets.length, equals(budgetCount)); 
 
      budgets.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      budgetCount = budgetCount + 2; 
      expect(budgets.length, equals(budgetCount)); 
 
      budgets.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      budgetCount = budgetCount - 2; 
      expect(budgets.length, equals(budgetCount)); 
 
      budgets.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final budgetCount = budgets.length; 
      final budget1 = coreModel.budgets.random(); 
      final budget2 = budget1; 
      final action1 = RemoveCommand(session, budgets, budget1); 
      final action2 = RemoveCommand(session, budgets, budget2); 
 
      final transaction = Transaction( 
        'two removes on budgets, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(budgets.length, equals(budgetCount)); 
 
      //budgets.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to budget actions', () { 
      var budgetCount = budgets.length; 
 
      final reaction = BudgetReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final budget = Budget(budgets.concept) 
  
      ..amount = 85.53745968553
      ..currency = 'cabinet';    final budgetProject = coreModel.projects.random(); 
    budget.project = budgetProject; 
      budgets.add(budget); 
    budgetProject.budgets.add(budget); 
      expect(budgets.length, equals(++budgetCount)); 
      budgets.remove(budget); 
      expect(budgets.length, equals(--budgetCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, budgets, budget).doIt(); 
      expect(budgets.length, equals(++budgetCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        budget,
        'amount',
        67.8421968771061,
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class BudgetReaction implements ICommandReaction { 
  bool reactedOnAdd    = false; 
  bool reactedOnUpdate = false; 
 
  @override  void react(ICommand action) { 
    if (action is IEntitiesCommand) { 
      reactedOnAdd = true; 
    } else if (action is IEntityCommand) { 
      reactedOnUpdate = true; 
    } 
  } 
} 
 
void main() { 
  final repository = ProjectCoreRepo(); 
  final projectDomain = repository.getDomainModels('Project') as ProjectDomain?;
  assert(projectDomain != null, 'ProjectDomain is not defined'); 
  final coreModel = projectDomain!.getModelEntries('Core') as CoreModel?;
  assert(coreModel != null, 'CoreModel is not defined'); 
  final budgets = coreModel!.budgets; 
  testProjectCoreBudgets(projectDomain, coreModel, budgets); 
} 
 
