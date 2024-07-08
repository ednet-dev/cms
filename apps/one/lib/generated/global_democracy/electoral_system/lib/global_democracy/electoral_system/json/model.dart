part of global_democracy_electoral_system;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/global_democracy/electoral_system/json/model.dart

var global_democracyElectoral_systemModelJson = r'''
domain: global_democracy
model: electoral_system

concepts:
  - name: Citizen
    entry: true
    attributes:
      - name: citizenId
        type: String
      - name: name
        type: String
    policies:
      - name: VerifyIdentity
        description: Verify the identity of a citizen.
        expression: "citizenId != null && name != null"
        dependencies:
          - citizenId
          - name
    commands:
      - name: RegisterCitizen
        category: citizen
        description: Register a new citizen.
        successEvent: CitizenRegistered
        failureEvent: RegistrationFailed
    events:
      - name: CitizenRegistered
        description: A citizen has been registered.
        handlers:
          - WelcomeNewCitizen
      - name: RegistrationFailed
        description: Registration of a citizen failed.

''';
  