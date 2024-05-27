 
// test/household/project/household_project_task_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_project/household_project.dart"; 
 
void testHouseholdProjectTasks( 
    HouseholdDomain householdDomain, ProjectModel projectModel, Tasks tasks) { 
  DomainSession session; 
  group("Testing Household.Project.Task", () { 
    session = householdDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(tasks.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(tasks.isEmpty, isTrue); 
      expect(tasks.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("Task"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("Task"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("Task"); 
      tasks.clear(); 
      expect(tasks.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
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
      var randomTask = projectModel.tasks.random(); 
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
      var randomTask = projectModel.tasks.random(); 
      var task = 
          tasks.firstWhereAttribute("title", randomTask.title); 
      expect(task, isNotNull); 
      expect(task.title, equals(randomTask.title)); 
    }); 
 
    test("Select tasks by attribute", () { 
      var randomTask = projectModel.tasks.random(); 
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
      var randomTask = projectModel.tasks.random(); 
      var selectedTasks = 
          tasks.selectWhereAttribute("title", randomTask.title); 
      expect(selectedTasks.isEmpty, isFalse); 
      expect(selectedTasks.source?.isEmpty, isFalse); 
      var tasksCount = tasks.length; 
 
      var task = Task(tasks.concept); 
      task.title = 'truck'; 
      task.dueDate = new DateTime.now(); 
      task.status = 'salary'; 
      task.priority = 'corner'; 
      var added = selectedTasks.add(task); 
      expect(added, isTrue); 
      expect(tasks.length, equals(++tasksCount)); 
 
      //selectedTasks.display(title: 
      //  "Select tasks by attribute, then add"); 
      //tasks.display(title: "All tasks"); 
    }); 
 
    test("Select tasks by attribute, then remove", () { 
      var randomTask = projectModel.tasks.random(); 
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
      var task1 = projectModel.tasks.random(); 
      expect(task1, isNotNull); 
      var task2 = projectModel.tasks.random(); 
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
      var randomTask = projectModel.tasks.random(); 
      var afterUpdateEntity = randomTask.copy(); 
      afterUpdateEntity.title = 'observation'; 
      expect(afterUpdateEntity.title, equals('observation')); 
      // tasks.update can only be used if oid, code or id is set. 
      expect(() => tasks.update(randomTask, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomTask = projectModel.tasks.random(); 
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
        task.title = 'life'; 
      task.dueDate = new DateTime.now(); 
      task.status = 'grading'; 
      task.priority = 'tax'; 
    var taskProject = projectModel.projects.random(); 
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
        task.title = 'explanation'; 
      task.dueDate = new DateTime.now(); 
      task.status = 'coffee'; 
      task.priority = 'entertainment'; 
    var taskProject = projectModel.projects.random(); 
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
      var task = projectModel.tasks.random(); 
      var action = SetAttributeCommand(session, task, "title", 'guest'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(task.title, equals(action.before)); 
 
      session.past.redo(); 
      expect(task.title, equals(action.after)); 
    }); 
 
    test("Task action with multiple undos and redos", () { 
      var taskCount = tasks.length; 
      var task1 = projectModel.tasks.random(); 
 
      var action1 = RemoveCommand(session, tasks, task1); 
      action1.doIt(); 
      expect(tasks.length, equals(--taskCount)); 
 
      var task2 = projectModel.tasks.random(); 
 
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
      var task1 = projectModel.tasks.random(); 
      var task2 = projectModel.tasks.random(); 
      while (task1 == task2) { 
        task2 = projectModel.tasks.random();  
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
      var task1 = projectModel.tasks.random(); 
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
 
      householdDomain.startCommandReaction(reaction); 
      var task = Task(tasks.concept); 
        task.title = 'agile'; 
      task.dueDate = new DateTime.now(); 
      task.status = 'parfem'; 
      task.priority = 'tag'; 
    var taskProject = projectModel.projects.random(); 
    task.project = taskProject; 
      tasks.add(task); 
    taskProject.tasks.add(task); 
      expect(tasks.length, equals(++taskCount)); 
      tasks.remove(task); 
      expect(tasks.length, equals(--taskCount)); 
 
      var session = householdDomain.newSession(); 
      var addCommand = AddCommand(session, tasks, task); 
      addCommand.doIt(); 
      expect(tasks.length, equals(++taskCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, task, "title", 'cardboard'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      householdDomain.cancelCommandReaction(reaction); 
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
  var repository = HouseholdProjectRepo(); 
  HouseholdDomain householdDomain = repository.getDomainModels("Household") as HouseholdDomain;   
  assert(householdDomain != null); 
  ProjectModel projectModel = householdDomain.getModelEntries("Project") as ProjectModel;  
  assert(projectModel != null); 
  var tasks = projectModel.tasks; 
  testHouseholdProjectTasks(householdDomain, projectModel, tasks); 
} 
 
