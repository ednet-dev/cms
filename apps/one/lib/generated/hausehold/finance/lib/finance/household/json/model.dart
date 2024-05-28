part of finance_household;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/finance/household/json/model.dart

var financeHouseholdModelJson = r'''
domain: 'finance'
model: 'household'
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
  