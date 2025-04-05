 
// test/project/core/project_core_initiative_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_core/project_core.dart"; 
 
void testProjectCoreInitiatives( 
    ProjectDomain projectDomain, CoreModel coreModel, Initiatives initiatives) { 
  DomainSession session; 
  group("Testing Project.Core.Initiative", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      coreModel.init(); 
    }); 
    tearDown(() { 
      coreModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(coreModel.isEmpty, isFalse); 
      expect(initiatives.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      coreModel.clear(); 
      expect(coreModel.isEmpty, isTrue); 
      expect(initiatives.isEmpty, isTrue); 
      expect(initiatives.exceptions.isEmpty, isTrue); 
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
      var json = coreModel.fromEntryToJson("Initiative"); 
      expect(json, isNotNull); 
 
      print(json); 
      //coreModel.displayEntryJson("Initiative"); 
      //coreModel.displayJson(); 
      //coreModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = coreModel.fromEntryToJson("Initiative"); 
      initiatives.clear(); 
      expect(initiatives.isEmpty, isTrue); 
      coreModel.fromJsonToEntry(json); 
      expect(initiatives.isEmpty, isFalse); 
 
      initiatives.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add initiative required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add initiative unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found initiative by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var initiative = initiatives.singleWhereOid(ednetOid); 
      expect(initiative, isNull); 
    }); 
 
    test("Find initiative by oid", () { 
      var randomInitiative = coreModel.initiatives.random(); 
      var initiative = initiatives.singleWhereOid(randomInitiative.oid); 
      expect(initiative, isNotNull); 
      expect(initiative, equals(randomInitiative)); 
    }); 
 
    test("Find initiative by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find initiative by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find initiative by attribute", () { 
      var randomInitiative = coreModel.initiatives.random(); 
      var initiative = 
          initiatives.firstWhereAttribute("name", randomInitiative.name); 
      expect(initiative, isNotNull); 
      expect(initiative.name, equals(randomInitiative.name)); 
    }); 
 
    test("Select initiatives by attribute", () { 
      var randomInitiative = coreModel.initiatives.random(); 
      var selectedInitiatives = 
          initiatives.selectWhereAttribute("name", randomInitiative.name); 
      expect(selectedInitiatives.isEmpty, isFalse); 
      selectedInitiatives.forEach((se) => 
          expect(se.name, equals(randomInitiative.name))); 
 
      //selectedInitiatives.display(title: "Select initiatives by name"); 
    }); 
 
    test("Select initiatives by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select initiatives by attribute, then add", () { 
      var randomInitiative = coreModel.initiatives.random(); 
      var selectedInitiatives = 
          initiatives.selectWhereAttribute("name", randomInitiative.name); 
      expect(selectedInitiatives.isEmpty, isFalse); 
      expect(selectedInitiatives.source?.isEmpty, isFalse); 
      var initiativesCount = initiatives.length; 
 
      var initiative = Initiative(initiatives.concept); 
      initiative.name = 'agreement'; 
      var added = selectedInitiatives.add(initiative); 
      expect(added, isTrue); 
      expect(initiatives.length, equals(++initiativesCount)); 
 
      //selectedInitiatives.display(title: 
      //  "Select initiatives by attribute, then add"); 
      //initiatives.display(title: "All initiatives"); 
    }); 
 
    test("Select initiatives by attribute, then remove", () { 
      var randomInitiative = coreModel.initiatives.random(); 
      var selectedInitiatives = 
          initiatives.selectWhereAttribute("name", randomInitiative.name); 
      expect(selectedInitiatives.isEmpty, isFalse); 
      expect(selectedInitiatives.source?.isEmpty, isFalse); 
      var initiativesCount = initiatives.length; 
 
      var removed = selectedInitiatives.remove(randomInitiative); 
      expect(removed, isTrue); 
      expect(initiatives.length, equals(--initiativesCount)); 
 
      randomInitiative.display(prefix: "removed"); 
      //selectedInitiatives.display(title: 
      //  "Select initiatives by attribute, then remove"); 
      //initiatives.display(title: "All initiatives"); 
    }); 
 
    test("Sort initiatives", () { 
      // no id attribute 
      // add compareTo method in the specific Initiative class 
      /* 
      initiatives.sort(); 
 
      //initiatives.display(title: "Sort initiatives"); 
      */ 
    }); 
 
    test("Order initiatives", () { 
      // no id attribute 
      // add compareTo method in the specific Initiative class 
      /* 
      var orderedInitiatives = initiatives.order(); 
      expect(orderedInitiatives.isEmpty, isFalse); 
      expect(orderedInitiatives.length, equals(initiatives.length)); 
      expect(orderedInitiatives.source?.isEmpty, isFalse); 
      expect(orderedInitiatives.source?.length, equals(initiatives.length)); 
      expect(orderedInitiatives, isNot(same(initiatives))); 
 
      //orderedInitiatives.display(title: "Order initiatives"); 
      */ 
    }); 
 
    test("Copy initiatives", () { 
      var copiedInitiatives = initiatives.copy(); 
      expect(copiedInitiatives.isEmpty, isFalse); 
      expect(copiedInitiatives.length, equals(initiatives.length)); 
      expect(copiedInitiatives, isNot(same(initiatives))); 
      copiedInitiatives.forEach((e) => 
        expect(e, equals(initiatives.singleWhereOid(e.oid)))); 
 
      //copiedInitiatives.display(title: "Copy initiatives"); 
    }); 
 
    test("True for every initiative", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random initiative", () { 
      var initiative1 = coreModel.initiatives.random(); 
      expect(initiative1, isNotNull); 
      var initiative2 = coreModel.initiatives.random(); 
      expect(initiative2, isNotNull); 
 
      //initiative1.display(prefix: "random1"); 
      //initiative2.display(prefix: "random2"); 
    }); 
 
    test("Update initiative id with try", () { 
      // no id attribute 
    }); 
 
    test("Update initiative id without try", () { 
      // no id attribute 
    }); 
 
    test("Update initiative id with success", () { 
      // no id attribute 
    }); 
 
    test("Update initiative non id attribute with failure", () { 
      var randomInitiative = coreModel.initiatives.random(); 
      var afterUpdateEntity = randomInitiative.copy(); 
      afterUpdateEntity.name = 'brad'; 
      expect(afterUpdateEntity.name, equals('brad')); 
      // initiatives.update can only be used if oid, code or id is set. 
      expect(() => initiatives.update(randomInitiative, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomInitiative = coreModel.initiatives.random(); 
      randomInitiative.display(prefix:"before copy: "); 
      var randomInitiativeCopy = randomInitiative.copy(); 
      randomInitiativeCopy.display(prefix:"after copy: "); 
      expect(randomInitiative, equals(randomInitiativeCopy)); 
      expect(randomInitiative.oid, equals(randomInitiativeCopy.oid)); 
      expect(randomInitiative.code, equals(randomInitiativeCopy.code)); 
      expect(randomInitiative.name, equals(randomInitiativeCopy.name)); 
 
    }); 
 
    test("initiative action undo and redo", () { 
      var initiativeCount = initiatives.length; 
      var initiative = Initiative(initiatives.concept); 
        initiative.name = 'tax'; 
    var initiativeProject = coreModel.projects.random(); 
    initiative.project = initiativeProject; 
      initiatives.add(initiative); 
    initiativeProject.initiatives.add(initiative); 
      expect(initiatives.length, equals(++initiativeCount)); 
      initiatives.remove(initiative); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      var action = AddCommand(session, initiatives, initiative); 
      action.doIt(); 
      expect(initiatives.length, equals(++initiativeCount)); 
 
      action.undo(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      action.redo(); 
      expect(initiatives.length, equals(++initiativeCount)); 
    }); 
 
    test("initiative session undo and redo", () { 
      var initiativeCount = initiatives.length; 
      var initiative = Initiative(initiatives.concept); 
        initiative.name = 'phone'; 
    var initiativeProject = coreModel.projects.random(); 
    initiative.project = initiativeProject; 
      initiatives.add(initiative); 
    initiativeProject.initiatives.add(initiative); 
      expect(initiatives.length, equals(++initiativeCount)); 
      initiatives.remove(initiative); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      var action = AddCommand(session, initiatives, initiative); 
      action.doIt(); 
      expect(initiatives.length, equals(++initiativeCount)); 
 
      session.past.undo(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      session.past.redo(); 
      expect(initiatives.length, equals(++initiativeCount)); 
    }); 
 
    test("Initiative update undo and redo", () { 
      var initiative = coreModel.initiatives.random(); 
      var action = SetAttributeCommand(session, initiative, "name", 'consciousness'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(initiative.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(initiative.name, equals(action.after)); 
    }); 
 
    test("Initiative action with multiple undos and redos", () { 
      var initiativeCount = initiatives.length; 
      var initiative1 = coreModel.initiatives.random(); 
 
      var action1 = RemoveCommand(session, initiatives, initiative1); 
      action1.doIt(); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      var initiative2 = coreModel.initiatives.random(); 
 
      var action2 = RemoveCommand(session, initiatives, initiative2); 
      action2.doIt(); 
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
 
    test("Transaction undo and redo", () { 
      var initiativeCount = initiatives.length; 
      var initiative1 = coreModel.initiatives.random(); 
      var initiative2 = coreModel.initiatives.random(); 
      while (initiative1 == initiative2) { 
        initiative2 = coreModel.initiatives.random();  
      } 
      var action1 = RemoveCommand(session, initiatives, initiative1); 
      var action2 = RemoveCommand(session, initiatives, initiative2); 
 
      var transaction = new Transaction("two removes on initiatives", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      initiativeCount = initiativeCount - 2; 
      expect(initiatives.length, equals(initiativeCount)); 
 
      initiatives.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      initiativeCount = initiativeCount + 2; 
      expect(initiatives.length, equals(initiativeCount)); 
 
      initiatives.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      initiativeCount = initiativeCount - 2; 
      expect(initiatives.length, equals(initiativeCount)); 
 
      initiatives.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var initiativeCount = initiatives.length; 
      var initiative1 = coreModel.initiatives.random(); 
      var initiative2 = initiative1; 
      var action1 = RemoveCommand(session, initiatives, initiative1); 
      var action2 = RemoveCommand(session, initiatives, initiative2); 
 
      var transaction = Transaction( 
        "two removes on initiatives, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(initiatives.length, equals(initiativeCount)); 
 
      //initiatives.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to initiative actions", () { 
      var initiativeCount = initiatives.length; 
 
      var reaction = InitiativeReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var initiative = Initiative(initiatives.concept); 
        initiative.name = 'theme'; 
    var initiativeProject = coreModel.projects.random(); 
    initiative.project = initiativeProject; 
      initiatives.add(initiative); 
    initiativeProject.initiatives.add(initiative); 
      expect(initiatives.length, equals(++initiativeCount)); 
      initiatives.remove(initiative); 
      expect(initiatives.length, equals(--initiativeCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, initiatives, initiative); 
      addCommand.doIt(); 
      expect(initiatives.length, equals(++initiativeCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, initiative, "name", 'time'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class InitiativeReaction implements ICommandReaction { 
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
  var initiatives = coreModel.initiatives; 
  testProjectCoreInitiatives(projectDomain, coreModel, initiatives); 
} 
 
