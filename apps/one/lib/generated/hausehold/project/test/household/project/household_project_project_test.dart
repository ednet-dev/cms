 
// test/household/project/household_project_project_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:household_project/household_project.dart"; 
 
void testHouseholdProjectProjects( 
    HouseholdDomain householdDomain, ProjectModel projectModel, Projects projects) { 
  DomainSession session; 
  group("Testing Household.Project.Project", () { 
    session = householdDomain.newSession();  
    setUp(() { 
      projectModel.init(); 
    }); 
    tearDown(() { 
      projectModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(projectModel.isEmpty, isFalse); 
      expect(projects.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      projectModel.clear(); 
      expect(projectModel.isEmpty, isTrue); 
      expect(projects.isEmpty, isTrue); 
      expect(projects.exceptions.isEmpty, isTrue); 
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
      var json = projectModel.fromEntryToJson("Project"); 
      expect(json, isNotNull); 
 
      print(json); 
      //projectModel.displayEntryJson("Project"); 
      //projectModel.displayJson(); 
      //projectModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = projectModel.fromEntryToJson("Project"); 
      projects.clear(); 
      expect(projects.isEmpty, isTrue); 
      projectModel.fromJsonToEntry(json); 
      expect(projects.isEmpty, isFalse); 
 
      projects.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add project required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add project unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found project by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var project = projects.singleWhereOid(ednetOid); 
      expect(project, isNull); 
    }); 
 
    test("Find project by oid", () { 
      var randomProject = projectModel.projects.random(); 
      var project = projects.singleWhereOid(randomProject.oid); 
      expect(project, isNotNull); 
      expect(project, equals(randomProject)); 
    }); 
 
    test("Find project by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find project by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find project by attribute", () { 
      var randomProject = projectModel.projects.random(); 
      var project = 
          projects.firstWhereAttribute("name", randomProject.name); 
      expect(project, isNotNull); 
      expect(project.name, equals(randomProject.name)); 
    }); 
 
    test("Select projects by attribute", () { 
      var randomProject = projectModel.projects.random(); 
      var selectedProjects = 
          projects.selectWhereAttribute("name", randomProject.name); 
      expect(selectedProjects.isEmpty, isFalse); 
      selectedProjects.forEach((se) => 
          expect(se.name, equals(randomProject.name))); 
 
      //selectedProjects.display(title: "Select projects by name"); 
    }); 
 
    test("Select projects by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select projects by attribute, then add", () { 
      var randomProject = projectModel.projects.random(); 
      var selectedProjects = 
          projects.selectWhereAttribute("name", randomProject.name); 
      expect(selectedProjects.isEmpty, isFalse); 
      expect(selectedProjects.source?.isEmpty, isFalse); 
      var projectsCount = projects.length; 
 
      var project = Project(projects.concept); 
      project.name = 'children'; 
      var added = selectedProjects.add(project); 
      expect(added, isTrue); 
      expect(projects.length, equals(++projectsCount)); 
 
      //selectedProjects.display(title: 
      //  "Select projects by attribute, then add"); 
      //projects.display(title: "All projects"); 
    }); 
 
    test("Select projects by attribute, then remove", () { 
      var randomProject = projectModel.projects.random(); 
      var selectedProjects = 
          projects.selectWhereAttribute("name", randomProject.name); 
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
      // no id attribute 
      // add compareTo method in the specific Project class 
      /* 
      projects.sort(); 
 
      //projects.display(title: "Sort projects"); 
      */ 
    }); 
 
    test("Order projects", () { 
      // no id attribute 
      // add compareTo method in the specific Project class 
      /* 
      var orderedProjects = projects.order(); 
      expect(orderedProjects.isEmpty, isFalse); 
      expect(orderedProjects.length, equals(projects.length)); 
      expect(orderedProjects.source?.isEmpty, isFalse); 
      expect(orderedProjects.source?.length, equals(projects.length)); 
      expect(orderedProjects, isNot(same(projects))); 
 
      //orderedProjects.display(title: "Order projects"); 
      */ 
    }); 
 
    test("Copy projects", () { 
      var copiedProjects = projects.copy(); 
      expect(copiedProjects.isEmpty, isFalse); 
      expect(copiedProjects.length, equals(projects.length)); 
      expect(copiedProjects, isNot(same(projects))); 
      copiedProjects.forEach((e) => 
        expect(e, equals(projects.singleWhereOid(e.oid)))); 
 
      //copiedProjects.display(title: "Copy projects"); 
    }); 
 
    test("True for every project", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random project", () { 
      var project1 = projectModel.projects.random(); 
      expect(project1, isNotNull); 
      var project2 = projectModel.projects.random(); 
      expect(project2, isNotNull); 
 
      //project1.display(prefix: "random1"); 
      //project2.display(prefix: "random2"); 
    }); 
 
    test("Update project id with try", () { 
      // no id attribute 
    }); 
 
    test("Update project id without try", () { 
      // no id attribute 
    }); 
 
    test("Update project id with success", () { 
      // no id attribute 
    }); 
 
    test("Update project non id attribute with failure", () { 
      var randomProject = projectModel.projects.random(); 
      var afterUpdateEntity = randomProject.copy(); 
      afterUpdateEntity.name = 'employer'; 
      expect(afterUpdateEntity.name, equals('employer')); 
      // projects.update can only be used if oid, code or id is set. 
      expect(() => projects.update(randomProject, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomProject = projectModel.projects.random(); 
      randomProject.display(prefix:"before copy: "); 
      var randomProjectCopy = randomProject.copy(); 
      randomProjectCopy.display(prefix:"after copy: "); 
      expect(randomProject, equals(randomProjectCopy)); 
      expect(randomProject.oid, equals(randomProjectCopy.oid)); 
      expect(randomProject.code, equals(randomProjectCopy.code)); 
      expect(randomProject.name, equals(randomProjectCopy.name)); 
 
    }); 
 
    test("project action undo and redo", () { 
      var projectCount = projects.length; 
      var project = Project(projects.concept); 
        project.name = 'children'; 
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
        project.name = 'organization'; 
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
      var project = projectModel.projects.random(); 
      var action = SetAttributeCommand(session, project, "name", 'winter'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(project.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(project.name, equals(action.after)); 
    }); 
 
    test("Project action with multiple undos and redos", () { 
      var projectCount = projects.length; 
      var project1 = projectModel.projects.random(); 
 
      var action1 = RemoveCommand(session, projects, project1); 
      action1.doIt(); 
      expect(projects.length, equals(--projectCount)); 
 
      var project2 = projectModel.projects.random(); 
 
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
      var project1 = projectModel.projects.random(); 
      var project2 = projectModel.projects.random(); 
      while (project1 == project2) { 
        project2 = projectModel.projects.random();  
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
      var project1 = projectModel.projects.random(); 
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
 
      householdDomain.startCommandReaction(reaction); 
      var project = Project(projects.concept); 
        project.name = 'discount'; 
      projects.add(project); 
      expect(projects.length, equals(++projectCount)); 
      projects.remove(project); 
      expect(projects.length, equals(--projectCount)); 
 
      var session = householdDomain.newSession(); 
      var addCommand = AddCommand(session, projects, project); 
      addCommand.doIt(); 
      expect(projects.length, equals(++projectCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, project, "name", 'consulting'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      householdDomain.cancelCommandReaction(reaction); 
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
  var repository = HouseholdProjectRepo(); 
  HouseholdDomain householdDomain = repository.getDomainModels("Household") as HouseholdDomain;   
  assert(householdDomain != null); 
  ProjectModel projectModel = householdDomain.getModelEntries("Project") as ProjectModel;  
  assert(projectModel != null); 
  var projects = projectModel.projects; 
  testHouseholdProjectProjects(householdDomain, projectModel, projects); 
} 
 
