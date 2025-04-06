 
// test/project/scheduling/project_scheduling_planning_phase_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_scheduling/project_scheduling.dart"; 
 
void testProjectSchedulingPlanningPhases( 
    ProjectDomain projectDomain, SchedulingModel schedulingModel, PlanningPhases planningPhases) { 
  DomainSession session; 
  group("Testing Project.Scheduling.PlanningPhase", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      schedulingModel.init(); 
    }); 
    tearDown(() { 
      schedulingModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(schedulingModel.isEmpty, isFalse); 
      expect(planningPhases.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      schedulingModel.clear(); 
      expect(schedulingModel.isEmpty, isTrue); 
      expect(planningPhases.isEmpty, isTrue); 
      expect(planningPhases.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = schedulingModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //schedulingModel.displayJson(); 
      //schedulingModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = schedulingModel.toJson(); 
      schedulingModel.clear(); 
      expect(schedulingModel.isEmpty, isTrue); 
      schedulingModel.fromJson(json); 
      expect(schedulingModel.isEmpty, isFalse); 
 
      schedulingModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = schedulingModel.fromEntryToJson("PlanningPhase"); 
      expect(json, isNotNull); 
 
      print(json); 
      //schedulingModel.displayEntryJson("PlanningPhase"); 
      //schedulingModel.displayJson(); 
      //schedulingModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = schedulingModel.fromEntryToJson("PlanningPhase"); 
      planningPhases.clear(); 
      expect(planningPhases.isEmpty, isTrue); 
      schedulingModel.fromJsonToEntry(json); 
      expect(planningPhases.isEmpty, isFalse); 
 
      planningPhases.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add planningPhase required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add planningPhase unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found planningPhase by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var planningPhase = planningPhases.singleWhereOid(ednetOid); 
      expect(planningPhase, isNull); 
    }); 
 
    test("Find planningPhase by oid", () { 
      var randomPlanningPhase = schedulingModel.planningPhases.random(); 
      var planningPhase = planningPhases.singleWhereOid(randomPlanningPhase.oid); 
      expect(planningPhase, isNotNull); 
      expect(planningPhase, equals(randomPlanningPhase)); 
    }); 
 
    test("Find planningPhase by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find planningPhase by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find planningPhase by attribute", () { 
      var randomPlanningPhase = schedulingModel.planningPhases.random(); 
      var planningPhase = 
          planningPhases.firstWhereAttribute("ScopeDefinition", randomPlanningPhase.ScopeDefinition); 
      expect(planningPhase, isNotNull); 
      expect(planningPhase.ScopeDefinition, equals(randomPlanningPhase.ScopeDefinition)); 
    }); 
 
    test("Select planningPhases by attribute", () { 
      var randomPlanningPhase = schedulingModel.planningPhases.random(); 
      var selectedPlanningPhases = 
          planningPhases.selectWhereAttribute("ScopeDefinition", randomPlanningPhase.ScopeDefinition); 
      expect(selectedPlanningPhases.isEmpty, isFalse); 
      selectedPlanningPhases.forEach((se) => 
          expect(se.ScopeDefinition, equals(randomPlanningPhase.ScopeDefinition))); 
 
      //selectedPlanningPhases.display(title: "Select planningPhases by ScopeDefinition"); 
    }); 
 
    test("Select planningPhases by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select planningPhases by attribute, then add", () { 
      var randomPlanningPhase = schedulingModel.planningPhases.random(); 
      var selectedPlanningPhases = 
          planningPhases.selectWhereAttribute("ScopeDefinition", randomPlanningPhase.ScopeDefinition); 
      expect(selectedPlanningPhases.isEmpty, isFalse); 
      expect(selectedPlanningPhases.source?.isEmpty, isFalse); 
      var planningPhasesCount = planningPhases.length; 
 
      var planningPhase = PlanningPhase(planningPhases.concept); 
      planningPhase.ScopeDefinition = 'chemist'; 
      planningPhase.WorkBreakdownStructure = 'city'; 
      planningPhase.ScheduleDevelopment = 'revolution'; 
      planningPhase.ResourcePlanning = 'entertainment'; 
      planningPhase.Budgeting = 'money'; 
      planningPhase.RiskManagement = 'life'; 
      planningPhase.CommunicationPlan = 'point'; 
      var added = selectedPlanningPhases.add(planningPhase); 
      expect(added, isTrue); 
      expect(planningPhases.length, equals(++planningPhasesCount)); 
 
      //selectedPlanningPhases.display(title: 
      //  "Select planningPhases by attribute, then add"); 
      //planningPhases.display(title: "All planningPhases"); 
    }); 
 
    test("Select planningPhases by attribute, then remove", () { 
      var randomPlanningPhase = schedulingModel.planningPhases.random(); 
      var selectedPlanningPhases = 
          planningPhases.selectWhereAttribute("ScopeDefinition", randomPlanningPhase.ScopeDefinition); 
      expect(selectedPlanningPhases.isEmpty, isFalse); 
      expect(selectedPlanningPhases.source?.isEmpty, isFalse); 
      var planningPhasesCount = planningPhases.length; 
 
      var removed = selectedPlanningPhases.remove(randomPlanningPhase); 
      expect(removed, isTrue); 
      expect(planningPhases.length, equals(--planningPhasesCount)); 
 
      randomPlanningPhase.display(prefix: "removed"); 
      //selectedPlanningPhases.display(title: 
      //  "Select planningPhases by attribute, then remove"); 
      //planningPhases.display(title: "All planningPhases"); 
    }); 
 
    test("Sort planningPhases", () { 
      // no id attribute 
      // add compareTo method in the specific PlanningPhase class 
      /* 
      planningPhases.sort(); 
 
      //planningPhases.display(title: "Sort planningPhases"); 
      */ 
    }); 
 
    test("Order planningPhases", () { 
      // no id attribute 
      // add compareTo method in the specific PlanningPhase class 
      /* 
      var orderedPlanningPhases = planningPhases.order(); 
      expect(orderedPlanningPhases.isEmpty, isFalse); 
      expect(orderedPlanningPhases.length, equals(planningPhases.length)); 
      expect(orderedPlanningPhases.source?.isEmpty, isFalse); 
      expect(orderedPlanningPhases.source?.length, equals(planningPhases.length)); 
      expect(orderedPlanningPhases, isNot(same(planningPhases))); 
 
      //orderedPlanningPhases.display(title: "Order planningPhases"); 
      */ 
    }); 
 
    test("Copy planningPhases", () { 
      var copiedPlanningPhases = planningPhases.copy(); 
      expect(copiedPlanningPhases.isEmpty, isFalse); 
      expect(copiedPlanningPhases.length, equals(planningPhases.length)); 
      expect(copiedPlanningPhases, isNot(same(planningPhases))); 
      copiedPlanningPhases.forEach((e) => 
        expect(e, equals(planningPhases.singleWhereOid(e.oid)))); 
 
      //copiedPlanningPhases.display(title: "Copy planningPhases"); 
    }); 
 
    test("True for every planningPhase", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random planningPhase", () { 
      var planningPhase1 = schedulingModel.planningPhases.random(); 
      expect(planningPhase1, isNotNull); 
      var planningPhase2 = schedulingModel.planningPhases.random(); 
      expect(planningPhase2, isNotNull); 
 
      //planningPhase1.display(prefix: "random1"); 
      //planningPhase2.display(prefix: "random2"); 
    }); 
 
    test("Update planningPhase id with try", () { 
      // no id attribute 
    }); 
 
    test("Update planningPhase id without try", () { 
      // no id attribute 
    }); 
 
    test("Update planningPhase id with success", () { 
      // no id attribute 
    }); 
 
    test("Update planningPhase non id attribute with failure", () { 
      var randomPlanningPhase = schedulingModel.planningPhases.random(); 
      var afterUpdateEntity = randomPlanningPhase.copy(); 
      afterUpdateEntity.ScopeDefinition = 'place'; 
      expect(afterUpdateEntity.ScopeDefinition, equals('place')); 
      // planningPhases.update can only be used if oid, code or id is set. 
      expect(() => planningPhases.update(randomPlanningPhase, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomPlanningPhase = schedulingModel.planningPhases.random(); 
      randomPlanningPhase.display(prefix:"before copy: "); 
      var randomPlanningPhaseCopy = randomPlanningPhase.copy(); 
      randomPlanningPhaseCopy.display(prefix:"after copy: "); 
      expect(randomPlanningPhase, equals(randomPlanningPhaseCopy)); 
      expect(randomPlanningPhase.oid, equals(randomPlanningPhaseCopy.oid)); 
      expect(randomPlanningPhase.code, equals(randomPlanningPhaseCopy.code)); 
      expect(randomPlanningPhase.ScopeDefinition, equals(randomPlanningPhaseCopy.ScopeDefinition)); 
      expect(randomPlanningPhase.WorkBreakdownStructure, equals(randomPlanningPhaseCopy.WorkBreakdownStructure)); 
      expect(randomPlanningPhase.ScheduleDevelopment, equals(randomPlanningPhaseCopy.ScheduleDevelopment)); 
      expect(randomPlanningPhase.ResourcePlanning, equals(randomPlanningPhaseCopy.ResourcePlanning)); 
      expect(randomPlanningPhase.Budgeting, equals(randomPlanningPhaseCopy.Budgeting)); 
      expect(randomPlanningPhase.RiskManagement, equals(randomPlanningPhaseCopy.RiskManagement)); 
      expect(randomPlanningPhase.CommunicationPlan, equals(randomPlanningPhaseCopy.CommunicationPlan)); 
 
    }); 
 
    test("planningPhase action undo and redo", () { 
      var planningPhaseCount = planningPhases.length; 
      var planningPhase = PlanningPhase(planningPhases.concept); 
        planningPhase.ScopeDefinition = 'call'; 
      planningPhase.WorkBreakdownStructure = 'universe'; 
      planningPhase.ScheduleDevelopment = 'unit'; 
      planningPhase.ResourcePlanning = 'paper'; 
      planningPhase.Budgeting = 'celebration'; 
      planningPhase.RiskManagement = 'car'; 
      planningPhase.CommunicationPlan = 'ticket'; 
    var planningPhaseInitiationPhase = schedulingModel.initiationPhases.random(); 
    planningPhase.initiationPhase = planningPhaseInitiationPhase; 
      planningPhases.add(planningPhase); 
    planningPhaseInitiationPhase.planningPhase.add(planningPhase); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
      planningPhases.remove(planningPhase); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      var action = AddCommand(session, planningPhases, planningPhase); 
      action.doIt(); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
 
      action.undo(); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      action.redo(); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
    }); 
 
    test("planningPhase session undo and redo", () { 
      var planningPhaseCount = planningPhases.length; 
      var planningPhase = PlanningPhase(planningPhases.concept); 
        planningPhase.ScopeDefinition = 'team'; 
      planningPhase.WorkBreakdownStructure = 'deep'; 
      planningPhase.ScheduleDevelopment = 'baby'; 
      planningPhase.ResourcePlanning = 'girl'; 
      planningPhase.Budgeting = 'universe'; 
      planningPhase.RiskManagement = 'pub'; 
      planningPhase.CommunicationPlan = 'home'; 
    var planningPhaseInitiationPhase = schedulingModel.initiationPhases.random(); 
    planningPhase.initiationPhase = planningPhaseInitiationPhase; 
      planningPhases.add(planningPhase); 
    planningPhaseInitiationPhase.planningPhase.add(planningPhase); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
      planningPhases.remove(planningPhase); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      var action = AddCommand(session, planningPhases, planningPhase); 
      action.doIt(); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
 
      session.past.undo(); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      session.past.redo(); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
    }); 
 
    test("PlanningPhase update undo and redo", () { 
      var planningPhase = schedulingModel.planningPhases.random(); 
      var action = SetAttributeCommand(session, planningPhase, "ScopeDefinition", 'health'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(planningPhase.ScopeDefinition, equals(action.before)); 
 
      session.past.redo(); 
      expect(planningPhase.ScopeDefinition, equals(action.after)); 
    }); 
 
    test("PlanningPhase action with multiple undos and redos", () { 
      var planningPhaseCount = planningPhases.length; 
      var planningPhase1 = schedulingModel.planningPhases.random(); 
 
      var action1 = RemoveCommand(session, planningPhases, planningPhase1); 
      action1.doIt(); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      var planningPhase2 = schedulingModel.planningPhases.random(); 
 
      var action2 = RemoveCommand(session, planningPhases, planningPhase2); 
      action2.doIt(); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
 
      session.past.undo(); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      session.past.redo(); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var planningPhaseCount = planningPhases.length; 
      var planningPhase1 = schedulingModel.planningPhases.random(); 
      var planningPhase2 = schedulingModel.planningPhases.random(); 
      while (planningPhase1 == planningPhase2) { 
        planningPhase2 = schedulingModel.planningPhases.random();  
      } 
      var action1 = RemoveCommand(session, planningPhases, planningPhase1); 
      var action2 = RemoveCommand(session, planningPhases, planningPhase2); 
 
      var transaction = new Transaction("two removes on planningPhases", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      planningPhaseCount = planningPhaseCount - 2; 
      expect(planningPhases.length, equals(planningPhaseCount)); 
 
      planningPhases.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      planningPhaseCount = planningPhaseCount + 2; 
      expect(planningPhases.length, equals(planningPhaseCount)); 
 
      planningPhases.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      planningPhaseCount = planningPhaseCount - 2; 
      expect(planningPhases.length, equals(planningPhaseCount)); 
 
      planningPhases.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var planningPhaseCount = planningPhases.length; 
      var planningPhase1 = schedulingModel.planningPhases.random(); 
      var planningPhase2 = planningPhase1; 
      var action1 = RemoveCommand(session, planningPhases, planningPhase1); 
      var action2 = RemoveCommand(session, planningPhases, planningPhase2); 
 
      var transaction = Transaction( 
        "two removes on planningPhases, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(planningPhases.length, equals(planningPhaseCount)); 
 
      //planningPhases.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to planningPhase actions", () { 
      var planningPhaseCount = planningPhases.length; 
 
      var reaction = PlanningPhaseReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var planningPhase = PlanningPhase(planningPhases.concept); 
        planningPhase.ScopeDefinition = 'photo'; 
      planningPhase.WorkBreakdownStructure = 'job'; 
      planningPhase.ScheduleDevelopment = 'salary'; 
      planningPhase.ResourcePlanning = 'center'; 
      planningPhase.Budgeting = 'abstract'; 
      planningPhase.RiskManagement = 'country'; 
      planningPhase.CommunicationPlan = 'oil'; 
    var planningPhaseInitiationPhase = schedulingModel.initiationPhases.random(); 
    planningPhase.initiationPhase = planningPhaseInitiationPhase; 
      planningPhases.add(planningPhase); 
    planningPhaseInitiationPhase.planningPhase.add(planningPhase); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
      planningPhases.remove(planningPhase); 
      expect(planningPhases.length, equals(--planningPhaseCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, planningPhases, planningPhase); 
      addCommand.doIt(); 
      expect(planningPhases.length, equals(++planningPhaseCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, planningPhase, "ScopeDefinition", 'umbrella'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class PlanningPhaseReaction implements ICommandReaction { 
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
  var repository = ProjectSchedulingRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  SchedulingModel schedulingModel = projectDomain.getModelEntries("Scheduling") as SchedulingModel;  
  assert(schedulingModel != null); 
  var planningPhases = schedulingModel.planningPhases; 
  testProjectSchedulingPlanningPhases(projectDomain, schedulingModel, planningPhases); 
} 
 
