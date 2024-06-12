part of project_kanban; 
 
// lib/gen/project/kanban/authors.dart 
 
abstract class AuthorGen extends Entity<Author> { 
 
  AuthorGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get image => getAttribute("image"); 
  void set image(String a) { setAttribute("image", a); } 
  
  String get bio => getAttribute("bio"); 
  void set bio(String a) { setAttribute("bio", a); } 
  
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
 
