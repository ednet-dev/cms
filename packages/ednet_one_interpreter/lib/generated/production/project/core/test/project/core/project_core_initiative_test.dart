 
// test/project/core/project_core_initiative_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreInitiatives( 
    ProjectDomain projectDomain, CoreModel coreModel, Initiatives initiatives) { 
  DomainSession session; 
  group('Testing Project.Core.Initiative', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(initiatives.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(initiatives.isEmpty, isTrue); 
      expect(initiatives.exceptions.isEmpty, isTrue); 
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
      final json = coreModel.fromEntryToJson('Initiative'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Initiative'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Initiative'); 
      initiatives.clear(); 
      expect(initiatives.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(initiatives.isEmpty, isFalse); 
 
      initiatives.display(title: 'From JSON to model entry'); 
    }); 
 
    test('Add initiative required error', () { 
      // no required attribute that is not id 
    }); 
 
    test('Add initiative unique error', () { 
      // no id attribute 
    }); 
 
    test('Not found initiative by oid', () { 
      final ednetOid = Oid.ts(1345648254063); 
      final initiative = initiatives.singleWhereOid(ednetOid); 
      expect(initiative, isNull); 
    }); 
 
    test('Find initiative by oid', () { 
      final randomInitiative = coreModel.initiatives.random(); 
      final initiative = initiatives.singleWhereOid(randomInitiative.oid); 
      expect(initiative, isNotNull); 
      expect(initiative, equals(randomInitiative)); 
    }); 
 
    test('Find initiative by attribute id', () { 
      // no id attribute 
    }); 
 
    test('Find initiative by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Find initiative by attribute', () { 
      final randomInitiative = coreModel.initiatives.random(); 
      final initiative = 
          initiatives.firstWhereAttribute('name', randomInitiative.name); 
      expect(initiative, isNotNull); 
      expect(initiative.name, equals(randomInitiative.name)); 
    }); 
 
    test('Select initiatives by attribute', () { 
      final randomInitiative = coreModel.initiatives.random(); 
      final selectedInitiatives = 
          initiatives.selectWhereAttribute('name', randomInitiative.name); 
      expect(selectedInitiatives.isEmpty, isFalse); 
      for (final se in selectedInitiatives) {        expect(se.name, equals(randomInitiative.name));      } 
      //selectedInitiatives.display(title: 'Select initiatives by name'); 
    }); 
 
    test('Select initiatives by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select initiatives by attribute, then add', () { 
      final randomInitiative = coreModel.initiatives.random(); 
      final selectedInitiatives = 
          initiatives.selectWhereAttribute('name', randomInitiative.name); 
      expect(selectedInitiatives.isEmpty, isFalse); 
      expect(selectedInitiatives.source?.isEmpty, isFalse); 
      var initiativesCount = initiatives.length; 
 
      final initiative = Initiative(initiatives.concept) 

      ..name = 'family';      final added = selectedInitiatives.add(initiative); 
      expect(added, isTrue); 
      expect(initiatives.length, equals(++initiativesCount)); 
 
      //selectedInitiatives.display(title: 
      //  'Select initiatives by attribute, then add'); 
      //initiatives.display(title: 'All initiatives'); 
    }); 
 
    test('Select initiatives by attribute, then remove', () { 
      final randomInitiative = coreModel.initiatives.random(); 
      final selectedInitiatives = 
          initiatives.selectWhereAttribute('name', randomInitiative.name); 
      expect(selectedInitiatives.isEmpty, isFalse); 
      expect(selectedInitiatives.source?.isEmpty, isFalse); 
      var initiativesCount = initiatives.length; 
 
      final removed = selectedInitiatives.remove(randomInitiative); 
      expect(removed, isTrue); 
      expect(initiatives.length, equals(--initiativesCount)); 
 
      randomInitiative.display(prefix: 'removed'); 
      //selectedInitiatives.display(title: 
      //  'Select initiatives by attribute, then remove'); 
      //initiatives.display(title: 'All initiatives'); 
    }); 
 
    test('Sort initiatives', () { 
      // no id attribute 
      // add compareTo method in the specific Initiative class 
      /* 
      initiatives.sort(); 
 
      //initiatives.display(title: 'Sort initiatives'); 
      */ 
    }); 
 
    test('Order initiatives', () { 
      // no id attribute 
      // add compareTo method in the specific Initiative class 
      /* 
      final orderedInitiatives = initiatives.order(); 
      expect(orderedInitiatives.isEmpty, isFalse); 
      expect(orderedInitiatives.length, equals(initiatives.length)); 
      expect(orderedInitiatives.source?.isEmpty, isFalse); 
      expect(orderedInitiatives.source?.length, equals(initiatives.length)); 
      expect(orderedInitiatives, isNot(same(initiatives))); 
 
      //orderedInitiatives.display(title: 'Order initiatives'); 
      */ 
    }); 
 
    test('Copy initiatives', () { 
      final copiedInitiatives = initiatives.copy(); 
      expect(copiedInitiatives.isEmpty, isFalse); 
      expect(copiedInitiatives.length, equals(initiatives.length)); 
      expect(copiedInitiatives, isNot(same(initiatives))); 
      for (final e in copiedInitiatives) {        expect(e, equals(initiatives.singleWhereOid(e.oid)));      } 
 
      //copiedInitiatives.display(title: "Copy initiatives"); 
    }); 
 
    test('True for every initiative', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random initiative', () { 
      final initiative1 = coreModel.initiatives.random(); 
      expect(initiative1, isNotNull); 
      final initiative2 = coreModel.initiatives.random(); 
      expect(initiative2, isNotNull); 
 
      //initiative1.display(prefix: 'random1'); 
      //initiative2.display(prefix: 'random2'); 
    }); 
 
    test('Update initiative id with try', () { 
      // no id attribute 
    }); 
 
    test('Update initiative id without try', () { 
      // no id attribute 
    }); 
 
    test('Update initiative id with success', () { 
      // no id attribute 
    }); 
 
    test('Update initiative non id attribute with failure', () { 
      final randomInitiative = coreModel.initiatives.random(); 
      final afterUpdateEntity = randomInitiative.copy()..name = 'celebration'; 
      expect(afterUpdateEntity.name, equals('celebration')); 
      // initiatives.update can only be used if oid, code or id is set. 
      expect(() => initiatives.update(randomInitiative, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomInitiative = coreModel.initiatives.random()..display(prefix:'before copy: '); 
      final randomInitiativeCopy = randomInitiative.copy()..display(prefix:'after copy: '); 
      expect(randomInitiative, equals(randomInitiativeCopy)); 
      expect(randomInitiative.oid, equals(randomInitiativeCopy.oid)); 
      expect(randomInitiative.code, equals(randomInitiativeCopy.code)); 
      expect(randomInitiative.name, equals(randomInitiativeCopy.name)); 
 
    }); 
 
    test('initiative action undo and redo', () { 
      var initiativeCount = initiatives.length; 
      final initiative = Initiative(initiatives.concept) 
  
      ..name = 'done';    final initiativeProject = coreModel.projects.random(); 
    initiative.project = initiativeProject; 
      initiatives.add(initiative); 
    initiativeProject.initiatives.add(initiative); 
      expect(initiatives.length, equals(++initiativeCount)); 
      initiatives.remove(initiative); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      final action = AddCommand(session, initiatives, initiative)..doIt(); 
      expect(initiatives.length, equals(++initiativeCount)); 
 
      action.undo(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      action.redo(); 
      expect(initiatives.length, equals(++initiativeCount)); 
    }); 
 
    test('initiative session undo and redo', () { 
      var initiativeCount = initiatives.length; 
      final initiative = Initiative(initiatives.concept) 
  
      ..name = 'tree';    final initiativeProject = coreModel.projects.random(); 
    initiative.project = initiativeProject; 
      initiatives.add(initiative); 
    initiativeProject.initiatives.add(initiative); 
      expect(initiatives.length, equals(++initiativeCount)); 
      initiatives.remove(initiative); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      AddCommand(session, initiatives, initiative).doIt();; 
      expect(initiatives.length, equals(++initiativeCount)); 
 
      session.past.undo(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      session.past.redo(); 
      expect(initiatives.length, equals(++initiativeCount)); 
    }); 
 
    test('Initiative update undo and redo', () { 
      final initiative = coreModel.initiatives.random(); 
      final action = SetAttributeCommand(session, initiative, 'name', 'restaurant')..doIt(); 
 
      session.past.undo(); 
      expect(initiative.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(initiative.name, equals(action.after)); 
    }); 
 
    test('Initiative action with multiple undos and redos', () { 
      var initiativeCount = initiatives.length; 
      final initiative1 = coreModel.initiatives.random(); 
 
      RemoveCommand(session, initiatives, initiative1).doIt(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      final initiative2 = coreModel.initiatives.random(); 
 
      RemoveCommand(session, initiatives, initiative2).doIt(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(initiatives.length, equals(++initiativeCount)); 
 
      session.past.undo(); 
      expect(initiatives.length, equals(++initiativeCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      session.past.redo(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      //session.past.display(); 
    }); 
 
    test('Transaction undo and redo', () { 
      var initiativeCount = initiatives.length; 
      final initiative1 = coreModel.initiatives.random(); 
      var initiative2 = coreModel.initiatives.random(); 
      while (initiative1 == initiative2) { 
        initiative2 = coreModel.initiatives.random();  
      } 
      final action1 = RemoveCommand(session, initiatives, initiative1); 
      final action2 = RemoveCommand(session, initiatives, initiative2); 
 
      Transaction('two removes on initiatives', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      initiativeCount = initiativeCount - 2; 
      expect(initiatives.length, equals(initiativeCount)); 
 
      initiatives.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      initiativeCount = initiativeCount + 2; 
      expect(initiatives.length, equals(initiativeCount)); 
 
      initiatives.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      initiativeCount = initiativeCount - 2; 
      expect(initiatives.length, equals(initiativeCount)); 
 
      initiatives.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final initiativeCount = initiatives.length; 
      final initiative1 = coreModel.initiatives.random(); 
      final initiative2 = initiative1; 
      final action1 = RemoveCommand(session, initiatives, initiative1); 
      final action2 = RemoveCommand(session, initiatives, initiative2); 
 
      final transaction = Transaction( 
        'two removes on initiatives, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(initiatives.length, equals(initiativeCount)); 
 
      //initiatives.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to initiative actions', () { 
      var initiativeCount = initiatives.length; 
 
      final reaction = InitiativeReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final initiative = Initiative(initiatives.concept) 
  
      ..name = 'smog';    final initiativeProject = coreModel.projects.random(); 
    initiative.project = initiativeProject; 
      initiatives.add(initiative); 
    initiativeProject.initiatives.add(initiative); 
      expect(initiatives.length, equals(++initiativeCount)); 
      initiatives.remove(initiative); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, initiatives, initiative).doIt(); 
      expect(initiatives.length, equals(++initiativeCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        initiative,
        'name',
        'teacher',
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class InitiativeReaction implements ICommandReaction { 
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
  final initiatives = coreModel!.initiatives; 
  testProjectCoreInitiatives(projectDomain, coreModel, initiatives); 
} 
 
