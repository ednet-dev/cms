part of ednet_core;

Model fromJsonToModel(String json, Domain domain, String modelCode, yaml) {
  var jsonConcepts;
  var relations;

  if (yaml == null) {
    if (json.trim() == '') {
      throw EDNetException('Empty JSON string for Model parse');
    }
    var boardMap = jsonDecode(json);
    jsonConcepts = boardMap["concepts"];
    relations = boardMap["relations"];
  } else {
    jsonConcepts = yaml["concepts"];
    relations = yaml["relations"];
  }

  Model model = Model(domain, modelCode);

  for (var jsonConcept in jsonConcepts) {
    String conceptCode = jsonConcept["name"];
    bool conceptEntry = jsonConcept["entry"] ?? false;
    Concept concept = Concept(model, conceptCode);
    concept.entry = conceptEntry;

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
        int itemSequence = item["sequence"];
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
  }

  for (var relation in relations) {
    String from = relation["from"];
    String to = relation["to"];

    Concept? concept1 = model.concepts.singleWhereCode(from);
    Concept? concept2 = model.concepts.singleWhereCode(to);
    if (concept1 == null) {
      throw ConceptException(
          'Line concept is missing for the $from jsonConcept. For ${domain.code}.$modelCode');
    }
    if (concept2 == null) {
      throw ConceptException(
          'Line concept is missing for the $to jsonConcept. For ${domain.code}.$modelCode');
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
      }

      neighbor21.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor21.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor21.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor21.twin = true;
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
      }

      neighbor21.internal = lineInternal;
      if (lineCategory == 'inheritance') {
        neighbor21.inheritance = true;
      } else if (lineCategory == 'reflexive') {
        neighbor21.reflexive = true;
      } else if (lineCategory == 'twin') {
        neighbor21.twin = true;
      }
    }
  }

  return model;
}
