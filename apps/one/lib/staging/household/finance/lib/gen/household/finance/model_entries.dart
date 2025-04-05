part of household_finance;
// Generated code for model entries in lib/gen/household/finance/model_entries.dart

class FinanceEntries extends ModelEntries {
  FinanceEntries(Model model) : super(model);

  /// Creates a map of new entries for each concept in the model.
  Map<String, Entities> newEntries() {
    var entries = Map<String, Entities>();
    var concept;
    concept = model.concepts.singleWhereCode("Finance");
    entries["Finance"] = Finances(concept);

    concept = model.concepts.singleWhereCode("Bank");
    entries["Bank"] = Banks(concept);

    concept = model.concepts.singleWhereCode("Account");
    entries["Account"] = Accounts(concept);

    concept = model.concepts.singleWhereCode("CreditCard");
    entries["CreditCard"] = CreditCards(concept);

    concept = model.concepts.singleWhereCode("Cash");
    entries["Cash"] = Cashs(concept);

    concept = model.concepts.singleWhereCode("Savings");
    entries["Savings"] = Savingss(concept);

    concept = model.concepts.singleWhereCode("Investment");
    entries["Investment"] = Investments(concept);

    concept = model.concepts.singleWhereCode("Income");
    entries["Income"] = Incomes(concept);

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
