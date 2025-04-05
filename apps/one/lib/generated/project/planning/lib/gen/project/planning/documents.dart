part of project_planning; 
 
// lib/gen/project/planning/documents.dart 
 
abstract class DocumentGen extends Entity<Document> { 
 
  DocumentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  String get description => getAttribute("description"); 
  void set description(String a) { setAttribute("description", a); } 
  
  String get type => getAttribute("type"); 
  void set type(String a) { setAttribute("type", a); } 
  
  String get status => getAttribute("status"); 
  void set status(String a) { setAttribute("status", a); } 
  
  Document newEntity() => Document(concept); 
  Documents newEntities() => Documents(concept); 
  
} 
 
abstract class DocumentsGen extends Entities<Document> { 
 
  DocumentsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Documents newEntities() => Documents(concept); 
  Document newEntity() => Document(concept); 
  
} 
 
