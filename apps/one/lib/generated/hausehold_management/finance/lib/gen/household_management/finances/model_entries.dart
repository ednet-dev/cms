part of household_management_finances; 
 
// lib/gen/household_management/finances/model_entries.dart 
 
class FinancesEntries extends ModelEntries { 
 
  FinancesEntries(Model model) : super(model); 
 
  Map<String, Entities> newEntries() { 
    var entries = Map<String, Entities>(); 
    var concept; 
    concept = model.concepts.singleWhereCode("Finance"); 
    entries["Finance"] = Finances(concept); 
    return entries; 
  } 
 
  Entities? newEntities(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Finance") { 
      return Finances(concept); 
    } 
    if (concept.code == "Bank") { 
      return Banks(concept); 
    } 
    if (concept.code == "Account") { 
      return Accounts(concept); 
    } 
    if (concept.code == "CreditCard") { 
      return CreditCards(concept); 
    } 
    if (concept.code == "Cash") { 
      return Cashs(concept); 
    } 
    if (concept.code == "Savings") { 
      return Savingss(concept); 
    } 
    if (concept.code == "Investment") { 
      return Investments(concept); 
    } 
    if (concept.code == "Income") { 
      return Incomes(concept); 
    } 
    return null; 
  } 
 
  Entity? newEntity(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Finance") { 
      return Finance(concept); 
    } 
    if (concept.code == "Bank") { 
      return Bank(concept); 
    } 
    if (concept.code == "Account") { 
      return Account(concept); 
    } 
    if (concept.code == "CreditCard") { 
      return CreditCard(concept); 
    } 
    if (concept.code == "Cash") { 
      return Cash(concept); 
    } 
    if (concept.code == "Savings") { 
      return Savings(concept); 
    } 
    if (concept.code == "Investment") { 
      return Investment(concept); 
    } 
    if (concept.code == "Income") { 
      return Income(concept); 
    } 
    return null; 
  } 
 
  Finances get finances => getEntry("Finance") as Finances; 
 
} 
 
