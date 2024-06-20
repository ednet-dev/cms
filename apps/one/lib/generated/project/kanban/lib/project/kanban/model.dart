 
part of project_kanban; 
 
// lib/project/kanban/model.dart 
 
class KanbanModel extends KanbanEntries { 
 
  KanbanModel(Model model) : super(model); 
 
  void fromJsonToLibraryEntry() { 
    fromJsonToEntry(projectKanbanLibraryEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(projectKanbanModel); 
  } 
 
  void init() { 
    initLibraries(); 
  } 
 
  void initLibraries() { 
    var library1 = Library(libraries.concept); 
    library1.name = 'city'; 
    libraries.add(library1); 
 
    var library2 = Library(libraries.concept); 
    library2.name = 'marriage'; 
    libraries.add(library2); 
 
    var library3 = Library(libraries.concept); 
    library3.name = 'security'; 
    libraries.add(library3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
