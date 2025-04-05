 
// test/project/core/project_core_time_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreTimes( 
    ProjectDomain projectDomain, CoreModel coreModel, Times times) { 
  DomainSession session; 
  group('Testing Project.Core.Time', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(times.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(times.isEmpty, isTrue); 
      expect(times.exceptions.isEmpty, isTrue); 
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
      final json = coreModel.fromEntryToJson('Time'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Time'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Time'); 
      times.clear(); 
      expect(times.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(times.isEmpty, isFalse); 
 
      times.display(title: 'From JSON to model entry'); 
    }); 
 
    test('Add time required error', () { 
      // no required attribute that is not id 
    }); 
 
    test('Add time unique error', () { 
      // no id attribute 
    }); 
 
    test('Not found time by oid', () { 
      final ednetOid = Oid.ts(1345648254063); 
      final time = times.singleWhereOid(ednetOid); 
      expect(time, isNull); 
    }); 
 
    test('Find time by oid', () { 
      final randomTime = coreModel.times.random(); 
      final time = times.singleWhereOid(randomTime.oid); 
      expect(time, isNotNull); 
      expect(time, equals(randomTime)); 
    }); 
 
    test('Find time by attribute id', () { 
      // no id attribute 
    }); 
 
    test('Find time by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Find time by attribute', () { 
      final randomTime = coreModel.times.random(); 
      final time = 
          times.firstWhereAttribute('hours', randomTime.hours); 
      expect(time, isNotNull); 
      expect(time.hours, equals(randomTime.hours)); 
    }); 
 
    test('Select times by attribute', () { 
      final randomTime = coreModel.times.random(); 
      final selectedTimes = 
          times.selectWhereAttribute('hours', randomTime.hours); 
      expect(selectedTimes.isEmpty, isFalse); 
      for (final se in selectedTimes) {        expect(se.hours, equals(randomTime.hours));      } 
      //selectedTimes.display(title: 'Select times by hours'); 
    }); 
 
    test('Select times by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select times by attribute, then add', () { 
      final randomTime = coreModel.times.random(); 
      final selectedTimes = 
          times.selectWhereAttribute('hours', randomTime.hours); 
      expect(selectedTimes.isEmpty, isFalse); 
      expect(selectedTimes.source?.isEmpty, isFalse); 
      var timesCount = times.length; 
 
      final time = Time(times.concept) 

      ..hours = 8773;      final added = selectedTimes.add(time); 
      expect(added, isTrue); 
      expect(times.length, equals(++timesCount)); 
 
      //selectedTimes.display(title: 
      //  'Select times by attribute, then add'); 
      //times.display(title: 'All times'); 
    }); 
 
    test('Select times by attribute, then remove', () { 
      final randomTime = coreModel.times.random(); 
      final selectedTimes = 
          times.selectWhereAttribute('hours', randomTime.hours); 
      expect(selectedTimes.isEmpty, isFalse); 
      expect(selectedTimes.source?.isEmpty, isFalse); 
      var timesCount = times.length; 
 
      final removed = selectedTimes.remove(randomTime); 
      expect(removed, isTrue); 
      expect(times.length, equals(--timesCount)); 
 
      randomTime.display(prefix: 'removed'); 
      //selectedTimes.display(title: 
      //  'Select times by attribute, then remove'); 
      //times.display(title: 'All times'); 
    }); 
 
    test('Sort times', () { 
      // no id attribute 
      // add compareTo method in the specific Time class 
      /* 
      times.sort(); 
 
      //times.display(title: 'Sort times'); 
      */ 
    }); 
 
    test('Order times', () { 
      // no id attribute 
      // add compareTo method in the specific Time class 
      /* 
      final orderedTimes = times.order(); 
      expect(orderedTimes.isEmpty, isFalse); 
      expect(orderedTimes.length, equals(times.length)); 
      expect(orderedTimes.source?.isEmpty, isFalse); 
      expect(orderedTimes.source?.length, equals(times.length)); 
      expect(orderedTimes, isNot(same(times))); 
 
      //orderedTimes.display(title: 'Order times'); 
      */ 
    }); 
 
    test('Copy times', () { 
      final copiedTimes = times.copy(); 
      expect(copiedTimes.isEmpty, isFalse); 
      expect(copiedTimes.length, equals(times.length)); 
      expect(copiedTimes, isNot(same(times))); 
      for (final e in copiedTimes) {        expect(e, equals(times.singleWhereOid(e.oid)));      } 
 
      //copiedTimes.display(title: "Copy times"); 
    }); 
 
    test('True for every time', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random time', () { 
      final time1 = coreModel.times.random(); 
      expect(time1, isNotNull); 
      final time2 = coreModel.times.random(); 
      expect(time2, isNotNull); 
 
      //time1.display(prefix: 'random1'); 
      //time2.display(prefix: 'random2'); 
    }); 
 
    test('Update time id with try', () { 
      // no id attribute 
    }); 
 
    test('Update time id without try', () { 
      // no id attribute 
    }); 
 
    test('Update time id with success', () { 
      // no id attribute 
    }); 
 
    test('Update time non id attribute with failure', () { 
      final randomTime = coreModel.times.random(); 
      final afterUpdateEntity = randomTime.copy()..hours = 3446; 
      expect(afterUpdateEntity.hours, equals(3446)); 
      // times.update can only be used if oid, code or id is set. 
      expect(() => times.update(randomTime, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomTime = coreModel.times.random()..display(prefix:'before copy: '); 
      final randomTimeCopy = randomTime.copy()..display(prefix:'after copy: '); 
      expect(randomTime, equals(randomTimeCopy)); 
      expect(randomTime.oid, equals(randomTimeCopy.oid)); 
      expect(randomTime.code, equals(randomTimeCopy.code)); 
      expect(randomTime.hours, equals(randomTimeCopy.hours)); 
 
    }); 
 
    test('time action undo and redo', () { 
      var timeCount = times.length; 
      final time = Time(times.concept) 
  
      ..hours = 2812;    final timeProject = coreModel.projects.random(); 
    time.project = timeProject; 
      times.add(time); 
    timeProject.times.add(time); 
      expect(times.length, equals(++timeCount)); 
      times.remove(time); 
      expect(times.length, equals(--timeCount)); 
 
      final action = AddCommand(session, times, time)..doIt(); 
      expect(times.length, equals(++timeCount)); 
 
      action.undo(); 
      expect(times.length, equals(--timeCount)); 
 
      action.redo(); 
      expect(times.length, equals(++timeCount)); 
    }); 
 
    test('time session undo and redo', () { 
      var timeCount = times.length; 
      final time = Time(times.concept) 
  
      ..hours = 5827;    final timeProject = coreModel.projects.random(); 
    time.project = timeProject; 
      times.add(time); 
    timeProject.times.add(time); 
      expect(times.length, equals(++timeCount)); 
      times.remove(time); 
      expect(times.length, equals(--timeCount)); 
 
      AddCommand(session, times, time).doIt();; 
      expect(times.length, equals(++timeCount)); 
 
      session.past.undo(); 
      expect(times.length, equals(--timeCount)); 
 
      session.past.redo(); 
      expect(times.length, equals(++timeCount)); 
    }); 
 
    test('Time update undo and redo', () { 
      final time = coreModel.times.random(); 
      final action = SetAttributeCommand(session, time, 'hours', 4801)..doIt(); 
 
      session.past.undo(); 
      expect(time.hours, equals(action.before)); 
 
      session.past.redo(); 
      expect(time.hours, equals(action.after)); 
    }); 
 
    test('Time action with multiple undos and redos', () { 
      var timeCount = times.length; 
      final time1 = coreModel.times.random(); 
 
      RemoveCommand(session, times, time1).doIt(); 
      expect(times.length, equals(--timeCount)); 
 
      final time2 = coreModel.times.random(); 
 
      RemoveCommand(session, times, time2).doIt(); 
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
 
    test('Transaction undo and redo', () { 
      var timeCount = times.length; 
      final time1 = coreModel.times.random(); 
      var time2 = coreModel.times.random(); 
      while (time1 == time2) { 
        time2 = coreModel.times.random();  
      } 
      final action1 = RemoveCommand(session, times, time1); 
      final action2 = RemoveCommand(session, times, time2); 
 
      Transaction('two removes on times', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      timeCount = timeCount - 2; 
      expect(times.length, equals(timeCount)); 
 
      times.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      timeCount = timeCount + 2; 
      expect(times.length, equals(timeCount)); 
 
      times.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      timeCount = timeCount - 2; 
      expect(times.length, equals(timeCount)); 
 
      times.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final timeCount = times.length; 
      final time1 = coreModel.times.random(); 
      final time2 = time1; 
      final action1 = RemoveCommand(session, times, time1); 
      final action2 = RemoveCommand(session, times, time2); 
 
      final transaction = Transaction( 
        'two removes on times, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(times.length, equals(timeCount)); 
 
      //times.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to time actions', () { 
      var timeCount = times.length; 
 
      final reaction = TimeReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final time = Time(times.concept) 
  
      ..hours = 5044;    final timeProject = coreModel.projects.random(); 
    time.project = timeProject; 
      times.add(time); 
    timeProject.times.add(time); 
      expect(times.length, equals(++timeCount)); 
      times.remove(time); 
      expect(times.length, equals(--timeCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, times, time).doIt(); 
      expect(times.length, equals(++timeCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        time,
        'hours',
        7992,
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class TimeReaction implements ICommandReaction { 
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
  final times = coreModel!.times; 
  testProjectCoreTimes(projectDomain, coreModel, times); 
} 
 
