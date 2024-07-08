part of settings_application; 
 
// lib/gen/settings/application/roles.dart 
 
abstract class RoleGen extends Entity<Role> { 
 
  RoleGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
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
 
