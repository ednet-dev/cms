part of user_library; 
 
// lib/gen/user/library/publishers.dart 
 
abstract class PublisherGen extends Entity<Publisher> { 
 
  PublisherGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Publisher newEntity() => Publisher(concept); 
  Publishers newEntities() => Publishers(concept); 
  
} 
 
abstract class PublishersGen extends Entities<Publisher> { 
 
  PublishersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Publishers newEntities() => Publishers(concept); 
  Publisher newEntity() => Publisher(concept); 
  
} 
 
