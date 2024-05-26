part of user_library; 
 
// lib/gen/user/library/t_v_shows.dart 
 
abstract class TVShowGen extends Entity<TVShow> { 
 
  TVShowGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  TVShow newEntity() => TVShow(concept); 
  TVShows newEntities() => TVShows(concept); 
  
} 
 
abstract class TVShowsGen extends Entities<TVShow> { 
 
  TVShowsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  TVShows newEntities() => TVShows(concept); 
  TVShow newEntity() => TVShow(concept); 
  
} 
 
