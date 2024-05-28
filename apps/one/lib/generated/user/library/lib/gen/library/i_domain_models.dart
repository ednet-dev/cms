part of library_user; 
 
// lib/gen/library/i_domain_models.dart 
 
class LibraryModels extends DomainModels { 
 
  LibraryModels(Domain domain) : super(domain) { 
    // fromJsonToModel function from ednet_core/lib/domain/model/transfer.json.dart 
 
    Model model = fromJsonToModel('', domain, "User",loadYaml(libraryUserModelJson)); 
    UserModel userModel = UserModel(model); 
    add(userModel); 
 
  } 
 
} 
 
