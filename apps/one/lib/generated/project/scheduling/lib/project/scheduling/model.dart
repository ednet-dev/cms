 
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
    initiationPhase1.ProjectCharter = 'job'; 
    initiationPhase1.StakeholderIdentification = 'mind'; 
    initiationPhase1.FeasibilityStudy = 'pencil'; 
    initiationPhase1.ProjectGoals = 'concern'; 
    initiationPhases.add(initiationPhase1); 
 
    var initiationPhase2 = InitiationPhase(initiationPhases.concept); 
    initiationPhase2.ProjectCharter = 'objective'; 
    initiationPhase2.StakeholderIdentification = 'accident'; 
    initiationPhase2.FeasibilityStudy = 'head'; 
    initiationPhase2.ProjectGoals = 'head'; 
    initiationPhases.add(initiationPhase2); 
 
    var initiationPhase3 = InitiationPhase(initiationPhases.concept); 
    initiationPhase3.ProjectCharter = 'instruction'; 
    initiationPhase3.StakeholderIdentification = 'cardboard'; 
    initiationPhase3.FeasibilityStudy = 'test'; 
    initiationPhase3.ProjectGoals = 'holiday'; 
    initiationPhases.add(initiationPhase3); 
 
  } 
 
  void initPlanningPhases() { 
    var planningPhase1 = PlanningPhase(planningPhases.concept); 
    planningPhase1.ScopeDefinition = 'hall'; 
    planningPhase1.WorkBreakdownStructure = 'camping'; 
    planningPhase1.ScheduleDevelopment = 'consciousness'; 
    planningPhase1.ResourcePlanning = 'theme'; 
    planningPhase1.Budgeting = 'concern'; 
    planningPhase1.RiskManagement = 'authority'; 
    planningPhase1.CommunicationPlan = 'debt'; 
    var planningPhase1InitiationPhase = initiationPhases.random(); 
    planningPhase1.initiationPhase = planningPhase1InitiationPhase; 
    planningPhases.add(planningPhase1); 
    planningPhase1InitiationPhase.planningPhase.add(planningPhase1); 
 
    var planningPhase2 = PlanningPhase(planningPhases.concept); 
    planningPhase2.ScopeDefinition = 'employer'; 
    planningPhase2.WorkBreakdownStructure = 'parfem'; 
    planningPhase2.ScheduleDevelopment = 'celebration'; 
    planningPhase2.ResourcePlanning = 'answer'; 
    planningPhase2.Budgeting = 'corner'; 
    planningPhase2.RiskManagement = 'revolution'; 
    planningPhase2.CommunicationPlan = 'auto'; 
    var planningPhase2InitiationPhase = initiationPhases.random(); 
    planningPhase2.initiationPhase = planningPhase2InitiationPhase; 
    planningPhases.add(planningPhase2); 
    planningPhase2InitiationPhase.planningPhase.add(planningPhase2); 
 
    var planningPhase3 = PlanningPhase(planningPhases.concept); 
    planningPhase3.ScopeDefinition = 'chairman'; 
    planningPhase3.WorkBreakdownStructure = 'right'; 
    planningPhase3.ScheduleDevelopment = 'lake'; 
    planningPhase3.ResourcePlanning = 'message'; 
    planningPhase3.Budgeting = 'marriage'; 
    planningPhase3.RiskManagement = 'tall'; 
    planningPhase3.CommunicationPlan = 'yellow'; 
    var planningPhase3InitiationPhase = initiationPhases.random(); 
    planningPhase3.initiationPhase = planningPhase3InitiationPhase; 
    planningPhases.add(planningPhase3); 
    planningPhase3InitiationPhase.planningPhase.add(planningPhase3); 
 
  } 
 
  void initExecutionPhases() { 
    var executionPhase1 = ExecutionPhase(executionPhases.concept); 
    executionPhase1.TaskAssignment = 'ocean'; 
    executionPhase1.ResourceAllocation = 'architecture'; 
    executionPhase1.ProjectManagement = 'future'; 
    executionPhase1.QualityAssurance = 'crisis'; 
    executionPhase1.Communication = 'ship'; 
    executionPhase1.RiskMonitoring = 'holiday'; 
    var executionPhase1PlanningPhase = planningPhases.random(); 
    executionPhase1.planningPhase = executionPhase1PlanningPhase; 
    executionPhases.add(executionPhase1); 
    executionPhase1PlanningPhase.executionPhase.add(executionPhase1); 
 
    var executionPhase2 = ExecutionPhase(executionPhases.concept); 
    executionPhase2.TaskAssignment = 'walking'; 
    executionPhase2.ResourceAllocation = 'question'; 
    executionPhase2.ProjectManagement = 'cup'; 
    executionPhase2.QualityAssurance = 'pub'; 
    executionPhase2.Communication = 'tension'; 
    executionPhase2.RiskMonitoring = 'cash'; 
    var executionPhase2PlanningPhase = planningPhases.random(); 
    executionPhase2.planningPhase = executionPhase2PlanningPhase; 
    executionPhases.add(executionPhase2); 
    executionPhase2PlanningPhase.executionPhase.add(executionPhase2); 
 
    var executionPhase3 = ExecutionPhase(executionPhases.concept); 
    executionPhase3.TaskAssignment = 'selfie'; 
    executionPhase3.ResourceAllocation = 'rice'; 
    executionPhase3.ProjectManagement = 'photo'; 
    executionPhase3.QualityAssurance = 'email'; 
    executionPhase3.Communication = 'left'; 
    executionPhase3.RiskMonitoring = 'course'; 
    var executionPhase3PlanningPhase = planningPhases.random(); 
    executionPhase3.planningPhase = executionPhase3PlanningPhase; 
    executionPhases.add(executionPhase3); 
    executionPhase3PlanningPhase.executionPhase.add(executionPhase3); 
 
  } 
 
  void initMonitoringAndControllingPhases() { 
    var monitoringAndControllingPhase1 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase1.PerformanceMeasurement = 'lunch'; 
    monitoringAndControllingPhase1.ChangeManagement = 'walking'; 
    monitoringAndControllingPhase1.QualityControl = 'course'; 
    monitoringAndControllingPhase1.IssueResolution = 'software'; 
    monitoringAndControllingPhase1.Reporting = 'seed'; 
    var monitoringAndControllingPhase1ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase1.executionPhase = monitoringAndControllingPhase1ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase1); 
    monitoringAndControllingPhase1ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase1); 
 
    var monitoringAndControllingPhase2 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase2.PerformanceMeasurement = 'executive'; 
    monitoringAndControllingPhase2.ChangeManagement = 'redo'; 
    monitoringAndControllingPhase2.QualityControl = 'hall'; 
    monitoringAndControllingPhase2.IssueResolution = 'school'; 
    monitoringAndControllingPhase2.Reporting = 'letter'; 
    var monitoringAndControllingPhase2ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase2.executionPhase = monitoringAndControllingPhase2ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase2); 
    monitoringAndControllingPhase2ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase2); 
 
    var monitoringAndControllingPhase3 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase3.PerformanceMeasurement = 'house'; 
    monitoringAndControllingPhase3.ChangeManagement = 'big'; 
    monitoringAndControllingPhase3.QualityControl = 'job'; 
    monitoringAndControllingPhase3.IssueResolution = 'price'; 
    monitoringAndControllingPhase3.Reporting = 'big'; 
    var monitoringAndControllingPhase3ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase3.executionPhase = monitoringAndControllingPhase3ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase3); 
    monitoringAndControllingPhase3ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase3); 
 
  } 
 
  void initClosingPhases() { 
    var closingPhase1 = ClosingPhase(closingPhases.concept); 
    closingPhase1.FinalDeliverableHandover = 'present'; 
    closingPhase1.ProjectDocumentation = 'baby'; 
    closingPhase1.StakeholderSignOff = 'judge'; 
    closingPhase1.ProjectReview = 'health'; 
    closingPhase1.ResourceRelease = 'training'; 
    closingPhase1.CelebrateSuccess = 'line'; 
    var closingPhase1MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase1.monitoringAndControllingPhase = closingPhase1MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase1); 
    closingPhase1MonitoringAndControllingPhase.closingPhase.add(closingPhase1); 
 
    var closingPhase2 = ClosingPhase(closingPhases.concept); 
    closingPhase2.FinalDeliverableHandover = 'do'; 
    closingPhase2.ProjectDocumentation = 'navigation'; 
    closingPhase2.StakeholderSignOff = 'chairman'; 
    closingPhase2.ProjectReview = 'pattern'; 
    closingPhase2.ResourceRelease = 'series'; 
    closingPhase2.CelebrateSuccess = 'tape'; 
    var closingPhase2MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase2.monitoringAndControllingPhase = closingPhase2MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase2); 
    closingPhase2MonitoringAndControllingPhase.closingPhase.add(closingPhase2); 
 
    var closingPhase3 = ClosingPhase(closingPhases.concept); 
    closingPhase3.FinalDeliverableHandover = 'line'; 
    closingPhase3.ProjectDocumentation = 'time'; 
    closingPhase3.StakeholderSignOff = 'message'; 
    closingPhase3.ProjectReview = 'objective'; 
    closingPhase3.ResourceRelease = 'ocean'; 
    closingPhase3.CelebrateSuccess = 'hospital'; 
    var closingPhase3MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase3.monitoringAndControllingPhase = closingPhase3MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase3); 
    closingPhase3MonitoringAndControllingPhase.closingPhase.add(closingPhase3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
