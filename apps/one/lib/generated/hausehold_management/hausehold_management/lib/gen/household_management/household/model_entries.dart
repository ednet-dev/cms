part of household_management_household; 
 
// lib/gen/household_management/household/model_entries.dart 
 
class HouseholdEntries extends ModelEntries { 
 
  HouseholdEntries(Model model) : super(model); 
 
  Map<String, Entities> newEntries() { 
    var entries = Map<String, Entities>(); 
    var concept; 
    concept = model.concepts.singleWhereCode("Household"); 
    entries["Household"] = Households(concept); 
    return entries; 
  } 
 
  Entities? newEntities(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Household") { 
      return Households(concept); 
    } 
    if (concept.code == "Member") { 
      return Members(concept); 
    } 
    if (concept.code == "Budget") { 
      return Budgets(concept); 
    } 
    if (concept.code == "Initiative") { 
      return Initiatives(concept); 
    } 
    if (concept.code == "Project") { 
      return Projects(concept); 
    } 
    if (concept.code == "Bank") { 
      return Banks(concept); 
    } 
    if (concept.code == "Event") { 
      return Events(concept); 
    } 
    return null; 
  } 
 
  Entity? newEntity(String conceptCode) { 
    var concept = model.concepts.singleWhereCode(conceptCode); 
    if (concept == null) { 
      throw ConceptError("${conceptCode} concept does not exist.") ; 
    } 
    if (concept.code == "Household") { 
      return Household(concept); 
    } 
    if (concept.code == "Member") { 
      return Member(concept); 
    } 
    if (concept.code == "Budget") { 
      return Budget(concept); 
    } 
    if (concept.code == "Initiative") { 
      return Initiative(concept); 
    } 
    if (concept.code == "Project") { 
      return Project(concept); 
    } 
    if (concept.code == "Bank") { 
      return Bank(concept); 
    } 
    if (concept.code == "Event") { 
      return Event(concept); 
    } 
    return null; 
  } 
 
  Households get households => getEntry("Household") as Households; 
 
} 
 
