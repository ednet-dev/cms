part of project_planning;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/project/planning/json/model.dart

var projectPlanningModelJson = r'''
domain: 'project'
model: 'planning'
concepts:
  - name: Plan
    entry: true
    attributes:
      - name: name
  - name: Schedule
    attributes:
      - name: name
      - name: tasks
      - name: executionType
      - name: StartDate
      - name: EndDate
  - name: Task
    attributes:
      - name: name
      - name: description
      - name: priority
      - name: status
      - name: StartDate
      - name: EndDate
  - name: Resource
    attributes:
      - name: name
      - name: type
      - name: description
      - name: status
  - name: Project
    attributes:
      - name: name
      - name: description
      - name: startDate
      - name: endDate
      - name: budget
  - name: Milestone
    attributes:
      - name: name
      - name: description
      - name: dueDate
      - name: status
  - name: Deliverable
    attributes:
      - name: name
      - name: description
      - name: dueDate
      - name: status
  - name: Dependency
    attributes:
      - name: name
      - name: description
      - name: type
      - name: status
  - name: Risk
    attributes:
      - name: name
      - name: description
      - name: type
      - name: status
  - name: Issue
    attributes:
      - name: name
      - name: description
      - name: type
      - name: status
  - name: ChangeRequest
    attributes:
      - name: name
      - name: description
      - name: type
      - name: status
  - name: Document
    attributes:
      - name: name
      - name: description
      - name: type
      - name: status
  - name: Review
    attributes:
      - name: name
      - name: description
      - name: type
      - name: status





''';
  