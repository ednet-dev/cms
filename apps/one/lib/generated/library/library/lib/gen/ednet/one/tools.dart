part of ednet_one; 
 
// lib/gen/ednet/one/tools.dart 
 
abstract class ToolGen extends Entity<Tool> { 
 
  ToolGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Tool newEntity() => Tool(concept); 
  Tools newEntities() => Tools(concept); 
  
} 
 
abstract class ToolsGen extends Entities<Tool> { 
 
  ToolsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Tools newEntities() => Tools(concept); 
  Tool newEntity() => Tool(concept); 
  
} 
 
