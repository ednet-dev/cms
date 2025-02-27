part of ednet_core;

class Domain extends Entity<Domain> {
  String description;

  late Domain domain;

  Domains domains;
  AttributeTypes types;
  Models models;

  Domain([String domainCode = 'Default'])
      : domains = Domains(),
        types = AttributeTypes(),
        models = Models(),
        description = 'please define description' {
    super.code = domainCode;
    if (domainCode == 'Default') {
      description = 'Default domain to keep types and models.';
    }

    AttributeType(this, 'String');
    AttributeType(this, 'num');
    AttributeType(this, 'int');
    AttributeType(this, 'double');
    AttributeType(this, 'bool');
    AttributeType(this, 'DateTime');
    AttributeType(this, 'Uri');
    AttributeType(this, 'Email');
    AttributeType(this, 'Telephone');
    AttributeType(this, 'Name');
    AttributeType(this, 'Description');
    AttributeType(this, 'Money');
    AttributeType(this, 'dynamic');
    AttributeType(this, 'Other');
    assert(types.length == 14);
  }

  Domain? getDomain(String domainCode) => domains.singleWhereCode(domainCode);

  Model? getModel(String modelCode) => models.singleWhereCode(modelCode);

  AttributeType? getType(String typeCode) => types.singleWhereCode(typeCode);

  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['description'] = description;
    graph['types'] = types.toList().map((type) => type.toGraph()).toList();
    graph['models'] = models.toList().map((model) => model.toGraph()).toList();
    return graph;
  }
}

extension DomainExtensionToGraph on Domain {
  Map<String, dynamic> toGraph() {
    return {
      'code': code,
      'description': description,
      'domain': domain.code,
      'domains': domains.toGraph(),
      'types': types.toGraph(),
      'models': models.toGraph(),
    };
  }
}

extension DomainExtensionToDomains on Domain {
  Domains toDomains() {
    final domains = Domains();
    domains.add(this);
    return domains;
  }
}

extension DomainListExtension on List<Domain> {
  Domains toDomains() {
    final domains = Domains();
    for (var d in this) {
      domains.add(d);
    }
    return domains;
  }
}
