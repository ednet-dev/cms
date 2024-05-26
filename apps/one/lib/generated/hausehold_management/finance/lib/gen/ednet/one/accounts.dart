part of ednet_one; 
 
// lib/gen/ednet/one/accounts.dart 
 
abstract class AccountGen extends Entity<Account> { 
 
  AccountGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Account newEntity() => Account(concept); 
  Accounts newEntities() => Accounts(concept); 
  
} 
 
abstract class AccountsGen extends Entities<Account> { 
 
  AccountsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Accounts newEntities() => Accounts(concept); 
  Account newEntity() => Account(concept); 
  
} 
 
