part of household_project; 
 
// lib/gen/household/project/teams.dart 
 
abstract class TeamGen extends Entity<Team> { 
 
  TeamGen(Concept concept) { 
    this.concept = concept; 
    Concept roleConcept = concept.model.concepts.singleWhereCode("Role") as Concept; 
    assert(roleConcept != null); 
    setChild("roles", Roles(roleConcept)); 
  } 
 
  Reference get projectReference => getReference("project") as Reference; 
  void set projectReference(Reference reference) { setReference("project", reference); } 
  
  Project get project => getParent("project") as Project; 
  void set project(Project p) { setParent("project", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Roles get roles => getChild("roles") as Roles; 
  
  Team newEntity() => Team(concept); 
  Teams newEntities() => Teams(concept); 
  
} 
 
abstract class TeamsGen extends Entities<Team> { 
 
  TeamsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Teams newEntities() => Teams(concept); 
  Team newEntity() => Team(concept); 
  
} 
 
