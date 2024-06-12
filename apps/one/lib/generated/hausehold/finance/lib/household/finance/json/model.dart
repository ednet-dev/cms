part of household_finance;

// http://www.json.org/
// http://jsonformatter.curiousconcept.com/

// lib/household/finance/json/model.dart

var householdFinanceModelJson = r'''
domain: 'household'
model: 'finance'
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
  