 
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
    initiationPhase1.ProjectCharter = 'dog'; 
    initiationPhase1.StakeholderIdentification = 'fish'; 
    initiationPhase1.FeasibilityStudy = 'algorithm'; 
    initiationPhase1.ProjectGoals = 'universe'; 
    initiationPhases.add(initiationPhase1); 
 
    var initiationPhase2 = InitiationPhase(initiationPhases.concept); 
    initiationPhase2.ProjectCharter = 'ship'; 
    initiationPhase2.StakeholderIdentification = 'executive'; 
    initiationPhase2.FeasibilityStudy = 'navigation'; 
    initiationPhase2.ProjectGoals = 'crisis'; 
    initiationPhases.add(initiationPhase2); 
 
    var initiationPhase3 = InitiationPhase(initiationPhases.concept); 
    initiationPhase3.ProjectCharter = 'point'; 
    initiationPhase3.StakeholderIdentification = 'vessel'; 
    initiationPhase3.FeasibilityStudy = 'house'; 
    initiationPhase3.ProjectGoals = 'ship'; 
    initiationPhases.add(initiationPhase3); 
 
  } 
 
  void initPlanningPhases() { 
    var planningPhase1 = PlanningPhase(planningPhases.concept); 
    planningPhase1.ScopeDefinition = 'objective'; 
    planningPhase1.WorkBreakdownStructure = 'sailing'; 
    planningPhase1.ScheduleDevelopment = 'consulting'; 
    planningPhase1.ResourcePlanning = 'down'; 
    planningPhase1.Budgeting = 'umbrella'; 
    planningPhase1.RiskManagement = 'training'; 
    planningPhase1.CommunicationPlan = 'hell'; 
    var planningPhase1InitiationPhase = initiationPhases.random(); 
    planningPhase1.initiationPhase = planningPhase1InitiationPhase; 
    planningPhases.add(planningPhase1); 
    planningPhase1InitiationPhase.planningPhase.add(planningPhase1); 
 
    var planningPhase2 = PlanningPhase(planningPhases.concept); 
    planningPhase2.ScopeDefinition = 'cloud'; 
    planningPhase2.WorkBreakdownStructure = 'lifespan'; 
    planningPhase2.ScheduleDevelopment = 'service'; 
    planningPhase2.ResourcePlanning = 'sin'; 
    planningPhase2.Budgeting = 'television'; 
    planningPhase2.RiskManagement = 'hospital'; 
    planningPhase2.CommunicationPlan = 'entertainment'; 
    var planningPhase2InitiationPhase = initiationPhases.random(); 
    planningPhase2.initiationPhase = planningPhase2InitiationPhase; 
    planningPhases.add(planningPhase2); 
    planningPhase2InitiationPhase.planningPhase.add(planningPhase2); 
 
    var planningPhase3 = PlanningPhase(planningPhases.concept); 
    planningPhase3.ScopeDefinition = 'slate'; 
    planningPhase3.WorkBreakdownStructure = 'capacity'; 
    planningPhase3.ScheduleDevelopment = 'economy'; 
    planningPhase3.ResourcePlanning = 'seed'; 
    planningPhase3.Budgeting = 'college'; 
    planningPhase3.RiskManagement = 'auto'; 
    planningPhase3.CommunicationPlan = 'computer'; 
    var planningPhase3InitiationPhase = initiationPhases.random(); 
    planningPhase3.initiationPhase = planningPhase3InitiationPhase; 
    planningPhases.add(planningPhase3); 
    planningPhase3InitiationPhase.planningPhase.add(planningPhase3); 
 
  } 
 
  void initExecutionPhases() { 
    var executionPhase1 = ExecutionPhase(executionPhases.concept); 
    executionPhase1.TaskAssignment = 'salad'; 
    executionPhase1.ResourceAllocation = 'architecture'; 
    executionPhase1.ProjectManagement = 'hell'; 
    executionPhase1.QualityAssurance = 'cloud'; 
    executionPhase1.Communication = 'small'; 
    executionPhase1.RiskMonitoring = 'beer'; 
    var executionPhase1PlanningPhase = planningPhases.random(); 
    executionPhase1.planningPhase = executionPhase1PlanningPhase; 
    executionPhases.add(executionPhase1); 
    executionPhase1PlanningPhase.executionPhase.add(executionPhase1); 
 
    var executionPhase2 = ExecutionPhase(executionPhases.concept); 
    executionPhase2.TaskAssignment = 'hell'; 
    executionPhase2.ResourceAllocation = 'message'; 
    executionPhase2.ProjectManagement = 'drink'; 
    executionPhase2.QualityAssurance = 'line'; 
    executionPhase2.Communication = 'flower'; 
    executionPhase2.RiskMonitoring = 'water'; 
    var executionPhase2PlanningPhase = planningPhases.random(); 
    executionPhase2.planningPhase = executionPhase2PlanningPhase; 
    executionPhases.add(executionPhase2); 
    executionPhase2PlanningPhase.executionPhase.add(executionPhase2); 
 
    var executionPhase3 = ExecutionPhase(executionPhases.concept); 
    executionPhase3.TaskAssignment = 'blue'; 
    executionPhase3.ResourceAllocation = 'season'; 
    executionPhase3.ProjectManagement = 'camping'; 
    executionPhase3.QualityAssurance = 'do'; 
    executionPhase3.Communication = 'guest'; 
    executionPhase3.RiskMonitoring = 'dvd'; 
    var executionPhase3PlanningPhase = planningPhases.random(); 
    executionPhase3.planningPhase = executionPhase3PlanningPhase; 
    executionPhases.add(executionPhase3); 
    executionPhase3PlanningPhase.executionPhase.add(executionPhase3); 
 
  } 
 
  void initMonitoringAndControllingPhases() { 
    var monitoringAndControllingPhase1 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase1.PerformanceMeasurement = 'cable'; 
    monitoringAndControllingPhase1.ChangeManagement = 'heating'; 
    monitoringAndControllingPhase1.QualityControl = 'unit'; 
    monitoringAndControllingPhase1.IssueResolution = 'message'; 
    monitoringAndControllingPhase1.Reporting = 'winter'; 
    var monitoringAndControllingPhase1ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase1.executionPhase = monitoringAndControllingPhase1ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase1); 
    monitoringAndControllingPhase1ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase1); 
 
    var monitoringAndControllingPhase2 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase2.PerformanceMeasurement = 'unit'; 
    monitoringAndControllingPhase2.ChangeManagement = 'craving'; 
    monitoringAndControllingPhase2.QualityControl = 'price'; 
    monitoringAndControllingPhase2.IssueResolution = 'cloud'; 
    monitoringAndControllingPhase2.Reporting = 'element'; 
    var monitoringAndControllingPhase2ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase2.executionPhase = monitoringAndControllingPhase2ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase2); 
    monitoringAndControllingPhase2ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase2); 
 
    var monitoringAndControllingPhase3 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase3.PerformanceMeasurement = 'do'; 
    monitoringAndControllingPhase3.ChangeManagement = 'salary'; 
    monitoringAndControllingPhase3.QualityControl = 'top'; 
    monitoringAndControllingPhase3.IssueResolution = 'dvd'; 
    monitoringAndControllingPhase3.Reporting = 'consciousness'; 
    var monitoringAndControllingPhase3ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase3.executionPhase = monitoringAndControllingPhase3ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase3); 
    monitoringAndControllingPhase3ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase3); 
 
  } 
 
  void initClosingPhases() { 
    var closingPhase1 = ClosingPhase(closingPhases.concept); 
    closingPhase1.FinalDeliverableHandover = 'fish'; 
    closingPhase1.ProjectDocumentation = 'plaho'; 
    closingPhase1.StakeholderSignOff = 'notch'; 
    closingPhase1.ProjectReview = 'auto'; 
    closingPhase1.ResourceRelease = 'series'; 
    closingPhase1.CelebrateSuccess = 'parfem'; 
    var closingPhase1MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase1.monitoringAndControllingPhase = closingPhase1MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase1); 
    closingPhase1MonitoringAndControllingPhase.closingPhase.add(closingPhase1); 
 
    var closingPhase2 = ClosingPhase(closingPhases.concept); 
    closingPhase2.FinalDeliverableHandover = 'sin'; 
    closingPhase2.ProjectDocumentation = 'undo'; 
    closingPhase2.StakeholderSignOff = 'east'; 
    closingPhase2.ProjectReview = 'sun'; 
    closingPhase2.ResourceRelease = 'down'; 
    closingPhase2.CelebrateSuccess = 'kids'; 
    var closingPhase2MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase2.monitoringAndControllingPhase = closingPhase2MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase2); 
    closingPhase2MonitoringAndControllingPhase.closingPhase.add(closingPhase2); 
 
    var closingPhase3 = ClosingPhase(closingPhases.concept); 
    closingPhase3.FinalDeliverableHandover = 'test'; 
    closingPhase3.ProjectDocumentation = 'professor'; 
    closingPhase3.StakeholderSignOff = 'email'; 
    closingPhase3.ProjectReview = 'salad'; 
    closingPhase3.ResourceRelease = 'sun'; 
    closingPhase3.CelebrateSuccess = 'cabinet'; 
    var closingPhase3MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase3.monitoringAndControllingPhase = closingPhase3MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase3); 
    closingPhase3MonitoringAndControllingPhase.closingPhase.add(closingPhase3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
