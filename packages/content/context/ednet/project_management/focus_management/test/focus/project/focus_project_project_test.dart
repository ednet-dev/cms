// test/focus/project/focus_project_project_test.dart

import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:focus_project/focus_project.dart';

void testFocusProjectProjects(
    FocusDomain focusDomain, ProjectModel projectModel, Projects projects) {
  DomainSession session;
  group('Testing Focus.Project.Project', () {
    session = focusDomain.newSession();
    setUp(() {
      projectModel.init();
    });
    tearDown(() {
      projectModel.clear();
    });

    test('Not empty model', () {
      expect(projectModel.isEmpty, isFalse);
      expect(projects.isEmpty, isFalse);
    });

    test('Empty model', () {
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      expect(projects.isEmpty, isTrue);
      expect(projects.exceptions.isEmpty, isTrue);
    });

    test('From model to JSON', () {
      final json = projectModel.toJson();
      expect(json, isNotNull);

      print(json);
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model', () {
      final json = projectModel.toJson();
      projectModel.clear();
      expect(projectModel.isEmpty, isTrue);
      projectModel.fromJson(json);
      expect(projectModel.isEmpty, isFalse);

      projectModel.display();
    });

    test('From model entry to JSON', () {
      final json = projectModel.fromEntryToJson('Project');
      expect(json, isNotNull);

      print(json);
      //projectModel.displayEntryJson("Project");
      //projectModel.displayJson();
      //projectModel.display();
    });

    test('From JSON to model entry', () {
      final json = projectModel.fromEntryToJson('Project');
      projects.clear();
      expect(projects.isEmpty, isTrue);
      projectModel.fromJsonToEntry(json);
      expect(projects.isEmpty, isFalse);

      projects.display(title: 'From JSON to model entry');
    });

    test('Add project required error', () {
      // no required attribute that is not id
    });

    test('Add project unique error', () {
      // no id attribute
    });

    test('Not found project by oid', () {
      final ednetOid = Oid.ts(1345648254063);
      final project = projects.singleWhereOid(ednetOid);
      expect(project, isNull);
    });

    test('Find project by oid', () {
      final randomProject = projectModel.projects.random();
      final project = projects.singleWhereOid(randomProject.oid);
      expect(project, isNotNull);
      expect(project, equals(randomProject));
    });

    test('Find project by attribute id', () {
      // no id attribute
    });

    test('Find project by required attribute', () {
      // no required attribute that is not id
    });

    test('Find project by attribute', () {
      // no attribute that is not required
    });

    test('Select projects by attribute', () {
      // no attribute that is not required
    });

    test('Select projects by required attribute', () {
      // no required attribute that is not id
    });

    test('Select projects by attribute, then add', () {
      // no attribute that is not id
    });

    test('Select projects by attribute, then remove', () {
      // no attribute that is not id
    });

    test('Sort projects', () {
      // no id attribute
      // add compareTo method in the specific Project class
      /* 
      projects.sort(); 
 
      //projects.display(title: "Sort projects"); 
      */
    });

    test('Order projects', () {
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

    test('Copy projects', () {
      final copiedProjects = projects.copy();
      expect(copiedProjects.isEmpty, isFalse);
      expect(copiedProjects.length, equals(projects.length));
      expect(copiedProjects, isNot(same(projects)));
      copiedProjects
          .forEach((e) => expect(e, equals(projects.singleWhereOid(e.oid))));

      //copiedProjects.display(title: "Copy projects");
    });

    test('True for every project', () {
      // no required attribute that is not id
    });

    test('Random project', () {
      final project1 = projectModel.projects.random();
      expect(project1, isNotNull);
      final project2 = projectModel.projects.random();
      expect(project2, isNotNull);

      //project1.display(prefix: "random1");
      //project2.display(prefix: "random2");
    });

    test('Update project id with try', () {
      // no id attribute
    });

    test('Update project id without try', () {
      // no id attribute
    });

    test('Update project id with success', () {
      // no id attribute
    });

    test('Update project non id attribute with failure', () {
      // no attribute that is not id
    });

    test('Copy Equality', () {
      final randomProject = projectModel.projects.random();
      randomProject.display(prefix: 'before copy: ');
      final randomProjectCopy = randomProject.copy();
      randomProjectCopy.display(prefix: 'after copy: ');
      expect(randomProject, equals(randomProjectCopy));
      expect(randomProject.oid, equals(randomProjectCopy.oid));
      expect(randomProject.code, equals(randomProjectCopy.code));
    });

    test('project action undo and redo', () {
      var projectCount = projects.length;
      final project = Project(projects.concept);
      projects.add(project);
      expect(projects.length, equals(++projectCount));
      projects.remove(project);
      expect(projects.length, equals(--projectCount));

      final action = AddCommand(session, projects, project);
      action.doIt();
      expect(projects.length, equals(++projectCount));

      action.undo();
      expect(projects.length, equals(--projectCount));

      action.redo();
      expect(projects.length, equals(++projectCount));
    });

    test('project session undo and redo', () {
      var projectCount = projects.length;
      final project = Project(projects.concept);
      projects.add(project);
      expect(projects.length, equals(++projectCount));
      projects.remove(project);
      expect(projects.length, equals(--projectCount));

      final action = AddCommand(session, projects, project);
      action.doIt();
      expect(projects.length, equals(++projectCount));

      session.past.undo();
      expect(projects.length, equals(--projectCount));

      session.past.redo();
      expect(projects.length, equals(++projectCount));
    });

    test('Project update undo and redo', () {
      // no attribute that is not id
    });

    test('Project action with multiple undos and redos', () {
      var projectCount = projects.length;
      final project1 = projectModel.projects.random();

      final action1 = RemoveCommand(session, projects, project1);
      action1.doIt();
      expect(projects.length, equals(--projectCount));

      final project2 = projectModel.projects.random();

      final action2 = RemoveCommand(session, projects, project2);
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

    test('Transaction undo and redo', () {
      var projectCount = projects.length;
      final project1 = projectModel.projects.random();
      var project2 = projectModel.projects.random();
      while (project1 == project2) {
        project2 = projectModel.projects.random();
      }
      final action1 = RemoveCommand(session, projects, project1);
      final action2 = RemoveCommand(session, projects, project2);

      final transaction = Transaction('two removes on projects', session);
      transaction.add(action1);
      transaction.add(action2);
      transaction.doIt();
      projectCount = projectCount - 2;
      expect(projects.length, equals(projectCount));

      projects.display(title: 'Transaction Done');

      session.past.undo();
      projectCount = projectCount + 2;
      expect(projects.length, equals(projectCount));

      projects.display(title: 'Transaction Undone');

      session.past.redo();
      projectCount = projectCount - 2;
      expect(projects.length, equals(projectCount));

      projects.display(title: 'Transaction Redone');
    });

    test('Transaction with one action error', () {
      final projectCount = projects.length;
      final project1 = projectModel.projects.random();
      final project2 = project1;
      final action1 = RemoveCommand(session, projects, project1);
      final action2 = RemoveCommand(session, projects, project2);

      final transaction = Transaction(
          'two removes on projects, with an error on the second', session);
      transaction.add(action1);
      transaction.add(action2);
      final done = transaction.doIt();
      expect(done, isFalse);
      expect(projects.length, equals(projectCount));

      //projects.display(title:"Transaction with an error");
    });

    test('Reactions to project actions', () {
      var projectCount = projects.length;

      final reaction = ProjectReaction();
      expect(reaction, isNotNull);

      focusDomain.startCommandReaction(reaction);
      final project = Project(projects.concept);
      projects.add(project);
      expect(projects.length, equals(++projectCount));
      projects.remove(project);
      expect(projects.length, equals(--projectCount));

      final session = focusDomain.newSession();
      final addCommand = AddCommand(session, projects, project);
      addCommand.doIt();
      expect(projects.length, equals(++projectCount));
      expect(reaction.reactedOnAdd, isTrue);

      // no attribute that is not id
    });
  });
}

class ProjectReaction implements ICommandReaction {
  bool reactedOnAdd = false;
  bool reactedOnUpdate = false;

  @override
  void react(ICommand action) {
    if (action is IEntitiesCommand) {
      reactedOnAdd = true;
    } else if (action is IEntityCommand) {
      reactedOnUpdate = true;
    }
  }
}

void main() {
  final repository = Repository();
  final focusDomain = repository.getDomainModels('Focus') as FocusDomain;
  final projectModel =
      focusDomain.getModelEntries('Project') as ProjectModel;
  final projects = projectModel.projects;
  testFocusProjectProjects(focusDomain, projectModel, projects);
}
