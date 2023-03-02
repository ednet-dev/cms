 
// test/ednetcore/tasks/ednetcore_tasks_project_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:ednetcore_tasks/ednetcore_tasks.dart"; 
 
void testEdnetcoreTasksProjects( 
    EdnetcoreDomain ednetcoreDomain, TasksModel tasksModel, Projects projects) { 
  DomainSession session; 
  group("Testing Ednetcore.Tasks.Project", () { 
    session = ednetcoreDomain.newSession();  
    setUp(() { 
      tasksModel.init(); 
    }); 
    tearDown(() { 
      tasksModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(tasksModel.isEmpty, isFalse); 
      expect(projects.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      tasksModel.clear(); 
      expect(tasksModel.isEmpty, isTrue); 
      expect(projects.isEmpty, isTrue); 
      expect(projects.exceptions..isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = tasksModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //tasksModel.displayJson(); 
      //tasksModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = tasksModel.toJson(); 
      tasksModel.clear(); 
      expect(tasksModel.isEmpty, isTrue); 
      tasksModel.fromJson(json); 
      expect(tasksModel.isEmpty, isFalse); 
 
      tasksModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = tasksModel.fromEntryToJson("Project"); 
      expect(json, isNotNull); 
 
      print(json); 
      //tasksModel.displayEntryJson("Project"); 
      //tasksModel.displayJson(); 
      //tasksModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = tasksModel.fromEntryToJson("Project"); 
      projects.clear(); 
      expect(projects.isEmpty, isTrue); 
      tasksModel.fromJsonToEntry(json); 
      expect(projects.isEmpty, isFalse); 
 
      projects.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add project required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add project unique error", () { 
      var projectConcept = projects.concept; 
      var projectCount = projects.length; 
      var project = Project(projectConcept); 
      var randomProject = projects.random(); 
      project.name = randomProject.name; 
      var added = projects.add(project); 
      expect(added, isFalse); 
      expect(projects.length, equals(projectCount)); 
      expect(projects.exceptions..length, greaterThan(0)); 
 
      projects.exceptions..display(title: "Add project unique error"); 
    }); 
 
    test("Not found project by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var project = projects.singleWhereOid(ednetOid); 
      expect(project, isNull); 
    }); 
 
    test("Find project by oid", () { 
      var randomProject = projects.random(); 
      var project = projects.singleWhereOid(randomProject.oid); 
      expect(project, isNotNull); 
      expect(project, equals(randomProject)); 
    }); 
 
    test("Find project by attribute id", () { 
      var randomProject = projects.random(); 
      var project = 
          projects.singleWhereAttributeId("name", randomProject.name); 
      expect(project, isNotNull); 
      expect(project.name, equals(randomProject.name)); 
    }); 
 
    test("Find project by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find project by attribute", () { 
      var randomProject = projects.random(); 
      var project = 
          projects.firstWhereAttribute("description", randomProject.description); 
      expect(project, isNotNull); 
      expect(project.description, equals(randomProject.description)); 
    }); 
 
    test("Select projects by attribute", () { 
      var randomProject = projects.random(); 
      var selectedProjects = 
          projects.selectWhereAttribute("description", randomProject.description); 
      expect(selectedProjects.isEmpty, isFalse); 
      selectedProjects.forEach((se) => 
          expect(se.description, equals(randomProject.description))); 
 
      //selectedProjects.display(title: "Select projects by description"); 
    }); 
 
    test("Select projects by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select projects by attribute, then add", () { 
      var randomProject = projects.random(); 
      var selectedProjects = 
          projects.selectWhereAttribute("description", randomProject.description); 
      expect(selectedProjects.isEmpty, isFalse); 
      expect(selectedProjects.source?.isEmpty, isFalse); 
      var projectsCount = projects.length; 
 
      var project = Project(projects.concept); 
      project.name = 'baby'; 
      project.description = 'observation'; 
      var added = selectedProjects.add(project); 
      expect(added, isTrue); 
      expect(projects.length, equals(++projectsCount)); 
 
      //selectedProjects.display(title: 
      //  "Select projects by attribute, then add"); 
      //projects.display(title: "All projects"); 
    }); 
 
    test("Select projects by attribute, then remove", () { 
      var randomProject = projects.random(); 
      var selectedProjects = 
          projects.selectWhereAttribute("description", randomProject.description); 
      expect(selectedProjects.isEmpty, isFalse); 
      expect(selectedProjects.source?.isEmpty, isFalse); 
      var projectsCount = projects.length; 
 
      var removed = selectedProjects.remove(randomProject); 
      expect(removed, isTrue); 
      expect(projects.length, equals(--projectsCount)); 
 
      randomProject.display(prefix: "removed"); 
      //selectedProjects.display(title: 
      //  "Select projects by attribute, then remove"); 
      //projects.display(title: "All projects"); 
    }); 
 
    test("Sort projects", () { 
      projects.sort(); 
 
      //projects.display(title: "Sort projects"); 
    }); 
 
    test("Order projects", () { 
      var orderedProjects = projects.order(); 
      expect(orderedProjects.isEmpty, isFalse); 
      expect(orderedProjects.length, equals(projects.length)); 
      expect(orderedProjects.source?.isEmpty, isFalse); 
      expect(orderedProjects.source?.length, equals(projects.length)); 
      expect(orderedProjects, isNot(same(projects))); 
 
      //orderedProjects.display(title: "Order projects"); 
    }); 
 
    test("Copy projects", () { 
      var copiedProjects = projects.copy(); 
      expect(copiedProjects.isEmpty, isFalse); 
      expect(copiedProjects.length, equals(projects.length)); 
      expect(copiedProjects, isNot(same(projects))); 
      copiedProjects.forEach((e) => 
        expect(e, equals(projects.singleWhereOid(e.oid)))); 
      copiedProjects.forEach((e) => 
        expect(e, isNot(same(projects.singleWhereId(e.id as IId<Project>))))); 
 
      //copiedProjects.display(title: "Copy projects"); 
    }); 
 
    test("True for every project", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random project", () { 
      var project1 = projects.random(); 
      expect(project1, isNotNull); 
      var project2 = projects.random(); 
      expect(project2, isNotNull); 
 
      //project1.display(prefix: "random1"); 
      //project2.display(prefix: "random2"); 
    }); 
 
    test("Update project id with try", () { 
      var randomProject = projects.random(); 
      var beforeUpdate = randomProject.name; 
      try { 
        randomProject.name = 'ocean'; 
      } on UpdateException catch (e) { 
        expect(randomProject.name, equals(beforeUpdate)); 
      } 
    }); 
 
    test("Update project id without try", () { 
      var randomProject = projects.random(); 
      var beforeUpdateValue = randomProject.name; 
      expect(() => randomProject.name = 'drink', throws); 
      expect(randomProject.name, equals(beforeUpdateValue)); 
    }); 
 
    test("Update project id with success", () { 
      var randomProject = projects.random(); 
      var afterUpdateEntity = randomProject.copy(); 
      var attribute = randomProject.concept.attributes.singleWhereCode("name"); 
      expect(attribute?.update, isFalse); 
      attribute?.update = true; 
      afterUpdateEntity.name = 'selfdo'; 
      expect(afterUpdateEntity.name, equals('selfdo')); 
      attribute?.update = false; 
      var updated = projects.update(randomProject, afterUpdateEntity); 
      expect(updated, isTrue); 
 
      var entity = projects.singleWhereAttributeId("name", 'selfdo'); 
      expect(entity, isNotNull); 
      expect(entity.name, equals('selfdo')); 
 
      //projects.display("After update project id"); 
    }); 
 
    test("Update project non id attribute with failure", () { 
      var randomProject = projects.random(); 
      var afterUpdateEntity = randomProject.copy(); 
      afterUpdateEntity.description = 'call'; 
      expect(afterUpdateEntity.description, equals('call')); 
      // projects.update can only be used if oid, code or id is set. 
      expect(() => projects.update(randomProject, afterUpdateEntity), throws); 
    }); 
 
    test("Copy Equality", () { 
      var randomProject = projects.random(); 
      randomProject.display(prefix:"before copy: "); 
      var randomProjectCopy = randomProject.copy(); 
      randomProjectCopy.display(prefix:"after copy: "); 
      expect(randomProject, equals(randomProjectCopy)); 
      expect(randomProject.oid, equals(randomProjectCopy.oid)); 
      expect(randomProject.code, equals(randomProjectCopy.code)); 
      expect(randomProject.name, equals(randomProjectCopy.name)); 
      expect(randomProject.description, equals(randomProjectCopy.description)); 
 
      expect(randomProject.id, isNotNull); 
      expect(randomProjectCopy.id, isNotNull); 
      expect(randomProject.id, equals(randomProjectCopy.id)); 
 
      var idsEqual = false; 
      if (randomProject.id == randomProjectCopy.id) { 
        idsEqual = true; 
      } 
      expect(idsEqual, isTrue); 
 
      idsEqual = false; 
      if (randomProject.id!.equals(randomProjectCopy.id!)) { 
        idsEqual = true; 
      } 
      expect(idsEqual, isTrue); 
    }); 
 
    test("project action undo and redo", () { 
      var projectCount = projects.length; 
      var project = Project(projects.concept); 
        project.name = 'down'; 
      project.description = 'accident'; 
      projects.add(project); 
      expect(projects.length, equals(++projectCount)); 
      projects.remove(project); 
      expect(projects.length, equals(--projectCount)); 
 
      var action = AddCommand(session, projects, project); 
      action.doIt(); 
      expect(projects.length, equals(++projectCount)); 
 
      action.undo(); 
      expect(projects.length, equals(--projectCount)); 
 
      action.redo(); 
      expect(projects.length, equals(++projectCount)); 
    }); 
 
    test("project session undo and redo", () { 
      var projectCount = projects.length; 
      var project = Project(projects.concept); 
        project.name = 'test'; 
      project.description = 'craving'; 
      projects.add(project); 
      expect(projects.length, equals(++projectCount)); 
      projects.remove(project); 
      expect(projects.length, equals(--projectCount)); 
 
      var action = AddCommand(session, projects, project); 
      action.doIt(); 
      expect(projects.length, equals(++projectCount)); 
 
      session.past.undo(); 
      expect(projects.length, equals(--projectCount)); 
 
      session.past.redo(); 
      expect(projects.length, equals(++projectCount)); 
    }); 
 
    test("Project update undo and redo", () { 
      var project = projects.random(); 
      var action = SetAttributeCommand(session, project, "description", 'family'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(project.description, equals(action.before)); 
 
      session.past.redo(); 
      expect(project.description, equals(action.after)); 
    }); 
 
    test("Project action with multiple undos and redos", () { 
      var projectCount = projects.length; 
      var project1 = projects.random(); 
 
      var action1 = RemoveCommand(session, projects, project1); 
      action1.doIt(); 
      expect(projects.length, equals(--projectCount)); 
 
      var project2 = projects.random(); 
 
      var action2 = RemoveCommand(session, projects, project2); 
      action2.doIt(); 
      expect(projects.length, equals(--projectCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(projects.length, equals(++projectCount)); 
 
      session.past.undo(); 
      expect(projects.length, equals(++projectCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(projects.length, equals(--projectCount)); 
 
      session.past.redo(); 
      expect(projects.length, equals(--projectCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var projectCount = projects.length; 
      var project1 = projects.random(); 
      var project2 = projects.random(); 
      while (project1 == project2) { 
        project2 = projects.random();  
      } 
      var action1 = RemoveCommand(session, projects, project1); 
      var action2 = RemoveCommand(session, projects, project2); 
 
      var transaction = new Transaction("two removes on projects", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      projectCount = projectCount - 2; 
      expect(projects.length, equals(projectCount)); 
 
      projects.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      projectCount = projectCount + 2; 
      expect(projects.length, equals(projectCount)); 
 
      projects.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      projectCount = projectCount - 2; 
      expect(projects.length, equals(projectCount)); 
 
      projects.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var projectCount = projects.length; 
      var project1 = projects.random(); 
      var project2 = project1; 
      var action1 = RemoveCommand(session, projects, project1); 
      var action2 = RemoveCommand(session, projects, project2); 
 
      var transaction = Transaction( 
        "two removes on projects, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(projects.length, equals(projectCount)); 
 
      //projects.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to project actions", () { 
      var projectCount = projects.length; 
 
      var reaction = ProjectReaction(); 
      expect(reaction, isNotNull); 
 
      ednetcoreDomain.startCommandReaction(reaction); 
      var project = Project(projects.concept); 
        project.name = 'lunch'; 
      project.description = 'salary'; 
      projects.add(project); 
      expect(projects.length, equals(++projectCount)); 
      projects.remove(project); 
      expect(projects.length, equals(--projectCount)); 
 
      var session = ednetcoreDomain.newSession(); 
      var addCommand = AddCommand(session, projects, project); 
      addCommand.doIt(); 
      expect(projects.length, equals(++projectCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, project, "description", 'small'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      ednetcoreDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ProjectReaction implements ICommandReaction { 
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
  var repository = Repository(); 
  EdnetcoreDomain ednetcoreDomain = repository.getDomainModels("Ednetcore") as EdnetcoreDomain;   
  assert(ednetcoreDomain != null); 
  TasksModel tasksModel = ednetcoreDomain.getModelEntries("Tasks") as TasksModel;  
  assert(tasksModel != null); 
  var projects = tasksModel.projects; 
  testEdnetcoreTasksProjects(ednetcoreDomain, tasksModel, projects); 
} 
 
