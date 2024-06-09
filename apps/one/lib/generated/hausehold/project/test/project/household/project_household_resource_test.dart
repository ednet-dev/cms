 
// test/project/household/project_household_resource_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_household/project_household.dart"; 
 
void testProjectHouseholdResources( 
    ProjectDomain projectDomain, HouseholdModel householdModel, Resources resources) { 
  DomainSession session; 
  group("Testing Project.Household.Resource", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      householdModel.simulate();
    }); 
    tearDown(() { 
      householdModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(householdModel.isEmpty, isFalse); 
      expect(resources.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      expect(resources.isEmpty, isTrue); 
      expect(resources.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = householdModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = householdModel.toJson(); 
      householdModel.clear(); 
      expect(householdModel.isEmpty, isTrue); 
      householdModel.fromJson(json); 
      expect(householdModel.isEmpty, isFalse); 
 
      householdModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = householdModel.fromEntryToJson("Resource"); 
      expect(json, isNotNull); 
 
      print(json); 
      //householdModel.displayEntryJson("Resource"); 
      //householdModel.displayJson(); 
      //householdModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = householdModel.fromEntryToJson("Resource"); 
      resources.clear(); 
      expect(resources.isEmpty, isTrue); 
      householdModel.fromJsonToEntry(json); 
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
      var randomResource = householdModel.resources.random(); 
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
      var randomResource = householdModel.resources.random(); 
      var resource = 
          resources.firstWhereAttribute("name", randomResource.name); 
      expect(resource, isNotNull); 
      expect(resource.name, equals(randomResource.name)); 
    }); 
 
    test("Select resources by attribute", () { 
      var randomResource = householdModel.resources.random(); 
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
      var randomResource = householdModel.resources.random(); 
      var selectedResources = 
          resources.selectWhereAttribute("name", randomResource.name); 
      expect(selectedResources.isEmpty, isFalse); 
      expect(selectedResources.source?.isEmpty, isFalse); 
      var resourcesCount = resources.length; 
 
      var resource = Resource(resources.concept); 
      resource.name = 'consciousness'; 
      resource.type = 'bird'; 
      resource.cost = 62.88206043043972; 
      var added = selectedResources.add(resource); 
      expect(added, isTrue); 
      expect(resources.length, equals(++resourcesCount)); 
 
      //selectedResources.display(title: 
      //  "Select resources by attribute, then add"); 
      //resources.display(title: "All resources"); 
    }); 
 
    test("Select resources by attribute, then remove", () { 
      var randomResource = householdModel.resources.random(); 
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
      var resource1 = householdModel.resources.random(); 
      expect(resource1, isNotNull); 
      var resource2 = householdModel.resources.random(); 
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
      var randomResource = householdModel.resources.random(); 
      var afterUpdateEntity = randomResource.copy(); 
      afterUpdateEntity.name = 'east'; 
      expect(afterUpdateEntity.name, equals('east')); 
      // resources.update can only be used if oid, code or id is set. 
      expect(() => resources.update(randomResource, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomResource = householdModel.resources.random(); 
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
        resource.name = 'sand'; 
      resource.type = 'head'; 
      resource.cost = 99.24743840285839; 
    var resourceTask = householdModel.tasks.random(); 
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
        resource.name = 'slate'; 
      resource.type = 'revolution'; 
      resource.cost = 79.84280929088385; 
    var resourceTask = householdModel.tasks.random(); 
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
      var resource = householdModel.resources.random(); 
      var action = SetAttributeCommand(session, resource, "name", 'plate'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(resource.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(resource.name, equals(action.after)); 
    }); 
 
    test("Resource action with multiple undos and redos", () { 
      var resourceCount = resources.length; 
      var resource1 = householdModel.resources.random(); 
 
      var action1 = RemoveCommand(session, resources, resource1); 
      action1.doIt(); 
      expect(resources.length, equals(--resourceCount)); 
 
      var resource2 = householdModel.resources.random(); 
 
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
      var resource1 = householdModel.resources.random(); 
      var resource2 = householdModel.resources.random(); 
      while (resource1 == resource2) { 
        resource2 = householdModel.resources.random();  
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
      var resource1 = householdModel.resources.random(); 
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
        resource.name = 'cream'; 
      resource.type = 'car'; 
      resource.cost = 51.783125562172295; 
    var resourceTask = householdModel.tasks.random(); 
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
        session, resource, "name", 'beginning'); 
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
  var repository = ProjectHouseholdRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  HouseholdModel householdModel = projectDomain.getModelEntries("Household") as HouseholdModel;  
  assert(householdModel != null); 
  var resources = householdModel.resources; 
  testProjectHouseholdResources(projectDomain, householdModel, resources); 
} 
 
