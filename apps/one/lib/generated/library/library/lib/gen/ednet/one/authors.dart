part of ednet_one; 
 
// lib/gen/ednet/one/authors.dart 
 
abstract class AuthorGen extends Entity<Author> { 
 
  AuthorGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Author newEntity() => Author(concept); 
  Authors newEntities() => Authors(concept); 
  
} 
 
abstract class AuthorsGen extends Entities<Author> { 
 
  AuthorsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Authors newEntities() => Authors(concept); 
  Author newEntity() => Author(concept); 
  
} 
 
