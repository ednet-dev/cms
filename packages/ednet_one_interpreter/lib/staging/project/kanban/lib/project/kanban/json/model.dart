part of project_kanban;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/project/kanban/json/model.dart

var projectKanbanModelJson = r'''
domain: 'project'
model: 'kanban'
concepts:
  - name: Library
    entry: true
    attributes:
      - name: name
  - name: Item
    attributes:
      - name: name
  - name: Author
    attributes:
      - name: name
      - name: image
      - name: bio
  - name: Publisher
    attributes:
      - name: name
      - name: logo
  - name: Genre
    attributes:
      - name: name
  - name: Series
    attributes:
      - name: name
  - name: Location
    attributes:
      - name: name
  - name: Book
    attributes:
      - name: name
      - name: author
      - name: publisher
      - name: genre
      - name: series
      - name: location
      - name: isbn
      - name: pages
      - name: published
      - name: language
      - name: format
      - name: description
  - name: Magazine
    attributes:
      - name: name
      - name: publisher
      - name: genre
      - name: series
      - name: location
      - name: published
      - name: language
      - name: format
      - name: description
  - name: Newspaper
    attributes:
      - name: name
      - name: publisher
      - name: genre
      - name: series
      - name: location
      - name: published
      - name: language
      - name: format
      - name: description
  - name: AudioBook
    attributes:
      - name: name
      - name: author
      - name: publisher
      - name: genre
      - name: series
      - name: location
      - name: published
      - name: language
      - name: format
      - name: description
  - name: eBook
    attributes:
      - name: name
      - name: author
      - name: publisher
      - name: genre
      - name: series
      - name: location
      - name: published
      - name: language
      - name: format
      - name: description






''';
  