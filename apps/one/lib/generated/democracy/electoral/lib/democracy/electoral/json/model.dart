part of '../../../democracy_electoral.dart';

// DSL: https://github.com/ednet-dev/cms/blob/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/code_generation/dsl/SCHEMA.md
// DSL Schema: https://github.com/ednet-dev/cms/blob/7bbe3ff53cc4e3178d0fac144f86dc87e5d27a44/packages/code_generation/dsl/schema/yaml/schema.json

// lib/democracy/electoral/json/model.dart
String democracyElectoralModelYaml = '''
domain: democracy
model: electoral

concepts:
  - name: Citizen
    entry: true
    attributes:
      - name: citizenId
        category: identifier
      - name: firstName
      - name: lastName

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

  