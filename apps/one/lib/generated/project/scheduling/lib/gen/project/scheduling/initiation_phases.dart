part of project_scheduling; 
 
// lib/gen/project/scheduling/initiation_phases.dart 
 
abstract class InitiationPhaseGen extends Entity<InitiationPhase> { 
 
  InitiationPhaseGen(Concept concept) { 
    this.concept = concept; 
    Concept planningPhaseConcept = concept.model.concepts.singleWhereCode("PlanningPhase") as Concept; 
    assert(planningPhaseConcept != null); 
    setChild("planningPhase", PlanningPhases(planningPhaseConcept)); 
  } 
 
  String get ProjectCharter => getAttribute("ProjectCharter"); 
  void set ProjectCharter(String a) { setAttribute("ProjectCharter", a); } 
  
  String get StakeholderIdentification => getAttribute("StakeholderIdentification"); 
  void set StakeholderIdentification(String a) { setAttribute("StakeholderIdentification", a); } 
  
  String get FeasibilityStudy => getAttribute("FeasibilityStudy"); 
  void set FeasibilityStudy(String a) { setAttribute("FeasibilityStudy", a); } 
  
  String get ProjectGoals => getAttribute("ProjectGoals"); 
  void set ProjectGoals(String a) { setAttribute("ProjectGoals", a); } 
  
  PlanningPhases get planningPhase => getChild("planningPhase") as PlanningPhases; 
  
  InitiationPhase newEntity() => InitiationPhase(concept); 
  InitiationPhases newEntities() => InitiationPhases(concept); 
  
} 
 
abstract class InitiationPhasesGen extends Entities<InitiationPhase> { 
 
  InitiationPhasesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  InitiationPhases newEntities() => InitiationPhases(concept); 
  InitiationPhase newEntity() => InitiationPhase(concept); 
  
} 
 
