 
// test/project/planning/project_planning_plan_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_planning/project_planning.dart"; 
 
void testProjectPlanningPlans( 
    ProjectDomain projectDomain, PlanningModel planningModel, Plans plans) { 
  DomainSession session; 
  group("Testing Project.Planning.Plan", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      planningModel.init(); 
    }); 
    tearDown(() { 
      planningModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(planningModel.isEmpty, isFalse); 
      expect(plans.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      planningModel.clear(); 
      expect(planningModel.isEmpty, isTrue); 
      expect(plans.isEmpty, isTrue); 
      expect(plans.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = planningModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //planningModel.displayJson(); 
      //planningModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = planningModel.toJson(); 
      planningModel.clear(); 
      expect(planningModel.isEmpty, isTrue); 
      planningModel.fromJson(json); 
      expect(planningModel.isEmpty, isFalse); 
 
      planningModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = planningModel.fromEntryToJson("Plan"); 
      expect(json, isNotNull); 
 
      print(json); 
      //planningModel.displayEntryJson("Plan"); 
      //planningModel.displayJson(); 
      //planningModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = planningModel.fromEntryToJson("Plan"); 
      plans.clear(); 
      expect(plans.isEmpty, isTrue); 
      planningModel.fromJsonToEntry(json); 
      expect(plans.isEmpty, isFalse); 
 
      plans.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add plan required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add plan unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found plan by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var plan = plans.singleWhereOid(ednetOid); 
      expect(plan, isNull); 
    }); 
 
    test("Find plan by oid", () { 
      var randomPlan = planningModel.plans.random(); 
      var plan = plans.singleWhereOid(randomPlan.oid); 
      expect(plan, isNotNull); 
      expect(plan, equals(randomPlan)); 
    }); 
 
    test("Find plan by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find plan by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find plan by attribute", () { 
      var randomPlan = planningModel.plans.random(); 
      var plan = 
          plans.firstWhereAttribute("name", randomPlan.name); 
      expect(plan, isNotNull); 
      expect(plan.name, equals(randomPlan.name)); 
    }); 
 
    test("Select plans by attribute", () { 
      var randomPlan = planningModel.plans.random(); 
      var selectedPlans = 
          plans.selectWhereAttribute("name", randomPlan.name); 
      expect(selectedPlans.isEmpty, isFalse); 
      selectedPlans.forEach((se) => 
          expect(se.name, equals(randomPlan.name))); 
 
      //selectedPlans.display(title: "Select plans by name"); 
    }); 
 
    test("Select plans by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select plans by attribute, then add", () { 
      var randomPlan = planningModel.plans.random(); 
      var selectedPlans = 
          plans.selectWhereAttribute("name", randomPlan.name); 
      expect(selectedPlans.isEmpty, isFalse); 
      expect(selectedPlans.source?.isEmpty, isFalse); 
      var plansCount = plans.length; 
 
      var plan = Plan(plans.concept); 
      plan.name = 'camping'; 
      var added = selectedPlans.add(plan); 
      expect(added, isTrue); 
      expect(plans.length, equals(++plansCount)); 
 
      //selectedPlans.display(title: 
      //  "Select plans by attribute, then add"); 
      //plans.display(title: "All plans"); 
    }); 
 
    test("Select plans by attribute, then remove", () { 
      var randomPlan = planningModel.plans.random(); 
      var selectedPlans = 
          plans.selectWhereAttribute("name", randomPlan.name); 
      expect(selectedPlans.isEmpty, isFalse); 
      expect(selectedPlans.source?.isEmpty, isFalse); 
      var plansCount = plans.length; 
 
      var removed = selectedPlans.remove(randomPlan); 
      expect(removed, isTrue); 
      expect(plans.length, equals(--plansCount)); 
 
      randomPlan.display(prefix: "removed"); 
      //selectedPlans.display(title: 
      //  "Select plans by attribute, then remove"); 
      //plans.display(title: "All plans"); 
    }); 
 
    test("Sort plans", () { 
      // no id attribute 
      // add compareTo method in the specific Plan class 
      /* 
      plans.sort(); 
 
      //plans.display(title: "Sort plans"); 
      */ 
    }); 
 
    test("Order plans", () { 
      // no id attribute 
      // add compareTo method in the specific Plan class 
      /* 
      var orderedPlans = plans.order(); 
      expect(orderedPlans.isEmpty, isFalse); 
      expect(orderedPlans.length, equals(plans.length)); 
      expect(orderedPlans.source?.isEmpty, isFalse); 
      expect(orderedPlans.source?.length, equals(plans.length)); 
      expect(orderedPlans, isNot(same(plans))); 
 
      //orderedPlans.display(title: "Order plans"); 
      */ 
    }); 
 
    test("Copy plans", () { 
      var copiedPlans = plans.copy(); 
      expect(copiedPlans.isEmpty, isFalse); 
      expect(copiedPlans.length, equals(plans.length)); 
      expect(copiedPlans, isNot(same(plans))); 
      copiedPlans.forEach((e) => 
        expect(e, equals(plans.singleWhereOid(e.oid)))); 
 
      //copiedPlans.display(title: "Copy plans"); 
    }); 
 
    test("True for every plan", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random plan", () { 
      var plan1 = planningModel.plans.random(); 
      expect(plan1, isNotNull); 
      var plan2 = planningModel.plans.random(); 
      expect(plan2, isNotNull); 
 
      //plan1.display(prefix: "random1"); 
      //plan2.display(prefix: "random2"); 
    }); 
 
    test("Update plan id with try", () { 
      // no id attribute 
    }); 
 
    test("Update plan id without try", () { 
      // no id attribute 
    }); 
 
    test("Update plan id with success", () { 
      // no id attribute 
    }); 
 
    test("Update plan non id attribute with failure", () { 
      var randomPlan = planningModel.plans.random(); 
      var afterUpdateEntity = randomPlan.copy(); 
      afterUpdateEntity.name = 'yellow'; 
      expect(afterUpdateEntity.name, equals('yellow')); 
      // plans.update can only be used if oid, code or id is set. 
      expect(() => plans.update(randomPlan, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomPlan = planningModel.plans.random(); 
      randomPlan.display(prefix:"before copy: "); 
      var randomPlanCopy = randomPlan.copy(); 
      randomPlanCopy.display(prefix:"after copy: "); 
      expect(randomPlan, equals(randomPlanCopy)); 
      expect(randomPlan.oid, equals(randomPlanCopy.oid)); 
      expect(randomPlan.code, equals(randomPlanCopy.code)); 
      expect(randomPlan.name, equals(randomPlanCopy.name)); 
 
    }); 
 
    test("plan action undo and redo", () { 
      var planCount = plans.length; 
      var plan = Plan(plans.concept); 
        plan.name = 'concern'; 
      plans.add(plan); 
      expect(plans.length, equals(++planCount)); 
      plans.remove(plan); 
      expect(plans.length, equals(--planCount)); 
 
      var action = AddCommand(session, plans, plan); 
      action.doIt(); 
      expect(plans.length, equals(++planCount)); 
 
      action.undo(); 
      expect(plans.length, equals(--planCount)); 
 
      action.redo(); 
      expect(plans.length, equals(++planCount)); 
    }); 
 
    test("plan session undo and redo", () { 
      var planCount = plans.length; 
      var plan = Plan(plans.concept); 
        plan.name = 'office'; 
      plans.add(plan); 
      expect(plans.length, equals(++planCount)); 
      plans.remove(plan); 
      expect(plans.length, equals(--planCount)); 
 
      var action = AddCommand(session, plans, plan); 
      action.doIt(); 
      expect(plans.length, equals(++planCount)); 
 
      session.past.undo(); 
      expect(plans.length, equals(--planCount)); 
 
      session.past.redo(); 
      expect(plans.length, equals(++planCount)); 
    }); 
 
    test("Plan update undo and redo", () { 
      var plan = planningModel.plans.random(); 
      var action = SetAttributeCommand(session, plan, "name", 'water'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(plan.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(plan.name, equals(action.after)); 
    }); 
 
    test("Plan action with multiple undos and redos", () { 
      var planCount = plans.length; 
      var plan1 = planningModel.plans.random(); 
 
      var action1 = RemoveCommand(session, plans, plan1); 
      action1.doIt(); 
      expect(plans.length, equals(--planCount)); 
 
      var plan2 = planningModel.plans.random(); 
 
      var action2 = RemoveCommand(session, plans, plan2); 
      action2.doIt(); 
      expect(plans.length, equals(--planCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(plans.length, equals(++planCount)); 
 
      session.past.undo(); 
      expect(plans.length, equals(++planCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(plans.length, equals(--planCount)); 
 
      session.past.redo(); 
      expect(plans.length, equals(--planCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var planCount = plans.length; 
      var plan1 = planningModel.plans.random(); 
      var plan2 = planningModel.plans.random(); 
      while (plan1 == plan2) { 
        plan2 = planningModel.plans.random();  
      } 
      var action1 = RemoveCommand(session, plans, plan1); 
      var action2 = RemoveCommand(session, plans, plan2); 
 
      var transaction = new Transaction("two removes on plans", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      planCount = planCount - 2; 
      expect(plans.length, equals(planCount)); 
 
      plans.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      planCount = planCount + 2; 
      expect(plans.length, equals(planCount)); 
 
      plans.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      planCount = planCount - 2; 
      expect(plans.length, equals(planCount)); 
 
      plans.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var planCount = plans.length; 
      var plan1 = planningModel.plans.random(); 
      var plan2 = plan1; 
      var action1 = RemoveCommand(session, plans, plan1); 
      var action2 = RemoveCommand(session, plans, plan2); 
 
      var transaction = Transaction( 
        "two removes on plans, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(plans.length, equals(planCount)); 
 
      //plans.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to plan actions", () { 
      var planCount = plans.length; 
 
      var reaction = PlanReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var plan = Plan(plans.concept); 
        plan.name = 'word'; 
      plans.add(plan); 
      expect(plans.length, equals(++planCount)); 
      plans.remove(plan); 
      expect(plans.length, equals(--planCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, plans, plan); 
      addCommand.doIt(); 
      expect(plans.length, equals(++planCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, plan, "name", 'professor'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class PlanReaction implements ICommandReaction { 
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
  var repository = ProjectPlanningRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  PlanningModel planningModel = projectDomain.getModelEntries("Planning") as PlanningModel;  
  assert(planningModel != null); 
  var plans = planningModel.plans; 
  testProjectPlanningPlans(projectDomain, planningModel, plans); 
} 
 
