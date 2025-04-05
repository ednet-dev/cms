part of household_finance; 
 
// lib/gen/household/finance/credit_cards.dart 
 
abstract class CreditCardGen extends Entity<CreditCard> { 
 
  CreditCardGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CreditCard newEntity() => CreditCard(concept); 
  CreditCards newEntities() => CreditCards(concept); 
  
} 
 
abstract class CreditCardsGen extends Entities<CreditCard> { 
 
  CreditCardsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  CreditCards newEntities() => CreditCards(concept); 
  CreditCard newEntity() => CreditCard(concept); 
  
} 
 
