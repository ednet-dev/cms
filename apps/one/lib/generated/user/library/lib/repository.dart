part of library_user; 
 
// lib/repository.dart 
 
class LibraryUserRepo extends CoreRepository { 
 
  static const REPOSITORY = "LibraryUserRepo"; 
 
  LibraryUserRepo([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Library"); 
    domains.add(domain); 
    add(LibraryDomain(domain)); 
 
  } 
 
} 
 
