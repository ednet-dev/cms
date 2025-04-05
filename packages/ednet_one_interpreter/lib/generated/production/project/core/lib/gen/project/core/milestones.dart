part of '../../../project_core.dart';

// lib/gen/project/core/milestones.dart

abstract class MilestoneGen extends Entity<Milestone> {
  MilestoneGen(Concept concept) {
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

  DateTime get date => getAttribute('date') as DateTime;
  
  set date(DateTime a) => setAttribute('date', a);


  
  @override
  Milestone newEntity() => Milestone(concept);

  @override
  Milestones newEntities() => Milestones(concept);

  
}

abstract class MilestonesGen extends Entities<Milestone> {
  MilestonesGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Milestones newEntities() => Milestones(concept);

  @override
  Milestone newEntity() => Milestone(concept);
}

// Commands for Milestone will be generated here
// Events for Milestone will be generated here
// Policies for Milestone will be generated here
