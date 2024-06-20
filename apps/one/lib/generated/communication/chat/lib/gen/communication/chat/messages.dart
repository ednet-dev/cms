part of communication_chat; 
 
// lib/gen/communication/chat/messages.dart 
 
abstract class MessageGen extends Entity<Message> { 
 
  MessageGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get chatReference => getReference("chat") as Reference; 
  void set chatReference(Reference reference) { setReference("chat", reference); } 
  
  Chat get chat => getParent("chat") as Chat; 
  void set chat(Chat p) { setParent("chat", p); } 
  
  String get text => getAttribute("text"); 
  void set text(String a) { setAttribute("text", a); } 
  
  String get timestamp => getAttribute("timestamp"); 
  void set timestamp(String a) { setAttribute("timestamp", a); } 
  
  Message newEntity() => Message(concept); 
  Messages newEntities() => Messages(concept); 
  
} 
 
abstract class MessagesGen extends Entities<Message> { 
 
  MessagesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Messages newEntities() => Messages(concept); 
  Message newEntity() => Message(concept); 
  
} 
 
