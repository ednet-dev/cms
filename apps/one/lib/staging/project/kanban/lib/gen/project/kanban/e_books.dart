part of project_kanban; 
 
// lib/gen/project/kanban/e_books.dart 
 
abstract class eBookGen extends Entity<eBook> { 
 
  eBookGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get author => getAttribute("author"); 
  void set author(String a) { setAttribute("author", a); } 
  
  String get publisher => getAttribute("publisher"); 
  void set publisher(String a) { setAttribute("publisher", a); } 
  
  String get genre => getAttribute("genre"); 
  void set genre(String a) { setAttribute("genre", a); } 
  
  String get series => getAttribute("series"); 
  void set series(String a) { setAttribute("series", a); } 
  
  String get location => getAttribute("location"); 
  void set location(String a) { setAttribute("location", a); } 
  
  String get published => getAttribute("published"); 
  void set published(String a) { setAttribute("published", a); } 
  
  String get language => getAttribute("language"); 
  void set language(String a) { setAttribute("language", a); } 
  
  String get format => getAttribute("format"); 
  void set format(String a) { setAttribute("format", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  eBook newEntity() => eBook(concept); 
  eBooks newEntities() => eBooks(concept); 
  
} 
 
abstract class eBooksGen extends Entities<eBook> { 
 
  eBooksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  eBooks newEntities() => eBooks(concept); 
  eBook newEntity() => eBook(concept); 
  
} 
 
