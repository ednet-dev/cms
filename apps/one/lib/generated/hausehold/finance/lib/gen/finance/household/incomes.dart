part of finance_household; 
 
// lib/gen/finance/household/incomes.dart 
 
abstract class IncomeGen extends Entity<Income> { 
 
  IncomeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Income newEntity() => Income(concept); 
  Incomes newEntities() => Incomes(concept); 
  
} 
 
abstract class IncomesGen extends Entities<Income> { 
 
  IncomesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Incomes newEntities() => Incomes(concept); 
  Income newEntity() => Income(concept); 
  
} 
 
