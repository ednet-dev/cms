 
part of ednet_one; 
 
// lib/ednet/one/model.dart 
 
class OneModel extends OneEntries { 
 
  OneModel(Model model) : super(model); 
 
  void fromJsonToLibraryEntry() { 
    fromJsonToEntry(ednetOneLibraryEntry); 
  } 
 
  void fromJsonToModel() { 
    fromJson(ednetOneModel); 
  } 
 
  void init() { 
    initLibraries(); 
  } 
 
  void initLibraries() { 
    var library1 = Library(libraries.concept); 
    libraries.add(library1); 
 
    var library2 = Library(libraries.concept); 
    libraries.add(library2); 
 
    var library3 = Library(libraries.concept); 
    libraries.add(library3); 
 
  } 
 
  // added after code gen - begin 
 
  // added after code gen - end 
 
} 
 
