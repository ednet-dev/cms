part of ednet_one; 
 
// lib/gen/ednet/one/images.dart 
 
abstract class ImageGen extends Entity<Image> { 
 
  ImageGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Image newEntity() => Image(concept); 
  Images newEntities() => Images(concept); 
  
} 
 
abstract class ImagesGen extends Entities<Image> { 
 
  ImagesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Images newEntities() => Images(concept); 
  Image newEntity() => Image(concept); 
  
} 
 
