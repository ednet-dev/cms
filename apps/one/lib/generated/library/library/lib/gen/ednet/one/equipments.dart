part of ednet_one; 
 
// lib/gen/ednet/one/equipments.dart 
 
abstract class EquipmentGen extends Entity<Equipment> { 
 
  EquipmentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Equipment newEntity() => Equipment(concept); 
  Equipments newEntities() => Equipments(concept); 
  
} 
 
abstract class EquipmentsGen extends Entities<Equipment> { 
 
  EquipmentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Equipments newEntities() => Equipments(concept); 
  Equipment newEntity() => Equipment(concept); 
  
} 
 
