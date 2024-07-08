part of project_kanban; 
 
// lib/gen/project/kanban/genres.dart 
 
abstract class GenreGen extends Entity<Genre> { 
 
  GenreGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Genre newEntity() => Genre(concept); 
  Genres newEntities() => Genres(concept); 
  
} 
 
abstract class GenresGen extends Entities<Genre> { 
 
  GenresGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Genres newEntities() => Genres(concept); 
  Genre newEntity() => Genre(concept); 
  
} 
 
