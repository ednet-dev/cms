part of household_project; 
 
// lib/gen/household/project/initiatives.dart 
 
abstract class InitiativeGen extends Entity<Initiative> { 
 
  InitiativeGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get projectReference => getReference("project") as Reference; 
  void set projectReference(Reference reference) { setReference("project", reference); } 
  
  Project get project => getParent("project") as Project; 
  void set project(Project p) { setParent("project", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
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
 
