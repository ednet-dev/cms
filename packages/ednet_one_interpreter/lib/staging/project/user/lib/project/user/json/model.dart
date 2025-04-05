part of project_user;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/project/user/json/model.dart

var projectUserModelJson = r'''
domain: 'project'
model: 'user'
concepts:
  - name: User
    entry: true
    attributes:
      - name: name
      - name: email
      - name: password
      - name: role
      - name: status
  - name: Avatar
    attributes:
      - name: name
      - name: image
  - name: Profile
    attributes:
      - name: name
      - name: bio
      - name: location
      - name: website
      - name: birthday

  - name: Bookmarks
    attributes:
      - name: name
      - name: url
      - name: description
  - name: Note
    attributes:
      - name: title
      - name: content
  - name: Comment
    attributes:
      - name: content
  - name: Tag
    attributes:
      - name: name
  - name: Category
    attributes:
      - name: name


''';
  