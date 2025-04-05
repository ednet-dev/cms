 
// test/project/core/project_core_resource_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_core/project_core.dart"; 
 
void testProjectCoreResources( 
    ProjectDomain projectDomain, CoreModel coreModel, Resources resources) { 
  DomainSession session; 
  group("Testing Project.Core.Resource", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(resources.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(resources.isEmpty, isTrue); 
      expect(resources.exceptions.isEmpty, isTrue); 
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
      var json = coreModel.fromEntryToJson("Resource"); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson("Resource"); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = coreModel.fromEntryToJson("Resource"); 
      resources.clear(); 
      expect(resources.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(resources.isEmpty, isFalse); 
 
      resources.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add resource required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add resource unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found resource by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var resource = resources.singleWhereOid(ednetOid); 
      expect(resource, isNull); 
    }); 
 
    test("Find resource by oid", () { 
      var randomResource = coreModel.resources.random(); 
      var resource = resources.singleWhereOid(randomResource.oid); 
      expect(resource, isNotNull); 
      expect(resource, equals(randomResource)); 
    }); 
 
    test("Find resource by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find resource by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find resource by attribute", () { 
      var randomResource = coreModel.resources.random(); 
      var resource = 
          resources.firstWhereAttribute("name", randomResource.name); 
      expect(resource, isNotNull); 
      expect(resource.name, equals(randomResource.name)); 
    }); 
 
    test("Select resources by attribute", () { 
      var randomResource = coreModel.resources.random(); 
      var selectedResources = 
          resources.selectWhereAttribute("name", randomResource.name); 
      expect(selectedResources.isEmpty, isFalse); 
      selectedResources.forEach((se) => 
          expect(se.name, equals(randomResource.name))); 
 
      //selectedResources.display(title: "Select resources by name"); 
    }); 
 
    test("Select resources by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select resources by attribute, then add", () { 
      var randomResource = coreModel.resources.random(); 
      var selectedResources = 
          resources.selectWhereAttribute("name", randomResource.name); 
      expect(selectedResources.isEmpty, isFalse); 
      expect(selectedResources.source?.isEmpty, isFalse); 
      var resourcesCount = resources.length; 
 
      var resource = Resource(resources.concept); 
      resource.name = 'heaven'; 
      resource.type = 'election'; 
      resource.cost = 62.840963731458096; 
      var added = selectedResources.add(resource); 
      expect(added, isTrue); 
      expect(resources.length, equals(++resourcesCount)); 
 
      //selectedResources.display(title: 
      //  "Select resources by attribute, then add"); 
      //resources.display(title: "All resources"); 
    }); 
 
    test("Select resources by attribute, then remove", () { 
      var randomResource = coreModel.resources.random(); 
      var selectedResources = 
          resources.selectWhereAttribute("name", randomResource.name); 
      expect(selectedResources.isEmpty, isFalse); 
      expect(selectedResources.source?.isEmpty, isFalse); 
      var resourcesCount = resources.length; 
 
      var removed = selectedResources.remove(randomResource); 
      expect(removed, isTrue); 
      expect(resources.length, equals(--resourcesCount)); 
 
      randomResource.display(prefix: "removed"); 
      //selectedResources.display(title: 
      //  "Select resources by attribute, then remove"); 
      //resources.display(title: "All resources"); 
    }); 
 
    test("Sort resources", () { 
      // no id attribute 
      // add compareTo method in the specific Resource class 
      /* 
      resources.sort(); 
 
      //resources.display(title: "Sort resources"); 
      */ 
    }); 
 
    test("Order resources", () { 
      // no id attribute 
      // add compareTo method in the specific Resource class 
      /* 
      var orderedResources = resources.order(); 
      expect(orderedResources.isEmpty, isFalse); 
      expect(orderedResources.length, equals(resources.length)); 
      expect(orderedResources.source?.isEmpty, isFalse); 
      expect(orderedResources.source?.length, equals(resources.length)); 
      expect(orderedResources, isNot(same(resources))); 
 
      //orderedResources.display(title: "Order resources"); 
      */ 
    }); 
 
    test("Copy resources", () { 
      var copiedResources = resources.copy(); 
      expect(copiedResources.isEmpty, isFalse); 
      expect(copiedResources.length, equals(resources.length)); 
      expect(copiedResources, isNot(same(resources))); 
      copiedResources.forEach((e) => 
        expect(e, equals(resources.singleWhereOid(e.oid)))); 
 
      //copiedResources.display(title: "Copy resources"); 
    }); 
 
    test("True for every resource", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random resource", () { 
      var resource1 = coreModel.resources.random(); 
      expect(resource1, isNotNull); 
      var resource2 = coreModel.resources.random(); 
      expect(resource2, isNotNull); 
 
      //resource1.display(prefix: "random1"); 
      //resource2.display(prefix: "random2"); 
    }); 
 
    test("Update resource id with try", () { 
      // no id attribute 
    }); 
 
    test("Update resource id without try", () { 
      // no id attribute 
    }); 
 
    test("Update resource id with success", () { 
      // no id attribute 
    }); 
 
    test("Update resource non id attribute with failure", () { 
      var randomResource = coreModel.resources.random(); 
      var afterUpdateEntity = randomResource.copy(); 
      afterUpdateEntity.name = 'beach'; 
      expect(afterUpdateEntity.name, equals('beach')); 
      // resources.update can only be used if oid, code or id is set. 
      expect(() => resources.update(randomResource, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomResource = coreModel.resources.random(); 
      randomResource.display(prefix:"before copy: "); 
      var randomResourceCopy = randomResource.copy(); 
      randomResourceCopy.display(prefix:"after copy: "); 
      expect(randomResource, equals(randomResourceCopy)); 
      expect(randomResource.oid, equals(randomResourceCopy.oid)); 
      expect(randomResource.code, equals(randomResourceCopy.code)); 
      expect(randomResource.name, equals(randomResourceCopy.name)); 
      expect(randomResource.type, equals(randomResourceCopy.type)); 
      expect(randomResource.cost, equals(randomResourceCopy.cost)); 
 
    }); 
 
    test("resource action undo and redo", () { 
      var resourceCount = resources.length; 
      var resource = Resource(resources.concept); 
        resource.name = 'small'; 
      resource.type = 'school'; 
      resource.cost = 75.43562557221168; 
    var resourceTask = coreModel.tasks.random(); 
    resource.task = resourceTask; 
      resources.add(resource); 
    resourceTask.resources.add(resource); 
      expect(resources.length, equals(++resourceCount)); 
      resources.remove(resource); 
      expect(resources.length, equals(--resourceCount)); 
 
      var action = AddCommand(session, resources, resource); 
      action.doIt(); 
      expect(resources.length, equals(++resourceCount)); 
 
      action.undo(); 
      expect(resources.length, equals(--resourceCount)); 
 
      action.redo(); 
      expect(resources.length, equals(++resourceCount)); 
    }); 
 
    test("resource session undo and redo", () { 
      var resourceCount = resources.length; 
      var resource = Resource(resources.concept); 
        resource.name = 'void'; 
      resource.type = 'revolution'; 
      resource.cost = 20.49846026457426; 
    var resourceTask = coreModel.tasks.random(); 
    resource.task = resourceTask; 
      resources.add(resource); 
    resourceTask.resources.add(resource); 
      expect(resources.length, equals(++resourceCount)); 
      resources.remove(resource); 
      expect(resources.length, equals(--resourceCount)); 
 
      var action = AddCommand(session, resources, resource); 
      action.doIt(); 
      expect(resources.length, equals(++resourceCount)); 
 
      session.past.undo(); 
      expect(resources.length, equals(--resourceCount)); 
 
      session.past.redo(); 
      expect(resources.length, equals(++resourceCount)); 
    }); 
 
    test("Resource update undo and redo", () { 
      var resource = coreModel.resources.random(); 
      var action = SetAttributeCommand(session, resource, "name", 'mind'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(resource.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(resource.name, equals(action.after)); 
    }); 
 
    test("Resource action with multiple undos and redos", () { 
      var resourceCount = resources.length; 
      var resource1 = coreModel.resources.random(); 
 
      var action1 = RemoveCommand(session, resources, resource1); 
      action1.doIt(); 
      expect(resources.length, equals(--resourceCount)); 
 
      var resource2 = coreModel.resources.random(); 
 
      var action2 = RemoveCommand(session, resources, resource2); 
      action2.doIt(); 
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
 
    test("Transaction undo and redo", () { 
      var resourceCount = resources.length; 
      var resource1 = coreModel.resources.random(); 
      var resource2 = coreModel.resources.random(); 
      while (resource1 == resource2) { 
        resource2 = coreModel.resources.random();  
      } 
      var action1 = RemoveCommand(session, resources, resource1); 
      var action2 = RemoveCommand(session, resources, resource2); 
 
      var transaction = new Transaction("two removes on resources", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      resourceCount = resourceCount - 2; 
      expect(resources.length, equals(resourceCount)); 
 
      resources.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      resourceCount = resourceCount + 2; 
      expect(resources.length, equals(resourceCount)); 
 
      resources.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      resourceCount = resourceCount - 2; 
      expect(resources.length, equals(resourceCount)); 
 
      resources.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var resourceCount = resources.length; 
      var resource1 = coreModel.resources.random(); 
      var resource2 = resource1; 
      var action1 = RemoveCommand(session, resources, resource1); 
      var action2 = RemoveCommand(session, resources, resource2); 
 
      var transaction = Transaction( 
        "two removes on resources, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(resources.length, equals(resourceCount)); 
 
      //resources.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to resource actions", () { 
      var resourceCount = resources.length; 
 
      var reaction = ResourceReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var resource = Resource(resources.concept); 
        resource.name = 'cardboard'; 
      resource.type = 'circle'; 
      resource.cost = 89.46632829203533; 
    var resourceTask = coreModel.tasks.random(); 
    resource.task = resourceTask; 
      resources.add(resource); 
    resourceTask.resources.add(resource); 
      expect(resources.length, equals(++resourceCount)); 
      resources.remove(resource); 
      expect(resources.length, equals(--resourceCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, resources, resource); 
      addCommand.doIt(); 
      expect(resources.length, equals(++resourceCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, resource, "name", 'pub'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class ResourceReaction implements ICommandReaction { 
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
  var resources = coreModel.resources; 
  testProjectCoreResources(projectDomain, coreModel, resources); 
} 
 
