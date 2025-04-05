 
// test/project/scheduling/project_scheduling_execution_phase_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_scheduling/project_scheduling.dart"; 
 
void testProjectSchedulingExecutionPhases( 
    ProjectDomain projectDomain, SchedulingModel schedulingModel, ExecutionPhases executionPhases) { 
  DomainSession session; 
  group("Testing Project.Scheduling.ExecutionPhase", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      schedulingModel.init(); 
    }); 
    tearDown(() { 
      schedulingModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(schedulingModel.isEmpty, isFalse); 
      expect(executionPhases.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      schedulingModel.clear(); 
      expect(schedulingModel.isEmpty, isTrue); 
      expect(executionPhases.isEmpty, isTrue); 
      expect(executionPhases.exceptions.isEmpty, isTrue); 
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
      var json = schedulingModel.fromEntryToJson("ExecutionPhase"); 
      expect(json, isNotNull); 
 
      print(json); 
      //schedulingModel.displayEntryJson("ExecutionPhase"); 
      //schedulingModel.displayJson(); 
      //schedulingModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = schedulingModel.fromEntryToJson("ExecutionPhase"); 
      executionPhases.clear(); 
      expect(executionPhases.isEmpty, isTrue); 
      schedulingModel.fromJsonToEntry(json); 
      expect(executionPhases.isEmpty, isFalse); 
 
      executionPhases.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add executionPhase required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add executionPhase unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found executionPhase by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var executionPhase = executionPhases.singleWhereOid(ednetOid); 
      expect(executionPhase, isNull); 
    }); 
 
    test("Find executionPhase by oid", () { 
      var randomExecutionPhase = schedulingModel.executionPhases.random(); 
      var executionPhase = executionPhases.singleWhereOid(randomExecutionPhase.oid); 
      expect(executionPhase, isNotNull); 
      expect(executionPhase, equals(randomExecutionPhase)); 
    }); 
 
    test("Find executionPhase by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find executionPhase by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find executionPhase by attribute", () { 
      var randomExecutionPhase = schedulingModel.executionPhases.random(); 
      var executionPhase = 
          executionPhases.firstWhereAttribute("TaskAssignment", randomExecutionPhase.TaskAssignment); 
      expect(executionPhase, isNotNull); 
      expect(executionPhase.TaskAssignment, equals(randomExecutionPhase.TaskAssignment)); 
    }); 
 
    test("Select executionPhases by attribute", () { 
      var randomExecutionPhase = schedulingModel.executionPhases.random(); 
      var selectedExecutionPhases = 
          executionPhases.selectWhereAttribute("TaskAssignment", randomExecutionPhase.TaskAssignment); 
      expect(selectedExecutionPhases.isEmpty, isFalse); 
      selectedExecutionPhases.forEach((se) => 
          expect(se.TaskAssignment, equals(randomExecutionPhase.TaskAssignment))); 
 
      //selectedExecutionPhases.display(title: "Select executionPhases by TaskAssignment"); 
    }); 
 
    test("Select executionPhases by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select executionPhases by attribute, then add", () { 
      var randomExecutionPhase = schedulingModel.executionPhases.random(); 
      var selectedExecutionPhases = 
          executionPhases.selectWhereAttribute("TaskAssignment", randomExecutionPhase.TaskAssignment); 
      expect(selectedExecutionPhases.isEmpty, isFalse); 
      expect(selectedExecutionPhases.source?.isEmpty, isFalse); 
      var executionPhasesCount = executionPhases.length; 
 
      var executionPhase = ExecutionPhase(executionPhases.concept); 
      executionPhase.TaskAssignment = 'blue'; 
      executionPhase.ResourceAllocation = 'organization'; 
      executionPhase.ProjectManagement = 'highway'; 
      executionPhase.QualityAssurance = 'line'; 
      executionPhase.Communication = 'series'; 
      executionPhase.RiskMonitoring = 'selfdo'; 
      var added = selectedExecutionPhases.add(executionPhase); 
      expect(added, isTrue); 
      expect(executionPhases.length, equals(++executionPhasesCount)); 
 
      //selectedExecutionPhases.display(title: 
      //  "Select executionPhases by attribute, then add"); 
      //executionPhases.display(title: "All executionPhases"); 
    }); 
 
    test("Select executionPhases by attribute, then remove", () { 
      var randomExecutionPhase = schedulingModel.executionPhases.random(); 
      var selectedExecutionPhases = 
          executionPhases.selectWhereAttribute("TaskAssignment", randomExecutionPhase.TaskAssignment); 
      expect(selectedExecutionPhases.isEmpty, isFalse); 
      expect(selectedExecutionPhases.source?.isEmpty, isFalse); 
      var executionPhasesCount = executionPhases.length; 
 
      var removed = selectedExecutionPhases.remove(randomExecutionPhase); 
      expect(removed, isTrue); 
      expect(executionPhases.length, equals(--executionPhasesCount)); 
 
      randomExecutionPhase.display(prefix: "removed"); 
      //selectedExecutionPhases.display(title: 
      //  "Select executionPhases by attribute, then remove"); 
      //executionPhases.display(title: "All executionPhases"); 
    }); 
 
    test("Sort executionPhases", () { 
      // no id attribute 
      // add compareTo method in the specific ExecutionPhase class 
      /* 
      executionPhases.sort(); 
 
      //executionPhases.display(title: "Sort executionPhases"); 
      */ 
    }); 
 
    test("Order executionPhases", () { 
      // no id attribute 
      // add compareTo method in the specific ExecutionPhase class 
      /* 
      var orderedExecutionPhases = executionPhases.order(); 
      expect(orderedExecutionPhases.isEmpty, isFalse); 
      expect(orderedExecutionPhases.length, equals(executionPhases.length)); 
      expect(orderedExecutionPhases.source?.isEmpty, isFalse); 
      expect(orderedExecutionPhases.source?.length, equals(executionPhases.length)); 
      expect(orderedExecutionPhases, isNot(same(executionPhases))); 
 
      //orderedExecutionPhases.display(title: "Order executionPhases"); 
      */ 
    }); 
 
    test("Copy executionPhases", () { 
      var copiedExecutionPhases = executionPhases.copy(); 
      expect(copiedExecutionPhases.isEmpty, isFalse); 
      expect(copiedExecutionPhases.length, equals(executionPhases.length)); 
      expect(copiedExecutionPhases, isNot(same(executionPhases))); 
      copiedExecutionPhases.forEach((e) => 
        expect(e, equals(executionPhases.singleWhereOid(e.oid)))); 
 
      //copiedExecutionPhases.display(title: "Copy executionPhases"); 
    }); 
 
    test("True for every executionPhase", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random executionPhase", () { 
      var executionPhase1 = schedulingModel.executionPhases.random(); 
      expect(executionPhase1, isNotNull); 
      var executionPhase2 = schedulingModel.executionPhases.random(); 
      expect(executionPhase2, isNotNull); 
 
      //executionPhase1.display(prefix: "random1"); 
      //executionPhase2.display(prefix: "random2"); 
    }); 
 
    test("Update executionPhase id with try", () { 
      // no id attribute 
    }); 
 
    test("Update executionPhase id without try", () { 
      // no id attribute 
    }); 
 
    test("Update executionPhase id with success", () { 
      // no id attribute 
    }); 
 
    test("Update executionPhase non id attribute with failure", () { 
      var randomExecutionPhase = schedulingModel.executionPhases.random(); 
      var afterUpdateEntity = randomExecutionPhase.copy(); 
      afterUpdateEntity.TaskAssignment = 'umbrella'; 
      expect(afterUpdateEntity.TaskAssignment, equals('umbrella')); 
      // executionPhases.update can only be used if oid, code or id is set. 
      expect(() => executionPhases.update(randomExecutionPhase, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomExecutionPhase = schedulingModel.executionPhases.random(); 
      randomExecutionPhase.display(prefix:"before copy: "); 
      var randomExecutionPhaseCopy = randomExecutionPhase.copy(); 
      randomExecutionPhaseCopy.display(prefix:"after copy: "); 
      expect(randomExecutionPhase, equals(randomExecutionPhaseCopy)); 
      expect(randomExecutionPhase.oid, equals(randomExecutionPhaseCopy.oid)); 
      expect(randomExecutionPhase.code, equals(randomExecutionPhaseCopy.code)); 
      expect(randomExecutionPhase.TaskAssignment, equals(randomExecutionPhaseCopy.TaskAssignment)); 
      expect(randomExecutionPhase.ResourceAllocation, equals(randomExecutionPhaseCopy.ResourceAllocation)); 
      expect(randomExecutionPhase.ProjectManagement, equals(randomExecutionPhaseCopy.ProjectManagement)); 
      expect(randomExecutionPhase.QualityAssurance, equals(randomExecutionPhaseCopy.QualityAssurance)); 
      expect(randomExecutionPhase.Communication, equals(randomExecutionPhaseCopy.Communication)); 
      expect(randomExecutionPhase.RiskMonitoring, equals(randomExecutionPhaseCopy.RiskMonitoring)); 
 
    }); 
 
    test("executionPhase action undo and redo", () { 
      var executionPhaseCount = executionPhases.length; 
      var executionPhase = ExecutionPhase(executionPhases.concept); 
        executionPhase.TaskAssignment = 'offence'; 
      executionPhase.ResourceAllocation = 'kids'; 
      executionPhase.ProjectManagement = 'sailing'; 
      executionPhase.QualityAssurance = 'celebration'; 
      executionPhase.Communication = 'cabinet'; 
      executionPhase.RiskMonitoring = 'discount'; 
    var executionPhasePlanningPhase = schedulingModel.planningPhases.random(); 
    executionPhase.planningPhase = executionPhasePlanningPhase; 
      executionPhases.add(executionPhase); 
    executionPhasePlanningPhase.executionPhase.add(executionPhase); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
      executionPhases.remove(executionPhase); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      var action = AddCommand(session, executionPhases, executionPhase); 
      action.doIt(); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
 
      action.undo(); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      action.redo(); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
    }); 
 
    test("executionPhase session undo and redo", () { 
      var executionPhaseCount = executionPhases.length; 
      var executionPhase = ExecutionPhase(executionPhases.concept); 
        executionPhase.TaskAssignment = 'sun'; 
      executionPhase.ResourceAllocation = 'teacher'; 
      executionPhase.ProjectManagement = 'tape'; 
      executionPhase.QualityAssurance = 'holiday'; 
      executionPhase.Communication = 'place'; 
      executionPhase.RiskMonitoring = 'parfem'; 
    var executionPhasePlanningPhase = schedulingModel.planningPhases.random(); 
    executionPhase.planningPhase = executionPhasePlanningPhase; 
      executionPhases.add(executionPhase); 
    executionPhasePlanningPhase.executionPhase.add(executionPhase); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
      executionPhases.remove(executionPhase); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      var action = AddCommand(session, executionPhases, executionPhase); 
      action.doIt(); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
 
      session.past.undo(); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      session.past.redo(); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
    }); 
 
    test("ExecutionPhase update undo and redo", () { 
      var executionPhase = schedulingModel.executionPhases.random(); 
      var action = SetAttributeCommand(session, executionPhase, "TaskAssignment", 'college'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(executionPhase.TaskAssignment, equals(action.before)); 
 
      session.past.redo(); 
      expect(executionPhase.TaskAssignment, equals(action.after)); 
    }); 
 
    test("ExecutionPhase action with multiple undos and redos", () { 
      var executionPhaseCount = executionPhases.length; 
      var executionPhase1 = schedulingModel.executionPhases.random(); 
 
      var action1 = RemoveCommand(session, executionPhases, executionPhase1); 
      action1.doIt(); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      var executionPhase2 = schedulingModel.executionPhases.random(); 
 
      var action2 = RemoveCommand(session, executionPhases, executionPhase2); 
      action2.doIt(); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
 
      session.past.undo(); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      session.past.redo(); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var executionPhaseCount = executionPhases.length; 
      var executionPhase1 = schedulingModel.executionPhases.random(); 
      var executionPhase2 = schedulingModel.executionPhases.random(); 
      while (executionPhase1 == executionPhase2) { 
        executionPhase2 = schedulingModel.executionPhases.random();  
      } 
      var action1 = RemoveCommand(session, executionPhases, executionPhase1); 
      var action2 = RemoveCommand(session, executionPhases, executionPhase2); 
 
      var transaction = new Transaction("two removes on executionPhases", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      executionPhaseCount = executionPhaseCount - 2; 
      expect(executionPhases.length, equals(executionPhaseCount)); 
 
      executionPhases.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      executionPhaseCount = executionPhaseCount + 2; 
      expect(executionPhases.length, equals(executionPhaseCount)); 
 
      executionPhases.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      executionPhaseCount = executionPhaseCount - 2; 
      expect(executionPhases.length, equals(executionPhaseCount)); 
 
      executionPhases.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var executionPhaseCount = executionPhases.length; 
      var executionPhase1 = schedulingModel.executionPhases.random(); 
      var executionPhase2 = executionPhase1; 
      var action1 = RemoveCommand(session, executionPhases, executionPhase1); 
      var action2 = RemoveCommand(session, executionPhases, executionPhase2); 
 
      var transaction = Transaction( 
        "two removes on executionPhases, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(executionPhases.length, equals(executionPhaseCount)); 
 
      //executionPhases.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to executionPhase actions", () { 
      var executionPhaseCount = executionPhases.length; 
 
      var reaction = ExecutionPhaseReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var executionPhase = ExecutionPhase(executionPhases.concept); 
        executionPhase.TaskAssignment = 'vessel'; 
      executionPhase.ResourceAllocation = 'cabinet'; 
      executionPhase.ProjectManagement = 'room'; 
      executionPhase.QualityAssurance = 'top'; 
      executionPhase.Communication = 'fish'; 
      executionPhase.RiskMonitoring = 'east'; 
    var executionPhasePlanningPhase = schedulingModel.planningPhases.random(); 
    executionPhase.planningPhase = executionPhasePlanningPhase; 
      executionPhases.add(executionPhase); 
    executionPhasePlanningPhase.executionPhase.add(executionPhase); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
      executionPhases.remove(executionPhase); 
      expect(executionPhases.length, equals(--executionPhaseCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, executionPhases, executionPhase); 
      addCommand.doIt(); 
      expect(executionPhases.length, equals(++executionPhaseCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, executionPhase, "TaskAssignment", 'sailing'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ExecutionPhaseReaction implements ICommandReaction { 
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
  var executionPhases = schedulingModel.executionPhases; 
  testProjectSchedulingExecutionPhases(projectDomain, schedulingModel, executionPhases); 
} 
 
