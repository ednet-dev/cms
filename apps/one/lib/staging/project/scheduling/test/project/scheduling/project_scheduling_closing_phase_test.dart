 
// test/project/scheduling/project_scheduling_closing_phase_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_scheduling/project_scheduling.dart"; 
 
void testProjectSchedulingClosingPhases( 
    ProjectDomain projectDomain, SchedulingModel schedulingModel, ClosingPhases closingPhases) { 
  DomainSession session; 
  group("Testing Project.Scheduling.ClosingPhase", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      schedulingModel.init(); 
    }); 
    tearDown(() { 
      schedulingModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(schedulingModel.isEmpty, isFalse); 
      expect(closingPhases.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      schedulingModel.clear(); 
      expect(schedulingModel.isEmpty, isTrue); 
      expect(closingPhases.isEmpty, isTrue); 
      expect(closingPhases.exceptions.isEmpty, isTrue); 
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
      var json = schedulingModel.fromEntryToJson("ClosingPhase"); 
      expect(json, isNotNull); 
 
      print(json); 
      //schedulingModel.displayEntryJson("ClosingPhase"); 
      //schedulingModel.displayJson(); 
      //schedulingModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = schedulingModel.fromEntryToJson("ClosingPhase"); 
      closingPhases.clear(); 
      expect(closingPhases.isEmpty, isTrue); 
      schedulingModel.fromJsonToEntry(json); 
      expect(closingPhases.isEmpty, isFalse); 
 
      closingPhases.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add closingPhase required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add closingPhase unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found closingPhase by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var closingPhase = closingPhases.singleWhereOid(ednetOid); 
      expect(closingPhase, isNull); 
    }); 
 
    test("Find closingPhase by oid", () { 
      var randomClosingPhase = schedulingModel.closingPhases.random(); 
      var closingPhase = closingPhases.singleWhereOid(randomClosingPhase.oid); 
      expect(closingPhase, isNotNull); 
      expect(closingPhase, equals(randomClosingPhase)); 
    }); 
 
    test("Find closingPhase by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find closingPhase by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find closingPhase by attribute", () { 
      var randomClosingPhase = schedulingModel.closingPhases.random(); 
      var closingPhase = 
          closingPhases.firstWhereAttribute("FinalDeliverableHandover", randomClosingPhase.FinalDeliverableHandover); 
      expect(closingPhase, isNotNull); 
      expect(closingPhase.FinalDeliverableHandover, equals(randomClosingPhase.FinalDeliverableHandover)); 
    }); 
 
    test("Select closingPhases by attribute", () { 
      var randomClosingPhase = schedulingModel.closingPhases.random(); 
      var selectedClosingPhases = 
          closingPhases.selectWhereAttribute("FinalDeliverableHandover", randomClosingPhase.FinalDeliverableHandover); 
      expect(selectedClosingPhases.isEmpty, isFalse); 
      selectedClosingPhases.forEach((se) => 
          expect(se.FinalDeliverableHandover, equals(randomClosingPhase.FinalDeliverableHandover))); 
 
      //selectedClosingPhases.display(title: "Select closingPhases by FinalDeliverableHandover"); 
    }); 
 
    test("Select closingPhases by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select closingPhases by attribute, then add", () { 
      var randomClosingPhase = schedulingModel.closingPhases.random(); 
      var selectedClosingPhases = 
          closingPhases.selectWhereAttribute("FinalDeliverableHandover", randomClosingPhase.FinalDeliverableHandover); 
      expect(selectedClosingPhases.isEmpty, isFalse); 
      expect(selectedClosingPhases.source?.isEmpty, isFalse); 
      var closingPhasesCount = closingPhases.length; 
 
      var closingPhase = ClosingPhase(closingPhases.concept); 
      closingPhase.FinalDeliverableHandover = 'line'; 
      closingPhase.ProjectDocumentation = 'question'; 
      closingPhase.StakeholderSignOff = 'feeling'; 
      closingPhase.ProjectReview = 'message'; 
      closingPhase.ResourceRelease = 'picture'; 
      closingPhase.CelebrateSuccess = 'hell'; 
      var added = selectedClosingPhases.add(closingPhase); 
      expect(added, isTrue); 
      expect(closingPhases.length, equals(++closingPhasesCount)); 
 
      //selectedClosingPhases.display(title: 
      //  "Select closingPhases by attribute, then add"); 
      //closingPhases.display(title: "All closingPhases"); 
    }); 
 
    test("Select closingPhases by attribute, then remove", () { 
      var randomClosingPhase = schedulingModel.closingPhases.random(); 
      var selectedClosingPhases = 
          closingPhases.selectWhereAttribute("FinalDeliverableHandover", randomClosingPhase.FinalDeliverableHandover); 
      expect(selectedClosingPhases.isEmpty, isFalse); 
      expect(selectedClosingPhases.source?.isEmpty, isFalse); 
      var closingPhasesCount = closingPhases.length; 
 
      var removed = selectedClosingPhases.remove(randomClosingPhase); 
      expect(removed, isTrue); 
      expect(closingPhases.length, equals(--closingPhasesCount)); 
 
      randomClosingPhase.display(prefix: "removed"); 
      //selectedClosingPhases.display(title: 
      //  "Select closingPhases by attribute, then remove"); 
      //closingPhases.display(title: "All closingPhases"); 
    }); 
 
    test("Sort closingPhases", () { 
      // no id attribute 
      // add compareTo method in the specific ClosingPhase class 
      /* 
      closingPhases.sort(); 
 
      //closingPhases.display(title: "Sort closingPhases"); 
      */ 
    }); 
 
    test("Order closingPhases", () { 
      // no id attribute 
      // add compareTo method in the specific ClosingPhase class 
      /* 
      var orderedClosingPhases = closingPhases.order(); 
      expect(orderedClosingPhases.isEmpty, isFalse); 
      expect(orderedClosingPhases.length, equals(closingPhases.length)); 
      expect(orderedClosingPhases.source?.isEmpty, isFalse); 
      expect(orderedClosingPhases.source?.length, equals(closingPhases.length)); 
      expect(orderedClosingPhases, isNot(same(closingPhases))); 
 
      //orderedClosingPhases.display(title: "Order closingPhases"); 
      */ 
    }); 
 
    test("Copy closingPhases", () { 
      var copiedClosingPhases = closingPhases.copy(); 
      expect(copiedClosingPhases.isEmpty, isFalse); 
      expect(copiedClosingPhases.length, equals(closingPhases.length)); 
      expect(copiedClosingPhases, isNot(same(closingPhases))); 
      copiedClosingPhases.forEach((e) => 
        expect(e, equals(closingPhases.singleWhereOid(e.oid)))); 
 
      //copiedClosingPhases.display(title: "Copy closingPhases"); 
    }); 
 
    test("True for every closingPhase", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random closingPhase", () { 
      var closingPhase1 = schedulingModel.closingPhases.random(); 
      expect(closingPhase1, isNotNull); 
      var closingPhase2 = schedulingModel.closingPhases.random(); 
      expect(closingPhase2, isNotNull); 
 
      //closingPhase1.display(prefix: "random1"); 
      //closingPhase2.display(prefix: "random2"); 
    }); 
 
    test("Update closingPhase id with try", () { 
      // no id attribute 
    }); 
 
    test("Update closingPhase id without try", () { 
      // no id attribute 
    }); 
 
    test("Update closingPhase id with success", () { 
      // no id attribute 
    }); 
 
    test("Update closingPhase non id attribute with failure", () { 
      var randomClosingPhase = schedulingModel.closingPhases.random(); 
      var afterUpdateEntity = randomClosingPhase.copy(); 
      afterUpdateEntity.FinalDeliverableHandover = 'energy'; 
      expect(afterUpdateEntity.FinalDeliverableHandover, equals('energy')); 
      // closingPhases.update can only be used if oid, code or id is set. 
      expect(() => closingPhases.update(randomClosingPhase, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomClosingPhase = schedulingModel.closingPhases.random(); 
      randomClosingPhase.display(prefix:"before copy: "); 
      var randomClosingPhaseCopy = randomClosingPhase.copy(); 
      randomClosingPhaseCopy.display(prefix:"after copy: "); 
      expect(randomClosingPhase, equals(randomClosingPhaseCopy)); 
      expect(randomClosingPhase.oid, equals(randomClosingPhaseCopy.oid)); 
      expect(randomClosingPhase.code, equals(randomClosingPhaseCopy.code)); 
      expect(randomClosingPhase.FinalDeliverableHandover, equals(randomClosingPhaseCopy.FinalDeliverableHandover)); 
      expect(randomClosingPhase.ProjectDocumentation, equals(randomClosingPhaseCopy.ProjectDocumentation)); 
      expect(randomClosingPhase.StakeholderSignOff, equals(randomClosingPhaseCopy.StakeholderSignOff)); 
      expect(randomClosingPhase.ProjectReview, equals(randomClosingPhaseCopy.ProjectReview)); 
      expect(randomClosingPhase.ResourceRelease, equals(randomClosingPhaseCopy.ResourceRelease)); 
      expect(randomClosingPhase.CelebrateSuccess, equals(randomClosingPhaseCopy.CelebrateSuccess)); 
 
    }); 
 
    test("closingPhase action undo and redo", () { 
      var closingPhaseCount = closingPhases.length; 
      var closingPhase = ClosingPhase(closingPhases.concept); 
        closingPhase.FinalDeliverableHandover = 'cardboard'; 
      closingPhase.ProjectDocumentation = 'room'; 
      closingPhase.StakeholderSignOff = 'mind'; 
      closingPhase.ProjectReview = 'explanation'; 
      closingPhase.ResourceRelease = 'beginning'; 
      closingPhase.CelebrateSuccess = 'selfdo'; 
    var closingPhaseMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
    closingPhase.monitoringAndControllingPhase = closingPhaseMonitoringAndControllingPhase; 
      closingPhases.add(closingPhase); 
    closingPhaseMonitoringAndControllingPhase.closingPhase.add(closingPhase); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
      closingPhases.remove(closingPhase); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      var action = AddCommand(session, closingPhases, closingPhase); 
      action.doIt(); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
 
      action.undo(); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      action.redo(); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
    }); 
 
    test("closingPhase session undo and redo", () { 
      var closingPhaseCount = closingPhases.length; 
      var closingPhase = ClosingPhase(closingPhases.concept); 
        closingPhase.FinalDeliverableHandover = 'sentence'; 
      closingPhase.ProjectDocumentation = 'yellow'; 
      closingPhase.StakeholderSignOff = 'horse'; 
      closingPhase.ProjectReview = 'smog'; 
      closingPhase.ResourceRelease = 'navigation'; 
      closingPhase.CelebrateSuccess = 'email'; 
    var closingPhaseMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
    closingPhase.monitoringAndControllingPhase = closingPhaseMonitoringAndControllingPhase; 
      closingPhases.add(closingPhase); 
    closingPhaseMonitoringAndControllingPhase.closingPhase.add(closingPhase); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
      closingPhases.remove(closingPhase); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      var action = AddCommand(session, closingPhases, closingPhase); 
      action.doIt(); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
 
      session.past.undo(); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      session.past.redo(); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
    }); 
 
    test("ClosingPhase update undo and redo", () { 
      var closingPhase = schedulingModel.closingPhases.random(); 
      var action = SetAttributeCommand(session, closingPhase, "FinalDeliverableHandover", 'bird'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(closingPhase.FinalDeliverableHandover, equals(action.before)); 
 
      session.past.redo(); 
      expect(closingPhase.FinalDeliverableHandover, equals(action.after)); 
    }); 
 
    test("ClosingPhase action with multiple undos and redos", () { 
      var closingPhaseCount = closingPhases.length; 
      var closingPhase1 = schedulingModel.closingPhases.random(); 
 
      var action1 = RemoveCommand(session, closingPhases, closingPhase1); 
      action1.doIt(); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      var closingPhase2 = schedulingModel.closingPhases.random(); 
 
      var action2 = RemoveCommand(session, closingPhases, closingPhase2); 
      action2.doIt(); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
 
      session.past.undo(); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      session.past.redo(); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var closingPhaseCount = closingPhases.length; 
      var closingPhase1 = schedulingModel.closingPhases.random(); 
      var closingPhase2 = schedulingModel.closingPhases.random(); 
      while (closingPhase1 == closingPhase2) { 
        closingPhase2 = schedulingModel.closingPhases.random();  
      } 
      var action1 = RemoveCommand(session, closingPhases, closingPhase1); 
      var action2 = RemoveCommand(session, closingPhases, closingPhase2); 
 
      var transaction = new Transaction("two removes on closingPhases", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      closingPhaseCount = closingPhaseCount - 2; 
      expect(closingPhases.length, equals(closingPhaseCount)); 
 
      closingPhases.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      closingPhaseCount = closingPhaseCount + 2; 
      expect(closingPhases.length, equals(closingPhaseCount)); 
 
      closingPhases.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      closingPhaseCount = closingPhaseCount - 2; 
      expect(closingPhases.length, equals(closingPhaseCount)); 
 
      closingPhases.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var closingPhaseCount = closingPhases.length; 
      var closingPhase1 = schedulingModel.closingPhases.random(); 
      var closingPhase2 = closingPhase1; 
      var action1 = RemoveCommand(session, closingPhases, closingPhase1); 
      var action2 = RemoveCommand(session, closingPhases, closingPhase2); 
 
      var transaction = Transaction( 
        "two removes on closingPhases, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(closingPhases.length, equals(closingPhaseCount)); 
 
      //closingPhases.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to closingPhase actions", () { 
      var closingPhaseCount = closingPhases.length; 
 
      var reaction = ClosingPhaseReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var closingPhase = ClosingPhase(closingPhases.concept); 
        closingPhase.FinalDeliverableHandover = 'selfie'; 
      closingPhase.ProjectDocumentation = 'slate'; 
      closingPhase.StakeholderSignOff = 'unit'; 
      closingPhase.ProjectReview = 'water'; 
      closingPhase.ResourceRelease = 'candy'; 
      closingPhase.CelebrateSuccess = 'email'; 
    var closingPhaseMonitoringAndControllingPhase = schedulingModel.monitoringAndControllingPhases.random(); 
    closingPhase.monitoringAndControllingPhase = closingPhaseMonitoringAndControllingPhase; 
      closingPhases.add(closingPhase); 
    closingPhaseMonitoringAndControllingPhase.closingPhase.add(closingPhase); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
      closingPhases.remove(closingPhase); 
      expect(closingPhases.length, equals(--closingPhaseCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, closingPhases, closingPhase); 
      addCommand.doIt(); 
      expect(closingPhases.length, equals(++closingPhaseCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, closingPhase, "FinalDeliverableHandover", 'line'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ClosingPhaseReaction implements ICommandReaction { 
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
  var closingPhases = schedulingModel.closingPhases; 
  testProjectSchedulingClosingPhases(projectDomain, schedulingModel, closingPhases); 
} 
 
