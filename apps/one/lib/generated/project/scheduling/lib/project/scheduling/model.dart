 
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
    initiationPhase1.ProjectCharter = 'judge'; 
    initiationPhase1.StakeholderIdentification = 'marriage'; 
    initiationPhase1.FeasibilityStudy = 'house'; 
    initiationPhase1.ProjectGoals = 'do'; 
    initiationPhases.add(initiationPhase1); 
 
    var initiationPhase2 = InitiationPhase(initiationPhases.concept); 
    initiationPhase2.ProjectCharter = 'privacy'; 
    initiationPhase2.StakeholderIdentification = 'ticket'; 
    initiationPhase2.FeasibilityStudy = 'hospital'; 
    initiationPhase2.ProjectGoals = 'heating'; 
    initiationPhases.add(initiationPhase2); 
 
    var initiationPhase3 = InitiationPhase(initiationPhases.concept); 
    initiationPhase3.ProjectCharter = 'employer'; 
    initiationPhase3.StakeholderIdentification = 'cream'; 
    initiationPhase3.FeasibilityStudy = 'dog'; 
    initiationPhase3.ProjectGoals = 'lunch'; 
    initiationPhases.add(initiationPhase3); 
 
  } 
 
  void initPlanningPhases() { 
    var planningPhase1 = PlanningPhase(planningPhases.concept); 
    planningPhase1.ScopeDefinition = 'horse'; 
    planningPhase1.WorkBreakdownStructure = 'ticket'; 
    planningPhase1.ScheduleDevelopment = 'life'; 
    planningPhase1.ResourcePlanning = 'heaven'; 
    planningPhase1.Budgeting = 'email'; 
    planningPhase1.RiskManagement = 'drink'; 
    planningPhase1.CommunicationPlan = 'accomodation'; 
    var planningPhase1InitiationPhase = initiationPhases.random(); 
    planningPhase1.initiationPhase = planningPhase1InitiationPhase; 
    planningPhases.add(planningPhase1); 
    planningPhase1InitiationPhase.planningPhase.add(planningPhase1); 
 
    var planningPhase2 = PlanningPhase(planningPhases.concept); 
    planningPhase2.ScopeDefinition = 'opinion'; 
    planningPhase2.WorkBreakdownStructure = 'oil'; 
    planningPhase2.ScheduleDevelopment = 'dog'; 
    planningPhase2.ResourcePlanning = 'salad'; 
    planningPhase2.Budgeting = 'camping'; 
    planningPhase2.RiskManagement = 'series'; 
    planningPhase2.CommunicationPlan = 'line'; 
    var planningPhase2InitiationPhase = initiationPhases.random(); 
    planningPhase2.initiationPhase = planningPhase2InitiationPhase; 
    planningPhases.add(planningPhase2); 
    planningPhase2InitiationPhase.planningPhase.add(planningPhase2); 
 
    var planningPhase3 = PlanningPhase(planningPhases.concept); 
    planningPhase3.ScopeDefinition = 'fascination'; 
    planningPhase3.WorkBreakdownStructure = 'present'; 
    planningPhase3.ScheduleDevelopment = 'wave'; 
    planningPhase3.ResourcePlanning = 'cloud'; 
    planningPhase3.Budgeting = 'girl'; 
    planningPhase3.RiskManagement = 'feeling'; 
    planningPhase3.CommunicationPlan = 'taxi'; 
    var planningPhase3InitiationPhase = initiationPhases.random(); 
    planningPhase3.initiationPhase = planningPhase3InitiationPhase; 
    planningPhases.add(planningPhase3); 
    planningPhase3InitiationPhase.planningPhase.add(planningPhase3); 
 
  } 
 
  void initExecutionPhases() { 
    var executionPhase1 = ExecutionPhase(executionPhases.concept); 
    executionPhase1.TaskAssignment = 'baby'; 
    executionPhase1.ResourceAllocation = 'beer'; 
    executionPhase1.ProjectManagement = 'tape'; 
    executionPhase1.QualityAssurance = 'kids'; 
    executionPhase1.Communication = 'question'; 
    executionPhase1.RiskMonitoring = 'health'; 
    var executionPhase1PlanningPhase = planningPhases.random(); 
    executionPhase1.planningPhase = executionPhase1PlanningPhase; 
    executionPhases.add(executionPhase1); 
    executionPhase1PlanningPhase.executionPhase.add(executionPhase1); 
 
    var executionPhase2 = ExecutionPhase(executionPhases.concept); 
    executionPhase2.TaskAssignment = 'revolution'; 
    executionPhase2.ResourceAllocation = 'beans'; 
    executionPhase2.ProjectManagement = 'consciousness'; 
    executionPhase2.QualityAssurance = 'camping'; 
    executionPhase2.Communication = 'boat'; 
    executionPhase2.RiskMonitoring = 'answer'; 
    var executionPhase2PlanningPhase = planningPhases.random(); 
    executionPhase2.planningPhase = executionPhase2PlanningPhase; 
    executionPhases.add(executionPhase2); 
    executionPhase2PlanningPhase.executionPhase.add(executionPhase2); 
 
    var executionPhase3 = ExecutionPhase(executionPhases.concept); 
    executionPhase3.TaskAssignment = 'text'; 
    executionPhase3.ResourceAllocation = 'train'; 
    executionPhase3.ProjectManagement = 'book'; 
    executionPhase3.QualityAssurance = 'consciousness'; 
    executionPhase3.Communication = 'restaurant'; 
    executionPhase3.RiskMonitoring = 'understanding'; 
    var executionPhase3PlanningPhase = planningPhases.random(); 
    executionPhase3.planningPhase = executionPhase3PlanningPhase; 
    executionPhases.add(executionPhase3); 
    executionPhase3PlanningPhase.executionPhase.add(executionPhase3); 
 
  } 
 
  void initMonitoringAndControllingPhases() { 
    var monitoringAndControllingPhase1 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase1.PerformanceMeasurement = 'time'; 
    monitoringAndControllingPhase1.ChangeManagement = 'email'; 
    monitoringAndControllingPhase1.QualityControl = 'interest'; 
    monitoringAndControllingPhase1.IssueResolution = 'school'; 
    monitoringAndControllingPhase1.Reporting = 'account'; 
    var monitoringAndControllingPhase1ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase1.executionPhase = monitoringAndControllingPhase1ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase1); 
    monitoringAndControllingPhase1ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase1); 
 
    var monitoringAndControllingPhase2 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase2.PerformanceMeasurement = 'output'; 
    monitoringAndControllingPhase2.ChangeManagement = 'big'; 
    monitoringAndControllingPhase2.QualityControl = 'hat'; 
    monitoringAndControllingPhase2.IssueResolution = 'walking'; 
    monitoringAndControllingPhase2.Reporting = 'economy'; 
    var monitoringAndControllingPhase2ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase2.executionPhase = monitoringAndControllingPhase2ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase2); 
    monitoringAndControllingPhase2ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase2); 
 
    var monitoringAndControllingPhase3 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase3.PerformanceMeasurement = 'course'; 
    monitoringAndControllingPhase3.ChangeManagement = 'blue'; 
    monitoringAndControllingPhase3.QualityControl = 'horse'; 
    monitoringAndControllingPhase3.IssueResolution = 'family'; 
    monitoringAndControllingPhase3.Reporting = 'city'; 
    var monitoringAndControllingPhase3ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase3.executionPhase = monitoringAndControllingPhase3ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase3); 
    monitoringAndControllingPhase3ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase3); 
 
  } 
 
  void initClosingPhases() { 
    var closingPhase1 = ClosingPhase(closingPhases.concept); 
    closingPhase1.FinalDeliverableHandover = 'answer'; 
    closingPhase1.ProjectDocumentation = 'understanding'; 
    closingPhase1.StakeholderSignOff = 'mind'; 
    closingPhase1.ProjectReview = 'time'; 
    closingPhase1.ResourceRelease = 'word'; 
    closingPhase1.CelebrateSuccess = 'measuremewnt'; 
    var closingPhase1MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase1.monitoringAndControllingPhase = closingPhase1MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase1); 
    closingPhase1MonitoringAndControllingPhase.closingPhase.add(closingPhase1); 
 
    var closingPhase2 = ClosingPhase(closingPhases.concept); 
    closingPhase2.FinalDeliverableHandover = 'line'; 
    closingPhase2.ProjectDocumentation = 'ball'; 
    closingPhase2.StakeholderSignOff = 'cream'; 
    closingPhase2.ProjectReview = 'mind'; 
    closingPhase2.ResourceRelease = 'seed'; 
    closingPhase2.CelebrateSuccess = 'river'; 
    var closingPhase2MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase2.monitoringAndControllingPhase = closingPhase2MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase2); 
    closingPhase2MonitoringAndControllingPhase.closingPhase.add(closingPhase2); 
 
    var closingPhase3 = ClosingPhase(closingPhases.concept); 
    closingPhase3.FinalDeliverableHandover = 'meter'; 
    closingPhase3.ProjectDocumentation = 'test'; 
    closingPhase3.StakeholderSignOff = 'center'; 
    closingPhase3.ProjectReview = 'right'; 
    closingPhase3.ResourceRelease = 'employer'; 
    closingPhase3.CelebrateSuccess = 'architecture'; 
    var closingPhase3MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase3.monitoringAndControllingPhase = closingPhase3MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase3); 
    closingPhase3MonitoringAndControllingPhase.closingPhase.add(closingPhase3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
