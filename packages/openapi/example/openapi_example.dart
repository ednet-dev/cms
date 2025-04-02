import 'dart:io';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_openapi/openapi.dart';

/// Example application demonstrating the EDNet OpenAPI package.
///
/// This example shows:
/// 1. Discovering an OpenAPI schema from a public API
/// 2. Building a domain model from the schema
/// 3. Creating repositories for the model
/// 4. Performing operations against the API
/// 5. Tracing policy evaluations
void main(List<String> args) async {
  print('EDNet OpenAPI Example');
  print('===================');
  print('');
  
  // Parse command line arguments
  final exampleName = args.isNotEmpty ? args.first : 'dynamic';
  
  switch (exampleName.toLowerCase()) {
    case 'dynamic':
      await runDynamicExample();
      break;
      
    case 'petstore':
      await runPetStoreExample();
      break;
      
    case 'custom':
      await runCustomExample();
      break;
      
    case 'test':
      await runIntegrationTest();
      break;
      
    default:
      print('Unknown example: $exampleName');
      print('Available examples: dynamic, petstore, custom, test');
      exit(1);
  }
}

/// Runs the custom example.
///
/// This example demonstrates creating a domain model manually
/// and connecting to a custom API.
Future<void> runCustomExample() async {
  print('Running Custom API Example');
  print('=========================');
  print('');
  
  // Create a domain model
  final domain = Domain('CustomAPI');
  
  // Create a Todo concept
  final todoConcept = Concept('Todo');
  todoConcept.addAttribute(StringAttribute('id')..isPrimaryKey = true);
  todoConcept.addAttribute(StringAttribute('title')..required = true);
  todoConcept.addAttribute(StringAttribute('description'));
  todoConcept.addAttribute(BooleanAttribute('completed'));
  
  domain.addConcept(todoConcept);
  
  // Create a User concept
  final userConcept = Concept('User');
  userConcept.addAttribute(StringAttribute('id')..isPrimaryKey = true);
  userConcept.addAttribute(StringAttribute('name')..required = true);
  userConcept.addAttribute(StringAttribute('email')..required = true);
  
  domain.addConcept(userConcept);
  
  // Set up relationships
  todoConcept.addParent(Parent('user', userConcept));
  userConcept.addChild(Child('todos', todoConcept));
  
  // Trace the domain model
  final tracer = PolicyEvaluationTracer();
  tracer.traceDomainModel(domain);
  
  // Create repository factory
  final factory = createOpenApiRepositoryFactory(
    domain: domain,
    baseUrl: 'https://jsonplaceholder.typicode.com',
  );
  
  // Create repositories
  final todoRepo = factory.createRepository(todoConcept);
  final userRepo = factory.createRepository(userConcept);
  
  // Fetch data
  try {
    // Get all todos
    print('Fetching todos...');
    final todos = await todoRepo.findAll();
    print('Found ${todos.length} todos');
    
    // Print first few todos
    for (int i = 0; i < todos.length && i < 3; i++) {
      final todo = todos[i];
      print('  Todo ${i + 1}: ${todo.getAttribute<String>('title')}');
    }
    
    print('');
    
    // Get all users
    print('Fetching users...');
    final users = await userRepo.findAll();
    print('Found ${users.length} users');
    
    // Print first few users
    for (int i = 0; i < users.length && i < 3; i++) {
      final user = users[i];
      print('  User ${i + 1}: ${user.getAttribute<String>('name')} (${user.getAttribute<String>('email')})');
    }
    
    print('');
    
    // Add a custom filter
    print('Fetching incomplete todos...');
    final criteria = FilterCriteria<Entity>();
    criteria.addCriterion(Criterion('completed', false));
    
    final incompleteTodos = await todoRepo.findByCriteria(criteria);
    print('Found ${incompleteTodos.length} incomplete todos');
    
  } catch (e) {
    print('Error: $e');
  }
  
  print('');
  print('Example completed successfully!');
}

/// Runs an integration test against an OpenAPI service.
///
/// This example demonstrates how to validate connectivity
/// and compatibility with an OpenAPI service.
Future<void> runIntegrationTest() async {
  print('Running Integration Test');
  print('======================');
  print('');
  
  // Define known APIs to test against
  final apis = {
    'petstore': 'https://petstore.swagger.io/v2',
    'jsonplaceholder': 'https://jsonplaceholder.typicode.com',
  };
  
  // Select API
  final apiName = 'petstore';
  final apiUrl = apis[apiName];
  
  if (apiUrl == null) {
    print('Unknown API: $apiName');
    print('Available APIs: ${apis.keys.join(', ')}');
    exit(1);
  }
  
  print('Testing against $apiName API at $apiUrl');
  print('');
  
  // Fetch schema
  print('Discovering OpenAPI schema...');
  Map<String, dynamic>? schema;
  
  try {
    schema = await discoverOpenApiSchema(apiUrl);
    if (schema == null) {
      print('Could not discover schema at $apiUrl');
      exit(1);
    }
    
    print('Schema discovered!');
    print('');
  } catch (e) {
    print('Error discovering schema: $e');
    print('Using predefined domain model...');
    print('');
    
    // If we can't discover the schema, create a predefined model
    schema = null;
  }
  
  // Create domain model
  Domain domain;
  
  if (schema != null) {
    print('Building domain model from schema...');
    domain = createDomainModelFromSchema(schema);
  } else if (apiName == 'petstore') {
    // For PetStore, use the predefined model
    print('Using predefined PetStore model...');
    domain = PetStoreExample()._createDomain();
  } else {
    print('No schema or predefined model available for $apiName');
    exit(1);
  }
  
  print('Domain model ready with ${domain.concepts.length} concepts');
  print('');
  
  // Create and run tester
  print('Running integration tests...');
  final tester = createIntegrationTester(
    domain: domain,
    baseUrl: apiUrl,
    verbose: true,
  );
  
  // Test only a subset of concepts if there are many
  if (domain.concepts.length > 3) {
    // Test the first 3 concepts
    for (int i = 0; i < 3; i++) {
      await tester.testConcept(domain.concepts[i].name);
    }
  } else {
    // Test all concepts
    await tester.testAll();
  }
  
  // Print summary
  print('');
  print('Integration test completed');
  tester.printSummary();
} 