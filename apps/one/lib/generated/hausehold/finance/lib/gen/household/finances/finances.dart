part of household_finances; 
 
// lib/gen/household/finances/finances.dart 
 
abstract class FinanceGen extends Entity<Finance> { 
 
  FinanceGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
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
 
