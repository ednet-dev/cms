part of user_library; 
 
// lib/gen/user/library/movies.dart 
 
abstract class MovieGen extends Entity<Movie> { 
 
  MovieGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Movie newEntity() => Movie(concept); 
  Movies newEntities() => Movies(concept); 
  
} 
 
abstract class MoviesGen extends Entities<Movie> { 
 
  MoviesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Movies newEntities() => Movies(concept); 
  Movie newEntity() => Movie(concept); 
  
} 
 
