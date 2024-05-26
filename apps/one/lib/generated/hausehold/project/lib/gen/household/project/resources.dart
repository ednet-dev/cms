part of household_project; 
 
// lib/gen/household/project/resources.dart 
 
abstract class ResourceGen extends Entity<Resource> { 
 
  ResourceGen(Concept concept) { 
    this.concept = concept; 
    Concept skillConcept = concept.model.concepts.singleWhereCode("Skill") as Concept; 
    assert(skillConcept != null); 
    setChild("skills", Skills(skillConcept)); 
  } 
 
  Reference get taskReference => getReference("task") as Reference; 
  void set taskReference(Reference reference) { setReference("task", reference); } 
  
  Task get task => getParent("task") as Task; 
  void set task(Task p) { setParent("task", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  double get cost => getAttribute("cost"); 
  void set cost(double a) { setAttribute("cost", a); } 
  
  Skills get skills => getChild("skills") as Skills; 
  
  Resource newEntity() => Resource(concept); 
  Resources newEntities() => Resources(concept); 
  
} 
 
abstract class ResourcesGen extends Entities<Resource> { 
 
  ResourcesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Resources newEntities() => Resources(concept); 
  Resource newEntity() => Resource(concept); 
  
} 
 
