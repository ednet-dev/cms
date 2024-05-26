part of household_project; 
 
// lib/gen/household/project/roles.dart 
 
abstract class RoleGen extends Entity<Role> { 
 
  RoleGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Role newEntity() => Role(concept); 
  Roles newEntities() => Roles(concept); 
  
} 
 
abstract class RolesGen extends Entities<Role> { 
 
  RolesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Roles newEntities() => Roles(concept); 
  Role newEntity() => Role(concept); 
  
} 
 
