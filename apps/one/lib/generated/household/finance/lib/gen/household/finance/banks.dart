part of household_finance; 
 
// lib/gen/household/finance/banks.dart 
 
abstract class BankGen extends Entity<Bank> { 
 
  BankGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Bank newEntity() => Bank(concept); 
  Banks newEntities() => Banks(concept); 
  
} 
 
abstract class BanksGen extends Entities<Bank> { 
 
  BanksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Banks newEntities() => Banks(concept); 
  Bank newEntity() => Bank(concept); 
  
} 
 
