 
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
    initiationPhase1.ProjectCharter = 'dinner'; 
    initiationPhase1.StakeholderIdentification = 'election'; 
    initiationPhase1.FeasibilityStudy = 'price'; 
    initiationPhase1.ProjectGoals = 'bird'; 
    initiationPhases.add(initiationPhase1); 
 
    var initiationPhase2 = InitiationPhase(initiationPhases.concept); 
    initiationPhase2.ProjectCharter = 'teaching'; 
    initiationPhase2.StakeholderIdentification = 'ball'; 
    initiationPhase2.FeasibilityStudy = 'wheat'; 
    initiationPhase2.ProjectGoals = 'instruction'; 
    initiationPhases.add(initiationPhase2); 
 
    var initiationPhase3 = InitiationPhase(initiationPhases.concept); 
    initiationPhase3.ProjectCharter = 'web'; 
    initiationPhase3.StakeholderIdentification = 'circle'; 
    initiationPhase3.FeasibilityStudy = 'river'; 
    initiationPhase3.ProjectGoals = 'question'; 
    initiationPhases.add(initiationPhase3); 
 
  } 
 
  void initPlanningPhases() { 
    var planningPhase1 = PlanningPhase(planningPhases.concept); 
    planningPhase1.ScopeDefinition = 'walking'; 
    planningPhase1.WorkBreakdownStructure = 'concern'; 
    planningPhase1.ScheduleDevelopment = 'tape'; 
    planningPhase1.ResourcePlanning = 'notch'; 
    planningPhase1.Budgeting = 'sin'; 
    planningPhase1.RiskManagement = 'salary'; 
    planningPhase1.CommunicationPlan = 'body'; 
    var planningPhase1InitiationPhase = initiationPhases.random(); 
    planningPhase1.initiationPhase = planningPhase1InitiationPhase; 
    planningPhases.add(planningPhase1); 
    planningPhase1InitiationPhase.planningPhase.add(planningPhase1); 
 
    var planningPhase2 = PlanningPhase(planningPhases.concept); 
    planningPhase2.ScopeDefinition = 'time'; 
    planningPhase2.WorkBreakdownStructure = 'executive'; 
    planningPhase2.ScheduleDevelopment = 'understanding'; 
    planningPhase2.ResourcePlanning = 'office'; 
    planningPhase2.Budgeting = 'cardboard'; 
    planningPhase2.RiskManagement = 'feeling'; 
    planningPhase2.CommunicationPlan = 'executive'; 
    var planningPhase2InitiationPhase = initiationPhases.random(); 
    planningPhase2.initiationPhase = planningPhase2InitiationPhase; 
    planningPhases.add(planningPhase2); 
    planningPhase2InitiationPhase.planningPhase.add(planningPhase2); 
 
    var planningPhase3 = PlanningPhase(planningPhases.concept); 
    planningPhase3.ScopeDefinition = 'future'; 
    planningPhase3.WorkBreakdownStructure = 'letter'; 
    planningPhase3.ScheduleDevelopment = 'school'; 
    planningPhase3.ResourcePlanning = 'ticket'; 
    planningPhase3.Budgeting = 'call'; 
    planningPhase3.RiskManagement = 'accomodation'; 
    planningPhase3.CommunicationPlan = 'hospital'; 
    var planningPhase3InitiationPhase = initiationPhases.random(); 
    planningPhase3.initiationPhase = planningPhase3InitiationPhase; 
    planningPhases.add(planningPhase3); 
    planningPhase3InitiationPhase.planningPhase.add(planningPhase3); 
 
  } 
 
  void initExecutionPhases() { 
    var executionPhase1 = ExecutionPhase(executionPhases.concept); 
    executionPhase1.TaskAssignment = 'beginning'; 
    executionPhase1.ResourceAllocation = 'account'; 
    executionPhase1.ProjectManagement = 'software'; 
    executionPhase1.QualityAssurance = 'college'; 
    executionPhase1.Communication = 'sun'; 
    executionPhase1.RiskMonitoring = 'seed'; 
    var executionPhase1PlanningPhase = planningPhases.random(); 
    executionPhase1.planningPhase = executionPhase1PlanningPhase; 
    executionPhases.add(executionPhase1); 
    executionPhase1PlanningPhase.executionPhase.add(executionPhase1); 
 
    var executionPhase2 = ExecutionPhase(executionPhases.concept); 
    executionPhase2.TaskAssignment = 'concern'; 
    executionPhase2.ResourceAllocation = 'down'; 
    executionPhase2.ProjectManagement = 'boat'; 
    executionPhase2.QualityAssurance = 'river'; 
    executionPhase2.Communication = 'end'; 
    executionPhase2.RiskMonitoring = 'grading'; 
    var executionPhase2PlanningPhase = planningPhases.random(); 
    executionPhase2.planningPhase = executionPhase2PlanningPhase; 
    executionPhases.add(executionPhase2); 
    executionPhase2PlanningPhase.executionPhase.add(executionPhase2); 
 
    var executionPhase3 = ExecutionPhase(executionPhases.concept); 
    executionPhase3.TaskAssignment = 'economy'; 
    executionPhase3.ResourceAllocation = 'brave'; 
    executionPhase3.ProjectManagement = 'time'; 
    executionPhase3.QualityAssurance = 'cabinet'; 
    executionPhase3.Communication = 'judge'; 
    executionPhase3.RiskMonitoring = 'teaching'; 
    var executionPhase3PlanningPhase = planningPhases.random(); 
    executionPhase3.planningPhase = executionPhase3PlanningPhase; 
    executionPhases.add(executionPhase3); 
    executionPhase3PlanningPhase.executionPhase.add(executionPhase3); 
 
  } 
 
  void initMonitoringAndControllingPhases() { 
    var monitoringAndControllingPhase1 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase1.PerformanceMeasurement = 'offence'; 
    monitoringAndControllingPhase1.ChangeManagement = 'observation'; 
    monitoringAndControllingPhase1.QualityControl = 'answer'; 
    monitoringAndControllingPhase1.IssueResolution = 'vessel'; 
    monitoringAndControllingPhase1.Reporting = 'brad'; 
    var monitoringAndControllingPhase1ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase1.executionPhase = monitoringAndControllingPhase1ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase1); 
    monitoringAndControllingPhase1ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase1); 
 
    var monitoringAndControllingPhase2 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase2.PerformanceMeasurement = 'discount'; 
    monitoringAndControllingPhase2.ChangeManagement = 'park'; 
    monitoringAndControllingPhase2.QualityControl = 'authority'; 
    monitoringAndControllingPhase2.IssueResolution = 'down'; 
    monitoringAndControllingPhase2.Reporting = 'present'; 
    var monitoringAndControllingPhase2ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase2.executionPhase = monitoringAndControllingPhase2ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase2); 
    monitoringAndControllingPhase2ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase2); 
 
    var monitoringAndControllingPhase3 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase3.PerformanceMeasurement = 'hunting'; 
    monitoringAndControllingPhase3.ChangeManagement = 'line'; 
    monitoringAndControllingPhase3.QualityControl = 'umbrella'; 
    monitoringAndControllingPhase3.IssueResolution = 'vacation'; 
    monitoringAndControllingPhase3.Reporting = 'photo'; 
    var monitoringAndControllingPhase3ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase3.executionPhase = monitoringAndControllingPhase3ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase3); 
    monitoringAndControllingPhase3ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase3); 
 
  } 
 
  void initClosingPhases() { 
    var closingPhase1 = ClosingPhase(closingPhases.concept); 
    closingPhase1.FinalDeliverableHandover = 'teacher'; 
    closingPhase1.ProjectDocumentation = 'camping'; 
    closingPhase1.StakeholderSignOff = 'water'; 
    closingPhase1.ProjectReview = 'ship'; 
    closingPhase1.ResourceRelease = 'autobus'; 
    closingPhase1.CelebrateSuccess = 'place'; 
    var closingPhase1MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase1.monitoringAndControllingPhase = closingPhase1MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase1); 
    closingPhase1MonitoringAndControllingPhase.closingPhase.add(closingPhase1); 
 
    var closingPhase2 = ClosingPhase(closingPhases.concept); 
    closingPhase2.FinalDeliverableHandover = 'beginning'; 
    closingPhase2.ProjectDocumentation = 'call'; 
    closingPhase2.StakeholderSignOff = 'abstract'; 
    closingPhase2.ProjectReview = 'algorithm'; 
    closingPhase2.ResourceRelease = 'beans'; 
    closingPhase2.CelebrateSuccess = 'undo'; 
    var closingPhase2MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase2.monitoringAndControllingPhase = closingPhase2MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase2); 
    closingPhase2MonitoringAndControllingPhase.closingPhase.add(closingPhase2); 
 
    var closingPhase3 = ClosingPhase(closingPhases.concept); 
    closingPhase3.FinalDeliverableHandover = 'slate'; 
    closingPhase3.ProjectDocumentation = 'void'; 
    closingPhase3.StakeholderSignOff = 'understanding'; 
    closingPhase3.ProjectReview = 'computer'; 
    closingPhase3.ResourceRelease = 'objective'; 
    closingPhase3.CelebrateSuccess = 'secretary'; 
    var closingPhase3MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase3.monitoringAndControllingPhase = closingPhase3MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase3); 
    closingPhase3MonitoringAndControllingPhase.closingPhase.add(closingPhase3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
