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
}
