part of library_user; 
 
// lib/gen/library/user/books.dart 
 
abstract class BookGen extends Entity<Book> { 
 
  BookGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
