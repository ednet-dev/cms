part of household_member;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/household/member/json/model.dart

var householdMemberModelJson = r'''
domain: 'household'
model: 'member'
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
  