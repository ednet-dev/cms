part of ednet_one; 
 
// lib/gen/ednet/one/items.dart 
 
abstract class ItemGen extends Entity<Item> { 
 
  ItemGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Item newEntity() => Item(concept); 
  Items newEntities() => Items(concept); 
  
} 
 
abstract class ItemsGen extends Entities<Item> { 
 
  ItemsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Items newEntities() => Items(concept); 
  Item newEntity() => Item(concept); 
  
} 
 
