part of project_user; 
 
// lib/gen/project/user/categories.dart 
 
abstract class CategoryGen extends Entity<Category> { 
 
  CategoryGen(Concept concept) { 
    this.concept = concept; 
  } 
 
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
 
