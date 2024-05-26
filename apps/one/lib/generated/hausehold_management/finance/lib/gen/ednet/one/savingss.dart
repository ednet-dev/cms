part of ednet_one; 
 
// lib/gen/ednet/one/savingss.dart 
 
abstract class SavingsGen extends Entity<Savings> { 
 
  SavingsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Savings newEntity() => Savings(concept); 
  Savingss newEntities() => Savingss(concept); 
  
} 
 
abstract class SavingssGen extends Entities<Savings> { 
 
  SavingssGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Savingss newEntities() => Savingss(concept); 
  Savings newEntity() => Savings(concept); 
  
} 
 
