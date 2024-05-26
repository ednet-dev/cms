part of household_core;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/household/core/json/model.dart

var householdCoreModelJson = r'''
domain: 'household'
model: 'core'
concepts:
  - name: Household
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false
  - name: Member
  - name: Budget
  - name: Initiative
  - name: Project
  - name: Bank
  - name: Event

''';
  