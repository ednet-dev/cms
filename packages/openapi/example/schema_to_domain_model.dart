import 'dart:convert';
import 'dart:io';

/// Demonstration of creating an ad hoc EDNet domain model from an OpenAPI schema.
///
/// This example shows a complete process for dynamically generating an EDNet domain model
/// from an OpenAPI schema discovered at runtime. It demonstrates key capabilities of the
/// EDNet framework, including:
///
/// 1. **Schema Discovery**: Automatically locating an OpenAPI schema at common endpoints
/// 2. **Domain Modeling**: Building a structured domain model with concepts, attributes and relationships
/// 3. **Repository Creation**: Setting up repositories for runtime data access
/// 4. **Model Validation**: Testing the model against real API calls
///
/// The EDNet approach allows for both static (pre-defined) domain models and dynamic
/// (runtime-generated) models, giving flexibility to adapt to discovered services.
///
/// Example usage:
/// ```dart
/// void main() async {
///   final apiUrl = 'https://petstore.swagger.io/v2';
///   final schemaUrl = await discoverOpenApiSchemaUrl(apiUrl);
///   final schema = await fetchJson(schemaUrl!);
///   
///   final builder = DomainModelBuilder(schema);
///   final domain = builder.build();
///   
///   // Use the domain model
///   final repository = PetStoreRepository(domain);
///   final petConcept = domain.concepts.firstWhere((c) => c.name == 'Pet');
///   final petRepo = repository.getConceptRepository(petConcept.name);
/// }
/// ```
void main() async {
  print('EDNet OpenAPI - Schema to Domain Model Example');
  print('============================================');
  print('');
  
  final apiUrl = 'https://petstore.swagger.io/v2';
  
  //==========================================
  // STEP 1: Discover OpenAPI Schema
  //==========================================
  print('STEP 1: Discovering OpenAPI Schema');
  print('----------------------------------');
  
  print('Target API: $apiUrl');
  print('Attempting to discover schema...');
  
  final schemaUrl = await discoverOpenApiSchemaUrl(apiUrl);
  
  if (schemaUrl == null) {
    print('❌ Could not discover schema. Exiting.');
    return;
  }
  
  print('✅ Schema discovered at: $schemaUrl');
  
  // Fetch and parse the schema
  final schema = await fetchJson(schemaUrl);
  
  print('API title: ${schema['info']?['title']}');
  print('API version: ${schema['info']?['version']}');
  print('');
  
  //==========================================
  // STEP 2: Create Domain Model Builder
  //==========================================
  print('STEP 2: Creating Domain Model');
  print('---------------------------');
  
  // Create the domain and model
  final builder = DomainModelBuilder(schema);
  final domain = builder.build();
  
  print('✅ Domain model created: ${domain.name}');
  print('Number of concepts: ${domain.concepts.length}');
  print('');
  
  //==========================================
  // STEP 3: Examine Model Structure
  //==========================================
  print('STEP 3: Examining Model Structure');
  print('-------------------------------');
  
  // Print domain structure
  domain.printStructure();
  print('');
  
  //==========================================
  // STEP 4: Create Repository
  //==========================================
  print('STEP 4: Creating Repository');
  print('-------------------------');
  
  // Create repository for the domain
  final repository = PetStoreRepository(domain);
  print('✅ Repository created: ${repository.name}');
  print('Repositories: ${repository.repositories.length}');
  
  // Create concept repositories
  for (final concept in domain.concepts) {
    final conceptRepo = repository.getConceptRepository(concept.name);
    print('  - ${concept.name} repository created');
  }
  print('');
  
  //==========================================
  // STEP 5: Test Model with API Calls
  //==========================================
  print('STEP 5: Testing Model with API Calls');
  print('----------------------------------');
  
  // Test with real API calls
  await testModelWithApi(apiUrl, domain, repository);
  
  print('');
  print('Schema traversal and domain model creation completed!');
}

/// Fetches and parses JSON data from a URL.
///
/// Makes an HTTP GET request to the specified URL and parses the response
/// as JSON. This function handles the entire HTTP lifecycle including creating
/// the client, setting appropriate headers, and closing connections.
///
/// Parameters:
/// - [url]: The URL to fetch JSON data from
///
/// Returns:
/// A Future that resolves to the parsed JSON data as a dynamic object.
/// For OpenAPI schemas, this will typically be a Map<String, dynamic>.
///
/// Throws:
/// - [Exception] if the HTTP status code is not 200
/// - [FormatException] if the response cannot be parsed as JSON
Future<dynamic> fetchJson(String url) async {
  final client = HttpClient();
  
  try {
    final request = await client.getUrl(Uri.parse(url));
    request.headers.add('Accept', 'application/json');
    
    final response = await request.close();
    
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    
    final body = await response.transform(utf8.decoder).join();
    return json.decode(body);
  } finally {
    client.close();
  }
}

/// Discovers an OpenAPI schema URL from a base API URL.
///
/// This function attempts to locate an OpenAPI schema by trying common
/// paths where schemas are typically published. It returns the first 
/// successful URL that returns a 200 status code.
///
/// Parameters:
/// - [baseUrl]: The base URL of the API to check for schemas
///
/// Returns:
/// A Future that resolves to the schema URL if found, or null if no schema is discovered.
///
/// Example:
/// ```dart
/// final apiUrl = 'https://petstore.swagger.io/v2';
/// final schemaUrl = await discoverOpenApiSchemaUrl(apiUrl);
/// // Might return 'https://petstore.swagger.io/v2/swagger.json'
/// ```
Future<String?> discoverOpenApiSchemaUrl(String baseUrl) async {
  // Common paths where OpenAPI schemas are published
  final commonPaths = [
    '/openapi.json',
    '/swagger.json',
    '/api-docs',
    '/v3/api-docs',
    '/v2/api-docs',
    '/openapi',
    '/swagger',
  ];
  
  // Ensure the base URL doesn't end with a slash
  final cleanBaseUrl = baseUrl.endsWith('/') 
      ? baseUrl.substring(0, baseUrl.length - 1) 
      : baseUrl;
  
  final client = HttpClient();
  
  // Try each common path
  for (final path in commonPaths) {
    final url = '$cleanBaseUrl$path';
    
    try {
      final request = await client.getUrl(Uri.parse(url));
      request.headers.add('Accept', 'application/json');
      
      final response = await request.close();
      
      if (response.statusCode == 200) {
        await response.drain();
        return url;
      }
      
      await response.drain();
    } catch (e) {
      // Continue to next path
    }
  }
  
  // No schema found
  return null;
}

/// Posts JSON data to a URL and returns the response.
///
/// Makes an HTTP POST request with the provided data encoded as JSON.
/// This is useful for testing write operations against the generated domain model.
///
/// Parameters:
/// - [url]: The URL to post data to
/// - [data]: The data to send, which will be encoded as JSON
///
/// Returns:
/// A Future that resolves to the parsed JSON response
///
/// Throws:
/// - [Exception] if the HTTP status code is not in the 2xx range
/// - [FormatException] if the response cannot be parsed as JSON
Future<dynamic> postJson(String url, Map<String, dynamic> data) async {
  final client = HttpClient();
  
  try {
    final request = await client.postUrl(Uri.parse(url));
    request.headers.add('Content-Type', 'application/json');
    request.headers.add('Accept', 'application/json');
    
    request.write(json.encode(data));
    
    final response = await request.close();
    
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}');
    }
    
    final body = await response.transform(utf8.decoder).join();
    return json.decode(body);
  } finally {
    client.close();
  }
}

/// Builder for creating domain models from OpenAPI schemas.
///
/// This class is responsible for analyzing an OpenAPI schema and constructing
/// a corresponding EDNet domain model with concepts, attributes, and relationships.
/// It follows a two-pass approach:
///
/// 1. First pass: Create all concepts with their attributes
/// 2. Second pass: Establish relationships between concepts
///
/// This approach ensures that all concepts exist before attempting to create
/// relationships between them, avoiding reference errors.
///
/// Example:
/// ```dart
/// final schema = await fetchJson('https://petstore.swagger.io/v2/swagger.json');
/// final builder = DomainModelBuilder(schema);
/// final domain = builder.build();
/// ```
class DomainModelBuilder {
  /// The OpenAPI schema to build from
  final Map<String, dynamic> _schema;
  
  /// Log of build operations for debugging and reporting
  final List<String> _log = [];
  
  /// Creates a new domain model builder.
  ///
  /// Parameters:
  /// - [_schema]: The OpenAPI schema to build from, typically fetched from a schema URL
  DomainModelBuilder(this._schema);
  
  /// Builds a domain model from the schema.
  ///
  /// This is the main entry point for domain model creation. It:
  /// 1. Creates the domain with a name derived from the API title
  /// 2. Adds a default model to the domain
  /// 3. Processes all schema definitions to create concepts
  /// 4. Processes relationships between concepts
  /// 5. Logs each step of the build process
  ///
  /// Returns:
  /// A fully constructed [Domain] with concepts, attributes, and relationships
  Domain build() {
    // Extract title and create domain
    final title = _schema['info']?['title'] ?? 'OpenAPI Domain';
    final domain = Domain(title.replaceAll(' ', ''));
    _log.add('Created domain: ${domain.name}');
    
    // Create model
    final model = Model(domain, 'Default');
    domain.addModel(model);
    _log.add('Added model: ${model.name}');
    
    // Process definitions/schemas
    final definitions = _schema['definitions'] as Map<String, dynamic>? ?? 
                       _schema['components']?['schemas'] as Map<String, dynamic>? ?? 
                       {};
    
    // First pass: Create all concepts
    for (final entry in definitions.entries) {
      final conceptName = entry.key;
      final schema = entry.value as Map<String, dynamic>;
      
      if (schema['type'] == 'object' || schema['properties'] != null) {
        final concept = _createConcept(conceptName, schema);
        model.addConcept(concept);
        _log.add('Added concept: ${concept.name}');
      }
    }
    
    // Second pass: Create relationships
    for (final entry in definitions.entries) {
      final conceptName = entry.key;
      final schema = entry.value as Map<String, dynamic>;
      final properties = schema['properties'] as Map<String, dynamic>? ?? {};
      
      final concept = model.concepts.firstWhere(
        (c) => c.name == conceptName,
        orElse: () => Concept('Not Found'),
      );
      
      if (concept.name == 'Not Found') continue;
      
      for (final propEntry in properties.entries) {
        final propertyName = propEntry.key;
        final property = propEntry.value as Map<String, dynamic>;
        
        _processProperty(model, concept, propertyName, property);
      }
    }
    
    // Print build log
    print('Domain Model Build Log:');
    for (final entry in _log) {
      print('  - $entry');
    }
    
    return domain;
  }
  
  /// Creates a concept from a schema definition.
  ///
  /// Analyzes a schema object definition and creates a corresponding EDNet Concept
  /// with appropriate attributes.
  ///
  /// Parameters:
  /// - [name]: The name of the concept (from schema definition key)
  /// - [schema]: The schema definition for this concept
  ///
  /// Returns:
  /// A newly created [Concept] with attributes corresponding to the schema properties
  Concept _createConcept(String name, Map<String, dynamic> schema) {
    final concept = Concept(name);
    
    // Add description if available
    if (schema['description'] != null) {
      concept.description = schema['description'];
      _log.add('  Added description to ${concept.name}');
    }
    
    // Process properties
    final properties = schema['properties'] as Map<String, dynamic>? ?? {};
    final required = schema['required'] as List<dynamic>? ?? [];
    
    for (final entry in properties.entries) {
      final propertyName = entry.key;
      final property = entry.value as Map<String, dynamic>;
      final type = property['type'];
      final isRequired = required.contains(propertyName);
      
      if (_isSimpleType(property)) {
        final attribute = _createAttribute(propertyName, property, isRequired);
        concept.addAttribute(attribute);
        _log.add('    Added attribute: ${attribute.name} (${attribute.type})');
      }
    }
    
    return concept;
  }
  
  /// Creates an attribute from a property definition.
  ///
  /// Maps OpenAPI property types to EDNet attribute types, handling
  /// type conversions, required flags, descriptions, and default values.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  /// - [property]: The schema property definition
  /// - [required]: Whether this attribute is required
  ///
  /// Returns:
  /// A newly created [Attribute] with appropriate type and metadata
  Attribute _createAttribute(String name, Map<String, dynamic> property, bool required) {
    final type = property['type'] as String?;
    final format = property['format'] as String?;
    
    String attributeType;
    if (type == 'integer') {
      attributeType = 'int';
    } else if (type == 'number') {
      attributeType = 'double';
    } else if (type == 'boolean') {
      attributeType = 'bool';
    } else if (type == 'string' && format == 'date-time') {
      attributeType = 'DateTime';
    } else {
      attributeType = 'String';
    }
    
    final attribute = Attribute(name, attributeType);
    
    // Set description
    if (property['description'] != null) {
      attribute.description = property['description'];
    }
    
    // Set required
    attribute.required = required;
    
    // Set default value
    if (property['default'] != null) {
      attribute.init = property['default'].toString();
    }
    
    return attribute;
  }
  
  /// Processes a property to potentially create relationships.
  ///
  /// Examines a property to determine if it represents a relationship 
  /// (parent or child) between concepts. Handles both direct references
  /// and arrays of references.
  ///
  /// Parameters:
  /// - [model]: The model containing all concepts
  /// - [concept]: The concept that owns this property
  /// - [propertyName]: The name of the property
  /// - [property]: The property definition
  void _processProperty(Model model, Concept concept, String propertyName, Map<String, dynamic> property) {
    // Check for references to other concepts
    if (property['\$ref'] != null) {
      final ref = property['\$ref'] as String;
      final refName = ref.split('/').last;
      
      final destinationConcept = model.concepts.firstWhere(
        (c) => c.name == refName,
        orElse: () => Concept('Not Found'),
      );
      
      if (destinationConcept.name != 'Not Found') {
        final parent = Parent(propertyName, destinationConcept);
        concept.addParent(parent);
        _log.add('    Added parent: ${concept.name} -> ${propertyName} -> ${destinationConcept.name}');
      }
    }
    // Check for array of references
    else if (property['type'] == 'array' && property['items'] != null) {
      final items = property['items'] as Map<String, dynamic>;
      
      if (items['\$ref'] != null) {
        final ref = items['\$ref'] as String;
        final refName = ref.split('/').last;
        
        final destinationConcept = model.concepts.firstWhere(
          (c) => c.name == refName,
          orElse: () => Concept('Not Found'),
        );
        
        if (destinationConcept.name != 'Not Found') {
          final child = Child(propertyName, destinationConcept);
          concept.addChild(child);
          _log.add('    Added child: ${concept.name} -> ${propertyName} -> ${destinationConcept.name}');
        }
      }
    }
  }
  
  /// Checks if a property is a simple type (not a reference or array).
  ///
  /// Used to determine if a property should be treated as an attribute
  /// rather than a relationship to another concept.
  ///
  /// Parameters:
  /// - [property]: The property definition to check
  ///
  /// Returns:
  /// True if the property represents a simple type, false otherwise
  bool _isSimpleType(Map<String, dynamic> property) {
    if (property['\$ref'] != null) return false;
    if (property['type'] == 'array') return false;
    if (property['type'] == 'object') return false;
    return true;
  }
}

/// A domain represents a complete business domain model.
///
/// In EDNet, a Domain is the top-level container that holds a collection of
/// related Models. It represents a bounded context in domain-driven design terms.
/// The domain provides a namespace and logical grouping for concepts.
///
/// Domains can be created statically at design time or dynamically at runtime,
/// as demonstrated in this example.
class Domain {
  /// The name of the domain, derived from the API title
  final String name;
  
  /// The models contained in this domain
  final List<Model> _models = [];
  
  /// Creates a new domain with the specified name.
  ///
  /// Parameters:
  /// - [name]: The name of the domain, typically derived from the API title
  Domain(this.name);
  
  /// Gets all models in this domain.
  ///
  /// Returns an unmodifiable view of the models list for safety.
  List<Model> get models => List.unmodifiable(_models);
  
  /// Adds a model to this domain.
  ///
  /// Parameters:
  /// - [model]: The model to add
  void addModel(Model model) {
    _models.add(model);
  }
  
  /// Gets all concepts across all models in this domain.
  ///
  /// This is a convenience method that flattens the model hierarchy
  /// to provide direct access to all concepts.
  List<Concept> get concepts {
    final result = <Concept>[];
    for (final model in _models) {
      result.addAll(model.concepts);
    }
    return result;
  }
  
  /// Prints the complete structure of this domain.
  ///
  /// This provides a detailed view of the domain including all models,
  /// concepts, attributes, and relationships for inspection and debugging.
  void printStructure() {
    print('Domain: $name');
    print('Models: ${_models.length}');
    
    for (final model in _models) {
      print('  Model: ${model.name}');
      print('  Concepts: ${model.concepts.length}');
      
      for (final concept in model.concepts) {
        print('    Concept: ${concept.name}');
        if (concept.description != null) {
          print('      Description: ${concept.description}');
        }
        
        print('      Attributes: ${concept.attributes.length}');
        for (final attribute in concept.attributes) {
          final requiredStr = attribute.required ? ' (required)' : '';
          print('        ${attribute.name}: ${attribute.type}$requiredStr');
        }
        
        print('      Parents: ${concept.parents.length}');
        for (final parent in concept.parents) {
          print('        ${parent.name} -> ${parent.destination.name}');
        }
        
        print('      Children: ${concept.children.length}');
        for (final child in concept.children) {
          print('        ${child.name} -> ${child.destination.name}');
        }
      }
    }
  }
}

/// A model groups related concepts within a domain.
///
/// In EDNet, a Model represents a subset of the domain containing related
/// concepts. It helps organize concepts into logical groups based on their
/// purpose or relationship.
///
/// Models act as namespaces within the domain to avoid naming conflicts
/// and improve organization.
class Model {
  /// The domain this model belongs to
  final Domain domain;
  
  /// The name of this model
  final String name;
  
  /// The concepts defined in this model
  final List<Concept> _concepts = [];
  
  /// Creates a new model within the specified domain.
  ///
  /// Parameters:
  /// - [domain]: The domain this model belongs to
  /// - [name]: The name of the model
  Model(this.domain, this.name);
  
  /// Gets all concepts in this model.
  ///
  /// Returns an unmodifiable view of the concepts list for safety.
  List<Concept> get concepts => List.unmodifiable(_concepts);
  
  /// Adds a concept to this model.
  ///
  /// Parameters:
  /// - [concept]: The concept to add
  void addConcept(Concept concept) {
    _concepts.add(concept);
  }
}

/// A concept represents an entity type in the domain model.
///
/// In EDNet, a Concept defines a type of entity with attributes and
/// relationships. Concepts are the building blocks of the domain model
/// and correspond to classes in object-oriented programming.
///
/// Each concept has:
/// - A name and optional description
/// - A set of attributes defining its properties
/// - Relationships to other concepts (parents and children)
class Concept {
  /// The name of this concept
  final String name;
  
  /// An optional description of this concept
  String? description;
  
  /// The attributes of this concept
  final List<Attribute> _attributes = [];
  
  /// Parent relationships to other concepts
  final List<Parent> _parents = [];
  
  /// Child relationships to other concepts
  final List<Child> _children = [];
  
  /// Creates a new concept with the specified name.
  ///
  /// Parameters:
  /// - [name]: The name of the concept
  Concept(this.name);
  
  /// Gets all attributes of this concept.
  ///
  /// Returns an unmodifiable view of the attributes list for safety.
  List<Attribute> get attributes => List.unmodifiable(_attributes);
  
  /// Gets all parent relationships of this concept.
  ///
  /// Returns an unmodifiable view of the parents list for safety.
  List<Parent> get parents => List.unmodifiable(_parents);
  
  /// Gets all child relationships of this concept.
  ///
  /// Returns an unmodifiable view of the children list for safety.
  List<Child> get children => List.unmodifiable(_children);
  
  /// Adds an attribute to this concept.
  ///
  /// Parameters:
  /// - [attribute]: The attribute to add
  void addAttribute(Attribute attribute) {
    _attributes.add(attribute);
  }
  
  /// Adds a parent relationship to this concept.
  ///
  /// A parent relationship represents a reference to another concept.
  /// In entity terms, this is similar to a many-to-one relationship.
  ///
  /// Parameters:
  /// - [parent]: The parent relationship to add
  void addParent(Parent parent) {
    _parents.add(parent);
  }
  
  /// Adds a child relationship to this concept.
  ///
  /// A child relationship represents a collection of other concept instances.
  /// In entity terms, this is similar to a one-to-many relationship.
  ///
  /// Parameters:
  /// - [child]: The child relationship to add
  void addChild(Child child) {
    _children.add(child);
  }
}

/// An attribute represents a property of a concept.
///
/// Attributes define the basic properties of a concept, such as its
/// name, description, or status. Each attribute has a name and a type,
/// and may have additional metadata such as a description, required flag,
/// or default value.
class Attribute {
  /// The name of this attribute
  final String name;
  
  /// The data type of this attribute (String, int, etc.)
  final String type;
  
  /// An optional description of this attribute
  String? description;
  
  /// Whether this attribute is required
  bool required = false;
  
  /// An optional default value for this attribute
  String? init;
  
  /// Creates a new attribute with the specified name and type.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  /// - [type]: The data type of the attribute
  Attribute(this.name, this.type);
}

/// A parent relationship from one concept to another.
///
/// In EDNet, a Parent relationship represents a reference from one concept
/// to another. This is analogous to a many-to-one relationship in relational
/// databases or a reference property in object-oriented programming.
///
/// For example, a Pet might have a parent relationship to a Category.
class Parent {
  /// The name of this relationship
  final String name;
  
  /// The concept this relationship points to
  final Concept destination;
  
  /// Creates a new parent relationship with the specified name and destination.
  ///
  /// Parameters:
  /// - [name]: The name of the relationship
  /// - [destination]: The concept this relationship points to
  Parent(this.name, this.destination);
}

/// A child relationship from one concept to another.
///
/// In EDNet, a Child relationship represents a collection of another concept.
/// This is analogous to a one-to-many relationship in relational databases
/// or a collection property in object-oriented programming.
///
/// For example, a Pet might have a child relationship to Tags.
class Child {
  /// The name of this relationship
  final String name;
  
  /// The concept this relationship points to
  final Concept destination;
  
  /// Creates a new child relationship with the specified name and destination.
  ///
  /// Parameters:
  /// - [name]: The name of the relationship
  /// - [destination]: The concept this relationship points to
  Child(this.name, this.destination);
}

/// A repository for storing and retrieving entities of a domain.
///
/// In EDNet, a Repository provides access to domain entities. It is responsible
/// for creating, reading, updating, and deleting entities of the domain.
///
/// This implementation creates sub-repositories for each concept in the domain.
class PetStoreRepository {
  /// The domain this repository serves
  final Domain domain;
  
  /// The name of this repository
  final String name;
  
  /// The repositories for each concept in the domain
  final Map<String, ConceptRepository> _repositories = {};
  
  /// Creates a new repository for the specified domain.
  ///
  /// This automatically creates sub-repositories for each concept
  /// in the domain.
  ///
  /// Parameters:
  /// - [domain]: The domain this repository serves
  PetStoreRepository(this.domain) : name = '${domain.name}Repository' {
    for (final concept in domain.concepts) {
      _repositories[concept.name] = ConceptRepository(concept);
    }
  }
  
  /// Gets all concept repositories.
  ///
  /// Returns:
  /// A list of all concept repositories in this repository
  List<ConceptRepository> get repositories => _repositories.values.toList();
  
  /// Gets the repository for the specified concept.
  ///
  /// Parameters:
  /// - [conceptName]: The name of the concept to get the repository for
  ///
  /// Returns:
  /// The repository for the specified concept
  ///
  /// Throws:
  /// - [Exception] if no repository exists for the specified concept
  ConceptRepository getConceptRepository(String conceptName) {
    return _repositories[conceptName] ?? 
        (throw Exception('Repository not found: $conceptName'));
  }
}

/// A repository for storing and retrieving entities of a specific concept.
///
/// In EDNet, a ConceptRepository provides access to entities of a specific concept.
/// It handles the CRUD operations for that concept.
class ConceptRepository {
  /// The concept this repository serves
  final Concept concept;
  
  /// Creates a new repository for the specified concept.
  ///
  /// Parameters:
  /// - [concept]: The concept this repository serves
  ConceptRepository(this.concept);
  
  /// Gets the name of this repository.
  ///
  /// The name is derived from the concept name by appending "Repository".
  String get name => '${concept.name}Repository';
}

/// An entity represents an instance of a concept.
///
/// In EDNet, an Entity is a runtime instance of a Concept. It contains
/// the actual data values for the attributes defined by the concept.
///
/// This implementation uses a simple map to store attribute values.
class Entity {
  /// The concept this entity belongs to
  final Concept concept;
  
  /// The attribute values of this entity
  final Map<String, dynamic> _data = {};
  
  /// Creates a new entity of the specified concept.
  ///
  /// Parameters:
  /// - [concept]: The concept this entity belongs to
  Entity(this.concept);
  
  /// Gets the value of the specified attribute.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute to get
  ///
  /// Returns:
  /// The value of the attribute, or null if not set
  dynamic getAttribute(String name) {
    return _data[name];
  }
  
  /// Sets the value of the specified attribute.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute to set
  /// - [value]: The value to set
  void setAttribute(String name, dynamic value) {
    _data[name] = value;
  }
  
  /// Returns a string representation of this entity.
  ///
  /// The string includes the concept name and all attribute values.
  @override
  String toString() {
    return '${concept.name}: $_data';
  }
}

/// Tests the domain model with real API calls.
///
/// This function demonstrates how to use the generated domain model
/// to interact with a real API. It fetches data from the API and
/// creates Entity instances from the response.
///
/// This validates that the model accurately represents the API structure
/// and can be used for real-world interactions.
///
/// Parameters:
/// - [apiUrl]: The base URL of the API
/// - [domain]: The domain model to test
/// - [repository]: The repository to use for creating entities
Future<void> testModelWithApi(String apiUrl, Domain domain, PetStoreRepository repository) async {
  try {
    // 1. Find Pet concept
    final petConcept = domain.concepts.firstWhere(
      (c) => c.name == 'Pet',
      orElse: () => throw Exception('Pet concept not found'),
    );
    
    print('Testing with Pet concept...');
    print('Attributes: ${petConcept.attributes.map((a) => a.name).join(', ')}');
    
    // 2. Call API to get a pet
    final petData = await fetchJson('$apiUrl/pet/1');
    print('Fetched pet data from API: $petData');
    
    // 3. Create Entity from API data
    final pet = Entity(petConcept);
    
    // Map API data to entity attributes
    for (final attribute in petConcept.attributes) {
      if (petData.containsKey(attribute.name)) {
        pet.setAttribute(attribute.name, petData[attribute.name]);
      }
    }
    
    print('Created Pet entity with attributes:');
    for (final attribute in petConcept.attributes) {
      final value = pet.getAttribute(attribute.name);
      if (value != null) {
        print('  ${attribute.name}: $value');
      }
    }
    
    // 4. Handle relationships if present
    for (final parent in petConcept.parents) {
      if (petData.containsKey(parent.name) && petData[parent.name] != null) {
        final parentData = petData[parent.name];
        print('  Found parent relationship: ${parent.name} = $parentData');
        
        final parentEntity = Entity(parent.destination);
        for (final attr in parent.destination.attributes) {
          if (parentData.containsKey(attr.name)) {
            parentEntity.setAttribute(attr.name, parentData[attr.name]);
          }
        }
        
        print('  Created parent entity: ${parent.destination.name}');
        for (final attr in parent.destination.attributes) {
          final value = parentEntity.getAttribute(attr.name);
          if (value != null) {
            print('    ${attr.name}: $value');
          }
        }
      }
    }
    
    for (final child in petConcept.children) {
      if (petData.containsKey(child.name) && petData[child.name] != null) {
        final childrenData = petData[child.name] as List<dynamic>;
        print('  Found child relationship: ${child.name} = ${childrenData.length} items');
        
        int i = 0;
        for (final childData in childrenData) {
          if (i >= 2) {
            print('    ... and ${childrenData.length - 2} more');
            break;
          }
          
          final childEntity = Entity(child.destination);
          for (final attr in child.destination.attributes) {
            if (childData.containsKey(attr.name)) {
              childEntity.setAttribute(attr.name, childData[attr.name]);
            }
          }
          
          print('    Child ${i+1}: ${child.destination.name}');
          for (final attr in child.destination.attributes) {
            final value = childEntity.getAttribute(attr.name);
            if (value != null) {
              print('      ${attr.name}: $value');
            }
          }
          
          i++;
        }
      }
    }
    
  } catch (e) {
    print('Error testing model: $e');
  }
} 