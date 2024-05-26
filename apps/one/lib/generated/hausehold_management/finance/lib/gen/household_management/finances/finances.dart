part of household_management_finances; 
 
// lib/gen/household_management/finances/finances.dart 
 
abstract class FinanceGen extends Entity<Finance> { 
 
  FinanceGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Finance newEntity() => Finance(concept); 
  Finances newEntities() => Finances(concept); 
  
} 
 
abstract class FinancesGen extends Entities<Finance> { 
 
  FinancesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Finances newEntities() => Finances(concept); 
  Finance newEntity() => Finance(concept); 
  
} 
 