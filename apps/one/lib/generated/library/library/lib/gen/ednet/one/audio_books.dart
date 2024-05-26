part of ednet_one; 
 
// lib/gen/ednet/one/audio_books.dart 
 
abstract class AudioBookGen extends Entity<AudioBook> { 
 
  AudioBookGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  AudioBook newEntity() => AudioBook(concept); 
  AudioBooks newEntities() => AudioBooks(concept); 
  
} 
 
abstract class AudioBooksGen extends Entities<AudioBook> { 
 
  AudioBooksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  AudioBooks newEntities() => AudioBooks(concept); 
  AudioBook newEntity() => AudioBook(concept); 
  
} 
 
