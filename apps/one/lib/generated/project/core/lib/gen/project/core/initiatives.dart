part of '../../../project_core.dart';

// lib/gen/project/core/initiatives.dart

abstract class InitiativeGen extends Entity<Initiative> {
  InitiativeGen(Concept concept) {
    this.concept = concept;
    // concept.children.isEmpty
  }
  

    Reference get projectReference => getReference('project')!;
  
  set projectReference(Reference reference) => 
      setReference('project', reference);
  Project get project =>
      getParent('project')! as Project;
  
  set project(Project p) => setParent('project', p);


    String get name => getAttribute('name') as String;
  
  set name(String a) => setAttribute('name', a);


  
  @override
  Initiative newEntity() => Initiative(concept);

  @override
  Initiatives newEntities() => Initiatives(concept);

  
}

abstract class InitiativesGen extends Entities<Initiative> {
  InitiativesGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Initiatives newEntities() => Initiatives(concept);

  @override
  Initiative newEntity() => Initiative(concept);
}

// Commands for Initiative will be generated here
// Events for Initiative will be generated here
// Policies for Initiative will be generated here
