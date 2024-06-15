 
part of project_scheduling; 
 
// lib/project/scheduling/model.dart 
 
class SchedulingModel extends SchedulingEntries { 
 
  SchedulingModel(Model model) : super(model); 
 
  void fromJsonToInitiationPhaseEntry() { 
    fromJsonToEntry(projectSchedulingInitiationPhaseEntry); 
  } 
 
  void fromJsonToPlanningPhaseEntry() { 
    fromJsonToEntry(projectSchedulingPlanningPhaseEntry); 
  } 
 
  void fromJsonToExecutionPhaseEntry() { 
    fromJsonToEntry(projectSchedulingExecutionPhaseEntry); 
  } 
 
  void fromJsonToMonitoringAndControllingPhaseEntry() { 
    fromJsonToEntry(projectSchedulingMonitoringAndControllingPhaseEntry); 
  } 
 
  void fromJsonToClosingPhaseEntry() { 
    fromJsonToEntry(projectSchedulingClosingPhaseEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(projectSchedulingModel); 
  } 
 
  void init() { 
    initInitiationPhases(); 
    initPlanningPhases(); 
    initExecutionPhases(); 
    initMonitoringAndControllingPhases(); 
    initClosingPhases(); 
  } 
 
  void initInitiationPhases() { 
    var initiationPhase1 = InitiationPhase(initiationPhases.concept); 
    initiationPhase1.ProjectCharter = 'explanation'; 
    initiationPhase1.StakeholderIdentification = 'training'; 
    initiationPhase1.FeasibilityStudy = 'pattern'; 
    initiationPhase1.ProjectGoals = 'mind'; 
    initiationPhases.add(initiationPhase1); 
 
    var initiationPhase2 = InitiationPhase(initiationPhases.concept); 
    initiationPhase2.ProjectCharter = 'price'; 
    initiationPhase2.StakeholderIdentification = 'fish'; 
    initiationPhase2.FeasibilityStudy = 'answer'; 
    initiationPhase2.ProjectGoals = 'interest'; 
    initiationPhases.add(initiationPhase2); 
 
    var initiationPhase3 = InitiationPhase(initiationPhases.concept); 
    initiationPhase3.ProjectCharter = 'tax'; 
    initiationPhase3.StakeholderIdentification = 'train'; 
    initiationPhase3.FeasibilityStudy = 'enquiry'; 
    initiationPhase3.ProjectGoals = 'debt'; 
    initiationPhases.add(initiationPhase3); 
 
  } 
 
  void initPlanningPhases() { 
    var planningPhase1 = PlanningPhase(planningPhases.concept); 
    planningPhase1.ScopeDefinition = 'hunting'; 
    planningPhase1.WorkBreakdownStructure = 'explanation'; 
    planningPhase1.ScheduleDevelopment = 'secretary'; 
    planningPhase1.ResourcePlanning = 'teaching'; 
    planningPhase1.Budgeting = 'revolution'; 
    planningPhase1.RiskManagement = 'beginning'; 
    planningPhase1.CommunicationPlan = 'college'; 
    var planningPhase1InitiationPhase = initiationPhases.random(); 
    planningPhase1.initiationPhase = planningPhase1InitiationPhase; 
    planningPhases.add(planningPhase1); 
    planningPhase1InitiationPhase.planningPhase.add(planningPhase1); 
 
    var planningPhase2 = PlanningPhase(planningPhases.concept); 
    planningPhase2.ScopeDefinition = 'water'; 
    planningPhase2.WorkBreakdownStructure = 'message'; 
    planningPhase2.ScheduleDevelopment = 'parfem'; 
    planningPhase2.ResourcePlanning = 'cream'; 
    planningPhase2.Budgeting = 'effort'; 
    planningPhase2.RiskManagement = 'cable'; 
    planningPhase2.CommunicationPlan = 'marriage'; 
    var planningPhase2InitiationPhase = initiationPhases.random(); 
    planningPhase2.initiationPhase = planningPhase2InitiationPhase; 
    planningPhases.add(planningPhase2); 
    planningPhase2InitiationPhase.planningPhase.add(planningPhase2); 
 
    var planningPhase3 = PlanningPhase(planningPhases.concept); 
    planningPhase3.ScopeDefinition = 'flower'; 
    planningPhase3.WorkBreakdownStructure = 'yellow'; 
    planningPhase3.ScheduleDevelopment = 'finger'; 
    planningPhase3.ResourcePlanning = 'revolution'; 
    planningPhase3.Budgeting = 'privacy'; 
    planningPhase3.RiskManagement = 'agile'; 
    planningPhase3.CommunicationPlan = 'pattern'; 
    var planningPhase3InitiationPhase = initiationPhases.random(); 
    planningPhase3.initiationPhase = planningPhase3InitiationPhase; 
    planningPhases.add(planningPhase3); 
    planningPhase3InitiationPhase.planningPhase.add(planningPhase3); 
 
  } 
 
  void initExecutionPhases() { 
    var executionPhase1 = ExecutionPhase(executionPhases.concept); 
    executionPhase1.TaskAssignment = 'horse'; 
    executionPhase1.ResourceAllocation = 'country'; 
    executionPhase1.ProjectManagement = 'do'; 
    executionPhase1.QualityAssurance = 'train'; 
    executionPhase1.Communication = 'cinema'; 
    executionPhase1.RiskMonitoring = 'university'; 
    var executionPhase1PlanningPhase = planningPhases.random(); 
    executionPhase1.planningPhase = executionPhase1PlanningPhase; 
    executionPhases.add(executionPhase1); 
    executionPhase1PlanningPhase.executionPhase.add(executionPhase1); 
 
    var executionPhase2 = ExecutionPhase(executionPhases.concept); 
    executionPhase2.TaskAssignment = 'big'; 
    executionPhase2.ResourceAllocation = 'sin'; 
    executionPhase2.ProjectManagement = 'service'; 
    executionPhase2.QualityAssurance = 'call'; 
    executionPhase2.Communication = 'top'; 
    executionPhase2.RiskMonitoring = 'darts'; 
    var executionPhase2PlanningPhase = planningPhases.random(); 
    executionPhase2.planningPhase = executionPhase2PlanningPhase; 
    executionPhases.add(executionPhase2); 
    executionPhase2PlanningPhase.executionPhase.add(executionPhase2); 
 
    var executionPhase3 = ExecutionPhase(executionPhases.concept); 
    executionPhase3.TaskAssignment = 'drink'; 
    executionPhase3.ResourceAllocation = 'explanation'; 
    executionPhase3.ProjectManagement = 'universe'; 
    executionPhase3.QualityAssurance = 'hall'; 
    executionPhase3.Communication = 'bird'; 
    executionPhase3.RiskMonitoring = 'school'; 
    var executionPhase3PlanningPhase = planningPhases.random(); 
    executionPhase3.planningPhase = executionPhase3PlanningPhase; 
    executionPhases.add(executionPhase3); 
    executionPhase3PlanningPhase.executionPhase.add(executionPhase3); 
 
  } 
 
  void initMonitoringAndControllingPhases() { 
    var monitoringAndControllingPhase1 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase1.PerformanceMeasurement = 'question'; 
    monitoringAndControllingPhase1.ChangeManagement = 'line'; 
    monitoringAndControllingPhase1.QualityControl = 'professor'; 
    monitoringAndControllingPhase1.IssueResolution = 'lake'; 
    monitoringAndControllingPhase1.Reporting = 'abstract'; 
    var monitoringAndControllingPhase1ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase1.executionPhase = monitoringAndControllingPhase1ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase1); 
    monitoringAndControllingPhase1ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase1); 
 
    var monitoringAndControllingPhase2 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase2.PerformanceMeasurement = 'heaven'; 
    monitoringAndControllingPhase2.ChangeManagement = 'sin'; 
    monitoringAndControllingPhase2.QualityControl = 'parfem'; 
    monitoringAndControllingPhase2.IssueResolution = 'mind'; 
    monitoringAndControllingPhase2.Reporting = 'consciousness'; 
    var monitoringAndControllingPhase2ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase2.executionPhase = monitoringAndControllingPhase2ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase2); 
    monitoringAndControllingPhase2ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase2); 
 
    var monitoringAndControllingPhase3 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase3.PerformanceMeasurement = 'umbrella'; 
    monitoringAndControllingPhase3.ChangeManagement = 'dog'; 
    monitoringAndControllingPhase3.QualityControl = 'camping'; 
    monitoringAndControllingPhase3.IssueResolution = 'hunting'; 
    monitoringAndControllingPhase3.Reporting = 'life'; 
    var monitoringAndControllingPhase3ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase3.executionPhase = monitoringAndControllingPhase3ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase3); 
    monitoringAndControllingPhase3ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase3); 
 
  } 
 
  void initClosingPhases() { 
    var closingPhase1 = ClosingPhase(closingPhases.concept); 
    closingPhase1.FinalDeliverableHandover = 'teaching'; 
    closingPhase1.ProjectDocumentation = 'distance'; 
    closingPhase1.StakeholderSignOff = 'drink'; 
    closingPhase1.ProjectReview = 'hunting'; 
    closingPhase1.ResourceRelease = 'done'; 
    closingPhase1.CelebrateSuccess = 'meter'; 
    var closingPhase1MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase1.monitoringAndControllingPhase = closingPhase1MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase1); 
    closingPhase1MonitoringAndControllingPhase.closingPhase.add(closingPhase1); 
 
    var closingPhase2 = ClosingPhase(closingPhases.concept); 
    closingPhase2.FinalDeliverableHandover = 'girl'; 
    closingPhase2.ProjectDocumentation = 'teacher'; 
    closingPhase2.StakeholderSignOff = 'universe'; 
    closingPhase2.ProjectReview = 'video'; 
    closingPhase2.ResourceRelease = 'service'; 
    closingPhase2.CelebrateSuccess = 'craving'; 
    var closingPhase2MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase2.monitoringAndControllingPhase = closingPhase2MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase2); 
    closingPhase2MonitoringAndControllingPhase.closingPhase.add(closingPhase2); 
 
    var closingPhase3 = ClosingPhase(closingPhases.concept); 
    closingPhase3.FinalDeliverableHandover = 'time'; 
    closingPhase3.ProjectDocumentation = 'body'; 
    closingPhase3.StakeholderSignOff = 'drink'; 
    closingPhase3.ProjectReview = 'opinion'; 
    closingPhase3.ResourceRelease = 'finger'; 
    closingPhase3.CelebrateSuccess = 'cream'; 
    var closingPhase3MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase3.monitoringAndControllingPhase = closingPhase3MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase3); 
    closingPhase3MonitoringAndControllingPhase.closingPhase.add(closingPhase3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
