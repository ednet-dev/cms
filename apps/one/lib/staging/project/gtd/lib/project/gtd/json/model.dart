part of project_gtd;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/project/gtd/json/model.dart

var projectGtdModelJson = r'''
domain: 'project'
model: 'gtd'
concepts:
  - name: Inbox
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: items
        type: List
        essential: true
        sensitive: false
    commands:
      - sequence: 1
        category: command
        name: CaptureItem
        type: String
        essential: true
        sensitive: false
    policies:
      - sequence: 1
        category: policy
        name: CapturePolicy
        description: Always capture everything immediately to ensure nothing is missed.
    events:
      - sequence: 1
        category: event
        name: ItemCaptured
        description: An item has been added to the inbox.

  - name: ClarifiedItem
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: nextAction
        type: String
        essential: true
        sensitive: false
    commands:
      - sequence: 1
        category: command
        name: ClarifyItem
        type: String
        essential: true
        sensitive: false
    policies:
      - sequence: 1
        category: policy
        name: ClarifyPolicy
        description: Process items regularly to keep the inbox empty.
    events:
      - sequence: 1
        category: event
        name: ItemClarified
        description: An item has been clarified and its next action decided.

  - name: Task
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: description
        type: String
        essential: true
        sensitive: false
    commands:
      - sequence: 1
        category: command
        name: OrganizeTask
        type: String
        essential: true
        sensitive: false
    events:
      - sequence: 1
        category: event
        name: TaskOrganized
        description: A task has been placed in the appropriate context or project.

  - name: Project
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: tasks
        type: List
        essential: true
        sensitive: false

  - name: Calendar
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: events
        type: List
        essential: true
        sensitive: false
    commands:
      - sequence: 1
        category: command
        name: ScheduleTask
        type: String
        essential: true
        sensitive: false
    events:
      - sequence: 1
        category: event
        name: TaskScheduled
        description: A task has been added to the calendar.

  - name: ContextList
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: contexts
        type: List
        essential: true
        sensitive: false

  - name: Review
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: assessments
        type: List
        essential: true
        sensitive: false
    commands:
      - sequence: 1
        category: command
        name: PerformReview
        type: String
        essential: true
        sensitive: false
    policies:
      - sequence: 1
        category: policy
        name: ReflectPolicy
        description: Weekly reviews to ensure the system stays current and reliable.
    events:
      - sequence: 1
        category: event
        name: ReviewCompleted
        description: A review has been conducted and the system updated.

  - name: NextAction
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: work
        type: String
        essential: true
        sensitive: false
    commands:
      - sequence: 1
        category: command
        name: ChooseNextAction
        type: String
        essential: true
        sensitive: false
      - sequence: 2
        category: command
        name: CompleteAction
        type: String
        essential: true
        sensitive: false
    policies:
      - sequence: 1
        category: policy
        name: EngagePolicy
        description: Use the current context, time available, energy levels, and priorities to choose the next action.
    events:
      - sequence: 1
        category: event
        name: ActionChosen
        description: An action has been selected to work on.
      - sequence: 2
        category: event
        name: ActionCompleted
        description: An action has been completed.

relations:
  - from: Inbox
    to: ClarifiedItem
    fromToName: clarifiedItems
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: inbox
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: ClarifiedItem
    to: Task
    fromToName: tasks
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: clarifiedItem
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Task
    to: Project
    fromToName: projects
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: task
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Task
    to: Calendar
    fromToName: calendar
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: task
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Task
    to: ContextList
    fromToName: contextLists
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: task
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Review
    to: Task
    fromToName: tasks
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: review
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: NextAction
    to: Task
    fromToName: tasks
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: action
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

''';
  