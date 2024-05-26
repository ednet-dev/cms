part of household_management_project; 
 
// lib/repository.dart 
 
class Repository extends CoreRepository { 
 
  static const REPOSITORY = "Repository"; 
 
  Repository([String code=REPOSITORY]) : super(code) { 
    var domain = Domain("Household_management"); 
    domains.add(domain); 
    add(Household_managementDomain(domain)); 
 
  } 
 
} 
 
