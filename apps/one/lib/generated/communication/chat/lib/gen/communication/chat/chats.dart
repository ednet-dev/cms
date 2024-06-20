part of communication_chat; 
 
// lib/gen/communication/chat/chats.dart 
 
abstract class ChatGen extends Entity<Chat> { 
 
  ChatGen(Concept concept) { 
    this.concept = concept; 
    Concept messageConcept = concept.model.concepts.singleWhereCode("Message") as Concept; 
    assert(messageConcept != null); 
    setChild("messages", Messages(messageConcept)); 
    Concept categoryConcept = concept.model.concepts.singleWhereCode("Category") as Concept; 
    assert(categoryConcept != null); 
    setChild("categories", Categories(categoryConcept)); 
  } 
 
  String get title => getAttribute("title"); 
  void set title(String a) { setAttribute("title", a); } 
  
  String get apiKey => getAttribute("apiKey"); 
  void set apiKey(String a) { setAttribute("apiKey", a); } 
  
  Messages get messages => getChild("messages") as Messages; 
  
  Categories get categories => getChild("categories") as Categories; 
  
  Chat newEntity() => Chat(concept); 
  Chats newEntities() => Chats(concept); 
  
} 
 
abstract class ChatsGen extends Entities<Chat> { 
 
  ChatsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Chats newEntities() => Chats(concept); 
  Chat newEntity() => Chat(concept); 
  
} 
 
