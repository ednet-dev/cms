part of '../../../project_core.dart';

// lib/gen/project/core/projects.dart

abstract class ProjectGen extends Entity<Project> {
  ProjectGen(Concept concept) {
    this.concept = concept;
        final taskConcept = 
        concept.model.concepts.singleWhereCode('Task');
    assert(taskConcept != null, 'Task concept is not defined');
    setChild('tasks', Tasks(taskConcept!));
    final milestoneConcept = 
        concept.model.concepts.singleWhereCode('Milestone');
    assert(milestoneConcept != null, 'Milestone concept is not defined');
    setChild('milestones', Milestones(milestoneConcept!));
    final teamConcept = 
        concept.model.concepts.singleWhereCode('Team');
    assert(teamConcept != null, 'Team concept is not defined');
    setChild('teams', Teams(teamConcept!));
    final budgetConcept = 
        concept.model.concepts.singleWhereCode('Budget');
    assert(budgetConcept != null, 'Budget concept is not defined');
    setChild('budgets', Budgets(budgetConcept!));
    final initiativeConcept = 
        concept.model.concepts.singleWhereCode('Initiative');
    assert(initiativeConcept != null, 'Initiative concept is not defined');
    setChild('initiatives', Initiatives(initiativeConcept!));
    final timeConcept = 
        concept.model.concepts.singleWhereCode('Time');
    assert(timeConcept != null, 'Time concept is not defined');
    setChild('times', Times(timeConcept!));

  }
  

  

    String get name => getAttribute('name') as String;
  
  set name(String a) => setAttribute('name', a);

  String get description => getAttribute('description') as String;
  
  set description(String a) => setAttribute('description', a);

  DateTime get startDate => getAttribute('startDate') as DateTime;
  
  set startDate(DateTime a) => setAttribute('startDate', a);

  DateTime get endDate => getAttribute('endDate') as DateTime;
  
  set endDate(DateTime a) => setAttribute('endDate', a);

  double get budget => getAttribute('budget') as double;
  
  set budget(double a) => setAttribute('budget', a);


    Tasks get tasks => getChild('tasks')! as Tasks;

  Milestones get milestones => getChild('milestones')! as Milestones;

  Teams get teams => getChild('teams')! as Teams;

  Budgets get budgets => getChild('budgets')! as Budgets;

  Initiatives get initiatives => getChild('initiatives')! as Initiatives;

  Times get times => getChild('times')! as Times;

  @override
  Project newEntity() => Project(concept);

  @override
  Projects newEntities() => Projects(concept);

  
}

abstract class ProjectsGen extends Entities<Project> {
  ProjectsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Projects newEntities() => Projects(concept);

  @override
  Project newEntity() => Project(concept);
}

// Commands for Project will be generated here
// Events for Project will be generated here
// Policies for Project will be generated here
