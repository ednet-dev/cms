part of '../../../project_core.dart';

// lib/gen/project/core/skills.dart

abstract class SkillGen extends Entity<Skill> {
  SkillGen(Concept concept) {
    this.concept = concept;
    // concept.children.isEmpty
  }
  

    Reference get resourceReference => getReference('resource')!;
  
  set resourceReference(Reference reference) => 
      setReference('resource', reference);
  Resource get resource =>
      getParent('resource')! as Resource;
  
  set resource(Resource p) => setParent('resource', p);


    String get name => getAttribute('name') as String;
  
  set name(String a) => setAttribute('name', a);

  String get level => getAttribute('level') as String;
  
  set level(String a) => setAttribute('level', a);


  
  @override
  Skill newEntity() => Skill(concept);

  @override
  Skills newEntities() => Skills(concept);

  
}

abstract class SkillsGen extends Entities<Skill> {
  SkillsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Skills newEntities() => Skills(concept);

  @override
  Skill newEntity() => Skill(concept);
}

// Commands for Skill will be generated here
// Events for Skill will be generated here
// Policies for Skill will be generated here
