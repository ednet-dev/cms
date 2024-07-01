part of settings_application;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/settings/application/json/model.dart

var settingsApplicationModelJson = r'''
domain: settings
model: application
concepts:
  - name: User
    attributes:
      - name: name
      - name: email
      - name: password

  - name: Role
    attributes:
      - name: name
      - name: description

  - name: Status
    attributes:
      - name: name
      - name: description

  - name: Theme

relationships:
  - name: UserRole
    from: User
    to: Role
    fromName: role
    toName: users
    fromMin: 1
    fromMax: 1
    toMin: 1
    toMax: N
  - name: UserStatus
    from: User
    to: Status
    fromName: status
    toName: users
    fromMin: 1
    fromMax: 1
    toMin: 1
    toMax: N



''';
  