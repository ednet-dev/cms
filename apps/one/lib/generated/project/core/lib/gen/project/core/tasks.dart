part of '../../../project_core.dart';

// lib/gen/project/core/tasks.dart

abstract class TaskGen extends Entity<Task> {
  TaskGen(Concept concept) {
    this.concept = concept;
        final resourceConcept = 
        concept.model.concepts.singleWhereCode('Resource');
    assert(resourceConcept != null, 'Resource concept is not defined');
    setChild('resources', Resources(resourceConcept!));

  }
  

    Reference get projectReference => getReference('project')!;
  
  set projectReference(Reference reference) => 
      setReference('project', reference);
  Project get project =>
      getParent('project')! as Project;
  
  set project(Project p) => setParent('project', p);


    String get title => getAttribute('title') as String;
  
  set title(String a) => setAttribute('title', a);

  DateTime get dueDate => getAttribute('dueDate') as DateTime;
  
  set dueDate(DateTime a) => setAttribute('dueDate', a);

  String get status => getAttribute('status') as String;
  
  set status(String a) => setAttribute('status', a);

  String get priority => getAttribute('priority') as String;
  
  set priority(String a) => setAttribute('priority', a);


    Resources get resources => getChild('resources')! as Resources;

  @override
  Task newEntity() => Task(concept);

  @override
  Tasks newEntities() => Tasks(concept);

  
}

abstract class TasksGen extends Entities<Task> {
  TasksGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Tasks newEntities() => Tasks(concept);

  @override
  Task newEntity() => Task(concept);
}

// Commands for Task will be generated here
// Events for Task will be generated here
// Policies for Task will be generated here
