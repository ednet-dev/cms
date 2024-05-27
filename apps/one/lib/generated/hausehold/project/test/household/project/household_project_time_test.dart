 
// test/household/project/household_project_time_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_project/household_project.dart"; 
 
void testHouseholdProjectTimes( 
    HouseholdDomain householdDomain, ProjectModel projectModel, Times times) { 
  DomainSession session; 
  group("Testing Household.Project.Time", () { 
    session = householdDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(times.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(times.isEmpty, isTrue); 
      expect(times.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("Time"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("Time"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("Time"); 
      times.clear(); 
      expect(times.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(times.isEmpty, isFalse); 
 
      times.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add time required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add time unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found time by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var time = times.singleWhereOid(ednetOid); 
      expect(time, isNull); 
    }); 
 
    test("Find time by oid", () { 
      var randomTime = projectModel.times.random(); 
      var time = times.singleWhereOid(randomTime.oid); 
      expect(time, isNotNull); 
      expect(time, equals(randomTime)); 
    }); 
 
    test("Find time by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find time by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find time by attribute", () { 
      var randomTime = projectModel.times.random(); 
      var time = 
          times.firstWhereAttribute("hours", randomTime.hours); 
      expect(time, isNotNull); 
      expect(time.hours, equals(randomTime.hours)); 
    }); 
 
    test("Select times by attribute", () { 
      var randomTime = projectModel.times.random(); 
      var selectedTimes = 
          times.selectWhereAttribute("hours", randomTime.hours); 
      expect(selectedTimes.isEmpty, isFalse); 
      selectedTimes.forEach((se) => 
          expect(se.hours, equals(randomTime.hours))); 
 
      //selectedTimes.display(title: "Select times by hours"); 
    }); 
 
    test("Select times by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select times by attribute, then add", () { 
      var randomTime = projectModel.times.random(); 
      var selectedTimes = 
          times.selectWhereAttribute("hours", randomTime.hours); 
      expect(selectedTimes.isEmpty, isFalse); 
      expect(selectedTimes.source?.isEmpty, isFalse); 
      var timesCount = times.length; 
 
      var time = Time(times.concept); 
      time.hours = 4540; 
      var added = selectedTimes.add(time); 
      expect(added, isTrue); 
      expect(times.length, equals(++timesCount)); 
 
      //selectedTimes.display(title: 
      //  "Select times by attribute, then add"); 
      //times.display(title: "All times"); 
    }); 
 
    test("Select times by attribute, then remove", () { 
      var randomTime = projectModel.times.random(); 
      var selectedTimes = 
          times.selectWhereAttribute("hours", randomTime.hours); 
      expect(selectedTimes.isEmpty, isFalse); 
      expect(selectedTimes.source?.isEmpty, isFalse); 
      var timesCount = times.length; 
 
      var removed = selectedTimes.remove(randomTime); 
      expect(removed, isTrue); 
      expect(times.length, equals(--timesCount)); 
 
      randomTime.display(prefix: "removed"); 
      //selectedTimes.display(title: 
      //  "Select times by attribute, then remove"); 
      //times.display(title: "All times"); 
    }); 
 
    test("Sort times", () { 
      // no id attribute 
      // add compareTo method in the specific Time class 
      /* 
      times.sort(); 
 
      //times.display(title: "Sort times"); 
      */ 
    }); 
 
    test("Order times", () { 
      // no id attribute 
      // add compareTo method in the specific Time class 
      /* 
      var orderedTimes = times.order(); 
      expect(orderedTimes.isEmpty, isFalse); 
      expect(orderedTimes.length, equals(times.length)); 
      expect(orderedTimes.source?.isEmpty, isFalse); 
      expect(orderedTimes.source?.length, equals(times.length)); 
      expect(orderedTimes, isNot(same(times))); 
 
      //orderedTimes.display(title: "Order times"); 
      */ 
    }); 
 
    test("Copy times", () { 
      var copiedTimes = times.copy(); 
      expect(copiedTimes.isEmpty, isFalse); 
      expect(copiedTimes.length, equals(times.length)); 
      expect(copiedTimes, isNot(same(times))); 
      copiedTimes.forEach((e) => 
        expect(e, equals(times.singleWhereOid(e.oid)))); 
 
      //copiedTimes.display(title: "Copy times"); 
    }); 
 
    test("True for every time", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random time", () { 
      var time1 = projectModel.times.random(); 
      expect(time1, isNotNull); 
      var time2 = projectModel.times.random(); 
      expect(time2, isNotNull); 
 
      //time1.display(prefix: "random1"); 
      //time2.display(prefix: "random2"); 
    }); 
 
    test("Update time id with try", () { 
      // no id attribute 
    }); 
 
    test("Update time id without try", () { 
      // no id attribute 
    }); 
 
    test("Update time id with success", () { 
      // no id attribute 
    }); 
 
    test("Update time non id attribute with failure", () { 
      var randomTime = projectModel.times.random(); 
      var afterUpdateEntity = randomTime.copy(); 
      afterUpdateEntity.hours = 8360; 
      expect(afterUpdateEntity.hours, equals(8360)); 
      // times.update can only be used if oid, code or id is set. 
      expect(() => times.update(randomTime, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomTime = projectModel.times.random(); 
      randomTime.display(prefix:"before copy: "); 
      var randomTimeCopy = randomTime.copy(); 
      randomTimeCopy.display(prefix:"after copy: "); 
      expect(randomTime, equals(randomTimeCopy)); 
      expect(randomTime.oid, equals(randomTimeCopy.oid)); 
      expect(randomTime.code, equals(randomTimeCopy.code)); 
      expect(randomTime.hours, equals(randomTimeCopy.hours)); 
 
    }); 
 
    test("time action undo and redo", () { 
      var timeCount = times.length; 
      var time = Time(times.concept); 
        time.hours = 2257; 
    var timeProject = projectModel.projects.random(); 
    time.project = timeProject; 
      times.add(time); 
    timeProject.times.add(time); 
      expect(times.length, equals(++timeCount)); 
      times.remove(time); 
      expect(times.length, equals(--timeCount)); 
 
      var action = AddCommand(session, times, time); 
      action.doIt(); 
      expect(times.length, equals(++timeCount)); 
 
      action.undo(); 
      expect(times.length, equals(--timeCount)); 
 
      action.redo(); 
      expect(times.length, equals(++timeCount)); 
    }); 
 
    test("time session undo and redo", () { 
      var timeCount = times.length; 
      var time = Time(times.concept); 
        time.hours = 7810; 
    var timeProject = projectModel.projects.random(); 
    time.project = timeProject; 
      times.add(time); 
    timeProject.times.add(time); 
      expect(times.length, equals(++timeCount)); 
      times.remove(time); 
      expect(times.length, equals(--timeCount)); 
 
      var action = AddCommand(session, times, time); 
      action.doIt(); 
      expect(times.length, equals(++timeCount)); 
 
      session.past.undo(); 
      expect(times.length, equals(--timeCount)); 
 
      session.past.redo(); 
      expect(times.length, equals(++timeCount)); 
    }); 
 
    test("Time update undo and redo", () { 
      var time = projectModel.times.random(); 
      var action = SetAttributeCommand(session, time, "hours", 6618); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(time.hours, equals(action.before)); 
 
      session.past.redo(); 
      expect(time.hours, equals(action.after)); 
    }); 
 
    test("Time action with multiple undos and redos", () { 
      var timeCount = times.length; 
      var time1 = projectModel.times.random(); 
 
      var action1 = RemoveCommand(session, times, time1); 
      action1.doIt(); 
      expect(times.length, equals(--timeCount)); 
 
      var time2 = projectModel.times.random(); 
 
      var action2 = RemoveCommand(session, times, time2); 
      action2.doIt(); 
      expect(times.length, equals(--timeCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(times.length, equals(++timeCount)); 
 
      session.past.undo(); 
      expect(times.length, equals(++timeCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(times.length, equals(--timeCount)); 
 
      session.past.redo(); 
      expect(times.length, equals(--timeCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var timeCount = times.length; 
      var time1 = projectModel.times.random(); 
      var time2 = projectModel.times.random(); 
      while (time1 == time2) { 
        time2 = projectModel.times.random();  
      } 
      var action1 = RemoveCommand(session, times, time1); 
      var action2 = RemoveCommand(session, times, time2); 
 
      var transaction = new Transaction("two removes on times", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      timeCount = timeCount - 2; 
      expect(times.length, equals(timeCount)); 
 
      times.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      timeCount = timeCount + 2; 
      expect(times.length, equals(timeCount)); 
 
      times.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      timeCount = timeCount - 2; 
      expect(times.length, equals(timeCount)); 
 
      times.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var timeCount = times.length; 
      var time1 = projectModel.times.random(); 
      var time2 = time1; 
      var action1 = RemoveCommand(session, times, time1); 
      var action2 = RemoveCommand(session, times, time2); 
 
      var transaction = Transaction( 
        "two removes on times, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(times.length, equals(timeCount)); 
 
      //times.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to time actions", () { 
      var timeCount = times.length; 
 
      var reaction = TimeReaction(); 
      expect(reaction, isNotNull); 
 
      householdDomain.startCommandReaction(reaction); 
      var time = Time(times.concept); 
        time.hours = 8313; 
    var timeProject = projectModel.projects.random(); 
    time.project = timeProject; 
      times.add(time); 
    timeProject.times.add(time); 
      expect(times.length, equals(++timeCount)); 
      times.remove(time); 
      expect(times.length, equals(--timeCount)); 
 
      var session = householdDomain.newSession(); 
      var addCommand = AddCommand(session, times, time); 
      addCommand.doIt(); 
      expect(times.length, equals(++timeCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, time, "hours", 1289); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      householdDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class TimeReaction implements ICommandReaction { 
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
  var times = projectModel.times; 
  testHouseholdProjectTimes(householdDomain, projectModel, times); 
} 
 
