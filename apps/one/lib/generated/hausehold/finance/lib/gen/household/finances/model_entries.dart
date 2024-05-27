part of household_finances;
// Generated code for model entries in lib/gen/household/finances/model_entries.dart

class FinancesEntries extends ModelEntries {

  FinancesEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("Finance");
    entries["Finance"] = Finances(concept);
    return entries;
  }

  /// Returns a new set of entities for the given concept code.
  Entities? newEntities(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
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

  /// Returns a new entity for the given concept code.
  Entity? newEntity(String conceptCode) {
    var concept = model.concepts.singleWhereCode(conceptCode);
    if (concept == null) {
      throw ConceptError("${conceptCode} concept does not exist.");
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
