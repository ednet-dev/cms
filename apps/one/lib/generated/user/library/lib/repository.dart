part of user_library; 
 
// lib/repository.dart 
 
class UserLibraryRepo extends CoreRepository { 
 
  static const REPOSITORY = "UserLibraryRepo"; 
 
  UserLibraryRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("User"); 
    domains.add(domain); 
    add(UserDomain(domain)); 
 
  } 
 
} 
 
