part of project_core; 
 
// lib/gen/project/core/skills.dart 
 
abstract class SkillGen extends Entity<Skill> { 
 
  SkillGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get resourceReference => getReference("resource") as Reference; 
  void set resourceReference(Reference reference) { setReference("resource", reference); } 
  
  Resource get resource => getParent("resource") as Resource; 
  void set resource(Resource p) { setParent("resource", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get level => getAttribute("level"); 
  void set level(String a) { setAttribute("level", a); } 
  
  Skill newEntity() => Skill(concept); 
  Skills newEntities() => Skills(concept); 
  
} 
 
abstract class SkillsGen extends Entities<Skill> { 
 
  SkillsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Skills newEntities() => Skills(concept); 
  Skill newEntity() => Skill(concept); 
  
} 
 
