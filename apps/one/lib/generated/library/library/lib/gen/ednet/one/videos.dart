part of ednet_one; 
 
// lib/gen/ednet/one/videos.dart 
 
abstract class VideoGen extends Entity<Video> { 
 
  VideoGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Video newEntity() => Video(concept); 
  Videos newEntities() => Videos(concept); 
  
} 
 
abstract class VideosGen extends Entities<Video> { 
 
  VideosGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Videos newEntities() => Videos(concept); 
  Video newEntity() => Video(concept); 
  
} 
 
