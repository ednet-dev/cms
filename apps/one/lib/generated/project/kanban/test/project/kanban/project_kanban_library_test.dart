 
// test/project/kanban/project_kanban_library_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:project_kanban/project_kanban.dart"; 
 
void testProjectKanbanLibraries( 
    ProjectDomain projectDomain, KanbanModel kanbanModel, Libraries libraries) { 
  DomainSession session; 
  group("Testing Project.Kanban.Library", () { 
    session = projectDomain.newSession();  
    setUp(() { 
      kanbanModel.init(); 
    }); 
    tearDown(() { 
      kanbanModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(kanbanModel.isEmpty, isFalse); 
      expect(libraries.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      kanbanModel.clear(); 
      expect(kanbanModel.isEmpty, isTrue); 
      expect(libraries.isEmpty, isTrue); 
      expect(libraries.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = kanbanModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //kanbanModel.displayJson(); 
      //kanbanModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = kanbanModel.toJson(); 
      kanbanModel.clear(); 
      expect(kanbanModel.isEmpty, isTrue); 
      kanbanModel.fromJson(json); 
      expect(kanbanModel.isEmpty, isFalse); 
 
      kanbanModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = kanbanModel.fromEntryToJson("Library"); 
      expect(json, isNotNull); 
 
      print(json); 
      //kanbanModel.displayEntryJson("Library"); 
      //kanbanModel.displayJson(); 
      //kanbanModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = kanbanModel.fromEntryToJson("Library"); 
      libraries.clear(); 
      expect(libraries.isEmpty, isTrue); 
      kanbanModel.fromJsonToEntry(json); 
      expect(libraries.isEmpty, isFalse); 
 
      libraries.display(title: "From JSON to model entry"); 
    }); 
 
    test("Add library required error", () { 
      // no required attribute that is not id 
    }); 
 
    test("Add library unique error", () { 
      // no id attribute 
    }); 
 
    test("Not found library by oid", () { 
      var ednetOid = Oid.ts(1345648254063); 
      var library = libraries.singleWhereOid(ednetOid); 
      expect(library, isNull); 
    }); 
 
    test("Find library by oid", () { 
      var randomLibrary = kanbanModel.libraries.random(); 
      var library = libraries.singleWhereOid(randomLibrary.oid); 
      expect(library, isNotNull); 
      expect(library, equals(randomLibrary)); 
    }); 
 
    test("Find library by attribute id", () { 
      // no id attribute 
    }); 
 
    test("Find library by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Find library by attribute", () { 
      var randomLibrary = kanbanModel.libraries.random(); 
      var library = 
          libraries.firstWhereAttribute("name", randomLibrary.name); 
      expect(library, isNotNull); 
      expect(library.name, equals(randomLibrary.name)); 
    }); 
 
    test("Select libraries by attribute", () { 
      var randomLibrary = kanbanModel.libraries.random(); 
      var selectedLibraries = 
          libraries.selectWhereAttribute("name", randomLibrary.name); 
      expect(selectedLibraries.isEmpty, isFalse); 
      selectedLibraries.forEach((se) => 
          expect(se.name, equals(randomLibrary.name))); 
 
      //selectedLibraries.display(title: "Select libraries by name"); 
    }); 
 
    test("Select libraries by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select libraries by attribute, then add", () { 
      var randomLibrary = kanbanModel.libraries.random(); 
      var selectedLibraries = 
          libraries.selectWhereAttribute("name", randomLibrary.name); 
      expect(selectedLibraries.isEmpty, isFalse); 
      expect(selectedLibraries.source?.isEmpty, isFalse); 
      var librariesCount = libraries.length; 
 
      var library = Library(libraries.concept); 
      library.name = 'meter'; 
      var added = selectedLibraries.add(library); 
      expect(added, isTrue); 
      expect(libraries.length, equals(++librariesCount)); 
 
      //selectedLibraries.display(title: 
      //  "Select libraries by attribute, then add"); 
      //libraries.display(title: "All libraries"); 
    }); 
 
    test("Select libraries by attribute, then remove", () { 
      var randomLibrary = kanbanModel.libraries.random(); 
      var selectedLibraries = 
          libraries.selectWhereAttribute("name", randomLibrary.name); 
      expect(selectedLibraries.isEmpty, isFalse); 
      expect(selectedLibraries.source?.isEmpty, isFalse); 
      var librariesCount = libraries.length; 
 
      var removed = selectedLibraries.remove(randomLibrary); 
      expect(removed, isTrue); 
      expect(libraries.length, equals(--librariesCount)); 
 
      randomLibrary.display(prefix: "removed"); 
      //selectedLibraries.display(title: 
      //  "Select libraries by attribute, then remove"); 
      //libraries.display(title: "All libraries"); 
    }); 
 
    test("Sort libraries", () { 
      // no id attribute 
      // add compareTo method in the specific Library class 
      /* 
      libraries.sort(); 
 
      //libraries.display(title: "Sort libraries"); 
      */ 
    }); 
 
    test("Order libraries", () { 
      // no id attribute 
      // add compareTo method in the specific Library class 
      /* 
      var orderedLibraries = libraries.order(); 
      expect(orderedLibraries.isEmpty, isFalse); 
      expect(orderedLibraries.length, equals(libraries.length)); 
      expect(orderedLibraries.source?.isEmpty, isFalse); 
      expect(orderedLibraries.source?.length, equals(libraries.length)); 
      expect(orderedLibraries, isNot(same(libraries))); 
 
      //orderedLibraries.display(title: "Order libraries"); 
      */ 
    }); 
 
    test("Copy libraries", () { 
      var copiedLibraries = libraries.copy(); 
      expect(copiedLibraries.isEmpty, isFalse); 
      expect(copiedLibraries.length, equals(libraries.length)); 
      expect(copiedLibraries, isNot(same(libraries))); 
      copiedLibraries.forEach((e) => 
        expect(e, equals(libraries.singleWhereOid(e.oid)))); 
 
      //copiedLibraries.display(title: "Copy libraries"); 
    }); 
 
    test("True for every library", () { 
      // no required attribute that is not id 
    }); 
 
    test("Random library", () { 
      var library1 = kanbanModel.libraries.random(); 
      expect(library1, isNotNull); 
      var library2 = kanbanModel.libraries.random(); 
      expect(library2, isNotNull); 
 
      //library1.display(prefix: "random1"); 
      //library2.display(prefix: "random2"); 
    }); 
 
    test("Update library id with try", () { 
      // no id attribute 
    }); 
 
    test("Update library id without try", () { 
      // no id attribute 
    }); 
 
    test("Update library id with success", () { 
      // no id attribute 
    }); 
 
    test("Update library non id attribute with failure", () { 
      var randomLibrary = kanbanModel.libraries.random(); 
      var afterUpdateEntity = randomLibrary.copy(); 
      afterUpdateEntity.name = 'ball'; 
      expect(afterUpdateEntity.name, equals('ball')); 
      // libraries.update can only be used if oid, code or id is set. 
      expect(() => libraries.update(randomLibrary, afterUpdateEntity), throwsA(isA<Exception>())); 
    }); 
 
    test("Copy Equality", () { 
      var randomLibrary = kanbanModel.libraries.random(); 
      randomLibrary.display(prefix:"before copy: "); 
      var randomLibraryCopy = randomLibrary.copy(); 
      randomLibraryCopy.display(prefix:"after copy: "); 
      expect(randomLibrary, equals(randomLibraryCopy)); 
      expect(randomLibrary.oid, equals(randomLibraryCopy.oid)); 
      expect(randomLibrary.code, equals(randomLibraryCopy.code)); 
      expect(randomLibrary.name, equals(randomLibraryCopy.name)); 
 
    }); 
 
    test("library action undo and redo", () { 
      var libraryCount = libraries.length; 
      var library = Library(libraries.concept); 
        library.name = 'navigation'; 
      libraries.add(library); 
      expect(libraries.length, equals(++libraryCount)); 
      libraries.remove(library); 
      expect(libraries.length, equals(--libraryCount)); 
 
      var action = AddCommand(session, libraries, library); 
      action.doIt(); 
      expect(libraries.length, equals(++libraryCount)); 
 
      action.undo(); 
      expect(libraries.length, equals(--libraryCount)); 
 
      action.redo(); 
      expect(libraries.length, equals(++libraryCount)); 
    }); 
 
    test("library session undo and redo", () { 
      var libraryCount = libraries.length; 
      var library = Library(libraries.concept); 
        library.name = 'abstract'; 
      libraries.add(library); 
      expect(libraries.length, equals(++libraryCount)); 
      libraries.remove(library); 
      expect(libraries.length, equals(--libraryCount)); 
 
      var action = AddCommand(session, libraries, library); 
      action.doIt(); 
      expect(libraries.length, equals(++libraryCount)); 
 
      session.past.undo(); 
      expect(libraries.length, equals(--libraryCount)); 
 
      session.past.redo(); 
      expect(libraries.length, equals(++libraryCount)); 
    }); 
 
    test("Library update undo and redo", () { 
      var library = kanbanModel.libraries.random(); 
      var action = SetAttributeCommand(session, library, "name", 'book'); 
      action.doIt(); 
 
      session.past.undo(); 
      expect(library.name, equals(action.before)); 
 
      session.past.redo(); 
      expect(library.name, equals(action.after)); 
    }); 
 
    test("Library action with multiple undos and redos", () { 
      var libraryCount = libraries.length; 
      var library1 = kanbanModel.libraries.random(); 
 
      var action1 = RemoveCommand(session, libraries, library1); 
      action1.doIt(); 
      expect(libraries.length, equals(--libraryCount)); 
 
      var library2 = kanbanModel.libraries.random(); 
 
      var action2 = RemoveCommand(session, libraries, library2); 
      action2.doIt(); 
      expect(libraries.length, equals(--libraryCount)); 
 
      //session.past.display(); 
 
      session.past.undo(); 
      expect(libraries.length, equals(++libraryCount)); 
 
      session.past.undo(); 
      expect(libraries.length, equals(++libraryCount)); 
 
      //session.past.display(); 
 
      session.past.redo(); 
      expect(libraries.length, equals(--libraryCount)); 
 
      session.past.redo(); 
      expect(libraries.length, equals(--libraryCount)); 
 
      //session.past.display(); 
    }); 
 
    test("Transaction undo and redo", () { 
      var libraryCount = libraries.length; 
      var library1 = kanbanModel.libraries.random(); 
      var library2 = kanbanModel.libraries.random(); 
      while (library1 == library2) { 
        library2 = kanbanModel.libraries.random();  
      } 
      var action1 = RemoveCommand(session, libraries, library1); 
      var action2 = RemoveCommand(session, libraries, library2); 
 
      var transaction = new Transaction("two removes on libraries", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      transaction.doIt(); 
      libraryCount = libraryCount - 2; 
      expect(libraries.length, equals(libraryCount)); 
 
      libraries.display(title:"Transaction Done"); 
 
      session.past.undo(); 
      libraryCount = libraryCount + 2; 
      expect(libraries.length, equals(libraryCount)); 
 
      libraries.display(title:"Transaction Undone"); 
 
      session.past.redo(); 
      libraryCount = libraryCount - 2; 
      expect(libraries.length, equals(libraryCount)); 
 
      libraries.display(title:"Transaction Redone"); 
    }); 
 
    test("Transaction with one action error", () { 
      var libraryCount = libraries.length; 
      var library1 = kanbanModel.libraries.random(); 
      var library2 = library1; 
      var action1 = RemoveCommand(session, libraries, library1); 
      var action2 = RemoveCommand(session, libraries, library2); 
 
      var transaction = Transaction( 
        "two removes on libraries, with an error on the second", session); 
      transaction.add(action1); 
      transaction.add(action2); 
      var done = transaction.doIt(); 
      expect(done, isFalse); 
      expect(libraries.length, equals(libraryCount)); 
 
      //libraries.display(title:"Transaction with an error"); 
    }); 
 
    test("Reactions to library actions", () { 
      var libraryCount = libraries.length; 
 
      var reaction = LibraryReaction(); 
      expect(reaction, isNotNull); 
 
      projectDomain.startCommandReaction(reaction); 
      var library = Library(libraries.concept); 
        library.name = 'debt'; 
      libraries.add(library); 
      expect(libraries.length, equals(++libraryCount)); 
      libraries.remove(library); 
      expect(libraries.length, equals(--libraryCount)); 
 
      var session = projectDomain.newSession(); 
      var addCommand = AddCommand(session, libraries, library); 
      addCommand.doIt(); 
      expect(libraries.length, equals(++libraryCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      var setAttributeCommand = SetAttributeCommand( 
        session, library, "name", 'center'); 
      setAttributeCommand.doIt(); 
      expect(reaction.reactedOnUpdate, isTrue); 
      projectDomain.cancelCommandReaction(reaction); 
    }); 
 
  }); 
} 
 
class LibraryReaction implements ICommandReaction { 
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
  var repository = ProjectKanbanRepo(); 
  ProjectDomain projectDomain = repository.getDomainModels("Project") as ProjectDomain;   
  assert(projectDomain != null); 
  KanbanModel kanbanModel = projectDomain.getModelEntries("Kanban") as KanbanModel;  
  assert(kanbanModel != null); 
  var libraries = kanbanModel.libraries; 
  testProjectKanbanLibraries(projectDomain, kanbanModel, libraries); 
} 
 
