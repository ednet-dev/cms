part of openapi;

/// Integration tester for OpenAPI repositories.
///
/// This utility class helps with testing OpenAPI repositories against
/// real services, performing common operations and reporting results.
class OpenApiIntegrationTester {
  /// The repository factory to test.
  final OpenApiRepositoryFactory _factory;
  
  /// The domain model to test with.
  final Domain _domain;
  
  /// The base URL of the API.
  final String _baseUrl;
  
  /// The authentication configuration.
  final AuthConfig? _authConfig;
  
  /// Whether to print detailed logs.
  final bool _verbose;
  
  /// The results of tests.
  final Map<String, Map<String, TestResult>> _results = {};
  
  /// Creates a new integration tester.
  ///
  /// Parameters:
  /// - [domain]: The domain model to test with
  /// - [baseUrl]: The base URL of the API
  /// - [authConfig]: Optional authentication configuration
  /// - [verbose]: Whether to print detailed logs
  OpenApiIntegrationTester({
    required Domain domain,
    required String baseUrl,
    AuthConfig? authConfig,
    bool verbose = false,
  }) : _domain = domain,
       _baseUrl = baseUrl,
       _authConfig = authConfig,
       _verbose = verbose,
       _factory = OpenApiRepositoryFactory(
         domain: domain,
         baseUrl: baseUrl,
         authConfig: authConfig,
       );
  
  /// Runs all tests on all concepts.
  ///
  /// Returns:
  /// A future that completes when tests are done
  Future<void> testAll() async {
    for (final concept in _domain.concepts) {
      await testConcept(concept.name);
    }
  }
  
  /// Tests a specific concept.
  ///
  /// Parameters:
  /// - [conceptName]: The name of the concept to test
  ///
  /// Returns:
  /// A future that completes when tests are done
  Future<void> testConcept(String conceptName) async {
    final concept = _domain.findConcept(conceptName);
    if (concept == null) {
      log('Unknown concept: $conceptName');
      return;
    }
    
    log('Testing concept: ${concept.name}');
    
    _results[concept.name] = {};
    
    // Create a repository
    final repository = _factory.createRepository(concept);
    
    // Run tests
    await testFindAll(repository, concept);
    await testFindById(repository, concept);
    await testQuery(repository, concept);
    
    // Optional: test write operations
    // These might fail if the API is read-only
    try {
      await testSave(repository, concept);
    } catch (e) {
      setResult(concept.name, 'save', false, 'API may be read-only: $e');
    }
    
    // Print a summary
    log('');
    log('Summary for ${concept.name}:');
    for (final entry in _results[concept.name]!.entries) {
      final result = entry.value;
      final status = result.success ? 'PASS' : 'FAIL';
      log('  ${entry.key.padRight(10)}: [$status] ${result.message}');
    }
    log('');
  }
  
  /// Tests the findAll operation.
  ///
  /// Parameters:
  /// - [repository]: The repository to test
  /// - [concept]: The concept being tested
  ///
  /// Returns:
  /// A future that completes when the test is done
  Future<void> testFindAll(Repository<Entity> repository, Concept concept) async {
    log('  Testing findAll()...');
    try {
      final start = DateTime.now();
      final entities = await repository.findAll();
      final elapsed = DateTime.now().difference(start);
      
      setResult(
        concept.name,
        'findAll',
        true,
        'Found ${entities.length} entities in ${elapsed.inMilliseconds}ms',
      );
      
      if (_verbose && entities.isNotEmpty) {
        log('    First entity: ${entities.first}');
      }
    } catch (e) {
      setResult(concept.name, 'findAll', false, 'Error: $e');
    }
  }
  
  /// Tests the findById operation.
  ///
  /// Parameters:
  /// - [repository]: The repository to test
  /// - [concept]: The concept being tested
  ///
  /// Returns:
  /// A future that completes when the test is done
  Future<void> testFindById(Repository<Entity> repository, Concept concept) async {
    log('  Testing findById()...');
    try {
      // First get an ID from findAll
      final entities = await repository.findAll();
      if (entities.isEmpty) {
        setResult(concept.name, 'findById', false, 'No entities to test with');
        return;
      }
      
      final id = entities.first.id;
      if (id == null) {
        setResult(concept.name, 'findById', false, 'First entity has no ID');
        return;
      }
      
      final start = DateTime.now();
      final entity = await repository.findById(id);
      final elapsed = DateTime.now().difference(start);
      
      if (entity == null) {
        setResult(concept.name, 'findById', false, 'Entity not found for ID: $id');
        return;
      }
      
      setResult(
        concept.name,
        'findById',
        true,
        'Found entity in ${elapsed.inMilliseconds}ms',
      );
      
      if (_verbose) {
        log('    Entity: $entity');
      }
    } catch (e) {
      setResult(concept.name, 'findById', false, 'Error: $e');
    }
  }
  
  /// Tests the query operation.
  ///
  /// Parameters:
  /// - [repository]: The repository to test
  /// - [concept]: The concept being tested
  ///
  /// Returns:
  /// A future that completes when the test is done
  Future<void> testQuery(Repository<Entity> repository, Concept concept) async {
    log('  Testing query...');
    try {
      // Build a simple query
      final criteria = FilterCriteria<Entity>();
      
      // Add a criterion if there's a string attribute to filter on
      final stringAttr = concept.attributes
          .where((a) => a.type?.code == 'String')
          .firstOrNull;
      
      if (stringAttr != null) {
        // Try to get a value to filter on
        final entities = await repository.findAll();
        if (entities.isNotEmpty) {
          final value = entities.first.getAttribute(stringAttr.code);
          if (value != null) {
            criteria.addCriterion(Criterion(stringAttr.code, value));
          }
        }
      }
      
      final start = DateTime.now();
      final results = await repository.findByCriteria(criteria);
      final elapsed = DateTime.now().difference(start);
      
      setResult(
        concept.name,
        'query',
        true,
        'Found ${results.length} entities in ${elapsed.inMilliseconds}ms',
      );
      
      if (_verbose && results.isNotEmpty) {
        log('    First result: ${results.first}');
      }
    } catch (e) {
      setResult(concept.name, 'query', false, 'Error: $e');
    }
  }
  
  /// Tests the save operation.
  ///
  /// Parameters:
  /// - [repository]: The repository to test
  /// - [concept]: The concept being tested
  ///
  /// Returns:
  /// A future that completes when the test is done
  Future<void> testSave(Repository<Entity> repository, Concept concept) async {
    log('  Testing save()...');
    try {
      // Create a new entity
      final entity = DomainEntity(concept, {});
      
      // Set required attributes
      for (final attr in concept.attributes) {
        if (attr.required) {
          // Set a dummy value based on type
          if (attr.type?.code == 'String') {
            entity.data[attr.code] = 'Test ${attr.code}';
          } else if (attr.type?.code == 'Integer') {
            entity.data[attr.code] = 1;
          } else if (attr.type?.code == 'Double') {
            entity.data[attr.code] = 1.0;
          } else if (attr.type?.code == 'Boolean') {
            entity.data[attr.code] = true;
          } else if (attr.type?.code == 'DateTime') {
            entity.data[attr.code] = DateTime.now().toIso8601String();
          }
        }
      }
      
      final start = DateTime.now();
      await repository.save(entity);
      final elapsed = DateTime.now().difference(start);
      
      setResult(
        concept.name,
        'save',
        true,
        'Saved entity in ${elapsed.inMilliseconds}ms',
      );
      
      if (_verbose) {
        log('    Entity: $entity');
      }
    } catch (e) {
      setResult(concept.name, 'save', false, 'Error: $e');
    }
  }
  
  /// Gets the test results.
  ///
  /// Returns:
  /// A map of concept names to test results
  Map<String, Map<String, TestResult>> getResults() {
    return Map.unmodifiable(_results);
  }
  
  /// Sets a test result.
  ///
  /// Parameters:
  /// - [concept]: The concept name
  /// - [test]: The test name
  /// - [success]: Whether the test succeeded
  /// - [message]: Additional message about the result
  void setResult(String concept, String test, bool success, String message) {
    _results.putIfAbsent(concept, () => {});
    _results[concept]![test] = TestResult(success, message);
    
    log('    ${success ? 'PASS' : 'FAIL'}: $message');
  }
  
  /// Logs a message if verbose.
  ///
  /// Parameters:
  /// - [message]: The message to log
  void log(String message) {
    print(message);
  }
  
  /// Prints a summary of all test results.
  void printSummary() {
    print('Integration Test Summary');
    print('=======================');
    print('');
    
    int totalTests = 0;
    int passedTests = 0;
    
    for (final entry in _results.entries) {
      final conceptName = entry.key;
      final tests = entry.value;
      
      print('Concept: $conceptName');
      
      for (final testEntry in tests.entries) {
        final testName = testEntry.key;
        final result = testEntry.value;
        
        final status = result.success ? 'PASS' : 'FAIL';
        print('  ${testName.padRight(10)}: [$status] ${result.message}');
        
        totalTests++;
        if (result.success) {
          passedTests++;
        }
      }
      
      print('');
    }
    
    final percentage = totalTests > 0 
        ? (passedTests / totalTests * 100).toStringAsFixed(2)
        : '0.00';
        
    print('Overall: $passedTests/$totalTests tests passed ($percentage%)');
  }
}

/// Result of an integration test.
class TestResult {
  /// Whether the test succeeded.
  final bool success;
  
  /// Additional message about the result.
  final String message;
  
  /// Creates a new test result.
  ///
  /// Parameters:
  /// - [success]: Whether the test succeeded
  /// - [message]: Additional message about the result
  TestResult(this.success, this.message);
} 