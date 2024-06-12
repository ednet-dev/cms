part of project_user; 
 
// lib/gen/project/user/bookmarkss.dart 
 
abstract class BookmarksGen extends Entity<Bookmarks> { 
 
  BookmarksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get url => getAttribute("url"); 
  void set url(String a) { setAttribute("url", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Bookmarks newEntity() => Bookmarks(concept); 
  Bookmarkss newEntities() => Bookmarkss(concept); 
  
} 
 
abstract class BookmarkssGen extends Entities<Bookmarks> { 
 
  BookmarkssGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Bookmarkss newEntities() => Bookmarkss(concept); 
  Bookmarks newEntity() => Bookmarks(concept); 
  
} 
 
