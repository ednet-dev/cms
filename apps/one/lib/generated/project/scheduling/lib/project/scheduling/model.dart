 
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
    initiationPhase1.ProjectCharter = 'water'; 
    initiationPhase1.StakeholderIdentification = 'understanding'; 
    initiationPhase1.FeasibilityStudy = 'coffee'; 
    initiationPhase1.ProjectGoals = 'horse'; 
    initiationPhases.add(initiationPhase1); 
 
    var initiationPhase2 = InitiationPhase(initiationPhases.concept); 
    initiationPhase2.ProjectCharter = 'home'; 
    initiationPhase2.StakeholderIdentification = 'line'; 
    initiationPhase2.FeasibilityStudy = 'pattern'; 
    initiationPhase2.ProjectGoals = 'vessel'; 
    initiationPhases.add(initiationPhase2); 
 
    var initiationPhase3 = InitiationPhase(initiationPhases.concept); 
    initiationPhase3.ProjectCharter = 'test'; 
    initiationPhase3.StakeholderIdentification = 'output'; 
    initiationPhase3.FeasibilityStudy = 'message'; 
    initiationPhase3.ProjectGoals = 'deep'; 
    initiationPhases.add(initiationPhase3); 
 
  } 
 
  void initPlanningPhases() { 
    var planningPhase1 = PlanningPhase(planningPhases.concept); 
    planningPhase1.ScopeDefinition = 'future'; 
    planningPhase1.WorkBreakdownStructure = 'month'; 
    planningPhase1.ScheduleDevelopment = 'beer'; 
    planningPhase1.ResourcePlanning = 'instruction'; 
    planningPhase1.Budgeting = 'hot'; 
    planningPhase1.RiskManagement = 'picture'; 
    planningPhase1.CommunicationPlan = 'table'; 
    var planningPhase1InitiationPhase = initiationPhases.random(); 
    planningPhase1.initiationPhase = planningPhase1InitiationPhase; 
    planningPhases.add(planningPhase1); 
    planningPhase1InitiationPhase.planningPhase.add(planningPhase1); 
 
    var planningPhase2 = PlanningPhase(planningPhases.concept); 
    planningPhase2.ScopeDefinition = 'craving'; 
    planningPhase2.WorkBreakdownStructure = 'privacy'; 
    planningPhase2.ScheduleDevelopment = 'winter'; 
    planningPhase2.ResourcePlanning = 'objective'; 
    planningPhase2.Budgeting = 'coffee'; 
    planningPhase2.RiskManagement = 'dvd'; 
    planningPhase2.CommunicationPlan = 'yellow'; 
    var planningPhase2InitiationPhase = initiationPhases.random(); 
    planningPhase2.initiationPhase = planningPhase2InitiationPhase; 
    planningPhases.add(planningPhase2); 
    planningPhase2InitiationPhase.planningPhase.add(planningPhase2); 
 
    var planningPhase3 = PlanningPhase(planningPhases.concept); 
    planningPhase3.ScopeDefinition = 'price'; 
    planningPhase3.WorkBreakdownStructure = 'professor'; 
    planningPhase3.ScheduleDevelopment = 'knowledge'; 
    planningPhase3.ResourcePlanning = 'tall'; 
    planningPhase3.Budgeting = 'sentence'; 
    planningPhase3.RiskManagement = 'understanding'; 
    planningPhase3.CommunicationPlan = 'job'; 
    var planningPhase3InitiationPhase = initiationPhases.random(); 
    planningPhase3.initiationPhase = planningPhase3InitiationPhase; 
    planningPhases.add(planningPhase3); 
    planningPhase3InitiationPhase.planningPhase.add(planningPhase3); 
 
  } 
 
  void initExecutionPhases() { 
    var executionPhase1 = ExecutionPhase(executionPhases.concept); 
    executionPhase1.TaskAssignment = 'television'; 
    executionPhase1.ResourceAllocation = 'edition'; 
    executionPhase1.ProjectManagement = 'energy'; 
    executionPhase1.QualityAssurance = 'advisor'; 
    executionPhase1.Communication = 'end'; 
    executionPhase1.RiskMonitoring = 'tape'; 
    var executionPhase1PlanningPhase = planningPhases.random(); 
    executionPhase1.planningPhase = executionPhase1PlanningPhase; 
    executionPhases.add(executionPhase1); 
    executionPhase1PlanningPhase.executionPhase.add(executionPhase1); 
 
    var executionPhase2 = ExecutionPhase(executionPhases.concept); 
    executionPhase2.TaskAssignment = 'discount'; 
    executionPhase2.ResourceAllocation = 'coffee'; 
    executionPhase2.ProjectManagement = 'umbrella'; 
    executionPhase2.QualityAssurance = 'center'; 
    executionPhase2.Communication = 'series'; 
    executionPhase2.RiskMonitoring = 'plaho'; 
    var executionPhase2PlanningPhase = planningPhases.random(); 
    executionPhase2.planningPhase = executionPhase2PlanningPhase; 
    executionPhases.add(executionPhase2); 
    executionPhase2PlanningPhase.executionPhase.add(executionPhase2); 
 
    var executionPhase3 = ExecutionPhase(executionPhases.concept); 
    executionPhase3.TaskAssignment = 'element'; 
    executionPhase3.ResourceAllocation = 'marriage'; 
    executionPhase3.ProjectManagement = 'revolution'; 
    executionPhase3.QualityAssurance = 'beans'; 
    executionPhase3.Communication = 'tax'; 
    executionPhase3.RiskMonitoring = 'walking'; 
    var executionPhase3PlanningPhase = planningPhases.random(); 
    executionPhase3.planningPhase = executionPhase3PlanningPhase; 
    executionPhases.add(executionPhase3); 
    executionPhase3PlanningPhase.executionPhase.add(executionPhase3); 
 
  } 
 
  void initMonitoringAndControllingPhases() { 
    var monitoringAndControllingPhase1 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase1.PerformanceMeasurement = 'accident'; 
    monitoringAndControllingPhase1.ChangeManagement = 'revolution'; 
    monitoringAndControllingPhase1.QualityControl = 'performance'; 
    monitoringAndControllingPhase1.IssueResolution = 'universe'; 
    monitoringAndControllingPhase1.Reporting = 'circle'; 
    var monitoringAndControllingPhase1ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase1.executionPhase = monitoringAndControllingPhase1ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase1); 
    monitoringAndControllingPhase1ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase1); 
 
    var monitoringAndControllingPhase2 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase2.PerformanceMeasurement = 'winter'; 
    monitoringAndControllingPhase2.ChangeManagement = 'tall'; 
    monitoringAndControllingPhase2.QualityControl = 'agile'; 
    monitoringAndControllingPhase2.IssueResolution = 'left'; 
    monitoringAndControllingPhase2.Reporting = 'ship'; 
    var monitoringAndControllingPhase2ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase2.executionPhase = monitoringAndControllingPhase2ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase2); 
    monitoringAndControllingPhase2ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase2); 
 
    var monitoringAndControllingPhase3 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase3.PerformanceMeasurement = 'tax'; 
    monitoringAndControllingPhase3.ChangeManagement = 'accident'; 
    monitoringAndControllingPhase3.QualityControl = 'abstract'; 
    monitoringAndControllingPhase3.IssueResolution = 'authority'; 
    monitoringAndControllingPhase3.Reporting = 'dinner'; 
    var monitoringAndControllingPhase3ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase3.executionPhase = monitoringAndControllingPhase3ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase3); 
    monitoringAndControllingPhase3ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase3); 
 
  } 
 
  void initClosingPhases() { 
    var closingPhase1 = ClosingPhase(closingPhases.concept); 
    closingPhase1.FinalDeliverableHandover = 'hall'; 
    closingPhase1.ProjectDocumentation = 'beach'; 
    closingPhase1.StakeholderSignOff = 'bank'; 
    closingPhase1.ProjectReview = 'coffee'; 
    closingPhase1.ResourceRelease = 'car'; 
    closingPhase1.CelebrateSuccess = 'walking'; 
    var closingPhase1MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase1.monitoringAndControllingPhase = closingPhase1MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase1); 
    closingPhase1MonitoringAndControllingPhase.closingPhase.add(closingPhase1); 
 
    var closingPhase2 = ClosingPhase(closingPhases.concept); 
    closingPhase2.FinalDeliverableHandover = 'photo'; 
    closingPhase2.ProjectDocumentation = 'course'; 
    closingPhase2.StakeholderSignOff = 'time'; 
    closingPhase2.ProjectReview = 'circle'; 
    closingPhase2.ResourceRelease = 'tall'; 
    closingPhase2.CelebrateSuccess = 'cardboard'; 
    var closingPhase2MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase2.monitoringAndControllingPhase = closingPhase2MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase2); 
    closingPhase2MonitoringAndControllingPhase.closingPhase.add(closingPhase2); 
 
    var closingPhase3 = ClosingPhase(closingPhases.concept); 
    closingPhase3.FinalDeliverableHandover = 'tape'; 
    closingPhase3.ProjectDocumentation = 'television'; 
    closingPhase3.StakeholderSignOff = 'wife'; 
    closingPhase3.ProjectReview = 'taxi'; 
    closingPhase3.ResourceRelease = 'productivity'; 
    closingPhase3.CelebrateSuccess = 'selfdo'; 
    var closingPhase3MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase3.monitoringAndControllingPhase = closingPhase3MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase3); 
    closingPhase3MonitoringAndControllingPhase.closingPhase.add(closingPhase3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
