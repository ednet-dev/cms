part of ednet_one; 
 
// lib/gen/ednet/one/newspapers.dart 
 
abstract class NewspaperGen extends Entity<Newspaper> { 
 
  NewspaperGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Newspaper newEntity() => Newspaper(concept); 
  Newspapers newEntities() => Newspapers(concept); 
  
} 
 
abstract class NewspapersGen extends Entities<Newspaper> { 
 
  NewspapersGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Newspapers newEntities() => Newspapers(concept); 
  Newspaper newEntity() => Newspaper(concept); 
  
} 
 
