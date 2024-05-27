part of user_library; 
 
// lib/gen/user/library/libraries.dart 
 
abstract class LibraryGen extends Entity<Library> { 
 
  LibraryGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Library newEntity() => Library(concept); 
  Libraries newEntities() => Libraries(concept); 
  
} 
 
abstract class LibrariesGen extends Entities<Library> { 
 
  LibrariesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Libraries newEntities() => Libraries(concept); 
  Library newEntity() => Library(concept); 
  
} 
 
