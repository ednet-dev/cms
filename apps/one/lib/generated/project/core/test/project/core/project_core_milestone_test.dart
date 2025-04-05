 
// test/project/core/project_core_milestone_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreMilestones( 
    ProjectDomain projectDomain, CoreModel coreModel, Milestones milestones) { 
  DomainSession session; 
  group('Testing Project.Core.Milestone', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(milestones.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(milestones.isEmpty, isTrue); 
      expect(milestones.exceptions.isEmpty, isTrue); 
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
      final json = coreModel.fromEntryToJson('Milestone'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Milestone'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Milestone'); 
      milestones.clear(); 
      expect(milestones.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(milestones.isEmpty, isFalse); 
 
      milestones.display(title: 'From JSON to model entry'); 
    }); 
 
    test('Add milestone required error', () { 
      // no required attribute that is not id 
    }); 
 
    test('Add milestone unique error', () { 
      // no id attribute 
    }); 
 
    test('Not found milestone by oid', () { 
      final ednetOid = Oid.ts(1345648254063); 
      final milestone = milestones.singleWhereOid(ednetOid); 
      expect(milestone, isNull); 
    }); 
 
    test('Find milestone by oid', () { 
      final randomMilestone = coreModel.milestones.random(); 
      final milestone = milestones.singleWhereOid(randomMilestone.oid); 
      expect(milestone, isNotNull); 
      expect(milestone, equals(randomMilestone)); 
    }); 
 
    test('Find milestone by attribute id', () { 
      // no id attribute 
    }); 
 
    test('Find milestone by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Find milestone by attribute', () { 
      final randomMilestone = coreModel.milestones.random(); 
      final milestone = 
          milestones.firstWhereAttribute('name', randomMilestone.name); 
      expect(milestone, isNotNull); 
      expect(milestone.name, equals(randomMilestone.name)); 
    }); 
 
    test('Select milestones by attribute', () { 
      final randomMilestone = coreModel.milestones.random(); 
      final selectedMilestones = 
          milestones.selectWhereAttribute('name', randomMilestone.name); 
      expect(selectedMilestones.isEmpty, isFalse); 
      for (final se in selectedMilestones) {        expect(se.name, equals(randomMilestone.name));      } 
      //selectedMilestones.display(title: 'Select milestones by name'); 
    }); 
 
    test('Select milestones by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select milestones by attribute, then add', () { 
      final randomMilestone = coreModel.milestones.random(); 
      final selectedMilestones = 
          milestones.selectWhereAttribute('name', randomMilestone.name); 
      expect(selectedMilestones.isEmpty, isFalse); 
      expect(selectedMilestones.source?.isEmpty, isFalse); 
      var milestonesCount = milestones.length; 
 
      final milestone = Milestone(milestones.concept) 

      ..name = 'autobus'
      ..date = new DateTime.now();      final added = selectedMilestones.add(milestone); 
      expect(added, isTrue); 
      expect(milestones.length, equals(++milestonesCount)); 
 
      //selectedMilestones.display(title: 
      //  'Select milestones by attribute, then add'); 
      //milestones.display(title: 'All milestones'); 
    }); 
 
    test('Select milestones by attribute, then remove', () { 
      final randomMilestone = coreModel.milestones.random(); 
      final selectedMilestones = 
          milestones.selectWhereAttribute('name', randomMilestone.name); 
      expect(selectedMilestones.isEmpty, isFalse); 
      expect(selectedMilestones.source?.isEmpty, isFalse); 
      var milestonesCount = milestones.length; 
 
      final removed = selectedMilestones.remove(randomMilestone); 
      expect(removed, isTrue); 
      expect(milestones.length, equals(--milestonesCount)); 
 
      randomMilestone.display(prefix: 'removed'); 
      //selectedMilestones.display(title: 
      //  'Select milestones by attribute, then remove'); 
      //milestones.display(title: 'All milestones'); 
    }); 
 
    test('Sort milestones', () { 
      // no id attribute 
      // add compareTo method in the specific Milestone class 
      /* 
      milestones.sort(); 
 
      //milestones.display(title: 'Sort milestones'); 
      */ 
    }); 
 
    test('Order milestones', () { 
      // no id attribute 
      // add compareTo method in the specific Milestone class 
      /* 
      final orderedMilestones = milestones.order(); 
      expect(orderedMilestones.isEmpty, isFalse); 
      expect(orderedMilestones.length, equals(milestones.length)); 
      expect(orderedMilestones.source?.isEmpty, isFalse); 
      expect(orderedMilestones.source?.length, equals(milestones.length)); 
      expect(orderedMilestones, isNot(same(milestones))); 
 
      //orderedMilestones.display(title: 'Order milestones'); 
      */ 
    }); 
 
    test('Copy milestones', () { 
      final copiedMilestones = milestones.copy(); 
      expect(copiedMilestones.isEmpty, isFalse); 
      expect(copiedMilestones.length, equals(milestones.length)); 
      expect(copiedMilestones, isNot(same(milestones))); 
      for (final e in copiedMilestones) {        expect(e, equals(milestones.singleWhereOid(e.oid)));      } 
 
      //copiedMilestones.display(title: "Copy milestones"); 
    }); 
 
    test('True for every milestone', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random milestone', () { 
      final milestone1 = coreModel.milestones.random(); 
      expect(milestone1, isNotNull); 
      final milestone2 = coreModel.milestones.random(); 
      expect(milestone2, isNotNull); 
 
      //milestone1.display(prefix: 'random1'); 
      //milestone2.display(prefix: 'random2'); 
    }); 
 
    test('Update milestone id with try', () { 
      // no id attribute 
    }); 
 
    test('Update milestone id without try', () { 
      // no id attribute 
    }); 
 
    test('Update milestone id with success', () { 
      // no id attribute 
    }); 
 
    test('Update milestone non id attribute with failure', () { 
      final randomMilestone = coreModel.milestones.random(); 
      final afterUpdateEntity = randomMilestone.copy()..name = 'explanation'; 
      expect(afterUpdateEntity.name, equals('explanation')); 
      // milestones.update can only be used if oid, code or id is set. 
      expect(() => milestones.update(randomMilestone, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomMilestone = coreModel.milestones.random()..display(prefix:'before copy: '); 
      final randomMilestoneCopy = randomMilestone.copy()..display(prefix:'after copy: '); 
      expect(randomMilestone, equals(randomMilestoneCopy)); 
      expect(randomMilestone.oid, equals(randomMilestoneCopy.oid)); 
      expect(randomMilestone.code, equals(randomMilestoneCopy.code)); 
      expect(randomMilestone.name, equals(randomMilestoneCopy.name)); 
      expect(randomMilestone.date, equals(randomMilestoneCopy.date)); 
 
    }); 
 
    test('milestone action undo and redo', () { 
      var milestoneCount = milestones.length; 
      final milestone = Milestone(milestones.concept) 
  
      ..name = 'tension'
      ..date = new DateTime.now();    final milestoneProject = coreModel.projects.random(); 
    milestone.project = milestoneProject; 
      milestones.add(milestone); 
    milestoneProject.milestones.add(milestone); 
      expect(milestones.length, equals(++milestoneCount)); 
      milestones.remove(milestone); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      final action = AddCommand(session, milestones, milestone)..doIt(); 
      expect(milestones.length, equals(++milestoneCount)); 
 
      action.undo(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      action.redo(); 
      expect(milestones.length, equals(++milestoneCount)); 
    }); 
 
    test('milestone session undo and redo', () { 
      var milestoneCount = milestones.length; 
      final milestone = Milestone(milestones.concept) 
  
      ..name = 'pub'
      ..date = new DateTime.now();    final milestoneProject = coreModel.projects.random(); 
    milestone.project = milestoneProject; 
      milestones.add(milestone); 
    milestoneProject.milestones.add(milestone); 
      expect(milestones.length, equals(++milestoneCount)); 
      milestones.remove(milestone); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      AddCommand(session, milestones, milestone).doIt();; 
      expect(milestones.length, equals(++milestoneCount)); 
 
      session.past.undo(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      session.past.redo(); 
      expect(milestones.length, equals(++milestoneCount)); 
    }); 
 
    test('Milestone update undo and redo', () { 
      final milestone = coreModel.milestones.random(); 
      final action = SetAttributeCommand(session, milestone, 'name', 'sand')..doIt(); 
 
      session.past.undo(); 
      expect(milestone.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(milestone.name, equals(action.after)); 
    }); 
 
    test('Milestone action with multiple undos and redos', () { 
      var milestoneCount = milestones.length; 
      final milestone1 = coreModel.milestones.random(); 
 
      RemoveCommand(session, milestones, milestone1).doIt(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      final milestone2 = coreModel.milestones.random(); 
 
      RemoveCommand(session, milestones, milestone2).doIt(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(milestones.length, equals(++milestoneCount)); 
 
      session.past.undo(); 
      expect(milestones.length, equals(++milestoneCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      session.past.redo(); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      //session.past.display(); 
    }); 
 
    test('Transaction undo and redo', () { 
      var milestoneCount = milestones.length; 
      final milestone1 = coreModel.milestones.random(); 
      var milestone2 = coreModel.milestones.random(); 
      while (milestone1 == milestone2) { 
        milestone2 = coreModel.milestones.random();  
      } 
      final action1 = RemoveCommand(session, milestones, milestone1); 
      final action2 = RemoveCommand(session, milestones, milestone2); 
 
      Transaction('two removes on milestones', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      milestoneCount = milestoneCount - 2; 
      expect(milestones.length, equals(milestoneCount)); 
 
      milestones.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      milestoneCount = milestoneCount + 2; 
      expect(milestones.length, equals(milestoneCount)); 
 
      milestones.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      milestoneCount = milestoneCount - 2; 
      expect(milestones.length, equals(milestoneCount)); 
 
      milestones.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final milestoneCount = milestones.length; 
      final milestone1 = coreModel.milestones.random(); 
      final milestone2 = milestone1; 
      final action1 = RemoveCommand(session, milestones, milestone1); 
      final action2 = RemoveCommand(session, milestones, milestone2); 
 
      final transaction = Transaction( 
        'two removes on milestones, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(milestones.length, equals(milestoneCount)); 
 
      //milestones.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to milestone actions', () { 
      var milestoneCount = milestones.length; 
 
      final reaction = MilestoneReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final milestone = Milestone(milestones.concept) 
  
      ..name = 'word'
      ..date = new DateTime.now();    final milestoneProject = coreModel.projects.random(); 
    milestone.project = milestoneProject; 
      milestones.add(milestone); 
    milestoneProject.milestones.add(milestone); 
      expect(milestones.length, equals(++milestoneCount)); 
      milestones.remove(milestone); 
      expect(milestones.length, equals(--milestoneCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, milestones, milestone).doIt(); 
      expect(milestones.length, equals(++milestoneCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        milestone,
        'name',
        'house',
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class MilestoneReaction implements ICommandReaction { 
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
  final milestones = coreModel!.milestones; 
  testProjectCoreMilestones(projectDomain, coreModel, milestones); 
} 
 
