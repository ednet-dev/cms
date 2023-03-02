part of ednetcore_tasks; 
 
// lib/repository.dart 
 
class Repository extends CoreRepository { 
 
  static const REPOSITORY = "Repository"; 
 
  Repository([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Ednetcore"); 
    domains.add(domain); 
    add(EdnetcoreDomain(domain)); 
 
  } 
 
} 
 
