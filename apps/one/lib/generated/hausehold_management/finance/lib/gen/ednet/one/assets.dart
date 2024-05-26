part of ednet_one; 
 
// lib/gen/ednet/one/assets.dart 
 
abstract class AssetGen extends Entity<Asset> { 
 
  AssetGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Asset newEntity() => Asset(concept); 
  Assets newEntities() => Assets(concept); 
  
} 
 
abstract class AssetsGen extends Entities<Asset> { 
 
  AssetsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Assets newEntities() => Assets(concept); 
  Asset newEntity() => Asset(concept); 
  
} 
 
