 
// test/project/core/project_core_project_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreProjects( 
    ProjectDomain projectDomain, CoreModel coreModel, Projects projects) { 
  DomainSession session; 
  group('Testing Project.Core.Project', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(projects.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(projects.isEmpty, isTrue); 
      expect(projects.exceptions.isEmpty, isTrue); 
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
      final json = coreModel.fromEntryToJson('Project'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Project'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Project'); 
      projects.clear(); 
      expect(projects.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
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
      final randomProject = coreModel.projects.random(); 
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
      final randomProject = coreModel.projects.random(); 
      final project = 
          projects.firstWhereAttribute('name', randomProject.name); 
      expect(project, isNotNull); 
      expect(project.name, equals(randomProject.name)); 
    }); 
 
    test('Select projects by attribute', () { 
      final randomProject = coreModel.projects.random(); 
      final selectedProjects = 
          projects.selectWhereAttribute('name', randomProject.name); 
      expect(selectedProjects.isEmpty, isFalse); 
      for (final se in selectedProjects) {        expect(se.name, equals(randomProject.name));      } 
      //selectedProjects.display(title: 'Select projects by name'); 
    }); 
 
    test('Select projects by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select projects by attribute, then add', () { 
      final randomProject = coreModel.projects.random(); 
      final selectedProjects = 
          projects.selectWhereAttribute('name', randomProject.name); 
      expect(selectedProjects.isEmpty, isFalse); 
      expect(selectedProjects.source?.isEmpty, isFalse); 
      var projectsCount = projects.length; 
 
      final project = Project(projects.concept) 

      ..name = 'training'
      ..description = 'unit'
      ..startDate = new DateTime.now()
      ..endDate = new DateTime.now()
      ..budget = 81.43447596472821;      final added = selectedProjects.add(project); 
      expect(added, isTrue); 
      expect(projects.length, equals(++projectsCount)); 
 
      //selectedProjects.display(title: 
      //  'Select projects by attribute, then add'); 
      //projects.display(title: 'All projects'); 
    }); 
 
    test('Select projects by attribute, then remove', () { 
      final randomProject = coreModel.projects.random(); 
      final selectedProjects = 
          projects.selectWhereAttribute('name', randomProject.name); 
      expect(selectedProjects.isEmpty, isFalse); 
      expect(selectedProjects.source?.isEmpty, isFalse); 
      var projectsCount = projects.length; 
 
      final removed = selectedProjects.remove(randomProject); 
      expect(removed, isTrue); 
      expect(projects.length, equals(--projectsCount)); 
 
      randomProject.display(prefix: 'removed'); 
      //selectedProjects.display(title: 
      //  'Select projects by attribute, then remove'); 
      //projects.display(title: 'All projects'); 
    }); 
 
    test('Sort projects', () { 
      // no id attribute 
      // add compareTo method in the specific Project class 
      /* 
      projects.sort(); 
 
      //projects.display(title: 'Sort projects'); 
      */ 
    }); 
 
    test('Order projects', () { 
      // no id attribute 
      // add compareTo method in the specific Project class 
      /* 
      final orderedProjects = projects.order(); 
      expect(orderedProjects.isEmpty, isFalse); 
      expect(orderedProjects.length, equals(projects.length)); 
      expect(orderedProjects.source?.isEmpty, isFalse); 
      expect(orderedProjects.source?.length, equals(projects.length)); 
      expect(orderedProjects, isNot(same(projects))); 
 
      //orderedProjects.display(title: 'Order projects'); 
      */ 
    }); 
 
    test('Copy projects', () { 
      final copiedProjects = projects.copy(); 
      expect(copiedProjects.isEmpty, isFalse); 
      expect(copiedProjects.length, equals(projects.length)); 
      expect(copiedProjects, isNot(same(projects))); 
      for (final e in copiedProjects) {        expect(e, equals(projects.singleWhereOid(e.oid)));      } 
 
      //copiedProjects.display(title: "Copy projects"); 
    }); 
 
    test('True for every project', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random project', () { 
      final project1 = coreModel.projects.random(); 
      expect(project1, isNotNull); 
      final project2 = coreModel.projects.random(); 
      expect(project2, isNotNull); 
 
      //project1.display(prefix: 'random1'); 
      //project2.display(prefix: 'random2'); 
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
      final randomProject = coreModel.projects.random(); 
      final afterUpdateEntity = randomProject.copy()..name = 'teacher'; 
      expect(afterUpdateEntity.name, equals('teacher')); 
      // projects.update can only be used if oid, code or id is set. 
      expect(() => projects.update(randomProject, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomProject = coreModel.projects.random()..display(prefix:'before copy: '); 
      final randomProjectCopy = randomProject.copy()..display(prefix:'after copy: '); 
      expect(randomProject, equals(randomProjectCopy)); 
      expect(randomProject.oid, equals(randomProjectCopy.oid)); 
      expect(randomProject.code, equals(randomProjectCopy.code)); 
      expect(randomProject.name, equals(randomProjectCopy.name)); 
      expect(randomProject.description, equals(randomProjectCopy.description)); 
      expect(randomProject.startDate, equals(randomProjectCopy.startDate)); 
      expect(randomProject.endDate, equals(randomProjectCopy.endDate)); 
      expect(randomProject.budget, equals(randomProjectCopy.budget)); 
 
    }); 
 
    test('project action undo and redo', () { 
      var projectCount = projects.length; 
      final project = Project(projects.concept) 
  
      ..name = 'winter'
      ..description = 'candy'
      ..startDate = new DateTime.now()
      ..endDate = new DateTime.now()
      ..budget = 37.721406745057074;      projects.add(project); 
      expect(projects.length, equals(++projectCount)); 
      projects.remove(project); 
      expect(projects.length, equals(--projectCount)); 
 
      final action = AddCommand(session, projects, project)..doIt(); 
      expect(projects.length, equals(++projectCount)); 
 
      action.undo(); 
      expect(projects.length, equals(--projectCount)); 
 
      action.redo(); 
      expect(projects.length, equals(++projectCount)); 
    }); 
 
    test('project session undo and redo', () { 
      var projectCount = projects.length; 
      final project = Project(projects.concept) 
  
      ..name = 'hospital'
      ..description = 'mile'
      ..startDate = new DateTime.now()
      ..endDate = new DateTime.now()
      ..budget = 29.389185739259016;      projects.add(project); 
      expect(projects.length, equals(++projectCount)); 
      projects.remove(project); 
      expect(projects.length, equals(--projectCount)); 
 
      AddCommand(session, projects, project).doIt();; 
      expect(projects.length, equals(++projectCount)); 
 
      session.past.undo(); 
      expect(projects.length, equals(--projectCount)); 
 
      session.past.redo(); 
      expect(projects.length, equals(++projectCount)); 
    }); 
 
    test('Project update undo and redo', () { 
      final project = coreModel.projects.random(); 
      final action = SetAttributeCommand(session, project, 'name', 'objective')..doIt(); 
 
      session.past.undo(); 
      expect(project.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(project.name, equals(action.after)); 
    }); 
 
    test('Project action with multiple undos and redos', () { 
      var projectCount = projects.length; 
      final project1 = coreModel.projects.random(); 
 
      RemoveCommand(session, projects, project1).doIt(); 
      expect(projects.length, equals(--projectCount)); 
 
      final project2 = coreModel.projects.random(); 
 
      RemoveCommand(session, projects, project2).doIt(); 
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
      final project1 = coreModel.projects.random(); 
      var project2 = coreModel.projects.random(); 
      while (project1 == project2) { 
        project2 = coreModel.projects.random();  
      } 
      final action1 = RemoveCommand(session, projects, project1); 
      final action2 = RemoveCommand(session, projects, project2); 
 
      Transaction('two removes on projects', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      projectCount = projectCount - 2; 
      expect(projects.length, equals(projectCount)); 
 
      projects.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      projectCount = projectCount + 2; 
      expect(projects.length, equals(projectCount)); 
 
      projects.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      projectCount = projectCount - 2; 
      expect(projects.length, equals(projectCount)); 
 
      projects.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final projectCount = projects.length; 
      final project1 = coreModel.projects.random(); 
      final project2 = project1; 
      final action1 = RemoveCommand(session, projects, project1); 
      final action2 = RemoveCommand(session, projects, project2); 
 
      final transaction = Transaction( 
        'two removes on projects, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(projects.length, equals(projectCount)); 
 
      //projects.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to project actions', () { 
      var projectCount = projects.length; 
 
      final reaction = ProjectReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final project = Project(projects.concept) 
  
      ..name = 'advisor'
      ..description = 'accomodation'
      ..startDate = new DateTime.now()
      ..endDate = new DateTime.now()
      ..budget = 26.57667040113144;      projects.add(project); 
      expect(projects.length, equals(++projectCount)); 
      projects.remove(project); 
      expect(projects.length, equals(--projectCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, projects, project).doIt(); 
      expect(projects.length, equals(++projectCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        project,
        'name',
        'element',
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ProjectReaction implements ICommandReaction { 
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
  final projects = coreModel!.projects; 
  testProjectCoreProjects(projectDomain, coreModel, projects); 
} 
 
