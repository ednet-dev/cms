part of project_scheduling; 
 
// lib/gen/project/scheduling/planning_phases.dart 
 
abstract class PlanningPhaseGen extends Entity<PlanningPhase> { 
 
  PlanningPhaseGen(Concept concept) { 
    this.concept = concept; 
    Concept executionPhaseConcept = concept.model.concepts.singleWhereCode("ExecutionPhase") as Concept; 
    assert(executionPhaseConcept != null); 
    setChild("executionPhase", ExecutionPhases(executionPhaseConcept)); 
  } 
 
  Reference get initiationPhaseReference => getReference("initiationPhase") as Reference; 
  void set initiationPhaseReference(Reference reference) { setReference("initiationPhase", reference); } 
  
  InitiationPhase get initiationPhase => getParent("initiationPhase") as InitiationPhase; 
  void set initiationPhase(InitiationPhase p) { setParent("initiationPhase", p); } 
  
  String get ScopeDefinition => getAttribute("ScopeDefinition"); 
  void set ScopeDefinition(String a) { setAttribute("ScopeDefinition", a); } 
  
  String get WorkBreakdownStructure => getAttribute("WorkBreakdownStructure"); 
  void set WorkBreakdownStructure(String a) { setAttribute("WorkBreakdownStructure", a); } 
  
  String get ScheduleDevelopment => getAttribute("ScheduleDevelopment"); 
  void set ScheduleDevelopment(String a) { setAttribute("ScheduleDevelopment", a); } 
  
  String get ResourcePlanning => getAttribute("ResourcePlanning"); 
  void set ResourcePlanning(String a) { setAttribute("ResourcePlanning", a); } 
  
  String get Budgeting => getAttribute("Budgeting"); 
  void set Budgeting(String a) { setAttribute("Budgeting", a); } 
  
  String get RiskManagement => getAttribute("RiskManagement"); 
  void set RiskManagement(String a) { setAttribute("RiskManagement", a); } 
  
  String get CommunicationPlan => getAttribute("CommunicationPlan"); 
  void set CommunicationPlan(String a) { setAttribute("CommunicationPlan", a); } 
  
  ExecutionPhases get executionPhase => getChild("executionPhase") as ExecutionPhases; 
  
  PlanningPhase newEntity() => PlanningPhase(concept); 
  PlanningPhases newEntities() => PlanningPhases(concept); 
  
} 
 
abstract class PlanningPhasesGen extends Entities<PlanningPhase> { 
 
  PlanningPhasesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  PlanningPhases newEntities() => PlanningPhases(concept); 
  PlanningPhase newEntity() => PlanningPhase(concept); 
  
} 
 
