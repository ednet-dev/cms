part of democracy_direct;

// lib/gen/democracy/direct/messages.dart

abstract class MessageGen extends Entity<Message> {

  MessageGen(Concept concept) {
    this.concept = concept;
    
  }

  

    Reference get ownerReference => getReference("owner") as Reference;
  void set ownerReference(Reference reference) => setReference("owner", reference);

  Citizen get owner => getParent("owner") as Citizen;
  void set owner(Citizen p) => setParent("owner", p);

  Reference get recipientReference => getReference("recipient") as Reference;
  void set recipientReference(Reference reference) => setReference("recipient", reference);

  Citizen get recipient => getParent("recipient") as Citizen;
  void set recipient(Citizen p) => setParent("recipient", p);


    String get text => getAttribute("text");
  void set text(String a) => setAttribute("text", a);

  String get status => getAttribute("status");
  void set status(String a) => setAttribute("status", a);


  

  @override
  Message newEntity() => Message(concept);

  Messages newEntities() => Messages(concept);

  
}

abstract class MessagesGen extends Entities<Message> {

  MessagesGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Messages newEntities() => Messages(concept);

  @override
  Message newEntity() => Message(concept);
}

// Commands for Message will be generated here
// Events for Message will be generated here
// Policies for Message will be generated here
