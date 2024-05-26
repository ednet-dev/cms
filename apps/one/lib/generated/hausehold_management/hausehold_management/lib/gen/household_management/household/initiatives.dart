part of household_management_household; 
 
// lib/gen/household_management/household/initiatives.dart 
 
abstract class InitiativeGen extends Entity<Initiative> { 
 
  InitiativeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Initiative newEntity() => Initiative(concept); 
  Initiatives newEntities() => Initiatives(concept); 
  
} 
 
abstract class InitiativesGen extends Entities<Initiative> { 
 
  InitiativesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Initiatives newEntities() => Initiatives(concept); 
  Initiative newEntity() => Initiative(concept); 
  
} 
 
