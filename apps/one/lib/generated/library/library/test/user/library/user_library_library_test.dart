 
// test/user/library/user_library_library_test.dart 
 
import "package:test/test.dart"; 
import "package:ednet_core/ednet_core.dart"; 
import "package:user_library/user_library.dart"; 
 
void testUserLibraryLibraries( 
    UserDomain userDomain, LibraryModel libraryModel, Libraries libraries) { 
  DomainSession session; 
  group("Testing User.Library.Library", () { 
    session = userDomain.newSession();  
    setUp(() { 
      libraryModel.init(); 
    }); 
    tearDown(() { 
      libraryModel.clear(); 
    }); 
 
    test("Not empty model", () { 
      expect(libraryModel.isEmpty, isFalse); 
      expect(libraries.isEmpty, isFalse); 
    }); 
 
    test("Empty model", () { 
      libraryModel.clear(); 
      expect(libraryModel.isEmpty, isTrue); 
      expect(libraries.isEmpty, isTrue); 
      expect(libraries.exceptions.isEmpty, isTrue); 
    }); 
 
    test("From model to JSON", () { 
      var json = libraryModel.toJson(); 
      expect(json, isNotNull); 
 
      print(json); 
      //libraryModel.displayJson(); 
      //libraryModel.display(); 
    }); 
 
    test("From JSON to model", () { 
      var json = libraryModel.toJson(); 
      libraryModel.clear(); 
      expect(libraryModel.isEmpty, isTrue); 
      libraryModel.fromJson(json); 
      expect(libraryModel.isEmpty, isFalse); 
 
      libraryModel.display(); 
    }); 
 
    test("From model entry to JSON", () { 
      var json = libraryModel.fromEntryToJson("Library"); 
      expect(json, isNotNull); 
 
      print(json); 
      //libraryModel.displayEntryJson("Library"); 
      //libraryModel.displayJson(); 
      //libraryModel.display(); 
    }); 
 
    test("From JSON to model entry", () { 
      var json = libraryModel.fromEntryToJson("Library"); 
      libraries.clear(); 
      expect(libraries.isEmpty, isTrue); 
      libraryModel.fromJsonToEntry(json); 
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
      var randomLibrary = libraryModel.libraries.random(); 
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
      // no attribute that is not required 
    }); 
 
    test("Select libraries by attribute", () { 
      // no attribute that is not required 
    }); 
 
    test("Select libraries by required attribute", () { 
      // no required attribute that is not id 
    }); 
 
    test("Select libraries by attribute, then add", () { 
      // no attribute that is not id 
    }); 
 
    test("Select libraries by attribute, then remove", () { 
      // no attribute that is not id 
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
      var library1 = libraryModel.libraries.random(); 
      expect(library1, isNotNull); 
      var library2 = libraryModel.libraries.random(); 
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
      // no attribute that is not id 
    }); 
 
    test("Copy Equality", () { 
      var randomLibrary = libraryModel.libraries.random(); 
      randomLibrary.display(prefix:"before copy: "); 
      var randomLibraryCopy = randomLibrary.copy(); 
      randomLibraryCopy.display(prefix:"after copy: "); 
      expect(randomLibrary, equals(randomLibraryCopy)); 
      expect(randomLibrary.oid, equals(randomLibraryCopy.oid)); 
      expect(randomLibrary.code, equals(randomLibraryCopy.code)); 
 
    }); 
 
    test("library action undo and redo", () { 
      var libraryCount = libraries.length; 
      var library = Library(libraries.concept); 
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
      // no attribute that is not id 
    }); 
 
    test("Library action with multiple undos and redos", () { 
      var libraryCount = libraries.length; 
      var library1 = libraryModel.libraries.random(); 
 
      var action1 = RemoveCommand(session, libraries, library1); 
      action1.doIt(); 
      expect(libraries.length, equals(--libraryCount)); 
 
      var library2 = libraryModel.libraries.random(); 
 
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
      var library1 = libraryModel.libraries.random(); 
      var library2 = libraryModel.libraries.random(); 
      while (library1 == library2) { 
        library2 = libraryModel.libraries.random();  
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
      var library1 = libraryModel.libraries.random(); 
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
 
      userDomain.startCommandReaction(reaction); 
      var library = Library(libraries.concept); 
        libraries.add(library); 
      expect(libraries.length, equals(++libraryCount)); 
      libraries.remove(library); 
      expect(libraries.length, equals(--libraryCount)); 
 
      var session = userDomain.newSession(); 
      var addCommand = AddCommand(session, libraries, library); 
      addCommand.doIt(); 
      expect(libraries.length, equals(++libraryCount)); 
      expect(reaction.reactedOnAdd, isTrue); 
 
      // no attribute that is not id 
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
  var repository = Repository(); 
  UserDomain userDomain = repository.getDomainModels("User") as UserDomain;   
  assert(userDomain != null); 
  LibraryModel libraryModel = userDomain.getModelEntries("Library") as LibraryModel;  
  assert(libraryModel != null); 
  var libraries = libraryModel.libraries; 
  testUserLibraryLibraries(userDomain, libraryModel, libraries); 
} 
 