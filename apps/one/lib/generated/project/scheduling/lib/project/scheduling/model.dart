 
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
    initiationPhase1.ProjectCharter = 'cream'; 
    initiationPhase1.StakeholderIdentification = 'salad'; 
    initiationPhase1.FeasibilityStudy = 'economy'; 
    initiationPhase1.ProjectGoals = 'fascination'; 
    initiationPhases.add(initiationPhase1); 
 
    var initiationPhase2 = InitiationPhase(initiationPhases.concept); 
    initiationPhase2.ProjectCharter = 'guest'; 
    initiationPhase2.StakeholderIdentification = 'do'; 
    initiationPhase2.FeasibilityStudy = 'debt'; 
    initiationPhase2.ProjectGoals = 'video'; 
    initiationPhases.add(initiationPhase2); 
 
    var initiationPhase3 = InitiationPhase(initiationPhases.concept); 
    initiationPhase3.ProjectCharter = 'security'; 
    initiationPhase3.StakeholderIdentification = 'agile'; 
    initiationPhase3.FeasibilityStudy = 'girl'; 
    initiationPhase3.ProjectGoals = 'ship'; 
    initiationPhases.add(initiationPhase3); 
 
  } 
 
  void initPlanningPhases() { 
    var planningPhase1 = PlanningPhase(planningPhases.concept); 
    planningPhase1.ScopeDefinition = 'parfem'; 
    planningPhase1.WorkBreakdownStructure = 'time'; 
    planningPhase1.ScheduleDevelopment = 'craving'; 
    planningPhase1.ResourcePlanning = 'consulting'; 
    planningPhase1.Budgeting = 'beans'; 
    planningPhase1.RiskManagement = 'chemist'; 
    planningPhase1.CommunicationPlan = 'objective'; 
    var planningPhase1InitiationPhase = initiationPhases.random(); 
    planningPhase1.initiationPhase = planningPhase1InitiationPhase; 
    planningPhases.add(planningPhase1); 
    planningPhase1InitiationPhase.planningPhase.add(planningPhase1); 
 
    var planningPhase2 = PlanningPhase(planningPhases.concept); 
    planningPhase2.ScopeDefinition = 'cream'; 
    planningPhase2.WorkBreakdownStructure = 'girl'; 
    planningPhase2.ScheduleDevelopment = 'employer'; 
    planningPhase2.ResourcePlanning = 'beach'; 
    planningPhase2.Budgeting = 'darts'; 
    planningPhase2.RiskManagement = 'corner'; 
    planningPhase2.CommunicationPlan = 'explanation'; 
    var planningPhase2InitiationPhase = initiationPhases.random(); 
    planningPhase2.initiationPhase = planningPhase2InitiationPhase; 
    planningPhases.add(planningPhase2); 
    planningPhase2InitiationPhase.planningPhase.add(planningPhase2); 
 
    var planningPhase3 = PlanningPhase(planningPhases.concept); 
    planningPhase3.ScopeDefinition = 'job'; 
    planningPhase3.WorkBreakdownStructure = 'brad'; 
    planningPhase3.ScheduleDevelopment = 'college'; 
    planningPhase3.ResourcePlanning = 'tent'; 
    planningPhase3.Budgeting = 'interest'; 
    planningPhase3.RiskManagement = 'kids'; 
    planningPhase3.CommunicationPlan = 'country'; 
    var planningPhase3InitiationPhase = initiationPhases.random(); 
    planningPhase3.initiationPhase = planningPhase3InitiationPhase; 
    planningPhases.add(planningPhase3); 
    planningPhase3InitiationPhase.planningPhase.add(planningPhase3); 
 
  } 
 
  void initExecutionPhases() { 
    var executionPhase1 = ExecutionPhase(executionPhases.concept); 
    executionPhase1.TaskAssignment = 'future'; 
    executionPhase1.ResourceAllocation = 'future'; 
    executionPhase1.ProjectManagement = 'office'; 
    executionPhase1.QualityAssurance = 'place'; 
    executionPhase1.Communication = 'seed'; 
    executionPhase1.RiskMonitoring = 'corner'; 
    var executionPhase1PlanningPhase = planningPhases.random(); 
    executionPhase1.planningPhase = executionPhase1PlanningPhase; 
    executionPhases.add(executionPhase1); 
    executionPhase1PlanningPhase.executionPhase.add(executionPhase1); 
 
    var executionPhase2 = ExecutionPhase(executionPhases.concept); 
    executionPhase2.TaskAssignment = 'cloud'; 
    executionPhase2.ResourceAllocation = 'time'; 
    executionPhase2.ProjectManagement = 'explanation'; 
    executionPhase2.QualityAssurance = 'advisor'; 
    executionPhase2.Communication = 'price'; 
    executionPhase2.RiskMonitoring = 'big'; 
    var executionPhase2PlanningPhase = planningPhases.random(); 
    executionPhase2.planningPhase = executionPhase2PlanningPhase; 
    executionPhases.add(executionPhase2); 
    executionPhase2PlanningPhase.executionPhase.add(executionPhase2); 
 
    var executionPhase3 = ExecutionPhase(executionPhases.concept); 
    executionPhase3.TaskAssignment = 'university'; 
    executionPhase3.ResourceAllocation = 'concern'; 
    executionPhase3.ProjectManagement = 'guest'; 
    executionPhase3.QualityAssurance = 'corner'; 
    executionPhase3.Communication = 'truck'; 
    executionPhase3.RiskMonitoring = 'offence'; 
    var executionPhase3PlanningPhase = planningPhases.random(); 
    executionPhase3.planningPhase = executionPhase3PlanningPhase; 
    executionPhases.add(executionPhase3); 
    executionPhase3PlanningPhase.executionPhase.add(executionPhase3); 
 
  } 
 
  void initMonitoringAndControllingPhases() { 
    var monitoringAndControllingPhase1 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase1.PerformanceMeasurement = 'vessel'; 
    monitoringAndControllingPhase1.ChangeManagement = 'phone'; 
    monitoringAndControllingPhase1.QualityControl = 'dog'; 
    monitoringAndControllingPhase1.IssueResolution = 'time'; 
    monitoringAndControllingPhase1.Reporting = 'hall'; 
    var monitoringAndControllingPhase1ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase1.executionPhase = monitoringAndControllingPhase1ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase1); 
    monitoringAndControllingPhase1ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase1); 
 
    var monitoringAndControllingPhase2 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase2.PerformanceMeasurement = 'grading'; 
    monitoringAndControllingPhase2.ChangeManagement = 'brad'; 
    monitoringAndControllingPhase2.QualityControl = 'course'; 
    monitoringAndControllingPhase2.IssueResolution = 'down'; 
    monitoringAndControllingPhase2.Reporting = 'yellow'; 
    var monitoringAndControllingPhase2ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase2.executionPhase = monitoringAndControllingPhase2ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase2); 
    monitoringAndControllingPhase2ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase2); 
 
    var monitoringAndControllingPhase3 = MonitoringAndControllingPhase(monitoringAndControllingPhases.concept); 
    monitoringAndControllingPhase3.PerformanceMeasurement = 'heating'; 
    monitoringAndControllingPhase3.ChangeManagement = 'sailing'; 
    monitoringAndControllingPhase3.QualityControl = 'policeman'; 
    monitoringAndControllingPhase3.IssueResolution = 'left'; 
    monitoringAndControllingPhase3.Reporting = 'call'; 
    var monitoringAndControllingPhase3ExecutionPhase = executionPhases.random(); 
    monitoringAndControllingPhase3.executionPhase = monitoringAndControllingPhase3ExecutionPhase; 
    monitoringAndControllingPhases.add(monitoringAndControllingPhase3); 
    monitoringAndControllingPhase3ExecutionPhase.monitoringAndControllingPhase.add(monitoringAndControllingPhase3); 
 
  } 
 
  void initClosingPhases() { 
    var closingPhase1 = ClosingPhase(closingPhases.concept); 
    closingPhase1.FinalDeliverableHandover = 'thing'; 
    closingPhase1.ProjectDocumentation = 'wife'; 
    closingPhase1.StakeholderSignOff = 'autobus'; 
    closingPhase1.ProjectReview = 'down'; 
    closingPhase1.ResourceRelease = 'dog'; 
    closingPhase1.CelebrateSuccess = 'security'; 
    var closingPhase1MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase1.monitoringAndControllingPhase = closingPhase1MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase1); 
    closingPhase1MonitoringAndControllingPhase.closingPhase.add(closingPhase1); 
 
    var closingPhase2 = ClosingPhase(closingPhases.concept); 
    closingPhase2.FinalDeliverableHandover = 'agreement'; 
    closingPhase2.ProjectDocumentation = 'vacation'; 
    closingPhase2.StakeholderSignOff = 'smog'; 
    closingPhase2.ProjectReview = 'universe'; 
    closingPhase2.ResourceRelease = 'restaurant'; 
    closingPhase2.CelebrateSuccess = 'coffee'; 
    var closingPhase2MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase2.monitoringAndControllingPhase = closingPhase2MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase2); 
    closingPhase2MonitoringAndControllingPhase.closingPhase.add(closingPhase2); 
 
    var closingPhase3 = ClosingPhase(closingPhases.concept); 
    closingPhase3.FinalDeliverableHandover = 'output'; 
    closingPhase3.ProjectDocumentation = 'school'; 
    closingPhase3.StakeholderSignOff = 'family'; 
    closingPhase3.ProjectReview = 'agile'; 
    closingPhase3.ResourceRelease = 'taxi'; 
    closingPhase3.CelebrateSuccess = 'plate'; 
    var closingPhase3MonitoringAndControllingPhase = monitoringAndControllingPhases.random(); 
    closingPhase3.monitoringAndControllingPhase = closingPhase3MonitoringAndControllingPhase; 
    closingPhases.add(closingPhase3); 
    closingPhase3MonitoringAndControllingPhase.closingPhase.add(closingPhase3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
