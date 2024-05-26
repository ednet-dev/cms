part of ednet_one; 
 
// lib/gen/ednet/one/transactions.dart 
 
abstract class TransactionGen extends Entity<Transaction> { 
 
  TransactionGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Transaction newEntity() => Transaction(concept); 
  Transactions newEntities() => Transactions(concept); 
  
} 
 
abstract class TransactionsGen extends Entities<Transaction> { 
 
  TransactionsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Transactions newEntities() => Transactions(concept); 
  Transaction newEntity() => Transaction(concept); 
  
} 
 
