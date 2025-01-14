part of ednet_core;

class Models extends Entities<Model> {}

class Model extends Entity<Model> {
  String? author;
  String? description;
  late final PolicyRegistry policyRegistry;
  late final PolicyEvaluator policyEvaluator;

  Domain domain;

  Concepts concepts = Concepts();

  Model(this.domain, String modelCode) {
    super.code = modelCode;
    domain.models.add(this);

    policyRegistry = PolicyRegistry();
    policyEvaluator = PolicyEvaluator(policyRegistry);
  }

  List<Concept> get entryConcepts {
    var selectedElements = concepts.toList().where((c) => c.entry);
    var entryList = <Concept>[];
    for (var concept in selectedElements) {
      entryList.add(concept);
    }
    return entryList;
  }

  // for model init, order by external parent count (from low to high)
  List<Concept> get orderedEntryConcepts {
    var orderedEntryConceptsCount = 0;
    var orderedEntryConcepts = <Concept>[];
    for (var c = 0; c < 9; c++) {
      var sameExternalCountConcepts = <Concept>[];
      for (var concept in entryConcepts) {
        if (concept.parents.externalCount == c) {
          sameExternalCountConcepts.add(concept);
        }
      }
      // order by external child count (from high to low)
      var orderedSameExternalCountConcepts = <Concept>[];
      for (var s = 8; s >= 0; s--) {
        for (var concept in sameExternalCountConcepts) {
          if (concept.children.externalCount == s) {
            orderedSameExternalCountConcepts.add(concept);
          }
        }
      }
      assert(sameExternalCountConcepts.length ==
          orderedSameExternalCountConcepts.length);
      for (var concept in orderedSameExternalCountConcepts) {
        orderedEntryConcepts.add(concept);
        orderedEntryConceptsCount++;
      }
      if (orderedEntryConceptsCount == entryConcepts.length) {
        return orderedEntryConcepts;
      }
    }
    var msg = """
      Not all entry concepts are ordered by external parent count (from low to high). 
      There is an entry concept in your model that has more than 9 external neighbors.
      Inform the EDNetCore authors to increase this restriction.
    """;
    throw ConceptException(msg);
  }

  int get entryConceptCount => entryConcepts.length;

  int get orderedEntryConceptCount => orderedEntryConcepts.length;

  Concept? getEntryConcept(String entryConceptCode) {
    Concept? concept = concepts.singleWhereCode(entryConceptCode);

    if (concept == null) {
      throw EDNetException(
          '  Concept getEntryConcept(String entryConceptCode)');
    }
    if (!(concept.entry)) {
      throw ConceptException(
          '$entryConceptCode concept is not entry. $entryConceptCode');
    }
    return concept;
  }

  int get conceptCount => concepts.length;

  Concept? getConcept(String conceptCode) =>
      concepts.singleWhereCode(conceptCode);

  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['author'] = author;
    graph['description'] = description;
    graph['concepts'] =
        concepts.toList().map((concept) => concept.toGraph()).toList();
    return graph;
  }

  Concepts getEntryConcepts() {
    var selectedElements = concepts.toList().where((c) => c.entry);
    var entryList = Concepts();
    for (var concept in selectedElements) {
      entryList.add(concept);
    }
    return entryList;
  }

  Concepts getOrderedEntryConcepts() {
    var orderedEntryConceptsAsConcepts = Concepts();
    orderedEntryConcepts.map(orderedEntryConceptsAsConcepts.add);
    return orderedEntryConceptsAsConcepts;
  }

  void registerPolicy(String key, IPolicy policy) {
    policyRegistry.registerPolicy(key, policy);
  }

  void removePolicy(String key) {
    policyRegistry.removePolicy(key);
  }

  @override
  PolicyEvaluationResult evaluatePolicies({String? policyKey}) {
    // gather all entity entries of model and evaluate them
    // var entityEntries = Entities<Concept>();
    // for (var concept in entryConcepts) {
    //   (concept.nonIdentifierAttributes.toList()
    //         ..addAll(concept.nonIdentifierAttributes.toList()))
    //       .forEach((attribute) {
    //     if (attribute is ReferenceAttribute) {
    //       entityEntries.addAll(attribute.entities);
    //     }
    //   });
    // }
    // return policyEvaluator.evaluate(this, policyKey: policyKey);

    return PolicyEvaluationResult(true, []);
  }

  bool validateEntity(Entity entity) {
    var result = evaluateModelPolicies(entity);
    return result.success;
  }

  void enforcePolicies(Entity entity) {
    var result = evaluateModelPolicies(entity);
    if (!result.success) {
      throw PolicyViolationException(result.violations);
    }
  }

  evaluateModelPolicies(Entity entity) {
    return true;
  }
}
