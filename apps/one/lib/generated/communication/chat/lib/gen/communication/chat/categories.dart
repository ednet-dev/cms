part of communication_chat; 
 
// lib/gen/communication/chat/categories.dart 
 
abstract class CategoryGen extends Entity<Category> { 
 
  CategoryGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Reference get chatsReference => getReference("chats") as Reference; 
  void set chatsReference(Reference reference) { setReference("chats", reference); } 
  
  Chat get chats => getParent("chats") as Chat; 
  void set chats(Chat p) { setParent("chats", p); } 
  
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Category newEntity() => Category(concept); 
  Categories newEntities() => Categories(concept); 
  
} 
 
abstract class CategoriesGen extends Entities<Category> { 
 
  CategoriesGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Categories newEntities() => Categories(concept); 
  Category newEntity() => Category(concept); 
  
} 
 
