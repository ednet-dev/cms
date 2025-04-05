 
// test/project/core/project_core_task_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreTasks( 
    ProjectDomain projectDomain, CoreModel coreModel, Tasks tasks) { 
  DomainSession session; 
  group('Testing Project.Core.Task', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(tasks.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(tasks.isEmpty, isTrue); 
      expect(tasks.exceptions.isEmpty, isTrue); 
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
      final json = coreModel.fromEntryToJson('Task'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Task'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Task'); 
      tasks.clear(); 
      expect(tasks.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(tasks.isEmpty, isFalse); 
 
      tasks.display(title: 'From JSON to model entry'); 
    }); 
 
    test('Add task required error', () { 
      // no required attribute that is not id 
    }); 
 
    test('Add task unique error', () { 
      // no id attribute 
    }); 
 
    test('Not found task by oid', () { 
      final ednetOid = Oid.ts(1345648254063); 
      final task = tasks.singleWhereOid(ednetOid); 
      expect(task, isNull); 
    }); 
 
    test('Find task by oid', () { 
      final randomTask = coreModel.tasks.random(); 
      final task = tasks.singleWhereOid(randomTask.oid); 
      expect(task, isNotNull); 
      expect(task, equals(randomTask)); 
    }); 
 
    test('Find task by attribute id', () { 
      // no id attribute 
    }); 
 
    test('Find task by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Find task by attribute', () { 
      final randomTask = coreModel.tasks.random(); 
      final task = 
          tasks.firstWhereAttribute('title', randomTask.title); 
      expect(task, isNotNull); 
      expect(task.title, equals(randomTask.title)); 
    }); 
 
    test('Select tasks by attribute', () { 
      final randomTask = coreModel.tasks.random(); 
      final selectedTasks = 
          tasks.selectWhereAttribute('title', randomTask.title); 
      expect(selectedTasks.isEmpty, isFalse); 
      for (final se in selectedTasks) {        expect(se.title, equals(randomTask.title));      } 
      //selectedTasks.display(title: 'Select tasks by title'); 
    }); 
 
    test('Select tasks by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select tasks by attribute, then add', () { 
      final randomTask = coreModel.tasks.random(); 
      final selectedTasks = 
          tasks.selectWhereAttribute('title', randomTask.title); 
      expect(selectedTasks.isEmpty, isFalse); 
      expect(selectedTasks.source?.isEmpty, isFalse); 
      var tasksCount = tasks.length; 
 
      final task = Task(tasks.concept) 

      ..title = 'table'
      ..dueDate = new DateTime.now()
      ..status = 'debt'
      ..priority = 'call';      final added = selectedTasks.add(task); 
      expect(added, isTrue); 
      expect(tasks.length, equals(++tasksCount)); 
 
      //selectedTasks.display(title: 
      //  'Select tasks by attribute, then add'); 
      //tasks.display(title: 'All tasks'); 
    }); 
 
    test('Select tasks by attribute, then remove', () { 
      final randomTask = coreModel.tasks.random(); 
      final selectedTasks = 
          tasks.selectWhereAttribute('title', randomTask.title); 
      expect(selectedTasks.isEmpty, isFalse); 
      expect(selectedTasks.source?.isEmpty, isFalse); 
      var tasksCount = tasks.length; 
 
      final removed = selectedTasks.remove(randomTask); 
      expect(removed, isTrue); 
      expect(tasks.length, equals(--tasksCount)); 
 
      randomTask.display(prefix: 'removed'); 
      //selectedTasks.display(title: 
      //  'Select tasks by attribute, then remove'); 
      //tasks.display(title: 'All tasks'); 
    }); 
 
    test('Sort tasks', () { 
      // no id attribute 
      // add compareTo method in the specific Task class 
      /* 
      tasks.sort(); 
 
      //tasks.display(title: 'Sort tasks'); 
      */ 
    }); 
 
    test('Order tasks', () { 
      // no id attribute 
      // add compareTo method in the specific Task class 
      /* 
      final orderedTasks = tasks.order(); 
      expect(orderedTasks.isEmpty, isFalse); 
      expect(orderedTasks.length, equals(tasks.length)); 
      expect(orderedTasks.source?.isEmpty, isFalse); 
      expect(orderedTasks.source?.length, equals(tasks.length)); 
      expect(orderedTasks, isNot(same(tasks))); 
 
      //orderedTasks.display(title: 'Order tasks'); 
      */ 
    }); 
 
    test('Copy tasks', () { 
      final copiedTasks = tasks.copy(); 
      expect(copiedTasks.isEmpty, isFalse); 
      expect(copiedTasks.length, equals(tasks.length)); 
      expect(copiedTasks, isNot(same(tasks))); 
      for (final e in copiedTasks) {        expect(e, equals(tasks.singleWhereOid(e.oid)));      } 
 
      //copiedTasks.display(title: "Copy tasks"); 
    }); 
 
    test('True for every task', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random task', () { 
      final task1 = coreModel.tasks.random(); 
      expect(task1, isNotNull); 
      final task2 = coreModel.tasks.random(); 
      expect(task2, isNotNull); 
 
      //task1.display(prefix: 'random1'); 
      //task2.display(prefix: 'random2'); 
    }); 
 
    test('Update task id with try', () { 
      // no id attribute 
    }); 
 
    test('Update task id without try', () { 
      // no id attribute 
    }); 
 
    test('Update task id with success', () { 
      // no id attribute 
    }); 
 
    test('Update task non id attribute with failure', () { 
      final randomTask = coreModel.tasks.random(); 
      final afterUpdateEntity = randomTask.copy()..title = 'discount'; 
      expect(afterUpdateEntity.title, equals('discount')); 
      // tasks.update can only be used if oid, code or id is set. 
      expect(() => tasks.update(randomTask, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomTask = coreModel.tasks.random()..display(prefix:'before copy: '); 
      final randomTaskCopy = randomTask.copy()..display(prefix:'after copy: '); 
      expect(randomTask, equals(randomTaskCopy)); 
      expect(randomTask.oid, equals(randomTaskCopy.oid)); 
      expect(randomTask.code, equals(randomTaskCopy.code)); 
      expect(randomTask.title, equals(randomTaskCopy.title)); 
      expect(randomTask.dueDate, equals(randomTaskCopy.dueDate)); 
      expect(randomTask.status, equals(randomTaskCopy.status)); 
      expect(randomTask.priority, equals(randomTaskCopy.priority)); 
 
    }); 
 
    test('task action undo and redo', () { 
      var taskCount = tasks.length; 
      final task = Task(tasks.concept) 
  
      ..title = 'entertainment'
      ..dueDate = new DateTime.now()
      ..status = 'hot'
      ..priority = 'energy';    final taskProject = coreModel.projects.random(); 
    task.project = taskProject; 
      tasks.add(task); 
    taskProject.tasks.add(task); 
      expect(tasks.length, equals(++taskCount)); 
      tasks.remove(task); 
      expect(tasks.length, equals(--taskCount)); 
 
      final action = AddCommand(session, tasks, task)..doIt(); 
      expect(tasks.length, equals(++taskCount)); 
 
      action.undo(); 
      expect(tasks.length, equals(--taskCount)); 
 
      action.redo(); 
      expect(tasks.length, equals(++taskCount)); 
    }); 
 
    test('task session undo and redo', () { 
      var taskCount = tasks.length; 
      final task = Task(tasks.concept) 
  
      ..title = 'team'
      ..dueDate = new DateTime.now()
      ..status = 'city'
      ..priority = 'plaho';    final taskProject = coreModel.projects.random(); 
    task.project = taskProject; 
      tasks.add(task); 
    taskProject.tasks.add(task); 
      expect(tasks.length, equals(++taskCount)); 
      tasks.remove(task); 
      expect(tasks.length, equals(--taskCount)); 
 
      AddCommand(session, tasks, task).doIt();; 
      expect(tasks.length, equals(++taskCount)); 
 
      session.past.undo(); 
      expect(tasks.length, equals(--taskCount)); 
 
      session.past.redo(); 
      expect(tasks.length, equals(++taskCount)); 
    }); 
 
    test('Task update undo and redo', () { 
      final task = coreModel.tasks.random(); 
      final action = SetAttributeCommand(session, task, 'title', 'notch')..doIt(); 
 
      session.past.undo(); 
      expect(task.title, equals(action.before)); 
 
      session.past.redo(); 
      expect(task.title, equals(action.after)); 
    }); 
 
    test('Task action with multiple undos and redos', () { 
      var taskCount = tasks.length; 
      final task1 = coreModel.tasks.random(); 
 
      RemoveCommand(session, tasks, task1).doIt(); 
      expect(tasks.length, equals(--taskCount)); 
 
      final task2 = coreModel.tasks.random(); 
 
      RemoveCommand(session, tasks, task2).doIt(); 
      expect(tasks.length, equals(--taskCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(tasks.length, equals(++taskCount)); 
 
      session.past.undo(); 
      expect(tasks.length, equals(++taskCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(tasks.length, equals(--taskCount)); 
 
      session.past.redo(); 
      expect(tasks.length, equals(--taskCount)); 
 
      //session.past.display(); 
    }); 
 
    test('Transaction undo and redo', () { 
      var taskCount = tasks.length; 
      final task1 = coreModel.tasks.random(); 
      var task2 = coreModel.tasks.random(); 
      while (task1 == task2) { 
        task2 = coreModel.tasks.random();  
      } 
      final action1 = RemoveCommand(session, tasks, task1); 
      final action2 = RemoveCommand(session, tasks, task2); 
 
      Transaction('two removes on tasks', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      taskCount = taskCount - 2; 
      expect(tasks.length, equals(taskCount)); 
 
      tasks.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      taskCount = taskCount + 2; 
      expect(tasks.length, equals(taskCount)); 
 
      tasks.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      taskCount = taskCount - 2; 
      expect(tasks.length, equals(taskCount)); 
 
      tasks.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final taskCount = tasks.length; 
      final task1 = coreModel.tasks.random(); 
      final task2 = task1; 
      final action1 = RemoveCommand(session, tasks, task1); 
      final action2 = RemoveCommand(session, tasks, task2); 
 
      final transaction = Transaction( 
        'two removes on tasks, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(tasks.length, equals(taskCount)); 
 
      //tasks.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to task actions', () { 
      var taskCount = tasks.length; 
 
      final reaction = TaskReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final task = Task(tasks.concept) 
  
      ..title = 'health'
      ..dueDate = new DateTime.now()
      ..status = 'beach'
      ..priority = 'done';    final taskProject = coreModel.projects.random(); 
    task.project = taskProject; 
      tasks.add(task); 
    taskProject.tasks.add(task); 
      expect(tasks.length, equals(++taskCount)); 
      tasks.remove(task); 
      expect(tasks.length, equals(--taskCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, tasks, task).doIt(); 
      expect(tasks.length, equals(++taskCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        task,
        'title',
        'cardboard',
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class TaskReaction implements ICommandReaction { 
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
  final tasks = coreModel!.tasks; 
  testProjectCoreTasks(projectDomain, coreModel, tasks); 
} 
 
