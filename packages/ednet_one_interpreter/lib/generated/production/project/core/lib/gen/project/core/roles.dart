part of '../../../project_core.dart';

// lib/gen/project/core/roles.dart

abstract class RoleGen extends Entity<Role> {
  RoleGen(Concept concept) {
    this.concept = concept;
    // concept.children.isEmpty
  }
  

    Reference get teamReference => getReference('team')!;
  
  set teamReference(Reference reference) => 
      setReference('team', reference);
  Team get team =>
      getParent('team')! as Team;
  
  set team(Team p) => setParent('team', p);


    String get title => getAttribute('title') as String;
  
  set title(String a) => setAttribute('title', a);

  String get responsibility => getAttribute('responsibility') as String;
  
  set responsibility(String a) => setAttribute('responsibility', a);


  
  @override
  Role newEntity() => Role(concept);

  @override
  Roles newEntities() => Roles(concept);

  
}

abstract class RolesGen extends Entities<Role> {
  RolesGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Roles newEntities() => Roles(concept);

  @override
  Role newEntity() => Role(concept);
}

// Commands for Role will be generated here
// Events for Role will be generated here
// Policies for Role will be generated here
