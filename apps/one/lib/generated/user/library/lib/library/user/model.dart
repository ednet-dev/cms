 
part of library_user; 
 
// lib/library/user/model.dart 
 
class UserModel extends UserEntries { 
 
  UserModel(Model model) : super(model); 
 
  void fromJsonToLibraryEntry() { 
    fromJsonToEntry(libraryUserLibraryEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(libraryUserModel); 
  } 
 
  void init() { 
    initLibraries(); 
  } 
 
  void initLibraries() { 
    var library1 = Library(libraries.concept); 
    library1.name = 'privacy'; 
    libraries.add(library1); 
 
    var library2 = Library(libraries.concept); 
    library2.name = 'tape'; 
    libraries.add(library2); 
 
    var library3 = Library(libraries.concept); 
    library3.name = 'end'; 
    libraries.add(library3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
