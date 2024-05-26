part of user_library; 
 
// lib/gen/user/library/musics.dart 
 
abstract class MusicGen extends Entity<Music> { 
 
  MusicGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Music newEntity() => Music(concept); 
  Musics newEntities() => Musics(concept); 
  
} 
 
abstract class MusicsGen extends Entities<Music> { 
 
  MusicsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Musics newEntities() => Musics(concept); 
  Music newEntity() => Music(concept); 
  
} 
 
