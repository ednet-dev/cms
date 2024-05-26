part of household_management_project; 
 
// lib/gen/household_management/project/budgets.dart 
 
abstract class BudgetGen extends Entity<Budget> { 
 
  BudgetGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Budget newEntity() => Budget(concept); 
  Budgets newEntities() => Budgets(concept); 
  
} 
 
abstract class BudgetsGen extends Entities<Budget> { 
 
  BudgetsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Budgets newEntities() => Budgets(concept); 
  Budget newEntity() => Budget(concept); 
  
} 
 
