part of project_scheduling; 
 
// lib/gen/project/scheduling/execution_phases.dart 
 
abstract class ExecutionPhaseGen extends Entity<ExecutionPhase> { 
 
  ExecutionPhaseGen(Concept concept) { 
    this.concept = concept; 
    Concept monitoringAndControllingPhaseConcept = concept.model.concepts.singleWhereCode("MonitoringAndControllingPhase") as Concept; 
    assert(monitoringAndControllingPhaseConcept != null); 
    setChild("monitoringAndControllingPhase", MonitoringAndControllingPhases(monitoringAndControllingPhaseConcept)); 
  } 
 
  Reference get planningPhaseReference => getReference("planningPhase") as Reference; 
  void set planningPhaseReference(Reference reference) { setReference("planningPhase", reference); } 
  
  PlanningPhase get planningPhase => getParent("planningPhase") as PlanningPhase; 
  void set planningPhase(PlanningPhase p) { setParent("planningPhase", p); } 
  
  String get TaskAssignment => getAttribute("TaskAssignment"); 
  void set TaskAssignment(String a) { setAttribute("TaskAssignment", a); } 
  
  String get ResourceAllocation => getAttribute("ResourceAllocation"); 
  void set ResourceAllocation(String a) { setAttribute("ResourceAllocation", a); } 
  
  String get ProjectManagement => getAttribute("ProjectManagement"); 
  void set ProjectManagement(String a) { setAttribute("ProjectManagement", a); } 
  
  String get QualityAssurance => getAttribute("QualityAssurance"); 
  void set QualityAssurance(String a) { setAttribute("QualityAssurance", a); } 
  
  String get Communication => getAttribute("Communication"); 
  void set Communication(String a) { setAttribute("Communication", a); } 
  
  String get RiskMonitoring => getAttribute("RiskMonitoring"); 
  void set RiskMonitoring(String a) { setAttribute("RiskMonitoring", a); } 
  
  MonitoringAndControllingPhases get monitoringAndControllingPhase => getChild("monitoringAndControllingPhase") as MonitoringAndControllingPhases; 
  
  ExecutionPhase newEntity() => ExecutionPhase(concept); 
  ExecutionPhases newEntities() => ExecutionPhases(concept); 
  
} 
 
abstract class ExecutionPhasesGen extends Entities<ExecutionPhase> { 
 
  ExecutionPhasesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ExecutionPhases newEntities() => ExecutionPhases(concept); 
  ExecutionPhase newEntity() => ExecutionPhase(concept); 
  
} 
 
