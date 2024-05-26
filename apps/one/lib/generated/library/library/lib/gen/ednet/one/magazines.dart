part of ednet_one; 
 
// lib/gen/ednet/one/magazines.dart 
 
abstract class MagazineGen extends Entity<Magazine> { 
 
  MagazineGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Magazine newEntity() => Magazine(concept); 
  Magazines newEntities() => Magazines(concept); 
  
} 
 
abstract class MagazinesGen extends Entities<Magazine> { 
 
  MagazinesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Magazines newEntities() => Magazines(concept); 
  Magazine newEntity() => Magazine(concept); 
  
} 
 
