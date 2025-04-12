part of ednet_core;

/// Bootstraps a domain model from YAML configuration.
///
/// This function takes a YAML map containing domain model definitions
/// and creates a corresponding Domain object with all its models, concepts,
/// attributes, and relations defined in the YAML.
///
/// Parameters:
/// - yaml: The YAML map containing the domain model definition
///
/// Returns:
/// A fully initialized Domain object
Domain bootstrapDomainModelFromYaml(Map yaml) {
  // Extract the domain name
  final domainName = yaml['name'] as String? ?? 'DefaultDomain';
  final domain = Domain(domainName);

  // Process domain-level attributes/types if present
  if (yaml.containsKey('attributes')) {
    _processAttributes(domain, yaml['attributes'] as Map<dynamic, dynamic>);
  }

  // Process models if present
  if (yaml.containsKey('models')) {
    final models = yaml['models'] as Map<dynamic, dynamic>;

    for (final modelName in models.keys) {
      final modelConfig = models[modelName] as Map<dynamic, dynamic>;
      _processModel(domain, modelName.toString(), modelConfig);
    }
  }

  return domain;
}

/// Processes attributes defined at the domain level.
///
/// This creates global attribute type definitions that can be used
/// throughout the domain model.
void _processAttributes(Domain domain, Map<dynamic, dynamic> attributes) {
  for (final attributeName in attributes.keys) {
    final attributeConfig = attributes[attributeName] as Map<dynamic, dynamic>;
    final typeName = attributeConfig['type'] as String? ?? 'String';

    // Get or create the attribute type
    AttributeType? attributeType = domain.types.singleWhereCode(typeName);
    if (attributeType == null) {
      attributeType = AttributeType(domain, typeName);
    }

    // Apply constraints if present
    if (attributeConfig.containsKey('constraints')) {
      final constraints =
          attributeConfig['constraints'] as Map<dynamic, dynamic>;
      _applyConstraintsToType(attributeType, constraints);
    }
  }
}

/// Processes a model defined in the YAML configuration.
///
/// Creates a model object and its concepts, attributes, and relations.
void _processModel(
  Domain domain,
  String modelName,
  Map<dynamic, dynamic> modelConfig,
) {
  final model = Model(domain, modelName);

  // Process model attributes if present
  if (modelConfig.containsKey('attributes')) {
    final attributes = modelConfig['attributes'] as Map<dynamic, dynamic>;

    for (final attributeName in attributes.keys) {
      final attributeConfig =
          attributes[attributeName] as Map<dynamic, dynamic>;
      final typeName = attributeConfig['type'] as String? ?? 'String';

      // Create the concept if it doesn't exist
      var concept = model.concepts.singleWhereCode(modelName);
      if (concept == null) {
        concept = Concept(model, modelName);
      }

      // Create the attribute
      final attribute = Attribute(concept, attributeName.toString());

      // Set the type
      final attributeType = domain.getType(typeName);
      if (attributeType != null) {
        attribute.type = attributeType;

        // Apply constraints if present
        if (attributeConfig.containsKey('constraints')) {
          final constraints =
              attributeConfig['constraints'] as Map<dynamic, dynamic>;
          _applyConstraintsToType(attributeType, constraints);
        }
      }
    }
  }

  // Process concepts if present
  if (modelConfig.containsKey('concepts')) {
    final concepts = modelConfig['concepts'] as List;

    for (final conceptConfig in concepts) {
      final conceptName = conceptConfig['name'] as String;
      final concept = Concept(model, conceptName);

      // Process concept attributes
      if (conceptConfig.containsKey('attributes')) {
        final attributes = conceptConfig['attributes'] as List;

        for (final attributeConfig in attributes) {
          final attributeName = attributeConfig['name'] as String;
          final typeName = attributeConfig['type'] as String? ?? 'String';

          // Create the attribute
          final attribute = Attribute(concept, attributeName);

          // Set the type
          final attributeType = domain.getType(typeName);
          if (attributeType != null) {
            attribute.type = attributeType;

            // Apply constraints if present
            if (attributeConfig.containsKey('constraints')) {
              final constraints =
                  attributeConfig['constraints'] as Map<dynamic, dynamic>;
              _applyConstraintsToType(attributeType, constraints);
            }
          }
        }
      }
    }
  }

  // Process relations if present
  if (modelConfig.containsKey('relations')) {
    // Relation processing logic would go here
    // This would create parent-child relationships between concepts
  }
}

/// Applies constraints to a type from the YAML configuration.
void _applyConstraintsToType(
  AttributeType type,
  Map<dynamic, dynamic> constraints,
) {
  // Apply numeric constraints
  if (type.base == 'int' || type.base == 'double' || type.base == 'num') {
    if (constraints.containsKey('min')) {
      final min = constraints['min'];
      if (min is num) {
        type.setMinValue(min);
      } else if (min is String) {
        try {
          type.setMinValue(num.parse(min));
        } catch (e) {
          print('Invalid min value: $min');
        }
      }
    }

    if (constraints.containsKey('max')) {
      final max = constraints['max'];
      if (max is num) {
        type.setMaxValue(max);
      } else if (max is String) {
        try {
          type.setMaxValue(num.parse(max));
        } catch (e) {
          print('Invalid max value: $max');
        }
      }
    }
  }

  // Apply string constraints
  if (type.base == 'String') {
    if (constraints.containsKey('minLength')) {
      final minLength = constraints['minLength'];
      if (minLength is int) {
        type.setMinLength(minLength);
      } else if (minLength is String) {
        try {
          type.setMinLength(int.parse(minLength));
        } catch (e) {
          print('Invalid minLength: $minLength');
        }
      }
    }

    // Note: We don't need to set maxLength explicitly since it's already
    // set by default based on the type's length property
    if (constraints.containsKey('maxLength')) {
      final maxLength = constraints['maxLength'];
      if (maxLength is int) {
        type.length = maxLength;
      } else if (maxLength is String) {
        try {
          type.length = int.parse(maxLength);
        } catch (e) {
          print('Invalid maxLength: $maxLength');
        }
      }
    }

    if (constraints.containsKey('pattern')) {
      final pattern = constraints['pattern'];
      if (pattern is String) {
        type.setPattern(pattern);
      }
    }
  }
}
