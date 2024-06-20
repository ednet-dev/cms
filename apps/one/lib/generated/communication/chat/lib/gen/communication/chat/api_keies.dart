part of communication_chat; 
 
// lib/gen/communication/chat/api_keies.dart 
 
abstract class ApiKeyGen extends Entity<ApiKey> { 
 
  ApiKeyGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get key => getAttribute("key"); 
  void set key(String a) { setAttribute("key", a); } 
  
  ApiKey newEntity() => ApiKey(concept); 
  ApiKeies newEntities() => ApiKeies(concept); 
  
} 
 
abstract class ApiKeiesGen extends Entities<ApiKey> { 
 
  ApiKeiesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  ApiKeies newEntities() => ApiKeies(concept); 
  ApiKey newEntity() => ApiKey(concept); 
  
} 
 
