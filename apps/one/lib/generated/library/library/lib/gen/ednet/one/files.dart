part of ednet_one; 
 
// lib/gen/ednet/one/files.dart 
 
abstract class FileGen extends Entity<File> { 
 
  FileGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  File newEntity() => File(concept); 
  Files newEntities() => Files(concept); 
  
} 
 
abstract class FilesGen extends Entities<File> { 
 
  FilesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Files newEntities() => Files(concept); 
  File newEntity() => File(concept); 
  
} 
 
