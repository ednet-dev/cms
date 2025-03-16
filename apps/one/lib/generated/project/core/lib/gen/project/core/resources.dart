part of '../../../project_core.dart';

// lib/gen/project/core/resources.dart

abstract class ResourceGen extends Entity<Resource> {
  ResourceGen(Concept concept) {
    this.concept = concept;
        final skillConcept = 
        concept.model.concepts.singleWhereCode('Skill');
    assert(skillConcept != null, 'Skill concept is not defined');
    setChild('skills', Skills(skillConcept!));

  }
  

    Reference get taskReference => getReference('task')!;
  
  set taskReference(Reference reference) => 
      setReference('task', reference);
  Task get task =>
      getParent('task')! as Task;
  
  set task(Task p) => setParent('task', p);


    String get name => getAttribute('name') as String;
  
  set name(String a) => setAttribute('name', a);

  String get type => getAttribute('type') as String;
  
  set type(String a) => setAttribute('type', a);

  double get cost => getAttribute('cost') as double;
  
  set cost(double a) => setAttribute('cost', a);


    Skills get skills => getChild('skills')! as Skills;

  @override
  Resource newEntity() => Resource(concept);

  @override
  Resources newEntities() => Resources(concept);

  
}

abstract class ResourcesGen extends Entities<Resource> {
  ResourcesGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Resources newEntities() => Resources(concept);

  @override
  Resource newEntity() => Resource(concept);
}

// Commands for Resource will be generated here
// Events for Resource will be generated here
// Policies for Resource will be generated here
