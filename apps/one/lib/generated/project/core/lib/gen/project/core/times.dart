part of '../../../project_core.dart';

// lib/gen/project/core/times.dart

abstract class TimeGen extends Entity<Time> {
  TimeGen(Concept concept) {
    this.concept = concept;
    // concept.children.isEmpty
  }
  

    Reference get projectReference => getReference('project')!;
  
  set projectReference(Reference reference) => 
      setReference('project', reference);
  Project get project =>
      getParent('project')! as Project;
  
  set project(Project p) => setParent('project', p);


    int get hours => getAttribute('hours') as int;
  
  set hours(int a) => setAttribute('hours', a);


  
  @override
  Time newEntity() => Time(concept);

  @override
  Times newEntities() => Times(concept);

  
}

abstract class TimesGen extends Entities<Time> {
  TimesGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Times newEntities() => Times(concept);

  @override
  Time newEntity() => Time(concept);
}

// Commands for Time will be generated here
// Events for Time will be generated here
// Policies for Time will be generated here
