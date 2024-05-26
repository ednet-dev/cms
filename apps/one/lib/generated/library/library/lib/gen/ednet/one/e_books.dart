part of ednet_one; 
 
// lib/gen/ednet/one/e_books.dart 
 
abstract class eBookGen extends Entity<eBook> { 
 
  eBookGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
