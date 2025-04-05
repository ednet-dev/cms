part of '../../../project_core.dart';

// DSL: https://github.com/ednet-dev/cms/blob/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/code_generation/dsl/SCHEMA.md
// DSL Schema: https://github.com/ednet-dev/cms/blob/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/code_generation/dsl/schema/yaml/schema.json

// lib/project/core/json/model.dart
String projectCoreModelYaml = '''
domain: 'project'
model: 'core'
concepts:
  - name: Task
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: title
        type: String
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: dueDate
        type: DateTime
        essential: true
        sensitive: false
      - sequence: 3
        category: attribute
        name: status
        type: String
        essential: true
        sensitive: false
      - sequence: 4
        category: attribute
        name: priority
        type: String
        
        sensitive: false

  - name: Project
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: description
        type: String
        
        sensitive: false
      - sequence: 3
        category: attribute
        name: startDate
        type: DateTime
        essential: true
        sensitive: false
      - sequence: 4
        category: attribute
        name: endDate
        type: DateTime
        
        sensitive: false
      - sequence: 5
        category: attribute
        name: budget
        type: double
        
        sensitive: false

  - name: Milestone
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: date
        type: DateTime
        essential: true
        sensitive: false

  - name: Resource
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: type
        type: String
        essential: true
        sensitive: false
      - sequence: 3
        category: attribute
        name: cost
        type: double
        
        sensitive: false

  - name: Role
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: title
        type: String
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: responsibility
        type: String
        essential: true
        sensitive: false

  - name: Team
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false

  - name: Skill
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: level
        type: String
        
        sensitive: false

  - name: Time
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: hours
        type: int
        essential: true
        sensitive: false

  - name: Budget
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: amount
        type: double
        essential: true
        sensitive: false
      - sequence: 2
        category: attribute
        name: currency
        type: String
        essential: true
        sensitive: false

  - name: Initiative
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false

relations:
  - from: Project
    to: Task
    fromToName: tasks
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: project
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Project
    to: Milestone
    fromToName: milestones
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: project
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Task
    to: Resource
    fromToName: resources
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: task
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Team
    to: Role
    fromToName: roles
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: team
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Resource
    to: Skill
    fromToName: skills
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: resource
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Project
    to: Team
    fromToName: teams
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: project
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Project
    to: Budget
    fromToName: budgets
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: project
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Project
    to: Initiative
    fromToName: initiatives
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: project
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    

  - from: Project
    to: Time
    fromToName: times
    fromToMin: '0'
    fromToMax: 'N'
    toFromName: project
    toFromMin: '1'
    toFromMax: '1'
    internal: false
    


''';

  