part of household_project; 
 
// lib/gen/household/project/roles.dart 
 
abstract class RoleGen extends Entity<Role> { 
 
  RoleGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get teamReference => getReference("team") as Reference; 
  void set teamReference(Reference reference) { setReference("team", reference); } 
  
  Team get team => getParent("team") as Team; 
  void set team(Team p) { setParent("team", p); } 
  
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get responsibility => getAttribute("responsibility"); 
  void set responsibility(String a) { setAttribute("responsibility", a); } 
  
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
 
