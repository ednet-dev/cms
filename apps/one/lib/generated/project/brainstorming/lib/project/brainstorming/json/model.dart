part of project_brainstorming;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/project/brainstorming/json/model.dart

var projectBrainstormingModelJson = r'''
domain: 'project'
model: 'brainstorming'
concepts:
  - name: MindMap
    entry: true
    attributes:
        - name: name
        - name: description
  - name: Node
    attributes:
        - name: name
        - name: description
  - name: Edge
    attributes:
        - name: name
        - name: description
        - name: from
        - name: to
        - name: weight
        - name: type
  - name: Link
    attributes:
        - name: name
        - name: description
        - name: url
  - name: Idea
    attributes:
        - name: name
        - name: description
  - name: Topic
    attributes:
        - name: name
        - name: description
''';
  