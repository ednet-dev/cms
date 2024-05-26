part of ednet_one; 
 
// lib/gen/ednet/one/d_v_ds.dart 
 
abstract class DVDGen extends Entity<DVD> { 
 
  DVDGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  DVD newEntity() => DVD(concept); 
  DVDs newEntities() => DVDs(concept); 
  
} 
 
abstract class DVDsGen extends Entities<DVD> { 
 
  DVDsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  DVDs newEntities() => DVDs(concept); 
  DVD newEntity() => DVD(concept); 
  
} 
 
