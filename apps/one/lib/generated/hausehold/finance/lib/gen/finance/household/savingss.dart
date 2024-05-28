part of finance_household; 
 
// lib/gen/finance/household/savingss.dart 
 
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
 
