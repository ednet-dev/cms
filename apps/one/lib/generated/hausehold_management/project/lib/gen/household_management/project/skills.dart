part of household_management_project; 
 
// lib/gen/household_management/project/skills.dart 
 
abstract class SkillGen extends Entity<Skill> { 
 
  SkillGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
