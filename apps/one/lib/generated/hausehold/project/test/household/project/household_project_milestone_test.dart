 
// test/household/project/household_project_milestone_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_project/household_project.dart"; 
 
void testHouseholdProjectMilestones( 
    HouseholdDomain householdDomain, ProjectModel projectModel, Milestones milestones) { 
  DomainSession session; 
  group("Testing Household.Project.Milestone", () { 
    session = householdDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(milestones.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(milestones.isEmpty, isTrue); 
      expect(milestones.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = projectModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = projectModel.toJson(); 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      projectModel.fromJson(json); 
      expect(projectModel.isEmpty, isFalse); 
 
      projectModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = projectModel.fromEntryToJson("Milestone"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("Milestone"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("Milestone"); 
      milestones.clear(); 
      expect(milestones.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(milestones.isEmpty, isFalse); 
 
      milestones.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add milestone required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add milestone unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found milestone by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var milestone = milestones.singleWhereOid(ednetOid); 
      expect(milestone, isNull); 
    }); 
 
    test("Find milestone by oid", () { 
      var randomMilestone = projectModel.milestones.random(); 
      var milestone = milestones.singleWhereOid(randomMilestone.oid); 
      expect(milestone, isNotNull); 
      expect(milestone, equals(randomMilestone)); 
    }); 
 
    test("Find milestone by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find milestone by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find milestone by attribute", () { 
      var randomMilestone = projectModel.milestones.random(); 
      var milestone = 
          milestones.firstWhereAttribute("name", randomMilestone.name); 
      expect(milestone, isNotNull); 
      expect(milestone.name, equals(randomMilestone.name)); 
    }); 
 
    test("Select milestones by attribute", () { 
      var randomMilestone = projectModel.milestones.random(); 
      var selectedMilestones = 
          milestones.selectWhereAttribute("name", randomMilestone.name); 
      expect(selectedMilestones.isEmpty, isFalse); 
      selectedMilestones.forEach((se) => 
          expect(se.name, equals(randomMilestone.name))); 
 
      //selectedMilestones.display(title: "Select milestones by name"); 
    }); 
 
    test("Select milestones by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select milestones by attribute, then add", () { 
      var randomMilestone = projectModel.milestones.random(); 
      var selectedMilestones = 
          milestones.selectWhereAttribute("name", randomMilestone.name); 
      expect(selectedMilestones.isEmpty, isFalse); 
      expect(selectedMilestones.source?.isEmpty, isFalse); 
      var milestonesCount = milestones.length; 
 
      var milestone = Milestone(milestones.concept); 
      milestone.name = 'time'; 
      milestone.date = new DateTime.now(); 
      var added = selectedMilestones.add(milestone); 
      expect(added, isTrue); 
      expect(milestones.length, equals(++milestonesCount)); 
 
      //selectedMilestones.display(title: 
      //  "Select milestones by attribute, then add"); 
      //milestones.display(title: "All milestones"); 
    }); 
 
    test("Select milestones by attribute, then remove", () { 
      var randomMilestone = projectModel.milestones.random(); 
      var selectedMilestones = 
          milestones.selectWhereAttribute("name", randomMilestone.name); 
      expect(selectedMilestones.isEmpty, isFalse); 
      expect(selectedMilestones.source?.isEmpty, isFalse); 
      var milestonesCount = milestones.length; 
 
      var removed = selectedMilestones.remove(randomMilestone); 
      expect(removed, isTrue); 
      expect(milestones.length, equals(--milestonesCount)); 
 
      randomMilestone.display(prefix: "removed"); 
      //selectedMilestones.display(title: 
      //  "Select milestones by attribute, then remove"); 
      //milestones.display(title: "All milestones"); 
    }); 
 
    test("Sort milestones", () { 
      // no id attribute 
      // add compareTo method in the specific Milestone class 
      /* 
      milestones.sort(); 
 
      //milestones.display(title: "Sort milestones"); 
      */ 
    }); 
 
    test("Order milestones", () { 
      // no id attribute 
      // add compareTo method in the specific Milestone class 
      /* 
      var orderedMilestones = milestones.order(); 
      expect(orderedMilestones.isEmpty, isFalse); 
      expect(orderedMilestones.length, equals(milestones.length)); 
      expect(orderedMilestones.source?.isEmpty, isFalse); 
      expect(orderedMilestones.source?.length, equals(milestones.length)); 
      expect(orderedMilestones, isNot(same(milestones))); 
 
      //orderedMilestones.display(title: "Order milestones"); 
      */ 
    }); 
 
    test("Copy milestones", () { 
      var copiedMilestones = milestones.copy(); 
      expect(copiedMilestones.isEmpty, isFalse); 
      expect(copiedMilestones.length, equals(milestones.length)); 
      expect(copiedMilestones, isNot(same(milestones))); 
      copiedMilestones.forEach((e) => 
        expect(e, equals(milestones.singleWhereOid(e.oid)))); 
 
      //copiedMilestones.display(title: "Copy milestones"); 
    }); 
 
    test("True for every milestone", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random milestone", () { 
      var milestone1 = projectModel.milestones.random(); 
      expect(milestone1, isNotNull); 
      var milestone2 = projectModel.milestones.random(); 
      expect(milestone2, isNotNull); 
 
      //milestone1.display(prefix: "random1"); 
      //milestone2.display(prefix: "random2"); 
    }); 
 
    test("Update milestone id with try", () { 
      // no id attribute 
    }); 
 
    test("Update milestone id without try", () { 
      // no id attribute 
    }); 
 
    test("Update milestone id with success", () { 
      // no id attribute 
    }); 
 
    test("Update milestone non id attribute with failure", () { 
      var randomMilestone = projectModel.milestones.random(); 
      var afterUpdateEntity = randomMilestone.copy(); 
      afterUpdateEntity.name = 'void'; 
      expect(afterUpdateEntity.name, equals('void')); 
      // milestones.update can only be used if oid, code or id is set. 
      expect(() => milestones.update(randomMilestone, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomMilestone = projectModel.milestones.random(); 
      randomMilestone.display(prefix:"before copy: "); 
      var randomMilestoneCopy = randomMilestone.copy(); 
      randomMilestoneCopy.display(prefix:"after copy: "); 
      expect(randomMilestone, equals(randomMilestoneCopy)); 
      expect(randomMilestone.oid, equals(randomMilestoneCopy.oid)); 
      expect(randomMilestone.code, equals(randomMilestoneCopy.code)); 
      expect(randomMilestone.name, equals(randomMilestoneCopy.name)); 
      expect(randomMilestone.date, equals(randomMilestoneCopy.date)); 
 
    }); 
 
    test("milestone action undo and redo", () { 
      var milestoneCount = milestones.length; 
      var milestone = Milestone(milestones.concept); 
        milestone.name = 'accomodation'; 
      milestone.date = new DateTime.now(); 
    var milestoneProject = projectModel.projects.random(); 
    milestone.project = milestoneProject; 
      milestones.add(milestone); 
    milestoneProject.milestones.add(milestone); 
      expect(milestones.length, equals(++milestoneCount)); 
      milestones.remove(milestone); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      var action = AddCommand(session, milestones, milestone); 
      action.doIt(); 
      expect(milestones.length, equals(++milestoneCount)); 
 
      action.undo(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      action.redo(); 
      expect(milestones.length, equals(++milestoneCount)); 
    }); 
 
    test("milestone session undo and redo", () { 
      var milestoneCount = milestones.length; 
      var milestone = Milestone(milestones.concept); 
        milestone.name = 'thing'; 
      milestone.date = new DateTime.now(); 
    var milestoneProject = projectModel.projects.random(); 
    milestone.project = milestoneProject; 
      milestones.add(milestone); 
    milestoneProject.milestones.add(milestone); 
      expect(milestones.length, equals(++milestoneCount)); 
      milestones.remove(milestone); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      var action = AddCommand(session, milestones, milestone); 
      action.doIt(); 
      expect(milestones.length, equals(++milestoneCount)); 
 
      session.past.undo(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      session.past.redo(); 
      expect(milestones.length, equals(++milestoneCount)); 
    }); 
 
    test("Milestone update undo and redo", () { 
      var milestone = projectModel.milestones.random(); 
      var action = SetAttributeCommand(session, milestone, "name", 'organization'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(milestone.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(milestone.name, equals(action.after)); 
    }); 
 
    test("Milestone action with multiple undos and redos", () { 
      var milestoneCount = milestones.length; 
      var milestone1 = projectModel.milestones.random(); 
 
      var action1 = RemoveCommand(session, milestones, milestone1); 
      action1.doIt(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      var milestone2 = projectModel.milestones.random(); 
 
      var action2 = RemoveCommand(session, milestones, milestone2); 
      action2.doIt(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(milestones.length, equals(++milestoneCount)); 
 
      session.past.undo(); 
      expect(milestones.length, equals(++milestoneCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      session.past.redo(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var milestoneCount = milestones.length; 
      var milestone1 = projectModel.milestones.random(); 
      var milestone2 = projectModel.milestones.random(); 
      while (milestone1 == milestone2) { 
        milestone2 = projectModel.milestones.random();  
      } 
      var action1 = RemoveCommand(session, milestones, milestone1); 
      var action2 = RemoveCommand(session, milestones, milestone2); 
 
      var transaction = new Transaction("two removes on milestones", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      milestoneCount = milestoneCount - 2; 
      expect(milestones.length, equals(milestoneCount)); 
 
      milestones.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      milestoneCount = milestoneCount + 2; 
      expect(milestones.length, equals(milestoneCount)); 
 
      milestones.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      milestoneCount = milestoneCount - 2; 
      expect(milestones.length, equals(milestoneCount)); 
 
      milestones.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var milestoneCount = milestones.length; 
      var milestone1 = projectModel.milestones.random(); 
      var milestone2 = milestone1; 
      var action1 = RemoveCommand(session, milestones, milestone1); 
      var action2 = RemoveCommand(session, milestones, milestone2); 
 
      var transaction = Transaction( 
        "two removes on milestones, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(milestones.length, equals(milestoneCount)); 
 
      //milestones.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to milestone actions", () { 
      var milestoneCount = milestones.length; 
 
      var reaction = MilestoneReaction(); 
      expect(reaction, isNotNull); 
 
      householdDomain.startCommandReaction(reaction); 
      var milestone = Milestone(milestones.concept); 
        milestone.name = 'knowledge'; 
      milestone.date = new DateTime.now(); 
    var milestoneProject = projectModel.projects.random(); 
    milestone.project = milestoneProject; 
      milestones.add(milestone); 
    milestoneProject.milestones.add(milestone); 
      expect(milestones.length, equals(++milestoneCount)); 
      milestones.remove(milestone); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      var session = householdDomain.newSession(); 
      var addCommand = AddCommand(session, milestones, milestone); 
      addCommand.doIt(); 
      expect(milestones.length, equals(++milestoneCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, milestone, "name", 'hospital'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      householdDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class MilestoneReaction implements ICommandReaction { 
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
  var repository = HouseholdProjectRepo(); 
  HouseholdDomain householdDomain = repository.getDomainModels("Household") as HouseholdDomain;   
  assert(householdDomain != null); 
  ProjectModel projectModel = householdDomain.getModelEntries("Project") as ProjectModel;  
  assert(projectModel != null); 
  var milestones = projectModel.milestones; 
  testHouseholdProjectMilestones(householdDomain, projectModel, milestones); 
} 
 
