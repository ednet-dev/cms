 
// test/ednet/one/ednet_one_project_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:ednet_one/ednet_one.dart"; 
 
void testEdnetOneProjects( 
    EdnetDomain ednetDomain, OneModel oneModel, Projects projects) { 
  DomainSession session; 
  group("Testing Ednet.One.Project", () { 
    session = ednetDomain.newSession();  
    setUp(() { 
      oneModel.init(); 
    }); 
    tearDown(() { 
      oneModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(oneModel.isEmpty, isFalse); 
      expect(projects.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      oneModel.clear(); 
      expect(oneModel.isEmpty, isTrue); 
      expect(projects.isEmpty, isTrue); 
      expect(projects.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = oneModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //oneModel.displayJson(); 
      //oneModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = oneModel.toJson(); 
      oneModel.clear(); 
      expect(oneModel.isEmpty, isTrue); 
      oneModel.fromJson(json); 
      expect(oneModel.isEmpty, isFalse); 
 
      oneModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = oneModel.fromEntryToJson("Project"); 
      expect(json, isNotNull); 
 
      print(json); 
      //oneModel.displayEntryJson("Project"); 
      //oneModel.displayJson(); 
      //oneModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = oneModel.fromEntryToJson("Project"); 
      projects.clear(); 
      expect(projects.isEmpty, isTrue); 
      oneModel.fromJsonToEntry(json); 
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
      var randomProject = oneModel.projects.random(); 
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
      // no attribute that is not required 
    }); 
 
    test("Select projects by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select projects by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select projects by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select projects by attribute, then remove", () { 
      // no attribute that is not id 
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
      var project1 = oneModel.projects.random(); 
      expect(project1, isNotNull); 
      var project2 = oneModel.projects.random(); 
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
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomProject = oneModel.projects.random(); 
      randomProject.display(prefix:"before copy: "); 
      var randomProjectCopy = randomProject.copy(); 
      randomProjectCopy.display(prefix:"after copy: "); 
      expect(randomProject, equals(randomProjectCopy)); 
      expect(randomProject.oid, equals(randomProjectCopy.oid)); 
      expect(randomProject.code, equals(randomProjectCopy.code)); 
 
    }); 
 
    test("project action undo and redo", () { 
      var projectCount = projects.length; 
      var project = Project(projects.concept); 
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
      // no attribute that is not id 
    }); 
 
    test("Project action with multiple undos and redos", () { 
      var projectCount = projects.length; 
      var project1 = oneModel.projects.random(); 
 
      var action1 = RemoveCommand(session, projects, project1); 
      action1.doIt(); 
      expect(projects.length, equals(--projectCount)); 
 
      var project2 = oneModel.projects.random(); 
 
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
      var project1 = oneModel.projects.random(); 
      var project2 = oneModel.projects.random(); 
      while (project1 == project2) { 
        project2 = oneModel.projects.random();  
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
      var project1 = oneModel.projects.random(); 
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
 
      ednetDomain.startCommandReaction(reaction); 
      var project = Project(projects.concept); 
        projects.add(project); 
      expect(projects.length, equals(++projectCount)); 
      projects.remove(project); 
      expect(projects.length, equals(--projectCount)); 
 
      var session = ednetDomain.newSession(); 
      var addCommand = AddCommand(session, projects, project); 
      addCommand.doIt(); 
      expect(projects.length, equals(++projectCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
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
  EdnetDomain ednetDomain = repository.getDomainModels("Ednet") as EdnetDomain;   
  assert(ednetDomain != null); 
  OneModel oneModel = ednetDomain.getModelEntries("One") as OneModel;  
  assert(oneModel != null); 
  var projects = oneModel.projects; 
  testEdnetOneProjects(ednetDomain, oneModel, projects); 
} 
 
