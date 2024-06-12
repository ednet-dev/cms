part of project_scheduling;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/project/scheduling/json/model.dart

var projectSchedulingModelJson = r'''
domain: 'project'
model: 'scheduling'
concepts:
  - name: InitiationPhase
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: ProjectCharter
        type: Document
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: StakeholderIdentification
        type: List
        essential: true
        sensitive: false
      - sequence: 3
        category: attribute
        name: FeasibilityStudy
        type: Document
        essential: true
        sensitive: false
      - sequence: 4
        category: attribute
        name: ProjectGoals
        type: List
        essential: true
        sensitive: false

  - name: PlanningPhase
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: ScopeDefinition
        type: Document
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: WorkBreakdownStructure
        type: Document
        essential: true
        sensitive: false
      - sequence: 3
        category: attribute
        name: ScheduleDevelopment
        type: Document
        essential: true
        sensitive: false
      - sequence: 4
        category: attribute
        name: ResourcePlanning
        type: Document
        essential: true
        sensitive: false
      - sequence: 5
        category: attribute
        name: Budgeting
        type: Document
        essential: true
        sensitive: false
      - sequence: 6
        category: attribute
        name: RiskManagement
        type: Document
        essential: true
        sensitive: false
      - sequence: 7
        category: attribute
        name: CommunicationPlan
        type: Document
        essential: true
        sensitive: false

  - name: ExecutionPhase
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: TaskAssignment
        type: Document
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: ResourceAllocation
        type: Document
        essential: true
        sensitive: false
      - sequence: 3
        category: attribute
        name: ProjectManagement
        type: Document
        essential: true
        sensitive: false
      - sequence: 4
        category: attribute
        name: QualityAssurance
        type: Document
        essential: true
        sensitive: false
      - sequence: 5
        category: attribute
        name: Communication
        type: Document
        essential: true
        sensitive: false
      - sequence: 6
        category: attribute
        name: RiskMonitoring
        type: Document
        essential: true
        sensitive: false

  - name: MonitoringAndControllingPhase
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: PerformanceMeasurement
        type: Document
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: ChangeManagement
        type: Document
        essential: true
        sensitive: false
      - sequence: 3
        category: attribute
        name: QualityControl
        type: Document
        essential: true
        sensitive: false
      - sequence: 4
        category: attribute
        name: IssueResolution
        type: Document
        essential: true
        sensitive: false
      - sequence: 5
        category: attribute
        name: Reporting
        type: Document
        essential: true
        sensitive: false

  - name: ClosingPhase
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: FinalDeliverableHandover
        type: Document
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: ProjectDocumentation
        type: Document
        essential: true
        sensitive: false
      - sequence: 3
        category: attribute
        name: StakeholderSignOff
        type: Document
        essential: true
        sensitive: false
      - sequence: 4
        category: attribute
        name: ProjectReview
        type: Document
        essential: true
        sensitive: false
      - sequence: 5
        category: attribute
        name: ResourceRelease
        type: Document
        essential: true
        sensitive: false
      - sequence: 6
        category: attribute
        name: CelebrateSuccess
        type: Document
        essential: true
        sensitive: false

relations:
  - from: InitiationPhase
    to: PlanningPhase
    fromToName: planningPhase
    fromToMin: '1'
    fromToMax: '1'
    toFromName: initiationPhase
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    category: 'sequence'

  - from: PlanningPhase
    to: ExecutionPhase
    fromToName: executionPhase
    fromToMin: '1'
    fromToMax: '1'
    toFromName: planningPhase
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    category: 'sequence'

  - from: ExecutionPhase
    to: MonitoringAndControllingPhase
    fromToName: monitoringAndControllingPhase
    fromToMin: '1'
    fromToMax: '1'
    toFromName: executionPhase
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    category: 'sequence'

  - from: MonitoringAndControllingPhase
    to: ClosingPhase
    fromToName: closingPhase
    fromToMin: '1'
    fromToMax: '1'
    toFromName: monitoringAndControllingPhase
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    category: 'sequence'

''';
  