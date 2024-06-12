part of project_scheduling; 
 
// lib/gen/project/scheduling/closing_phases.dart 
 
abstract class ClosingPhaseGen extends Entity<ClosingPhase> { 
 
  ClosingPhaseGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get monitoringAndControllingPhaseReference => getReference("monitoringAndControllingPhase") as Reference; 
  void set monitoringAndControllingPhaseReference(Reference reference) { setReference("monitoringAndControllingPhase", reference); } 
  
  MonitoringAndControllingPhase get monitoringAndControllingPhase => getParent("monitoringAndControllingPhase") as MonitoringAndControllingPhase; 
  void set monitoringAndControllingPhase(MonitoringAndControllingPhase p) { setParent("monitoringAndControllingPhase", p); } 
  
  String get FinalDeliverableHandover => getAttribute("FinalDeliverableHandover"); 
  void set FinalDeliverableHandover(String a) { setAttribute("FinalDeliverableHandover", a); } 
  
  String get ProjectDocumentation => getAttribute("ProjectDocumentation"); 
  void set ProjectDocumentation(String a) { setAttribute("ProjectDocumentation", a); } 
  
  String get StakeholderSignOff => getAttribute("StakeholderSignOff"); 
  void set StakeholderSignOff(String a) { setAttribute("StakeholderSignOff", a); } 
  
  String get ProjectReview => getAttribute("ProjectReview"); 
  void set ProjectReview(String a) { setAttribute("ProjectReview", a); } 
  
  String get ResourceRelease => getAttribute("ResourceRelease"); 
  void set ResourceRelease(String a) { setAttribute("ResourceRelease", a); } 
  
  String get CelebrateSuccess => getAttribute("CelebrateSuccess"); 
  void set CelebrateSuccess(String a) { setAttribute("CelebrateSuccess", a); } 
  
  ClosingPhase newEntity() => ClosingPhase(concept); 
  ClosingPhases newEntities() => ClosingPhases(concept); 
  
} 
 
abstract class ClosingPhasesGen extends Entities<ClosingPhase> { 
 
  ClosingPhasesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ClosingPhases newEntities() => ClosingPhases(concept); 
  ClosingPhase newEntity() => ClosingPhase(concept); 
  
} 
 
