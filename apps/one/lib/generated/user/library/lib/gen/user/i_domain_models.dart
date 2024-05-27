part of user_library; 
 
// lib/gen/user/i_domain_models.dart 
 
class UserModels extends DomainModels { 
 
  UserModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "Library",loadYaml(userLibraryModelJson)); 
    LibraryModel libraryModel = LibraryModel(model); 
    add(libraryModel); 
 
  } 
 
} 
 
