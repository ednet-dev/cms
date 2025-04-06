 
// test/project/core/project_core_task_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_core/project_core.dart"; 
 
void testProjectCoreTasks( 
    ProjectDomain projectDomain, CoreModel coreModel, Tasks tasks) { 
  DomainSession session; 
  group("Testing Project.Core.Task", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(tasks.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(tasks.isEmpty, isTrue); 
      expect(tasks.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = coreModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = coreModel.toJson(); 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      coreModel.fromJson(json); 
      expect(coreModel.isEmpty, isFalse); 
 
      coreModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = coreModel.fromEntryToJson("Task"); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson("Task"); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = coreModel.fromEntryToJson("Task"); 
      tasks.clear(); 
      expect(tasks.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(tasks.isEmpty, isFalse); 
 
      tasks.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add task required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add task unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found task by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var task = tasks.singleWhereOid(ednetOid); 
      expect(task, isNull); 
    }); 
 
    test("Find task by oid", () { 
      var randomTask = coreModel.tasks.random(); 
      var task = tasks.singleWhereOid(randomTask.oid); 
      expect(task, isNotNull); 
      expect(task, equals(randomTask)); 
    }); 
 
    test("Find task by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find task by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find task by attribute", () { 
      var randomTask = coreModel.tasks.random(); 
      var task = 
          tasks.firstWhereAttribute("title", randomTask.title); 
      expect(task, isNotNull); 
      expect(task.title, equals(randomTask.title)); 
    }); 
 
    test("Select tasks by attribute", () { 
      var randomTask = coreModel.tasks.random(); 
      var selectedTasks = 
          tasks.selectWhereAttribute("title", randomTask.title); 
      expect(selectedTasks.isEmpty, isFalse); 
      selectedTasks.forEach((se) => 
          expect(se.title, equals(randomTask.title))); 
 
      //selectedTasks.display(title: "Select tasks by title"); 
    }); 
 
    test("Select tasks by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select tasks by attribute, then add", () { 
      var randomTask = coreModel.tasks.random(); 
      var selectedTasks = 
          tasks.selectWhereAttribute("title", randomTask.title); 
      expect(selectedTasks.isEmpty, isFalse); 
      expect(selectedTasks.source?.isEmpty, isFalse); 
      var tasksCount = tasks.length; 
 
      var task = Task(tasks.concept); 
      task.title = 'edition'; 
      task.dueDate = new DateTime.now(); 
      task.status = 'election'; 
      task.priority = 'meter'; 
      var added = selectedTasks.add(task); 
      expect(added, isTrue); 
      expect(tasks.length, equals(++tasksCount)); 
 
      //selectedTasks.display(title: 
      //  "Select tasks by attribute, then add"); 
      //tasks.display(title: "All tasks"); 
    }); 
 
    test("Select tasks by attribute, then remove", () { 
      var randomTask = coreModel.tasks.random(); 
      var selectedTasks = 
          tasks.selectWhereAttribute("title", randomTask.title); 
      expect(selectedTasks.isEmpty, isFalse); 
      expect(selectedTasks.source?.isEmpty, isFalse); 
      var tasksCount = tasks.length; 
 
      var removed = selectedTasks.remove(randomTask); 
      expect(removed, isTrue); 
      expect(tasks.length, equals(--tasksCount)); 
 
      randomTask.display(prefix: "removed"); 
      //selectedTasks.display(title: 
      //  "Select tasks by attribute, then remove"); 
      //tasks.display(title: "All tasks"); 
    }); 
 
    test("Sort tasks", () { 
      // no id attribute 
      // add compareTo method in the specific Task class 
      /* 
      tasks.sort(); 
 
      //tasks.display(title: "Sort tasks"); 
      */ 
    }); 
 
    test("Order tasks", () { 
      // no id attribute 
      // add compareTo method in the specific Task class 
      /* 
      var orderedTasks = tasks.order(); 
      expect(orderedTasks.isEmpty, isFalse); 
      expect(orderedTasks.length, equals(tasks.length)); 
      expect(orderedTasks.source?.isEmpty, isFalse); 
      expect(orderedTasks.source?.length, equals(tasks.length)); 
      expect(orderedTasks, isNot(same(tasks))); 
 
      //orderedTasks.display(title: "Order tasks"); 
      */ 
    }); 
 
    test("Copy tasks", () { 
      var copiedTasks = tasks.copy(); 
      expect(copiedTasks.isEmpty, isFalse); 
      expect(copiedTasks.length, equals(tasks.length)); 
      expect(copiedTasks, isNot(same(tasks))); 
      copiedTasks.forEach((e) => 
        expect(e, equals(tasks.singleWhereOid(e.oid)))); 
 
      //copiedTasks.display(title: "Copy tasks"); 
    }); 
 
    test("True for every task", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random task", () { 
      var task1 = coreModel.tasks.random(); 
      expect(task1, isNotNull); 
      var task2 = coreModel.tasks.random(); 
      expect(task2, isNotNull); 
 
      //task1.display(prefix: "random1"); 
      //task2.display(prefix: "random2"); 
    }); 
 
    test("Update task id with try", () { 
      // no id attribute 
    }); 
 
    test("Update task id without try", () { 
      // no id attribute 
    }); 
 
    test("Update task id with success", () { 
      // no id attribute 
    }); 
 
    test("Update task non id attribute with failure", () { 
      var randomTask = coreModel.tasks.random(); 
      var afterUpdateEntity = randomTask.copy(); 
      afterUpdateEntity.title = 'wheat'; 
      expect(afterUpdateEntity.title, equals('wheat')); 
      // tasks.update can only be used if oid, code or id is set. 
      expect(() => tasks.update(randomTask, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomTask = coreModel.tasks.random(); 
      randomTask.display(prefix:"before copy: "); 
      var randomTaskCopy = randomTask.copy(); 
      randomTaskCopy.display(prefix:"after copy: "); 
      expect(randomTask, equals(randomTaskCopy)); 
      expect(randomTask.oid, equals(randomTaskCopy.oid)); 
      expect(randomTask.code, equals(randomTaskCopy.code)); 
      expect(randomTask.title, equals(randomTaskCopy.title)); 
      expect(randomTask.dueDate, equals(randomTaskCopy.dueDate)); 
      expect(randomTask.status, equals(randomTaskCopy.status)); 
      expect(randomTask.priority, equals(randomTaskCopy.priority)); 
 
    }); 
 
    test("task action undo and redo", () { 
      var taskCount = tasks.length; 
      var task = Task(tasks.concept); 
        task.title = 'enquiry'; 
      task.dueDate = new DateTime.now(); 
      task.status = 'unit'; 
      task.priority = 'test'; 
    var taskProject = coreModel.projects.random(); 
    task.project = taskProject; 
      tasks.add(task); 
    taskProject.tasks.add(task); 
      expect(tasks.length, equals(++taskCount)); 
      tasks.remove(task); 
      expect(tasks.length, equals(--taskCount)); 
 
      var action = AddCommand(session, tasks, task); 
      action.doIt(); 
      expect(tasks.length, equals(++taskCount)); 
 
      action.undo(); 
      expect(tasks.length, equals(--taskCount)); 
 
      action.redo(); 
      expect(tasks.length, equals(++taskCount)); 
    }); 
 
    test("task session undo and redo", () { 
      var taskCount = tasks.length; 
      var task = Task(tasks.concept); 
        task.title = 'accomodation'; 
      task.dueDate = new DateTime.now(); 
      task.status = 'drink'; 
      task.priority = 'interest'; 
    var taskProject = coreModel.projects.random(); 
    task.project = taskProject; 
      tasks.add(task); 
    taskProject.tasks.add(task); 
      expect(tasks.length, equals(++taskCount)); 
      tasks.remove(task); 
      expect(tasks.length, equals(--taskCount)); 
 
      var action = AddCommand(session, tasks, task); 
      action.doIt(); 
      expect(tasks.length, equals(++taskCount)); 
 
      session.past.undo(); 
      expect(tasks.length, equals(--taskCount)); 
 
      session.past.redo(); 
      expect(tasks.length, equals(++taskCount)); 
    }); 
 
    test("Task update undo and redo", () { 
      var task = coreModel.tasks.random(); 
      var action = SetAttributeCommand(session, task, "title", 'beginning'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(task.title, equals(action.before)); 
 
      session.past.redo(); 
      expect(task.title, equals(action.after)); 
    }); 
 
    test("Task action with multiple undos and redos", () { 
      var taskCount = tasks.length; 
      var task1 = coreModel.tasks.random(); 
 
      var action1 = RemoveCommand(session, tasks, task1); 
      action1.doIt(); 
      expect(tasks.length, equals(--taskCount)); 
 
      var task2 = coreModel.tasks.random(); 
 
      var action2 = RemoveCommand(session, tasks, task2); 
      action2.doIt(); 
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
 
    test("Transaction undo and redo", () { 
      var taskCount = tasks.length; 
      var task1 = coreModel.tasks.random(); 
      var task2 = coreModel.tasks.random(); 
      while (task1 == task2) { 
        task2 = coreModel.tasks.random();  
      } 
      var action1 = RemoveCommand(session, tasks, task1); 
      var action2 = RemoveCommand(session, tasks, task2); 
 
      var transaction = new Transaction("two removes on tasks", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      taskCount = taskCount - 2; 
      expect(tasks.length, equals(taskCount)); 
 
      tasks.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      taskCount = taskCount + 2; 
      expect(tasks.length, equals(taskCount)); 
 
      tasks.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      taskCount = taskCount - 2; 
      expect(tasks.length, equals(taskCount)); 
 
      tasks.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var taskCount = tasks.length; 
      var task1 = coreModel.tasks.random(); 
      var task2 = task1; 
      var action1 = RemoveCommand(session, tasks, task1); 
      var action2 = RemoveCommand(session, tasks, task2); 
 
      var transaction = Transaction( 
        "two removes on tasks, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(tasks.length, equals(taskCount)); 
 
      //tasks.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to task actions", () { 
      var taskCount = tasks.length; 
 
      var reaction = TaskReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var task = Task(tasks.concept); 
        task.title = 'accident'; 
      task.dueDate = new DateTime.now(); 
      task.status = 'web'; 
      task.priority = 'lake'; 
    var taskProject = coreModel.projects.random(); 
    task.project = taskProject; 
      tasks.add(task); 
    taskProject.tasks.add(task); 
      expect(tasks.length, equals(++taskCount)); 
      tasks.remove(task); 
      expect(tasks.length, equals(--taskCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, tasks, task); 
      addCommand.doIt(); 
      expect(tasks.length, equals(++taskCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, task, "title", 'parfem'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class TaskReaction implements ICommandReaction { 
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
  var repository = ProjectCoreRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  CoreModel coreModel = projectDomain.getModelEntries("Core") as CoreModel;  
  assert(coreModel != null); 
  var tasks = coreModel.tasks; 
  testProjectCoreTasks(projectDomain, coreModel, tasks); 
} 
 
