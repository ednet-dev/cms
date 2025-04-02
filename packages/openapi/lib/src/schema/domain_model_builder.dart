part of openapi;

/// Builder for creating EDNet domain models from OpenAPI schemas.
///
/// This class takes an OpenAPI schema and transforms it into an EDNet
/// domain model, allowing dynamic integration with any OpenAPI service.
class DomainModelBuilder {
  /// Creates a domain model from an OpenAPI schema.
  ///
  /// Parameters:
  /// - [schema]: The OpenAPI schema to build from
  /// - [domainName]: Optional name for the domain (defaults to schema title)
  /// - [includeExtensions]: Whether to include OpenAPI extensions (x-* fields)
  ///
  /// Returns:
  /// An EDNet domain model
  Domain buildDomainFromSchema(
    Map<String, dynamic> schema, {
    String? domainName,
    bool includeExtensions = false,
  }) {
    // Get the title from schema info
    final info = schema['info'] as Map<String, dynamic>?;
    final title = info?['title'] as String? ?? 'OpenApiDomain';
    
    // Create the domain
    final domain = Domain(domainName ?? title);
    
    // Process schema components/definitions
    final components = schema['components'] as Map<String, dynamic>?;
    final definitions = schema['definitions'] as Map<String, dynamic>?;
    final schemas = components?['schemas'] as Map<String, dynamic>? ?? 
                   definitions as Map<String, dynamic>?;
    
    if (schemas != null) {
      // Create concepts from schemas
      for (final entry in schemas.entries) {
        final conceptName = entry.key;
        final schemaObj = entry.value as Map<String, dynamic>;
        
        _addConceptFromSchema(domain, conceptName, schemaObj, includeExtensions);
      }
    }
    
    // Build relationships from schema references
    _buildRelationships(domain, schemas);
    
    return domain;
  }
  
  /// Adds a concept to the domain from a schema.
  ///
  /// Parameters:
  /// - [domain]: The domain to add the concept to
  /// - [conceptName]: The name of the concept
  /// - [schema]: The schema object for the concept
  /// - [includeExtensions]: Whether to include OpenAPI extensions
  void _addConceptFromSchema(
    Domain domain,
    String conceptName,
    Map<String, dynamic> schema,
    bool includeExtensions,
  ) {
    // Skip if this isn't an object
    final type = schema['type'] as String?;
    if (type != null && type != 'object') {
      return;
    }
    
    // Create the concept
    final concept = Concept(conceptName);
    
    // Add description if available
    final description = schema['description'] as String?;
    if (description != null) {
      concept.description = description;
    }
    
    // Process properties
    final properties = schema['properties'] as Map<String, dynamic>?;
    if (properties != null) {
      // Get required properties
      final required = schema['required'] as List<dynamic>? ?? <String>[];
      
      for (final prop in properties.entries) {
        final propName = prop.key;
        final propSchema = prop.value as Map<String, dynamic>;
        
        // Create attribute for this property
        final attribute = _createAttributeFromProperty(
          propName, 
          propSchema,
          required.contains(propName),
          includeExtensions,
        );
        
        concept.addAttribute(attribute);
      }
    }
    
    domain.addConcept(concept);
  }
  
  /// Creates an attribute from a property schema.
  ///
  /// Parameters:
  /// - [name]: The name of the property
  /// - [property]: The property schema
  /// - [isRequired]: Whether the property is required
  /// - [includeExtensions]: Whether to include OpenAPI extensions
  ///
  /// Returns:
  /// An attribute for the property
  Attribute _createAttributeFromProperty(
    String name,
    Map<String, dynamic> property,
    bool isRequired,
    bool includeExtensions,
  ) {
    final type = property['type'] as String?;
    final format = property['format'] as String?;
    final description = property['description'] as String?;
    
    // Determine attribute type
    Attribute attribute;
    
    switch (type) {
      case 'string':
        if (format == 'date-time' || format == 'date') {
          attribute = DateTimeAttribute(name);
        } else if (format == 'binary' || format == 'byte') {
          attribute = BinaryAttribute(name);
        } else {
          attribute = StringAttribute(name);
        }
        break;
        
      case 'integer':
        attribute = IntegerAttribute(name);
        break;
        
      case 'number':
        attribute = DoubleAttribute(name);
        break;
        
      case 'boolean':
        attribute = BooleanAttribute(name);
        break;
        
      case 'array':
        // For arrays, we'll use a string attribute with a special marker
        attribute = StringAttribute(name);
        attribute.isCollection = true;
        break;
        
      case 'object':
      default:
        // For complex objects or unknown types, default to string
        attribute = StringAttribute(name);
        break;
    }
    
    // Set common properties
    if (description != null) {
      attribute.description = description;
    }
    
    attribute.required = isRequired;
    
    // Handle additional schema properties
    final enumValues = property['enum'] as List<dynamic>?;
    if (enumValues != null && enumValues.isNotEmpty) {
      attribute.hasEnumeration = true;
      // Set enum values (would need to implement this in the Attribute classes)
    }
    
    // Handle extensions if enabled
    if (includeExtensions) {
      for (final entry in property.entries) {
        final key = entry.key;
        if (key.startsWith('x-')) {
          // Store extension in attribute metadata
          // (would need to implement this in the Attribute classes)
        }
      }
    }
    
    return attribute;
  }
  
  /// Builds relationships between concepts based on schema references.
  ///
  /// Parameters:
  /// - [domain]: The domain to add relationships to
  /// - [schemas]: The schema definitions
  void _buildRelationships(Domain domain, Map<String, dynamic>? schemas) {
    if (schemas == null) return;
    
    // For each concept in the domain
    for (final concept in domain.concepts) {
      final conceptSchema = schemas[concept.name] as Map<String, dynamic>?;
      if (conceptSchema == null) continue;
      
      final properties = conceptSchema['properties'] as Map<String, dynamic>?;
      if (properties == null) continue;
      
      // For each property in the concept
      for (final entry in properties.entries) {
        final propName = entry.key;
        final propSchema = entry.value as Map<String, dynamic>;
        
        // Check if this property is a reference
        final ref = propSchema['\$ref'] as String?;
        if (ref != null) {
          // Extract the referenced concept name
          final refParts = ref.split('/');
          final refName = refParts.last;
          
          // Find the referenced concept
          final refConcept = domain.findConcept(refName);
          if (refConcept != null) {
            // Create a parent relationship
            concept.addParent(Parent(propName, refConcept));
          }
        }
        
        // Check if this is an array of references
        final items = propSchema['items'] as Map<String, dynamic>?;
        final itemRef = items?['\$ref'] as String?;
        if (type == 'array' && itemRef != null) {
          // Extract the referenced concept name
          final refParts = itemRef.split('/');
          final refName = refParts.last;
          
          // Find the referenced concept
          final refConcept = domain.findConcept(refName);
          if (refConcept != null) {
            // Create a child relationship
            concept.addChild(Child(propName, refConcept));
          }
        }
      }
    }
  }
}

/// String attribute for OpenAPI schema integration.
class StringAttribute extends Attribute {
  /// Whether this attribute represents a collection.
  bool isCollection = false;
  
  /// Creates a new string attribute.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  StringAttribute(String name) : super(name, 'String');
}

/// Integer attribute for OpenAPI schema integration.
class IntegerAttribute extends Attribute {
  /// Creates a new integer attribute.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  IntegerAttribute(String name) : super(name, 'Integer');
}

/// Double attribute for OpenAPI schema integration.
class DoubleAttribute extends Attribute {
  /// Creates a new double attribute.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  DoubleAttribute(String name) : super(name, 'Double');
}

/// Boolean attribute for OpenAPI schema integration.
class BooleanAttribute extends Attribute {
  /// Creates a new boolean attribute.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  BooleanAttribute(String name) : super(name, 'Boolean');
}

/// DateTime attribute for OpenAPI schema integration.
class DateTimeAttribute extends Attribute {
  /// Creates a new date-time attribute.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  DateTimeAttribute(String name) : super(name, 'DateTime');
}

/// Binary attribute for OpenAPI schema integration.
class BinaryAttribute extends Attribute {
  /// Creates a new binary attribute.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  BinaryAttribute(String name) : super(name, 'Binary');
} 