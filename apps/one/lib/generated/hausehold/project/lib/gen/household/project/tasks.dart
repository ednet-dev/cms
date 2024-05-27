part of household_project; 
 
// lib/gen/household/project/tasks.dart 
 
abstract class TaskGen extends Entity<Task> { 
 
  TaskGen(Concept concept) { 
    this.concept = concept; 
    Concept resourceConcept = concept.model.concepts.singleWhereCode("Resource") as Concept; 
    assert(resourceConcept != null); 
    setChild("resources", Resources(resourceConcept)); 
  } 
 
  Reference get projectReference => getReference("project") as Reference; 
  void set projectReference(Reference reference) { setReference("project", reference); } 
  
  Project get project => getParent("project") as Project; 
  void set project(Project p) { setParent("project", p); } 
  
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  DateTime get dueDate => getAttribute("dueDate"); 
  void set dueDate(DateTime a) { setAttribute("dueDate", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  String get priority => getAttribute("priority"); 
  void set priority(String a) { setAttribute("priority", a); } 
  
  Resources get resources => getChild("resources") as Resources; 
  
  Task newEntity() => Task(concept); 
  Tasks newEntities() => Tasks(concept); 
  
} 
 
abstract class TasksGen extends Entities<Task> { 
 
  TasksGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Tasks newEntities() => Tasks(concept); 
  Task newEntity() => Task(concept); 
  
} 
 
