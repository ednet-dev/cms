part of project_kanban; 
 
// lib/gen/project/kanban/books.dart 
 
abstract class BookGen extends Entity<Book> { 
 
  BookGen(Concept concept) { 
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
  
  String get isbn => getAttribute("isbn"); 
  void set isbn(String a) { setAttribute("isbn", a); } 
  
  String get pages => getAttribute("pages"); 
  void set pages(String a) { setAttribute("pages", a); } 
  
  String get published => getAttribute("published"); 
  void set published(String a) { setAttribute("published", a); } 
  
  String get language => getAttribute("language"); 
  void set language(String a) { setAttribute("language", a); } 
  
  String get format => getAttribute("format"); 
  void set format(String a) { setAttribute("format", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  Book newEntity() => Book(concept); 
  Books newEntities() => Books(concept); 
  
} 
 
abstract class BooksGen extends Entities<Book> { 
 
  BooksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Books newEntities() => Books(concept); 
  Book newEntity() => Book(concept); 
  
} 
 
