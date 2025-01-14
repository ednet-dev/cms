part of project_scheduling; 
 
// lib/gen/project/scheduling/monitoring_and_controlling_phases.dart 
 
abstract class MonitoringAndControllingPhaseGen extends Entity<MonitoringAndControllingPhase> { 
 
  MonitoringAndControllingPhaseGen(Concept concept) { 
    this.concept = concept; 
    Concept closingPhaseConcept = concept.model.concepts.singleWhereCode("ClosingPhase") as Concept; 
    assert(closingPhaseConcept != null); 
    setChild("closingPhase", ClosingPhases(closingPhaseConcept)); 
  } 
 
  Reference get executionPhaseReference => getReference("executionPhase") as Reference; 
  void set executionPhaseReference(Reference reference) { setReference("executionPhase", reference); } 
  
  ExecutionPhase get executionPhase => getParent("executionPhase") as ExecutionPhase; 
  void set executionPhase(ExecutionPhase p) { setParent("executionPhase", p); } 
  
  String get PerformanceMeasurement => getAttribute("PerformanceMeasurement"); 
  void set PerformanceMeasurement(String a) { setAttribute("PerformanceMeasurement", a); } 
  
  String get ChangeManagement => getAttribute("ChangeManagement"); 
  void set ChangeManagement(String a) { setAttribute("ChangeManagement", a); } 
  
  String get QualityControl => getAttribute("QualityControl"); 
  void set QualityControl(String a) { setAttribute("QualityControl", a); } 
  
  String get IssueResolution => getAttribute("IssueResolution"); 
  void set IssueResolution(String a) { setAttribute("IssueResolution", a); } 
  
  String get Reporting => getAttribute("Reporting"); 
  void set Reporting(String a) { setAttribute("Reporting", a); } 
  
  ClosingPhases get closingPhase => getChild("closingPhase") as ClosingPhases; 
  
  MonitoringAndControllingPhase newEntity() => MonitoringAndControllingPhase(concept); 
  MonitoringAndControllingPhases newEntities() => MonitoringAndControllingPhases(concept); 
  
} 
 
abstract class MonitoringAndControllingPhasesGen extends Entities<MonitoringAndControllingPhase> { 
 
  MonitoringAndControllingPhasesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  MonitoringAndControllingPhases newEntities() => MonitoringAndControllingPhases(concept); 
  MonitoringAndControllingPhase newEntity() => MonitoringAndControllingPhase(concept); 
  
} 
 
