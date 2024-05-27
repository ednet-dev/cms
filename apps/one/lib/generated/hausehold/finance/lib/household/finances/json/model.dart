part of household_finances;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/household/finances/json/model.dart

var householdFinancesModelJson = r'''
domain: 'household'
model: 'finances'
concepts:
  - name: Finance
    entry: true
    attributes:
      - sequence: 1
        category: attribute
        name: name
        type: String
        essential: true
        sensitive: false

  - name: Bank
  - name: Account
  - name: CreditCard
  - name: Cash
  - name: Savings
  - name: Investment
  - name: Income

''';
  