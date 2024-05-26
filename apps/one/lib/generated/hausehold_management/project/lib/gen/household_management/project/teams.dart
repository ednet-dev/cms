part of household_management_project; 
 
// lib/gen/household_management/project/teams.dart 
 
abstract class TeamGen extends Entity<Team> { 
 
  TeamGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
