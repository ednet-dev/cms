part of household_project; 
 
// lib/gen/household/project/budgets.dart 
 
abstract class BudgetGen extends Entity<Budget> { 
 
  BudgetGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get projectReference => getReference("project") as Reference; 
  void set projectReference(Reference reference) { setReference("project", reference); } 
  
  Project get project => getParent("project") as Project; 
  void set project(Project p) { setParent("project", p); } 
  
  double get amount => getAttribute("amount"); 
  void set amount(double a) { setAttribute("amount", a); } 
  
  String get currency => getAttribute("currency"); 
  void set currency(String a) { setAttribute("currency", a); } 
  
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
 
