 
// test/project/scheduling/project_scheduling_initiation_phase_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_scheduling/project_scheduling.dart"; 
 
void testProjectSchedulingInitiationPhases( 
    ProjectDomain projectDomain, SchedulingModel schedulingModel, InitiationPhases initiationPhases) { 
  DomainSession session; 
  group("Testing Project.Scheduling.InitiationPhase", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      schedulingModel.init(); 
    }); 
    tearDown(() { 
      schedulingModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(schedulingModel.isEmpty, isFalse); 
      expect(initiationPhases.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      schedulingModel.clear(); 
      expect(schedulingModel.isEmpty, isTrue); 
      expect(initiationPhases.isEmpty, isTrue); 
      expect(initiationPhases.exceptions.isEmpty, isTrue); 
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
      var json = schedulingModel.fromEntryToJson("InitiationPhase"); 
      expect(json, isNotNull); 
 
      print(json); 
      //schedulingModel.displayEntryJson("InitiationPhase"); 
      //schedulingModel.displayJson(); 
      //schedulingModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = schedulingModel.fromEntryToJson("InitiationPhase"); 
      initiationPhases.clear(); 
      expect(initiationPhases.isEmpty, isTrue); 
      schedulingModel.fromJsonToEntry(json); 
      expect(initiationPhases.isEmpty, isFalse); 
 
      initiationPhases.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add initiationPhase required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add initiationPhase unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found initiationPhase by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var initiationPhase = initiationPhases.singleWhereOid(ednetOid); 
      expect(initiationPhase, isNull); 
    }); 
 
    test("Find initiationPhase by oid", () { 
      var randomInitiationPhase = schedulingModel.initiationPhases.random(); 
      var initiationPhase = initiationPhases.singleWhereOid(randomInitiationPhase.oid); 
      expect(initiationPhase, isNotNull); 
      expect(initiationPhase, equals(randomInitiationPhase)); 
    }); 
 
    test("Find initiationPhase by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find initiationPhase by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find initiationPhase by attribute", () { 
      var randomInitiationPhase = schedulingModel.initiationPhases.random(); 
      var initiationPhase = 
          initiationPhases.firstWhereAttribute("ProjectCharter", randomInitiationPhase.ProjectCharter); 
      expect(initiationPhase, isNotNull); 
      expect(initiationPhase.ProjectCharter, equals(randomInitiationPhase.ProjectCharter)); 
    }); 
 
    test("Select initiationPhases by attribute", () { 
      var randomInitiationPhase = schedulingModel.initiationPhases.random(); 
      var selectedInitiationPhases = 
          initiationPhases.selectWhereAttribute("ProjectCharter", randomInitiationPhase.ProjectCharter); 
      expect(selectedInitiationPhases.isEmpty, isFalse); 
      selectedInitiationPhases.forEach((se) => 
          expect(se.ProjectCharter, equals(randomInitiationPhase.ProjectCharter))); 
 
      //selectedInitiationPhases.display(title: "Select initiationPhases by ProjectCharter"); 
    }); 
 
    test("Select initiationPhases by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select initiationPhases by attribute, then add", () { 
      var randomInitiationPhase = schedulingModel.initiationPhases.random(); 
      var selectedInitiationPhases = 
          initiationPhases.selectWhereAttribute("ProjectCharter", randomInitiationPhase.ProjectCharter); 
      expect(selectedInitiationPhases.isEmpty, isFalse); 
      expect(selectedInitiationPhases.source?.isEmpty, isFalse); 
      var initiationPhasesCount = initiationPhases.length; 
 
      var initiationPhase = InitiationPhase(initiationPhases.concept); 
      initiationPhase.ProjectCharter = 'dinner'; 
      initiationPhase.StakeholderIdentification = 'pattern'; 
      initiationPhase.FeasibilityStudy = 'dvd'; 
      initiationPhase.ProjectGoals = 'grading'; 
      var added = selectedInitiationPhases.add(initiationPhase); 
      expect(added, isTrue); 
      expect(initiationPhases.length, equals(++initiationPhasesCount)); 
 
      //selectedInitiationPhases.display(title: 
      //  "Select initiationPhases by attribute, then add"); 
      //initiationPhases.display(title: "All initiationPhases"); 
    }); 
 
    test("Select initiationPhases by attribute, then remove", () { 
      var randomInitiationPhase = schedulingModel.initiationPhases.random(); 
      var selectedInitiationPhases = 
          initiationPhases.selectWhereAttribute("ProjectCharter", randomInitiationPhase.ProjectCharter); 
      expect(selectedInitiationPhases.isEmpty, isFalse); 
      expect(selectedInitiationPhases.source?.isEmpty, isFalse); 
      var initiationPhasesCount = initiationPhases.length; 
 
      var removed = selectedInitiationPhases.remove(randomInitiationPhase); 
      expect(removed, isTrue); 
      expect(initiationPhases.length, equals(--initiationPhasesCount)); 
 
      randomInitiationPhase.display(prefix: "removed"); 
      //selectedInitiationPhases.display(title: 
      //  "Select initiationPhases by attribute, then remove"); 
      //initiationPhases.display(title: "All initiationPhases"); 
    }); 
 
    test("Sort initiationPhases", () { 
      // no id attribute 
      // add compareTo method in the specific InitiationPhase class 
      /* 
      initiationPhases.sort(); 
 
      //initiationPhases.display(title: "Sort initiationPhases"); 
      */ 
    }); 
 
    test("Order initiationPhases", () { 
      // no id attribute 
      // add compareTo method in the specific InitiationPhase class 
      /* 
      var orderedInitiationPhases = initiationPhases.order(); 
      expect(orderedInitiationPhases.isEmpty, isFalse); 
      expect(orderedInitiationPhases.length, equals(initiationPhases.length)); 
      expect(orderedInitiationPhases.source?.isEmpty, isFalse); 
      expect(orderedInitiationPhases.source?.length, equals(initiationPhases.length)); 
      expect(orderedInitiationPhases, isNot(same(initiationPhases))); 
 
      //orderedInitiationPhases.display(title: "Order initiationPhases"); 
      */ 
    }); 
 
    test("Copy initiationPhases", () { 
      var copiedInitiationPhases = initiationPhases.copy(); 
      expect(copiedInitiationPhases.isEmpty, isFalse); 
      expect(copiedInitiationPhases.length, equals(initiationPhases.length)); 
      expect(copiedInitiationPhases, isNot(same(initiationPhases))); 
      copiedInitiationPhases.forEach((e) => 
        expect(e, equals(initiationPhases.singleWhereOid(e.oid)))); 
 
      //copiedInitiationPhases.display(title: "Copy initiationPhases"); 
    }); 
 
    test("True for every initiationPhase", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random initiationPhase", () { 
      var initiationPhase1 = schedulingModel.initiationPhases.random(); 
      expect(initiationPhase1, isNotNull); 
      var initiationPhase2 = schedulingModel.initiationPhases.random(); 
      expect(initiationPhase2, isNotNull); 
 
      //initiationPhase1.display(prefix: "random1"); 
      //initiationPhase2.display(prefix: "random2"); 
    }); 
 
    test("Update initiationPhase id with try", () { 
      // no id attribute 
    }); 
 
    test("Update initiationPhase id without try", () { 
      // no id attribute 
    }); 
 
    test("Update initiationPhase id with success", () { 
      // no id attribute 
    }); 
 
    test("Update initiationPhase non id attribute with failure", () { 
      var randomInitiationPhase = schedulingModel.initiationPhases.random(); 
      var afterUpdateEntity = randomInitiationPhase.copy(); 
      afterUpdateEntity.ProjectCharter = 'accident'; 
      expect(afterUpdateEntity.ProjectCharter, equals('accident')); 
      // initiationPhases.update can only be used if oid, code or id is set. 
      expect(() => initiationPhases.update(randomInitiationPhase, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomInitiationPhase = schedulingModel.initiationPhases.random(); 
      randomInitiationPhase.display(prefix:"before copy: "); 
      var randomInitiationPhaseCopy = randomInitiationPhase.copy(); 
      randomInitiationPhaseCopy.display(prefix:"after copy: "); 
      expect(randomInitiationPhase, equals(randomInitiationPhaseCopy)); 
      expect(randomInitiationPhase.oid, equals(randomInitiationPhaseCopy.oid)); 
      expect(randomInitiationPhase.code, equals(randomInitiationPhaseCopy.code)); 
      expect(randomInitiationPhase.ProjectCharter, equals(randomInitiationPhaseCopy.ProjectCharter)); 
      expect(randomInitiationPhase.StakeholderIdentification, equals(randomInitiationPhaseCopy.StakeholderIdentification)); 
      expect(randomInitiationPhase.FeasibilityStudy, equals(randomInitiationPhaseCopy.FeasibilityStudy)); 
      expect(randomInitiationPhase.ProjectGoals, equals(randomInitiationPhaseCopy.ProjectGoals)); 
 
    }); 
 
    test("initiationPhase action undo and redo", () { 
      var initiationPhaseCount = initiationPhases.length; 
      var initiationPhase = InitiationPhase(initiationPhases.concept); 
        initiationPhase.ProjectCharter = 'country'; 
      initiationPhase.StakeholderIdentification = 'email'; 
      initiationPhase.FeasibilityStudy = 'tension'; 
      initiationPhase.ProjectGoals = 'body'; 
      initiationPhases.add(initiationPhase); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
      initiationPhases.remove(initiationPhase); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      var action = AddCommand(session, initiationPhases, initiationPhase); 
      action.doIt(); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
 
      action.undo(); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      action.redo(); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
    }); 
 
    test("initiationPhase session undo and redo", () { 
      var initiationPhaseCount = initiationPhases.length; 
      var initiationPhase = InitiationPhase(initiationPhases.concept); 
        initiationPhase.ProjectCharter = 'camping'; 
      initiationPhase.StakeholderIdentification = 'salad'; 
      initiationPhase.FeasibilityStudy = 'enquiry'; 
      initiationPhase.ProjectGoals = 'car'; 
      initiationPhases.add(initiationPhase); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
      initiationPhases.remove(initiationPhase); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      var action = AddCommand(session, initiationPhases, initiationPhase); 
      action.doIt(); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
 
      session.past.undo(); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      session.past.redo(); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
    }); 
 
    test("InitiationPhase update undo and redo", () { 
      var initiationPhase = schedulingModel.initiationPhases.random(); 
      var action = SetAttributeCommand(session, initiationPhase, "ProjectCharter", 'lifespan'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(initiationPhase.ProjectCharter, equals(action.before)); 
 
      session.past.redo(); 
      expect(initiationPhase.ProjectCharter, equals(action.after)); 
    }); 
 
    test("InitiationPhase action with multiple undos and redos", () { 
      var initiationPhaseCount = initiationPhases.length; 
      var initiationPhase1 = schedulingModel.initiationPhases.random(); 
 
      var action1 = RemoveCommand(session, initiationPhases, initiationPhase1); 
      action1.doIt(); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      var initiationPhase2 = schedulingModel.initiationPhases.random(); 
 
      var action2 = RemoveCommand(session, initiationPhases, initiationPhase2); 
      action2.doIt(); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
 
      session.past.undo(); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      session.past.redo(); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var initiationPhaseCount = initiationPhases.length; 
      var initiationPhase1 = schedulingModel.initiationPhases.random(); 
      var initiationPhase2 = schedulingModel.initiationPhases.random(); 
      while (initiationPhase1 == initiationPhase2) { 
        initiationPhase2 = schedulingModel.initiationPhases.random();  
      } 
      var action1 = RemoveCommand(session, initiationPhases, initiationPhase1); 
      var action2 = RemoveCommand(session, initiationPhases, initiationPhase2); 
 
      var transaction = new Transaction("two removes on initiationPhases", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      initiationPhaseCount = initiationPhaseCount - 2; 
      expect(initiationPhases.length, equals(initiationPhaseCount)); 
 
      initiationPhases.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      initiationPhaseCount = initiationPhaseCount + 2; 
      expect(initiationPhases.length, equals(initiationPhaseCount)); 
 
      initiationPhases.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      initiationPhaseCount = initiationPhaseCount - 2; 
      expect(initiationPhases.length, equals(initiationPhaseCount)); 
 
      initiationPhases.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var initiationPhaseCount = initiationPhases.length; 
      var initiationPhase1 = schedulingModel.initiationPhases.random(); 
      var initiationPhase2 = initiationPhase1; 
      var action1 = RemoveCommand(session, initiationPhases, initiationPhase1); 
      var action2 = RemoveCommand(session, initiationPhases, initiationPhase2); 
 
      var transaction = Transaction( 
        "two removes on initiationPhases, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(initiationPhases.length, equals(initiationPhaseCount)); 
 
      //initiationPhases.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to initiationPhase actions", () { 
      var initiationPhaseCount = initiationPhases.length; 
 
      var reaction = InitiationPhaseReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var initiationPhase = InitiationPhase(initiationPhases.concept); 
        initiationPhase.ProjectCharter = 'question'; 
      initiationPhase.StakeholderIdentification = 'tension'; 
      initiationPhase.FeasibilityStudy = 'country'; 
      initiationPhase.ProjectGoals = 'message'; 
      initiationPhases.add(initiationPhase); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
      initiationPhases.remove(initiationPhase); 
      expect(initiationPhases.length, equals(--initiationPhaseCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, initiationPhases, initiationPhase); 
      addCommand.doIt(); 
      expect(initiationPhases.length, equals(++initiationPhaseCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, initiationPhase, "ProjectCharter", 'season'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class InitiationPhaseReaction implements ICommandReaction { 
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
  var initiationPhases = schedulingModel.initiationPhases; 
  testProjectSchedulingInitiationPhases(projectDomain, schedulingModel, initiationPhases); 
} 
 
