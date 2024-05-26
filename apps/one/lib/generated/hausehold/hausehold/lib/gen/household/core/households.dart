part of household_core; 
 
// lib/gen/household/core/households.dart 
 
abstract class HouseholdGen extends Entity<Household> { 
 
  HouseholdGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Household newEntity() => Household(concept); 
  Households newEntities() => Households(concept); 
  
} 
 
abstract class HouseholdsGen extends Entities<Household> { 
 
  HouseholdsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Households newEntities() => Households(concept); 
  Household newEntity() => Household(concept); 
  
} 
 
