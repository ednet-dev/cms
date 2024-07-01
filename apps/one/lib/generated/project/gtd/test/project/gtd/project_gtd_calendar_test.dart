 
// test/project/gtd/project_gtd_calendar_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_gtd/project_gtd.dart"; 
 
void testProjectGtdCalendars( 
    ProjectDomain projectDomain, GtdModel gtdModel, Calendars calendars) { 
  DomainSession session; 
  group("Testing Project.Gtd.Calendar", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      gtdModel.init(); 
    }); 
    tearDown(() { 
      gtdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(gtdModel.isEmpty, isFalse); 
      expect(calendars.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      expect(calendars.isEmpty, isTrue); 
      expect(calendars.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = gtdModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = gtdModel.toJson(); 
      gtdModel.clear(); 
      expect(gtdModel.isEmpty, isTrue); 
      gtdModel.fromJson(json); 
      expect(gtdModel.isEmpty, isFalse); 
 
      gtdModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = gtdModel.fromEntryToJson("Calendar"); 
      expect(json, isNotNull); 
 
      print(json); 
      //gtdModel.displayEntryJson("Calendar"); 
      //gtdModel.displayJson(); 
      //gtdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = gtdModel.fromEntryToJson("Calendar"); 
      calendars.clear(); 
      expect(calendars.isEmpty, isTrue); 
      gtdModel.fromJsonToEntry(json); 
      expect(calendars.isEmpty, isFalse); 
 
      calendars.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add calendar required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add calendar unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found calendar by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var calendar = calendars.singleWhereOid(ednetOid); 
      expect(calendar, isNull); 
    }); 
 
    test("Find calendar by oid", () { 
      var randomCalendar = gtdModel.calendars.random(); 
      var calendar = calendars.singleWhereOid(randomCalendar.oid); 
      expect(calendar, isNotNull); 
      expect(calendar, equals(randomCalendar)); 
    }); 
 
    test("Find calendar by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find calendar by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find calendar by attribute", () { 
      var randomCalendar = gtdModel.calendars.random(); 
      var calendar = 
          calendars.firstWhereAttribute("events", randomCalendar.events); 
      expect(calendar, isNotNull); 
      expect(calendar.events, equals(randomCalendar.events)); 
    }); 
 
    test("Select calendars by attribute", () { 
      var randomCalendar = gtdModel.calendars.random(); 
      var selectedCalendars = 
          calendars.selectWhereAttribute("events", randomCalendar.events); 
      expect(selectedCalendars.isEmpty, isFalse); 
      selectedCalendars.forEach((se) => 
          expect(se.events, equals(randomCalendar.events))); 
 
      //selectedCalendars.display(title: "Select calendars by events"); 
    }); 
 
    test("Select calendars by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select calendars by attribute, then add", () { 
      var randomCalendar = gtdModel.calendars.random(); 
      var selectedCalendars = 
          calendars.selectWhereAttribute("events", randomCalendar.events); 
      expect(selectedCalendars.isEmpty, isFalse); 
      expect(selectedCalendars.source?.isEmpty, isFalse); 
      var calendarsCount = calendars.length; 
 
      var calendar = Calendar(calendars.concept); 
      calendar.events = 'selfie'; 
      var added = selectedCalendars.add(calendar); 
      expect(added, isTrue); 
      expect(calendars.length, equals(++calendarsCount)); 
 
      //selectedCalendars.display(title: 
      //  "Select calendars by attribute, then add"); 
      //calendars.display(title: "All calendars"); 
    }); 
 
    test("Select calendars by attribute, then remove", () { 
      var randomCalendar = gtdModel.calendars.random(); 
      var selectedCalendars = 
          calendars.selectWhereAttribute("events", randomCalendar.events); 
      expect(selectedCalendars.isEmpty, isFalse); 
      expect(selectedCalendars.source?.isEmpty, isFalse); 
      var calendarsCount = calendars.length; 
 
      var removed = selectedCalendars.remove(randomCalendar); 
      expect(removed, isTrue); 
      expect(calendars.length, equals(--calendarsCount)); 
 
      randomCalendar.display(prefix: "removed"); 
      //selectedCalendars.display(title: 
      //  "Select calendars by attribute, then remove"); 
      //calendars.display(title: "All calendars"); 
    }); 
 
    test("Sort calendars", () { 
      // no id attribute 
      // add compareTo method in the specific Calendar class 
      /* 
      calendars.sort(); 
 
      //calendars.display(title: "Sort calendars"); 
      */ 
    }); 
 
    test("Order calendars", () { 
      // no id attribute 
      // add compareTo method in the specific Calendar class 
      /* 
      var orderedCalendars = calendars.order(); 
      expect(orderedCalendars.isEmpty, isFalse); 
      expect(orderedCalendars.length, equals(calendars.length)); 
      expect(orderedCalendars.source?.isEmpty, isFalse); 
      expect(orderedCalendars.source?.length, equals(calendars.length)); 
      expect(orderedCalendars, isNot(same(calendars))); 
 
      //orderedCalendars.display(title: "Order calendars"); 
      */ 
    }); 
 
    test("Copy calendars", () { 
      var copiedCalendars = calendars.copy(); 
      expect(copiedCalendars.isEmpty, isFalse); 
      expect(copiedCalendars.length, equals(calendars.length)); 
      expect(copiedCalendars, isNot(same(calendars))); 
      copiedCalendars.forEach((e) => 
        expect(e, equals(calendars.singleWhereOid(e.oid)))); 
 
      //copiedCalendars.display(title: "Copy calendars"); 
    }); 
 
    test("True for every calendar", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random calendar", () { 
      var calendar1 = gtdModel.calendars.random(); 
      expect(calendar1, isNotNull); 
      var calendar2 = gtdModel.calendars.random(); 
      expect(calendar2, isNotNull); 
 
      //calendar1.display(prefix: "random1"); 
      //calendar2.display(prefix: "random2"); 
    }); 
 
    test("Update calendar id with try", () { 
      // no id attribute 
    }); 
 
    test("Update calendar id without try", () { 
      // no id attribute 
    }); 
 
    test("Update calendar id with success", () { 
      // no id attribute 
    }); 
 
    test("Update calendar non id attribute with failure", () { 
      var randomCalendar = gtdModel.calendars.random(); 
      var afterUpdateEntity = randomCalendar.copy(); 
      afterUpdateEntity.events = 'plaho'; 
      expect(afterUpdateEntity.events, equals('plaho')); 
      // calendars.update can only be used if oid, code or id is set. 
      expect(() => calendars.update(randomCalendar, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomCalendar = gtdModel.calendars.random(); 
      randomCalendar.display(prefix:"before copy: "); 
      var randomCalendarCopy = randomCalendar.copy(); 
      randomCalendarCopy.display(prefix:"after copy: "); 
      expect(randomCalendar, equals(randomCalendarCopy)); 
      expect(randomCalendar.oid, equals(randomCalendarCopy.oid)); 
      expect(randomCalendar.code, equals(randomCalendarCopy.code)); 
      expect(randomCalendar.events, equals(randomCalendarCopy.events)); 
 
    }); 
 
    test("calendar action undo and redo", () { 
      var calendarCount = calendars.length; 
      var calendar = Calendar(calendars.concept); 
        calendar.events = 'paper'; 
    var calendarTask = gtdModel.tasks.random(); 
    calendar.task = calendarTask; 
      calendars.add(calendar); 
    calendarTask.calendar.add(calendar); 
      expect(calendars.length, equals(++calendarCount)); 
      calendars.remove(calendar); 
      expect(calendars.length, equals(--calendarCount)); 
 
      var action = AddCommand(session, calendars, calendar); 
      action.doIt(); 
      expect(calendars.length, equals(++calendarCount)); 
 
      action.undo(); 
      expect(calendars.length, equals(--calendarCount)); 
 
      action.redo(); 
      expect(calendars.length, equals(++calendarCount)); 
    }); 
 
    test("calendar session undo and redo", () { 
      var calendarCount = calendars.length; 
      var calendar = Calendar(calendars.concept); 
        calendar.events = 'oil'; 
    var calendarTask = gtdModel.tasks.random(); 
    calendar.task = calendarTask; 
      calendars.add(calendar); 
    calendarTask.calendar.add(calendar); 
      expect(calendars.length, equals(++calendarCount)); 
      calendars.remove(calendar); 
      expect(calendars.length, equals(--calendarCount)); 
 
      var action = AddCommand(session, calendars, calendar); 
      action.doIt(); 
      expect(calendars.length, equals(++calendarCount)); 
 
      session.past.undo(); 
      expect(calendars.length, equals(--calendarCount)); 
 
      session.past.redo(); 
      expect(calendars.length, equals(++calendarCount)); 
    }); 
 
    test("Calendar update undo and redo", () { 
      var calendar = gtdModel.calendars.random(); 
      var action = SetAttributeCommand(session, calendar, "events", 'children'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(calendar.events, equals(action.before)); 
 
      session.past.redo(); 
      expect(calendar.events, equals(action.after)); 
    }); 
 
    test("Calendar action with multiple undos and redos", () { 
      var calendarCount = calendars.length; 
      var calendar1 = gtdModel.calendars.random(); 
 
      var action1 = RemoveCommand(session, calendars, calendar1); 
      action1.doIt(); 
      expect(calendars.length, equals(--calendarCount)); 
 
      var calendar2 = gtdModel.calendars.random(); 
 
      var action2 = RemoveCommand(session, calendars, calendar2); 
      action2.doIt(); 
      expect(calendars.length, equals(--calendarCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(calendars.length, equals(++calendarCount)); 
 
      session.past.undo(); 
      expect(calendars.length, equals(++calendarCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(calendars.length, equals(--calendarCount)); 
 
      session.past.redo(); 
      expect(calendars.length, equals(--calendarCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var calendarCount = calendars.length; 
      var calendar1 = gtdModel.calendars.random(); 
      var calendar2 = gtdModel.calendars.random(); 
      while (calendar1 == calendar2) { 
        calendar2 = gtdModel.calendars.random();  
      } 
      var action1 = RemoveCommand(session, calendars, calendar1); 
      var action2 = RemoveCommand(session, calendars, calendar2); 
 
      var transaction = new Transaction("two removes on calendars", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      calendarCount = calendarCount - 2; 
      expect(calendars.length, equals(calendarCount)); 
 
      calendars.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      calendarCount = calendarCount + 2; 
      expect(calendars.length, equals(calendarCount)); 
 
      calendars.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      calendarCount = calendarCount - 2; 
      expect(calendars.length, equals(calendarCount)); 
 
      calendars.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var calendarCount = calendars.length; 
      var calendar1 = gtdModel.calendars.random(); 
      var calendar2 = calendar1; 
      var action1 = RemoveCommand(session, calendars, calendar1); 
      var action2 = RemoveCommand(session, calendars, calendar2); 
 
      var transaction = Transaction( 
        "two removes on calendars, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(calendars.length, equals(calendarCount)); 
 
      //calendars.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to calendar actions", () { 
      var calendarCount = calendars.length; 
 
      var reaction = CalendarReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var calendar = Calendar(calendars.concept); 
        calendar.events = 'objective'; 
    var calendarTask = gtdModel.tasks.random(); 
    calendar.task = calendarTask; 
      calendars.add(calendar); 
    calendarTask.calendar.add(calendar); 
      expect(calendars.length, equals(++calendarCount)); 
      calendars.remove(calendar); 
      expect(calendars.length, equals(--calendarCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, calendars, calendar); 
      addCommand.doIt(); 
      expect(calendars.length, equals(++calendarCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, calendar, "events", 'hot'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class CalendarReaction implements ICommandReaction { 
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
  var repository = ProjectGtdRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  GtdModel gtdModel = projectDomain.getModelEntries("Gtd") as GtdModel;  
  assert(gtdModel != null); 
  var calendars = gtdModel.calendars; 
  testProjectGtdCalendars(projectDomain, gtdModel, calendars); 
} 
 
