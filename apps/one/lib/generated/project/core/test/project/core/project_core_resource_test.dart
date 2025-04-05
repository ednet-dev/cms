 
// test/project/core/project_core_resource_test.dart 
 
import 'package:test/test.dart'; 
import 'package:ednet_core/ednet_core.dart'; 
import '../../../lib/project_core.dart'; 
 
void testProjectCoreResources( 
    ProjectDomain projectDomain, CoreModel coreModel, Resources resources) { 
  DomainSession session; 
  group('Testing Project.Core.Resource', () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test('Not empty model', () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(resources.isEmpty, isFalse); 
    }); 
 
    test('Empty model', () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(resources.isEmpty, isTrue); 
      expect(resources.exceptions.isEmpty, isTrue); 
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
      final json = coreModel.fromEntryToJson('Resource'); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson('Resource'); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test('From JSON to model entry', () { 
      final json = coreModel.fromEntryToJson('Resource'); 
      resources.clear(); 
      expect(resources.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(resources.isEmpty, isFalse); 
 
      resources.display(title: 'From JSON to model entry'); 
    }); 
 
    test('Add resource required error', () { 
      // no required attribute that is not id 
    }); 
 
    test('Add resource unique error', () { 
      // no id attribute 
    }); 
 
    test('Not found resource by oid', () { 
      final ednetOid = Oid.ts(1345648254063); 
      final resource = resources.singleWhereOid(ednetOid); 
      expect(resource, isNull); 
    }); 
 
    test('Find resource by oid', () { 
      final randomResource = coreModel.resources.random(); 
      final resource = resources.singleWhereOid(randomResource.oid); 
      expect(resource, isNotNull); 
      expect(resource, equals(randomResource)); 
    }); 
 
    test('Find resource by attribute id', () { 
      // no id attribute 
    }); 
 
    test('Find resource by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Find resource by attribute', () { 
      final randomResource = coreModel.resources.random(); 
      final resource = 
          resources.firstWhereAttribute('name', randomResource.name); 
      expect(resource, isNotNull); 
      expect(resource.name, equals(randomResource.name)); 
    }); 
 
    test('Select resources by attribute', () { 
      final randomResource = coreModel.resources.random(); 
      final selectedResources = 
          resources.selectWhereAttribute('name', randomResource.name); 
      expect(selectedResources.isEmpty, isFalse); 
      for (final se in selectedResources) {        expect(se.name, equals(randomResource.name));      } 
      //selectedResources.display(title: 'Select resources by name'); 
    }); 
 
    test('Select resources by required attribute', () { 
      // no required attribute that is not id 
    }); 
 
    test('Select resources by attribute, then add', () { 
      final randomResource = coreModel.resources.random(); 
      final selectedResources = 
          resources.selectWhereAttribute('name', randomResource.name); 
      expect(selectedResources.isEmpty, isFalse); 
      expect(selectedResources.source?.isEmpty, isFalse); 
      var resourcesCount = resources.length; 
 
      final resource = Resource(resources.concept) 

      ..name = 'horse'
      ..type = 'tree'
      ..cost = 64.93998703292606;      final added = selectedResources.add(resource); 
      expect(added, isTrue); 
      expect(resources.length, equals(++resourcesCount)); 
 
      //selectedResources.display(title: 
      //  'Select resources by attribute, then add'); 
      //resources.display(title: 'All resources'); 
    }); 
 
    test('Select resources by attribute, then remove', () { 
      final randomResource = coreModel.resources.random(); 
      final selectedResources = 
          resources.selectWhereAttribute('name', randomResource.name); 
      expect(selectedResources.isEmpty, isFalse); 
      expect(selectedResources.source?.isEmpty, isFalse); 
      var resourcesCount = resources.length; 
 
      final removed = selectedResources.remove(randomResource); 
      expect(removed, isTrue); 
      expect(resources.length, equals(--resourcesCount)); 
 
      randomResource.display(prefix: 'removed'); 
      //selectedResources.display(title: 
      //  'Select resources by attribute, then remove'); 
      //resources.display(title: 'All resources'); 
    }); 
 
    test('Sort resources', () { 
      // no id attribute 
      // add compareTo method in the specific Resource class 
      /* 
      resources.sort(); 
 
      //resources.display(title: 'Sort resources'); 
      */ 
    }); 
 
    test('Order resources', () { 
      // no id attribute 
      // add compareTo method in the specific Resource class 
      /* 
      final orderedResources = resources.order(); 
      expect(orderedResources.isEmpty, isFalse); 
      expect(orderedResources.length, equals(resources.length)); 
      expect(orderedResources.source?.isEmpty, isFalse); 
      expect(orderedResources.source?.length, equals(resources.length)); 
      expect(orderedResources, isNot(same(resources))); 
 
      //orderedResources.display(title: 'Order resources'); 
      */ 
    }); 
 
    test('Copy resources', () { 
      final copiedResources = resources.copy(); 
      expect(copiedResources.isEmpty, isFalse); 
      expect(copiedResources.length, equals(resources.length)); 
      expect(copiedResources, isNot(same(resources))); 
      for (final e in copiedResources) {        expect(e, equals(resources.singleWhereOid(e.oid)));      } 
 
      //copiedResources.display(title: "Copy resources"); 
    }); 
 
    test('True for every resource', () { 
      // no required attribute that is not id 
    }); 
 
    test('Random resource', () { 
      final resource1 = coreModel.resources.random(); 
      expect(resource1, isNotNull); 
      final resource2 = coreModel.resources.random(); 
      expect(resource2, isNotNull); 
 
      //resource1.display(prefix: 'random1'); 
      //resource2.display(prefix: 'random2'); 
    }); 
 
    test('Update resource id with try', () { 
      // no id attribute 
    }); 
 
    test('Update resource id without try', () { 
      // no id attribute 
    }); 
 
    test('Update resource id with success', () { 
      // no id attribute 
    }); 
 
    test('Update resource non id attribute with failure', () { 
      final randomResource = coreModel.resources.random(); 
      final afterUpdateEntity = randomResource.copy()..name = 'economy'; 
      expect(afterUpdateEntity.name, equals('economy')); 
      // resources.update can only be used if oid, code or id is set. 
      expect(() => resources.update(randomResource, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test('Copy Equality', () { 
      final randomResource = coreModel.resources.random()..display(prefix:'before copy: '); 
      final randomResourceCopy = randomResource.copy()..display(prefix:'after copy: '); 
      expect(randomResource, equals(randomResourceCopy)); 
      expect(randomResource.oid, equals(randomResourceCopy.oid)); 
      expect(randomResource.code, equals(randomResourceCopy.code)); 
      expect(randomResource.name, equals(randomResourceCopy.name)); 
      expect(randomResource.type, equals(randomResourceCopy.type)); 
      expect(randomResource.cost, equals(randomResourceCopy.cost)); 
 
    }); 
 
    test('resource action undo and redo', () { 
      var resourceCount = resources.length; 
      final resource = Resource(resources.concept) 
  
      ..name = 'service'
      ..type = 'family'
      ..cost = 45.07975326541527;    final resourceTask = coreModel.tasks.random(); 
    resource.task = resourceTask; 
      resources.add(resource); 
    resourceTask.resources.add(resource); 
      expect(resources.length, equals(++resourceCount)); 
      resources.remove(resource); 
      expect(resources.length, equals(--resourceCount)); 
 
      final action = AddCommand(session, resources, resource)..doIt(); 
      expect(resources.length, equals(++resourceCount)); 
 
      action.undo(); 
      expect(resources.length, equals(--resourceCount)); 
 
      action.redo(); 
      expect(resources.length, equals(++resourceCount)); 
    }); 
 
    test('resource session undo and redo', () { 
      var resourceCount = resources.length; 
      final resource = Resource(resources.concept) 
  
      ..name = 'teacher'
      ..type = 'executive'
      ..cost = 46.8312411516715;    final resourceTask = coreModel.tasks.random(); 
    resource.task = resourceTask; 
      resources.add(resource); 
    resourceTask.resources.add(resource); 
      expect(resources.length, equals(++resourceCount)); 
      resources.remove(resource); 
      expect(resources.length, equals(--resourceCount)); 
 
      AddCommand(session, resources, resource).doIt();; 
      expect(resources.length, equals(++resourceCount)); 
 
      session.past.undo(); 
      expect(resources.length, equals(--resourceCount)); 
 
      session.past.redo(); 
      expect(resources.length, equals(++resourceCount)); 
    }); 
 
    test('Resource update undo and redo', () { 
      final resource = coreModel.resources.random(); 
      final action = SetAttributeCommand(session, resource, 'name', 'marriage')..doIt(); 
 
      session.past.undo(); 
      expect(resource.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(resource.name, equals(action.after)); 
    }); 
 
    test('Resource action with multiple undos and redos', () { 
      var resourceCount = resources.length; 
      final resource1 = coreModel.resources.random(); 
 
      RemoveCommand(session, resources, resource1).doIt(); 
      expect(resources.length, equals(--resourceCount)); 
 
      final resource2 = coreModel.resources.random(); 
 
      RemoveCommand(session, resources, resource2).doIt(); 
      expect(resources.length, equals(--resourceCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(resources.length, equals(++resourceCount)); 
 
      session.past.undo(); 
      expect(resources.length, equals(++resourceCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(resources.length, equals(--resourceCount)); 
 
      session.past.redo(); 
      expect(resources.length, equals(--resourceCount)); 
 
      //session.past.display(); 
    }); 
 
    test('Transaction undo and redo', () { 
      var resourceCount = resources.length; 
      final resource1 = coreModel.resources.random(); 
      var resource2 = coreModel.resources.random(); 
      while (resource1 == resource2) { 
        resource2 = coreModel.resources.random();  
      } 
      final action1 = RemoveCommand(session, resources, resource1); 
      final action2 = RemoveCommand(session, resources, resource2); 
 
      Transaction('two removes on resources', session) 
        ..add(action1) 
        ..add(action2) 
        ..doIt(); 
      resourceCount = resourceCount - 2; 
      expect(resources.length, equals(resourceCount)); 
 
      resources.display(title:'Transaction Done'); 
 
      session.past.undo(); 
      resourceCount = resourceCount + 2; 
      expect(resources.length, equals(resourceCount)); 
 
      resources.display(title:'Transaction Undone'); 
 
      session.past.redo(); 
      resourceCount = resourceCount - 2; 
      expect(resources.length, equals(resourceCount)); 
 
      resources.display(title:'Transaction Redone'); 
    }); 
 
    test('Transaction with one action error', () { 
      final resourceCount = resources.length; 
      final resource1 = coreModel.resources.random(); 
      final resource2 = resource1; 
      final action1 = RemoveCommand(session, resources, resource1); 
      final action2 = RemoveCommand(session, resources, resource2); 
 
      final transaction = Transaction( 
        'two removes on resources, with an error on the second',
        session, 
        )
        ..add(action1) 
        ..add(action2); 
      final done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(resources.length, equals(resourceCount)); 
 
      //resources.display(title:'Transaction with an error'); 
    }); 
 
    test('Reactions to resource actions', () { 
      var resourceCount = resources.length; 
 
      final reaction = ResourceReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      final resource = Resource(resources.concept) 
  
      ..name = 'tent'
      ..type = 'present'
      ..cost = 8.750912397737242;    final resourceTask = coreModel.tasks.random(); 
    resource.task = resourceTask; 
      resources.add(resource); 
    resourceTask.resources.add(resource); 
      expect(resources.length, equals(++resourceCount)); 
      resources.remove(resource); 
      expect(resources.length, equals(--resourceCount)); 
 
      final session = projectDomain.newSession(); 
      AddCommand(session, resources, resource).doIt(); 
      expect(resources.length, equals(++resourceCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      SetAttributeCommand( 
        session,
        resource,
        'name',
        'bank',
      ).doIt();
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ResourceReaction implements ICommandReaction { 
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
  final resources = coreModel!.resources; 
  testProjectCoreResources(projectDomain, coreModel, resources); 
} 
 
