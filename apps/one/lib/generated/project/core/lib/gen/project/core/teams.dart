part of '../../../project_core.dart';

// lib/gen/project/core/teams.dart

abstract class TeamGen extends Entity<Team> {
  TeamGen(Concept concept) {
    this.concept = concept;
        final roleConcept = 
        concept.model.concepts.singleWhereCode('Role');
    assert(roleConcept != null, 'Role concept is not defined');
    setChild('roles', Roles(roleConcept!));

  }
  

    Reference get projectReference => getReference('project')!;
  
  set projectReference(Reference reference) => 
      setReference('project', reference);
  Project get project =>
      getParent('project')! as Project;
  
  set project(Project p) => setParent('project', p);


    String get name => getAttribute('name') as String;
  
  set name(String a) => setAttribute('name', a);


    Roles get roles => getChild('roles')! as Roles;

  @override
  Team newEntity() => Team(concept);

  @override
  Teams newEntities() => Teams(concept);

  
}

abstract class TeamsGen extends Entities<Team> {
  TeamsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Teams newEntities() => Teams(concept);

  @override
  Team newEntity() => Team(concept);
}

// Commands for Team will be generated here
// Events for Team will be generated here
// Policies for Team will be generated here
