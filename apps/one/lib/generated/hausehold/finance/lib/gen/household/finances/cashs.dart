part of household_finances; 
 
// lib/gen/household/finances/cashs.dart 
 
abstract class CashGen extends Entity<Cash> { 
 
  CashGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Cash newEntity() => Cash(concept); 
  Cashs newEntities() => Cashs(concept); 
  
} 
 
abstract class CashsGen extends Entities<Cash> { 
 
  CashsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Cashs newEntities() => Cashs(concept); 
  Cash newEntity() => Cash(concept); 
  
} 
 
