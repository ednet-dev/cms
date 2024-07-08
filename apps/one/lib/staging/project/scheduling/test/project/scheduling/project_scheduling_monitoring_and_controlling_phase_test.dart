 
// test/project/scheduling/project_scheduling_monitoring_and_controlling_phase_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_scheduling/project_scheduling.dart"; 
 
void testProjectSchedulingMonitoringAndControllingPhases( 
    ProjectDomain projectDomain, SchedulingModel schedulingModel, MonitoringAndControllingPhases monitoringAndControllingPhases) { 
  DomainSession session; 
  group("Testing Project.Scheduling.MonitoringAndControllingPhase", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      schedulingModel.init(); 
    }); 
    tearDown(() { 
      schedulingModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(schedulingModel.isEmpty, isFalse); 
      expect(monitoringAndControllingPhases.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      schedulingModel.clear(); 
      expect(schedulingModel.isEmpty, isTrue); 
      expect(monitoringAndControllingPhases.isEmpty, isTrue); 
      expect(monitoringAndControllingPhases.exceptions.isEmpty, isTrue); 
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
      var json = schedulingModel.fromEntryToJson("MonitoringAndControllingPhase"); 
      expect(json, isNotNull); 
 
      print(json); 
      //schedulingModel.displayEntryJson("MonitoringAndControllingPhase"); 
      //schedulingModel.displayJson(); 
      //schedulingModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = schedulingModel.fromEntryToJson("MonitoringAndControllingPhase"); 
      monitoringAndControllingPhases.clear(); 
      expect(monitoringAndControllingPhases.isEmpty, isTrue); 
      schedulingModel.fromJsonToEntry(json); 
      expect(monitoringAndControllingPhases.isEmpty, isFalse); 
 
      monitoringAndControllingPhases.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add monitoringAndControllingPhase required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add monitoringAndControllingPhase unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found monitoringAndControllingPhase by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var monitoringAndControllingPhase = monitoringAndControllingPhases.singleWhereOid(ednetOid); 
      expect(monitoringAndControllingPhase, isNull); 
    }); 
 
    test("Find monitoringAndControllingPhase by oid", () { 
      var randomMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
      var monitoringAndControllingPhase = monitoringAndControllingPhases.singleWhereOid(randomMonitoringAndControllingPhase.oid); 
      expect(monitoringAndControllingPhase, isNotNull); 
      expect(monitoringAndControllingPhase, equals(randomMonitoringAndControllingPhase)); 
    }); 
 
    test("Find monitoringAndControllingPhase by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find monitoringAndControllingPhase by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find monitoringAndControllingPhase by attribute", () { 
      var randomMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
      var monitoringAndControllingPhase = 
          monitoringAndControllingPhases.firstWhereAttribute("PerformanceMeasurement", randomMonitoringAndControllingPhase.PerformanceMeasurement); 
      expect(monitoringAndControllingPhase, isNotNull); 
      expect(monitoringAndControllingPhase.PerformanceMeasurement, equals(randomMonitoringAndControllingPhase.PerformanceMeasurement)); 
    }); 
 
    test("Select monitoringAndControllingPhases by attribute", () { 
      var randomMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
      var selectedMonitoringAndControllingPhases = 
          monitoringAndControllingPhases.selectWhereAttribute("PerformanceMeasurement", randomMonitoringAndControllingPhase.PerformanceMeasurement); 
      expect(selectedMonitoringAndControllingPhases.isEmpty, isFalse); 
      selectedMonitoringAndControllingPhases.forEach((se) => 
          expect(se.PerformanceMeasurement, equals(randomMonitoringAndControllingPhase.PerformanceMeasurement))); 
 
      //selectedMonitoringAndControllingPhases.display(title: "Select monitoringAndControllingPhases by PerformanceMeasurement"); 
    }); 
 
    test("Select monitoringAndControllingPhases by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select monitoringAndControllingPhases by attribute, then add", () { 
      var randomMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
      var selectedMonitoringAndControllingPhases = 
          monitoringAndControllingPhases.selectWhereAttribute("PerformanceMeasurement", randomMonitoringAndControllingPhase.PerformanceMeasurement); 
      expect(selectedMonitoringAndControllingPhases.isEmpty, isFalse); 
      expect(selectedMonitoringAndControllingPhases.source?.isEmpty, isFalse); 
      var monitoringAndControllingPhasesCount = monitoringAndControllingPhases.length; 
 
      var monitoringAndControllingPhase = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
      monitoringAndControllingPhase.PerformanceMeasurement = 'center'; 
      monitoringAndControllingPhase.ChangeManagement = 'architecture'; 
      monitoringAndControllingPhase.QualityControl = 'message'; 
      monitoringAndControllingPhase.IssueResolution = 'crisis'; 
      monitoringAndControllingPhase.Reporting = 'agreement'; 
      var added = selectedMonitoringAndControllingPhases.add(monitoringAndControllingPhase); 
      expect(added, isTrue); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhasesCount)); 
 
      //selectedMonitoringAndControllingPhases.display(title: 
      //  "Select monitoringAndControllingPhases by attribute, then add"); 
      //monitoringAndControllingPhases.display(title: "All monitoringAndControllingPhases"); 
    }); 
 
    test("Select monitoringAndControllingPhases by attribute, then remove", () { 
      var randomMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
      var selectedMonitoringAndControllingPhases = 
          monitoringAndControllingPhases.selectWhereAttribute("PerformanceMeasurement", randomMonitoringAndControllingPhase.PerformanceMeasurement); 
      expect(selectedMonitoringAndControllingPhases.isEmpty, isFalse); 
      expect(selectedMonitoringAndControllingPhases.source?.isEmpty, isFalse); 
      var monitoringAndControllingPhasesCount = monitoringAndControllingPhases.length; 
 
      var removed = selectedMonitoringAndControllingPhases.remove(randomMonitoringAndControllingPhase); 
      expect(removed, isTrue); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhasesCount)); 
 
      randomMonitoringAndControllingPhase.display(prefix: "removed"); 
      //selectedMonitoringAndControllingPhases.display(title: 
      //  "Select monitoringAndControllingPhases by attribute, then remove"); 
      //monitoringAndControllingPhases.display(title: "All monitoringAndControllingPhases"); 
    }); 
 
    test("Sort monitoringAndControllingPhases", () { 
      // no id attribute 
      // add compareTo method in the specific MonitoringAndControllingPhase class 
      /* 
      monitoringAndControllingPhases.sort(); 
 
      //monitoringAndControllingPhases.display(title: "Sort monitoringAndControllingPhases"); 
      */ 
    }); 
 
    test("Order monitoringAndControllingPhases", () { 
      // no id attribute 
      // add compareTo method in the specific MonitoringAndControllingPhase class 
      /* 
      var orderedMonitoringAndControllingPhases = monitoringAndControllingPhases.order(); 
      expect(orderedMonitoringAndControllingPhases.isEmpty, isFalse); 
      expect(orderedMonitoringAndControllingPhases.length, equals(monitoringAndControllingPhases.length)); 
      expect(orderedMonitoringAndControllingPhases.source?.isEmpty, isFalse); 
      expect(orderedMonitoringAndControllingPhases.source?.length, equals(monitoringAndControllingPhases.length)); 
      expect(orderedMonitoringAndControllingPhases, isNot(same(monitoringAndControllingPhases))); 
 
      //orderedMonitoringAndControllingPhases.display(title: "Order monitoringAndControllingPhases"); 
      */ 
    }); 
 
    test("Copy monitoringAndControllingPhases", () { 
      var copiedMonitoringAndControllingPhases = monitoringAndControllingPhases.copy(); 
      expect(copiedMonitoringAndControllingPhases.isEmpty, isFalse); 
      expect(copiedMonitoringAndControllingPhases.length, equals(monitoringAndControllingPhases.length)); 
      expect(copiedMonitoringAndControllingPhases, isNot(same(monitoringAndControllingPhases))); 
      copiedMonitoringAndControllingPhases.forEach((e) => 
        expect(e, equals(monitoringAndControllingPhases.singleWhereOid(e.oid)))); 
 
      //copiedMonitoringAndControllingPhases.display(title: "Copy monitoringAndControllingPhases"); 
    }); 
 
    test("True for every monitoringAndControllingPhase", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random monitoringAndControllingPhase", () { 
      var monitoringAndControllingPhase1 = schedulingModel.monitoringAndControllingPhases.random(); 
      expect(monitoringAndControllingPhase1, isNotNull); 
      var monitoringAndControllingPhase2 = schedulingModel.monitoringAndControllingPhases.random(); 
      expect(monitoringAndControllingPhase2, isNotNull); 
 
      //monitoringAndControllingPhase1.display(prefix: "random1"); 
      //monitoringAndControllingPhase2.display(prefix: "random2"); 
    }); 
 
    test("Update monitoringAndControllingPhase id with try", () { 
      // no id attribute 
    }); 
 
    test("Update monitoringAndControllingPhase id without try", () { 
      // no id attribute 
    }); 
 
    test("Update monitoringAndControllingPhase id with success", () { 
      // no id attribute 
    }); 
 
    test("Update monitoringAndControllingPhase non id attribute with failure", () { 
      var randomMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
      var afterUpdateEntity = randomMonitoringAndControllingPhase.copy(); 
      afterUpdateEntity.PerformanceMeasurement = 'privacy'; 
      expect(afterUpdateEntity.PerformanceMeasurement, equals('privacy')); 
      // monitoringAndControllingPhases.update can only be used if oid, code or id is set. 
      expect(() => monitoringAndControllingPhases.update(randomMonitoringAndControllingPhase, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
      randomMonitoringAndControllingPhase.display(prefix:"before copy: "); 
      var randomMonitoringAndControllingPhaseCopy = randomMonitoringAndControllingPhase.copy(); 
      randomMonitoringAndControllingPhaseCopy.display(prefix:"after copy: "); 
      expect(randomMonitoringAndControllingPhase, equals(randomMonitoringAndControllingPhaseCopy)); 
      expect(randomMonitoringAndControllingPhase.oid, equals(randomMonitoringAndControllingPhaseCopy.oid)); 
      expect(randomMonitoringAndControllingPhase.code, equals(randomMonitoringAndControllingPhaseCopy.code)); 
      expect(randomMonitoringAndControllingPhase.PerformanceMeasurement, equals(randomMonitoringAndControllingPhaseCopy.PerformanceMeasurement)); 
      expect(randomMonitoringAndControllingPhase.ChangeManagement, equals(randomMonitoringAndControllingPhaseCopy.ChangeManagement)); 
      expect(randomMonitoringAndControllingPhase.QualityControl, equals(randomMonitoringAndControllingPhaseCopy.QualityControl)); 
      expect(randomMonitoringAndControllingPhase.IssueResolution, equals(randomMonitoringAndControllingPhaseCopy.IssueResolution)); 
      expect(randomMonitoringAndControllingPhase.Reporting, equals(randomMonitoringAndControllingPhaseCopy.Reporting)); 
 
    }); 
 
    test("monitoringAndControllingPhase action undo and redo", () { 
      var monitoringAndControllingPhaseCount = monitoringAndControllingPhases.length; 
      var monitoringAndControllingPhase = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
        monitoringAndControllingPhase.PerformanceMeasurement = 'sentence'; 
      monitoringAndControllingPhase.ChangeManagement = 'ticket'; 
      monitoringAndControllingPhase.QualityControl = 'beginning'; 
      monitoringAndControllingPhase.IssueResolution = 'edition'; 
      monitoringAndControllingPhase.Reporting = 'pub'; 
    var monitoringAndControllingPhaseExecutionPhase = schedulingModel.executionPhases.random(); 
    monitoringAndControllingPhase.executionPhase = monitoringAndControllingPhaseExecutionPhase; 
      monitoringAndControllingPhases.add(monitoringAndControllingPhase); 
    monitoringAndControllingPhaseExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
      monitoringAndControllingPhases.remove(monitoringAndControllingPhase); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      var action = AddCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase); 
      action.doIt(); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
 
      action.undo(); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      action.redo(); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
    }); 
 
    test("monitoringAndControllingPhase session undo and redo", () { 
      var monitoringAndControllingPhaseCount = monitoringAndControllingPhases.length; 
      var monitoringAndControllingPhase = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
        monitoringAndControllingPhase.PerformanceMeasurement = 'television'; 
      monitoringAndControllingPhase.ChangeManagement = 'horse'; 
      monitoringAndControllingPhase.QualityControl = 'baby'; 
      monitoringAndControllingPhase.IssueResolution = 'restaurant'; 
      monitoringAndControllingPhase.Reporting = 'car'; 
    var monitoringAndControllingPhaseExecutionPhase = schedulingModel.executionPhases.random(); 
    monitoringAndControllingPhase.executionPhase = monitoringAndControllingPhaseExecutionPhase; 
      monitoringAndControllingPhases.add(monitoringAndControllingPhase); 
    monitoringAndControllingPhaseExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
      monitoringAndControllingPhases.remove(monitoringAndControllingPhase); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      var action = AddCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase); 
      action.doIt(); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
 
      session.past.undo(); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      session.past.redo(); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
    }); 
 
    test("MonitoringAndControllingPhase update undo and redo", () { 
      var monitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
      var action = SetAttributeCommand(session, monitoringAndControllingPhase, "PerformanceMeasurement", 'wave'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(monitoringAndControllingPhase.PerformanceMeasurement, equals(action.before)); 
 
      session.past.redo(); 
      expect(monitoringAndControllingPhase.PerformanceMeasurement, equals(action.after)); 
    }); 
 
    test("MonitoringAndControllingPhase action with multiple undos and redos", () { 
      var monitoringAndControllingPhaseCount = monitoringAndControllingPhases.length; 
      var monitoringAndControllingPhase1 = schedulingModel.monitoringAndControllingPhases.random(); 
 
      var action1 = RemoveCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase1); 
      action1.doIt(); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      var monitoringAndControllingPhase2 = schedulingModel.monitoringAndControllingPhases.random(); 
 
      var action2 = RemoveCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase2); 
      action2.doIt(); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
 
      session.past.undo(); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      session.past.redo(); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var monitoringAndControllingPhaseCount = monitoringAndControllingPhases.length; 
      var monitoringAndControllingPhase1 = schedulingModel.monitoringAndControllingPhases.random(); 
      var monitoringAndControllingPhase2 = schedulingModel.monitoringAndControllingPhases.random(); 
      while (monitoringAndControllingPhase1 == monitoringAndControllingPhase2) { 
        monitoringAndControllingPhase2 = schedulingModel.monitoringAndControllingPhases.random();  
      } 
      var action1 = RemoveCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase1); 
      var action2 = RemoveCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase2); 
 
      var transaction = new Transaction("two removes on monitoringAndControllingPhases", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      monitoringAndControllingPhaseCount = monitoringAndControllingPhaseCount - 2; 
      expect(monitoringAndControllingPhases.length, equals(monitoringAndControllingPhaseCount)); 
 
      monitoringAndControllingPhases.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      monitoringAndControllingPhaseCount = monitoringAndControllingPhaseCount + 2; 
      expect(monitoringAndControllingPhases.length, equals(monitoringAndControllingPhaseCount)); 
 
      monitoringAndControllingPhases.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      monitoringAndControllingPhaseCount = monitoringAndControllingPhaseCount - 2; 
      expect(monitoringAndControllingPhases.length, equals(monitoringAndControllingPhaseCount)); 
 
      monitoringAndControllingPhases.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var monitoringAndControllingPhaseCount = monitoringAndControllingPhases.length; 
      var monitoringAndControllingPhase1 = schedulingModel.monitoringAndControllingPhases.random(); 
      var monitoringAndControllingPhase2 = monitoringAndControllingPhase1; 
      var action1 = RemoveCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase1); 
      var action2 = RemoveCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase2); 
 
      var transaction = Transaction( 
        "two removes on monitoringAndControllingPhases, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(monitoringAndControllingPhases.length, equals(monitoringAndControllingPhaseCount)); 
 
      //monitoringAndControllingPhases.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to monitoringAndControllingPhase actions", () { 
      var monitoringAndControllingPhaseCount = monitoringAndControllingPhases.length; 
 
      var reaction = MonitoringAndControllingPhaseReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var monitoringAndControllingPhase = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
        monitoringAndControllingPhase.PerformanceMeasurement = 'photo'; 
      monitoringAndControllingPhase.ChangeManagement = 'train'; 
      monitoringAndControllingPhase.QualityControl = 'celebration'; 
      monitoringAndControllingPhase.IssueResolution = 'truck'; 
      monitoringAndControllingPhase.Reporting = 'chairman'; 
    var monitoringAndControllingPhaseExecutionPhase = schedulingModel.executionPhases.random(); 
    monitoringAndControllingPhase.executionPhase = monitoringAndControllingPhaseExecutionPhase; 
      monitoringAndControllingPhases.add(monitoringAndControllingPhase); 
    monitoringAndControllingPhaseExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
      monitoringAndControllingPhases.remove(monitoringAndControllingPhase); 
      expect(monitoringAndControllingPhases.length, equals(--monitoringAndControllingPhaseCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, monitoringAndControllingPhases, monitoringAndControllingPhase); 
      addCommand.doIt(); 
      expect(monitoringAndControllingPhases.length, equals(++monitoringAndControllingPhaseCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, monitoringAndControllingPhase, "PerformanceMeasurement", 'organization'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class MonitoringAndControllingPhaseReaction implements ICommandReaction { 
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
  var monitoringAndControllingPhases = schedulingModel.monitoringAndControllingPhases; 
  testProjectSchedulingMonitoringAndControllingPhases(projectDomain, schedulingModel, monitoringAndControllingPhases); 
} 
 
