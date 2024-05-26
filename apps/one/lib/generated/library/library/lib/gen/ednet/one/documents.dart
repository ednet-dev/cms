part of ednet_one; 
 
// lib/gen/ednet/one/documents.dart 
 
abstract class DocumentGen extends Entity<Document> { 
 
  DocumentGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
