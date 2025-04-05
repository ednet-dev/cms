part of project_user; 
 
// lib/gen/project/user/notes.dart 
 
abstract class NoteGen extends Entity<Note> { 
 
  NoteGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get content => getAttribute("content"); 
  void set content(String a) { setAttribute("content", a); } 
  
  Note newEntity() => Note(concept); 
  Notes newEntities() => Notes(concept); 
  
} 
 
abstract class NotesGen extends Entities<Note> { 
 
  NotesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Notes newEntities() => Notes(concept); 
  Note newEntity() => Note(concept); 
  
} 
 
