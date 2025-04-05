part of project_kanban; 
 
// lib/gen/project/kanban/items.dart 
 
abstract class ItemGen extends Entity<Item> { 
 
  ItemGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  String get name => getAttribute("name"); 
  void set name(String a) { setAttribute("name", a); } 
  
  Item newEntity() => Item(concept); 
  Items newEntities() => Items(concept); 
  
} 
 
abstract class ItemsGen extends Entities<Item> { 
 
  ItemsGen(Concept concept) { 
    this.concept = concept; 
  } 
 
  Items newEntities() => Items(concept); 
  Item newEntity() => Item(concept); 
  
} 
 
