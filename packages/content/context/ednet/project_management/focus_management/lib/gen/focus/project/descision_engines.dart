part of focus_project; 
 
// lib/gen/focus/project/descision_engines.dart 
 
abstract class DescisionEngineGen extends Entity<DescisionEngine> { 
 
  DescisionEngineGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  DescisionEngine newEntity() => DescisionEngine(concept); 
  DescisionEngines newEntities() => DescisionEngines(concept); 
  
} 
 
abstract class DescisionEnginesGen extends Entities<DescisionEngine> { 
 
  DescisionEnginesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  DescisionEngines newEntities() => DescisionEngines(concept); 
  DescisionEngine newEntity() => DescisionEngine(concept); 
  
} 
 
