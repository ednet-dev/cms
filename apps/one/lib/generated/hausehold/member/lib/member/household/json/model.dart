part of member_household;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/member/household/json/model.dart

var memberHouseholdModelJson = r'''
domain: 'member'
model: 'household'
concepts:
  - name: Member
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false

''';
  