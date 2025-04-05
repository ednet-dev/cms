part of '../../../project_core.dart';

// lib/gen/project/core/budgets.dart

abstract class BudgetGen extends Entity<Budget> {
  BudgetGen(Concept concept) {
    this.concept = concept;
    // concept.children.isEmpty
  }
  

    Reference get projectReference => getReference('project')!;
  
  set projectReference(Reference reference) => 
      setReference('project', reference);
  Project get project =>
      getParent('project')! as Project;
  
  set project(Project p) => setParent('project', p);


    double get amount => getAttribute('amount') as double;
  
  set amount(double a) => setAttribute('amount', a);

  String get currency => getAttribute('currency') as String;
  
  set currency(String a) => setAttribute('currency', a);


  
  @override
  Budget newEntity() => Budget(concept);

  @override
  Budgets newEntities() => Budgets(concept);

  
}

abstract class BudgetsGen extends Entities<Budget> {
  BudgetsGen(Concept concept) {
    this.concept = concept;
  }

  @override
  Budgets newEntities() => Budgets(concept);

  @override
  Budget newEntity() => Budget(concept);
}

// Commands for Budget will be generated here
// Events for Budget will be generated here
// Policies for Budget will be generated here
