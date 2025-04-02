part of openapi;

/// Example application demonstrating dynamic domain model creation from OpenAPI.
///
/// This example shows how to:
/// 1. Fetch an OpenAPI schema from a public API
/// 2. Convert it to a dynamic EDNet domain model
/// 3. Create a repository for the model
/// 4. Perform operations against the API
/// 5. Trace policy evaluations
class DynamicDomainModelExample {
  /// Available public APIs for testing.
  static const Map<String, String> publicApis = {
    'PetStore': 'https://petstore.swagger.io/v2',
    'JSONPlaceholder': 'https://jsonplaceholder.typicode.com',
    'Star Wars API': 'https://swapi.dev/api',
    'OpenWeatherMap': 'https://api.openweathermap.org/data',
    'GitHub API': 'https://api.github.com',
  };
  
  /// Runs the example.
  ///
  /// Parameters:
  /// - [apiName]: The name of the API to use (from [publicApis])
  /// - [tracePolicies]: Whether to trace policy evaluations
  /// - [printModelDetails]: Whether to print model details
  Future<void> run({
    String apiName = 'PetStore',
    bool tracePolicies = true,
    bool printModelDetails = true,
  }) async {
    print('Running Dynamic Domain Model Example');
    print('===================================');
    print('');
    
    // 1. Select API
    final apiUrl = publicApis[apiName];
    if (apiUrl == null) {
      print('Unknown API: $apiName');
      print('Available APIs: ${publicApis.keys.join(', ')}');
      return;
    }
    
    print('Using API: $apiName ($apiUrl)');
    print('');
    
    // 2. Fetch schema
    print('Fetching OpenAPI schema...');
    final schemaFetcher = OpenApiSchemaFetcher();
    Map<String, dynamic>? schema;
    
    try {
      schema = await schemaFetcher.discoverSchema(apiUrl);
      if (schema == null) {
        print('Could not discover OpenAPI schema at $apiUrl');
        return;
      }
      
      print('Schema discovered successfully!');
      print('API title: ${schema['info']?['title'] ?? 'Unknown'}');
      print('API version: ${schema['info']?['version'] ?? 'Unknown'}');
      print('');
    } catch (e) {
      print('Error fetching schema: $e');
      return;
    }
    
    // 3. Build domain model
    print('Building domain model...');
    final modelBuilder = DomainModelBuilder();
    final domain = modelBuilder.buildDomainFromSchema(
      schema!,
      domainName: '${apiName}Domain',
    );
    
    print('Domain model built successfully!');
    print('Domain name: ${domain.name}');
    print('Concepts: ${domain.concepts.length}');
    
    if (printModelDetails) {
      print('');
      print('Model details:');
      print('-------------');
      for (final concept in domain.concepts) {
        print('Concept: ${concept.name}');
        print('  Attributes: ${concept.attributes.length}');
        print('  Parents: ${concept.parents.length}');
        print('  Children: ${concept.children.length}');
      }
    }
    
    print('');
    
    // 4. Set up policy tracer if requested
    PolicyEvaluationTracer? tracer;
    if (tracePolicies) {
      tracer = PolicyEvaluationTracer(printImmediately: true);
      print('Policy tracing enabled.');
      
      // Attach tracer to policy evaluator
      // In a real application, you would typically use:
      // final policyEvaluator = PolicyEvaluator(PolicyRegistry());
      // policyEvaluator.addListener(tracer.getPolicyEvaluatorListener(domain));
      
      // For this example, we'll just trace the domain model
      tracer.traceDomainModel(domain);
    }
    
    // 5. Create repositories
    print('Creating repositories...');
    final repoFactory = OpenApiRepositoryFactory(
      domain: domain,
      baseUrl: apiUrl,
    );
    
    // Find a concept to demonstrate with
    final exampleConcept = domain.concepts.isNotEmpty ? domain.concepts.first : null;
    if (exampleConcept == null) {
      print('No concepts found in domain model.');
      return;
    }
    
    print('Using concept: ${exampleConcept.name}');
    final repository = repoFactory.createRepository(exampleConcept);
    
    // 6. Perform operations if the API is accessible
    try {
      print('Fetching entities...');
      final entities = await repository.findAll();
      
      print('Found ${entities.length} entities:');
      for (int i = 0; i < entities.length && i < 5; i++) {
        print('  Entity ${i + 1}: ${_entityToString(entities[i])}');
      }
      
      if (entities.length > 5) {
        print('  ... and ${entities.length - 5} more');
      }
    } catch (e) {
      print('Error performing operations: $e');
      print('This may be due to CORS restrictions or API limitations.');
    }
    
    print('');
    print('Example completed successfully!');
  }
  
  /// Converts an entity to a string representation.
  ///
  /// Parameters:
  /// - [entity]: The entity to convert
  ///
  /// Returns:
  /// A string representation of the entity
  String _entityToString(Entity entity) {
    final buffer = StringBuffer();
    buffer.write('${entity.concept.name} [');
    
    final attributes = <String>[];
    for (final attr in entity.concept.attributes) {
      final value = entity.getAttribute(attr.name);
      if (value != null) {
        attributes.add('${attr.name}: $value');
      }
    }
    
    buffer.write(attributes.join(', '));
    buffer.write(']');
    
    return buffer.toString();
  }
}

/// Example of a simple command-line application using the dynamic domain model.
///
/// This can be run directly to demonstrate the functionality.
Future<void> runDynamicDomainModelExample() async {
  final example = DynamicDomainModelExample();
  await example.run();
} 