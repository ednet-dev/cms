part of ednet_one; 
 
// lib/gen/ednet/one/expenses.dart 
 
abstract class ExpenseGen extends Entity<Expense> { 
 
  ExpenseGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Expense newEntity() => Expense(concept); 
  Expenses newEntities() => Expenses(concept); 
  
} 
 
abstract class ExpensesGen extends Entities<Expense> { 
 
  ExpensesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Expenses newEntities() => Expenses(concept); 
  Expense newEntity() => Expense(concept); 
  
} 
 
