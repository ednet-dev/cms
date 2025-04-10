part of ednet_core;

Model fromJsonToModel(String json, Domain domain, String modelCode, Map? yaml) {
  Iterable jsonConcepts = [];
  Iterable relations = [];
  Map? schemaExtensions;

  if (yaml == null || yaml.isEmpty) {
    if (json.trim() == '') {
      throw EDNetException('Empty JSON string for Model parse');
    }
    var boardMap = jsonDecode(json);
    jsonConcepts = boardMap["concepts"];
    relations = boardMap["relations"];
    schemaExtensions = boardMap["schemaExtensions"];
  } else {
    jsonConcepts = yaml["concepts"] as Iterable;
    if (yaml.containsKey("relations")) {
      relations = yaml["relations"] as Iterable;
    }
    if (yaml.containsKey("schemaExtensions")) {
      schemaExtensions = yaml["schemaExtensions"] as Map;
    }
  }

  Model model = Model(domain, modelCode);

  // Parse concepts
  for (var jsonConcept in jsonConcepts) {
    String? conceptCode = jsonConcept["name"];
    assert(
      conceptCode != null,
      'Concept code is missing for the jsonConcept. For ${domain.code}.$modelCode',
    );
    bool conceptEntry = jsonConcept["entry"] ?? false;
    bool aggregateRoot = jsonConcept["aggregateRoot"] ?? false;

    Concept concept = Concept(model, conceptCode!);
    concept.entry = conceptEntry;

    // Add aggregateRoot marker if present
    if (aggregateRoot) {
      concept.category = "AggregateRoot";
    }

    // Process attributes
    var items = jsonConcept["attributes"] ?? [];
    for (var item in items) {
      String attributeCode = item["name"];
      if (attributeCode != 'oid' && attributeCode != 'code') {
        Attribute attribute = Attribute(concept, attributeCode);
        String itemCategory = item["category"] ?? '';
        if (itemCategory == 'guid') {
          attribute.guid = true;
        } else if (itemCategory == 'identifier') {
          attribute.identifier = true;
        } else if (itemCategory == 'required') {
          attribute.minc = '1';
        }
        int itemSequence = item["sequence"] as int? ?? 0;
        attribute.sequence = itemSequence;
        String itemInit = item["init"] ?? '';
        if (itemInit.trim() == '') {
          attribute.init = null;
        } else if (itemInit == 'increment') {
          attribute.increment = 1;
          attribute.init = null;
        } else if (itemInit == 'empty') {
          attribute.init = '';
        } else {
          attribute.init = itemInit;
        }
        bool itemEssential = item["essential"] ?? true;
        attribute.essential = itemEssential;
        bool itemSensitive = item["sensitive"] ?? false;
        attribute.sensitive = itemSensitive;
        String itemType = item["type"] ?? 'String';
        AttributeType? type = domain.types.singleWhereCode(itemType);
        if (type != null) {
          attribute.type = type;
        } else {
          attribute.type = domain.getType('String');
        }
      }
    }

    // Process commands
    processCommands(jsonConcept, concept);

    // Process events
    processEvents(jsonConcept, concept);

    // Process policies
    processPolicies(jsonConcept, concept);
  }

  // Process relations
  for (var relation in relations) {
    String from = relation["from"];
    String to = relation["to"];

    Concept? concept1 = model.concepts.singleWhereCode(from);
    Concept? concept2 = model.concepts.singleWhereCode(to);
    if (concept1 == null) {
      throw ConceptException(
        'Line concept is missing for the $from jsonConcept. For ${domain.code}.$modelCode',
      );
    }
    if (concept2 == null) {
      throw ConceptException(
        'Line concept is missing for the $to jsonConcept. For ${domain.code}.$modelCode',
      );
    }

    String fromToName = relation["fromToName"];
    String fromToMin = '${relation["fromToMin"]}';
    String fromToMax = '${relation["fromToMax"]}';
    bool fromToId = relation["fromToId"] ?? false;
    String toFromName = relation["toFromName"];
    String toFromMin = '${relation["toFromMin"]}';
    String toFromMax = '${relation["toFromMax"]}';
    bool toFromId = relation["toFromId"] ?? false;
    bool lineInternal = relation["internal"] ?? false;
    String lineCategory = relation["category"] ?? 'rel';

    bool d12Child;
    bool d21Child;
    bool d12Parent;
    bool d21Parent;

    if (fromToMax != '1') {
      d12Child = true;
      if (toFromMax != '1') {
        d21Child = true;
      } else {
        d21Child = false;
      }
    } else if (toFromMax != '1') {
      d12Child = false;
      d21Child = true;
    } else if (fromToMin == '0') {
      d12Child = true;
      d21Child = false;
    } else if (toFromMin == '0') {
      d12Child = false;
      d21Child = true;
    } else {
      d12Child = true;
      d21Child = false;
    }

    d12Parent = !d12Child;
    d21Parent = !d21Child;

    if (d12Child && d21Child) {
      throw Exception('$from -- $to relation has two children.');
    }
    if (d12Parent && d21Parent) {
      throw Exception('$from -- $to relation has two parents.');
    }

    Neighbor neighbor12;
    Neighbor neighbor21;

    if (d12Child && d21Parent) {
      neighbor12 = Child(concept1, concept2, fromToName);
      neighbor21 = Parent(concept2, concept1, toFromName);

      neighbor12.opposite = neighbor21;
      neighbor21.opposite = neighbor12;

      neighbor12.minc = fromToMin;
      neighbor12.maxc = fromToMax;
      neighbor12.identifier = fromToId;

      neighbor21.minc = toFromMin;
      neighbor21.maxc = toFromMax;
      neighbor21.identifier = toFromId;

      neighbor12.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor12.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor12.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor12.twin = true;
      } else if (lineCategory == 'association') {
        neighbor12.category = 'association';
      }

      neighbor21.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor21.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor21.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor21.twin = true;
      } else if (lineCategory == 'association') {
        neighbor21.category = 'association';
      }
    } else if (d12Parent && d21Child) {
      neighbor12 = Parent(concept1, concept2, fromToName);
      neighbor21 = Child(concept2, concept1, toFromName);

      neighbor12.opposite = neighbor21;
      neighbor21.opposite = neighbor12;

      neighbor12.minc = fromToMin;
      neighbor12.maxc = fromToMax;
      neighbor12.identifier = fromToId;

      neighbor21.minc = toFromMin;
      neighbor21.maxc = toFromMax;
      neighbor21.identifier = toFromId;

      neighbor12.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor12.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor12.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor12.twin = true;
      } else if (lineCategory == 'association') {
        neighbor12.category = 'association';
      }

      neighbor21.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor21.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor21.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor21.twin = true;
      } else if (lineCategory == 'association') {
        neighbor21.category = 'association';
      }
    }
  }

  return model;
}

void processCommands(Map jsonConcept, Concept concept) {
  var commands = jsonConcept["commands"] ?? [];
  for (var command in commands) {
    String commandName = command["name"];
    String description = command["description"] ?? '';
    String successEvent = command["successEvent"] ?? '';
    String failureEvent = command["failureEvent"] ?? '';
    List<String> roles = [];

    if (command.containsKey("roles")) {
      var rolesList = command["roles"] as List;
      roles = rolesList.map((role) => role.toString()).toList();
    }

    // Add command metadata to the concept
    if (!concept.metadata.containsKey('commands')) {
      concept.metadata['commands'] = {};
    }

    concept.metadata['commands'][commandName] = {
      'description': description,
      'successEvent': successEvent,
      'failureEvent': failureEvent,
      'roles': roles,
    };
  }
}

void processEvents(Map jsonConcept, Concept concept) {
  var events = jsonConcept["events"] ?? [];
  for (var event in events) {
    String eventName = event["name"];
    String description = event["description"] ?? '';
    List<String> triggers = [];

    if (event.containsKey("triggers")) {
      var triggersList = event["triggers"] as List;
      triggers = triggersList.map((trigger) => trigger.toString()).toList();
    }

    // Add event metadata to the concept
    if (!concept.metadata.containsKey('events')) {
      concept.metadata['events'] = {};
    }

    concept.metadata['events'][eventName] = {
      'description': description,
      'triggers': triggers,
    };
  }
}

void processPolicies(Map jsonConcept, Concept concept) {
  var policies = jsonConcept["policies"] ?? [];
  for (var policy in policies) {
    String policyName = policy["name"];
    String description = policy["description"] ?? '';
    String expression = policy["expression"] ?? '';
    List<String> eventTriggers = [];
    List<Map<String, String>> actions = [];

    if (policy.containsKey("events")) {
      var eventsList = policy["events"] as List;
      eventTriggers = eventsList.map((event) => event.toString()).toList();
    }

    if (policy.containsKey("actions")) {
      var actionsList = policy["actions"] as List;
      for (var action in actionsList) {
        actions.add({
          'command': action["command"] ?? '',
          'target': action["target"] ?? '',
        });
      }
    }

    // Add policy metadata to the concept
    if (!concept.metadata.containsKey('policies')) {
      concept.metadata['policies'] = {};
    }

    concept.metadata['policies'][policyName] = {
      'description': description,
      'expression': expression,
      'events': eventTriggers,
      'actions': actions,
    };
  }
}
