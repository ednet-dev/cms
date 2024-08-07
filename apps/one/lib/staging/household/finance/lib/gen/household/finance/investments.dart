part of household_finance; 
 
// lib/gen/household/finance/investments.dart 
 
abstract class InvestmentGen extends Entity<Investment> { 
 
  InvestmentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Investment newEntity() => Investment(concept); 
  Investments newEntities() => Investments(concept); 
  
} 
 
abstract class InvestmentsGen extends Entities<Investment> { 
 
  InvestmentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Investments newEntities() => Investments(concept); 
  Investment newEntity() => Investment(concept); 
  
} 
 
