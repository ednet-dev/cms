part of openapi;

/// Example demonstrating integration with the Swagger PetStore API.
///
/// This example shows how to:
/// 1. Connect to the Swagger PetStore API
/// 2. Create a domain model
/// 3. Perform operations on pets, stores, and users
class PetStoreExample {
  /// The base URL for the PetStore API.
  static const String apiUrl = 'https://petstore.swagger.io/v2';
  
  /// Domain model for the PetStore API.
  late final Domain _domain;
  
  /// Repository factory.
  late final OpenApiRepositoryFactory _factory;
  
  /// Creates a new PetStore example.
  ///
  /// This initializes the domain model and repository factory.
  PetStoreExample() {
    _domain = _createDomain();
    _factory = OpenApiRepositoryFactory(
      domain: _domain,
      baseUrl: apiUrl,
    );
  }
  
  /// Creates the domain model for the PetStore API.
  ///
  /// This method manually defines the domain model based on
  /// the known structure of the PetStore API.
  ///
  /// Returns:
  /// The domain model
  Domain _createDomain() {
    final domain = Domain('PetStore');
    
    // Create Category concept
    final categoryConcept = Concept('Category');
    categoryConcept.addAttribute(_createAttribute('id', 'Integer', isPrimaryKey: true));
    categoryConcept.addAttribute(_createAttribute('name', 'String'));
    domain.addConcept(categoryConcept);
    
    // Create Tag concept
    final tagConcept = Concept('Tag');
    tagConcept.addAttribute(_createAttribute('id', 'Integer', isPrimaryKey: true));
    tagConcept.addAttribute(_createAttribute('name', 'String'));
    domain.addConcept(tagConcept);
    
    // Create Pet concept
    final petConcept = Concept('Pet');
    petConcept.addAttribute(_createAttribute('id', 'Integer', isPrimaryKey: true));
    petConcept.addAttribute(_createAttribute('name', 'String', required: true));
    petConcept.addAttribute(_createAttribute('status', 'String'));
    petConcept.addAttribute(_createAttribute('photoUrls', 'String', isCollection: true));
    
    // Add relationships
    petConcept.addParent(Parent('category', categoryConcept));
    petConcept.addChild(Child('tags', tagConcept));
    
    domain.addConcept(petConcept);
    
    // Create Order concept
    final orderConcept = Concept('Order');
    orderConcept.addAttribute(_createAttribute('id', 'Integer', isPrimaryKey: true));
    orderConcept.addAttribute(_createAttribute('petId', 'Integer'));
    orderConcept.addAttribute(_createAttribute('quantity', 'Integer'));
    orderConcept.addAttribute(_createAttribute('shipDate', 'DateTime'));
    orderConcept.addAttribute(_createAttribute('status', 'String'));
    orderConcept.addAttribute(_createAttribute('complete', 'Boolean'));
    
    domain.addConcept(orderConcept);
    
    // Create User concept
    final userConcept = Concept('User');
    userConcept.addAttribute(_createAttribute('id', 'Integer', isPrimaryKey: true));
    userConcept.addAttribute(_createAttribute('username', 'String'));
    userConcept.addAttribute(_createAttribute('firstName', 'String'));
    userConcept.addAttribute(_createAttribute('lastName', 'String'));
    userConcept.addAttribute(_createAttribute('email', 'String'));
    userConcept.addAttribute(_createAttribute('password', 'String'));
    userConcept.addAttribute(_createAttribute('phone', 'String'));
    userConcept.addAttribute(_createAttribute('userStatus', 'Integer'));
    
    domain.addConcept(userConcept);
    
    return domain;
  }
  
  /// Creates an attribute with the given properties.
  ///
  /// Parameters:
  /// - [name]: The name of the attribute
  /// - [type]: The type of the attribute
  /// - [isPrimaryKey]: Whether this is a primary key
  /// - [required]: Whether this attribute is required
  /// - [isCollection]: Whether this attribute is a collection
  ///
  /// Returns:
  /// The created attribute
  Attribute _createAttribute(
    String name,
    String type, {
    bool isPrimaryKey = false,
    bool required = false,
    bool isCollection = false,
  }) {
    Attribute attribute;
    
    switch (type) {
      case 'String':
        attribute = StringAttribute(name);
        (attribute as StringAttribute).isCollection = isCollection;
        break;
      case 'Integer':
        attribute = IntegerAttribute(name);
        break;
      case 'Double':
        attribute = DoubleAttribute(name);
        break;
      case 'Boolean':
        attribute = BooleanAttribute(name);
        break;
      case 'DateTime':
        attribute = DateTimeAttribute(name);
        break;
      default:
        attribute = StringAttribute(name);
        break;
    }
    
    attribute.isPrimaryKey = isPrimaryKey;
    attribute.required = required;
    
    return attribute;
  }
  
  /// Runs the example.
  ///
  /// This method demonstrates various operations on the PetStore API.
  ///
  /// Parameters:
  /// - [tracePolicies]: Whether to trace policy evaluations
  ///
  /// Returns:
  /// A Future that completes when the example is done
  Future<void> run({bool tracePolicies = true}) async {
    print('Running PetStore Example');
    print('======================');
    print('');
    
    // Create policy tracer if requested
    PolicyEvaluationTracer? tracer;
    if (tracePolicies) {
      tracer = PolicyEvaluationTracer(printImmediately: true);
      print('Policy tracing enabled.');
      
      // For this example, we'll just trace the domain model
      tracer.traceDomainModel(_domain);
    }
    
    // Find available pets
    await _findAvailablePets();
    
    // Get pet by ID
    await _getPetById(1);
    
    // Find pets by status
    await _findPetsByStatus('available');
    
    // Get store inventory
    await _getStoreInventory();
    
    // Find users
    await _findUsers();
    
    print('');
    print('Example completed successfully!');
  }
  
  /// Finds available pets.
  ///
  /// Returns:
  /// A Future that completes when the operation is done
  Future<void> _findAvailablePets() async {
    print('Finding available pets...');
    
    try {
      // Get the Pet concept
      final petConcept = _domain.findConcept('Pet');
      if (petConcept == null) {
        print('  Error: Pet concept not found');
        return;
      }
      
      // Create a repository
      final repository = _factory.createRepository(petConcept);
      
      // Create a filter for available pets
      final criteria = FilterCriteria<Entity>();
      criteria.addCriterion(Criterion('status', 'available'));
      
      // Find pets
      final pets = await repository.findByCriteria(criteria);
      
      print('  Found ${pets.length} available pets');
      
      // Print the first few pets
      for (int i = 0; i < pets.length && i < 3; i++) {
        final pet = pets[i];
        final name = pet.getAttribute<String>('name');
        final id = pet.getAttribute<int>('id');
        print('  Pet $i: $name (ID: $id)');
      }
      
      if (pets.length > 3) {
        print('  ... and ${pets.length - 3} more');
      }
    } catch (e) {
      print('  Error: $e');
    }
    
    print('');
  }
  
  /// Gets a pet by ID.
  ///
  /// Parameters:
  /// - [id]: The ID of the pet to get
  ///
  /// Returns:
  /// A Future that completes when the operation is done
  Future<void> _getPetById(int id) async {
    print('Getting pet with ID $id...');
    
    try {
      // Get the Pet concept
      final petConcept = _domain.findConcept('Pet');
      if (petConcept == null) {
        print('  Error: Pet concept not found');
        return;
      }
      
      // Create a repository
      final repository = _factory.createRepository(petConcept);
      
      // Find pet
      final pet = await repository.findById(id);
      
      if (pet == null) {
        print('  Pet not found');
        return;
      }
      
      print('  Found pet:');
      print('    ID: ${pet.getAttribute<int>('id')}');
      print('    Name: ${pet.getAttribute<String>('name')}');
      print('    Status: ${pet.getAttribute<String>('status')}');
      
      // Get category
      final category = pet.getParent('category');
      if (category != null) {
        print('    Category: ${category.getAttribute<String>('name')}');
      }
      
      // Get tags
      final tags = pet.getChild('tags');
      if (tags != null) {
        print('    Tags: ${(tags as Entities).length}');
      }
    } catch (e) {
      print('  Error: $e');
    }
    
    print('');
  }
  
  /// Finds pets by status.
  ///
  /// Parameters:
  /// - [status]: The status to search for
  ///
  /// Returns:
  /// A Future that completes when the operation is done
  Future<void> _findPetsByStatus(String status) async {
    print('Finding pets with status "$status"...');
    
    try {
      // Get the Pet concept
      final petConcept = _domain.findConcept('Pet');
      if (petConcept == null) {
        print('  Error: Pet concept not found');
        return;
      }
      
      // Create a repository
      final repository = _factory.createRepository(petConcept);
      
      // Create a filter
      final criteria = FilterCriteria<Entity>();
      criteria.addCriterion(Criterion('status', status));
      
      // Find pets
      final pets = await repository.findByCriteria(criteria);
      
      print('  Found ${pets.length} pets with status "$status"');
      
      // Print the first few pets
      for (int i = 0; i < pets.length && i < 3; i++) {
        final pet = pets[i];
        final name = pet.getAttribute<String>('name');
        final id = pet.getAttribute<int>('id');
        print('  Pet $i: $name (ID: $id)');
      }
      
      if (pets.length > 3) {
        print('  ... and ${pets.length - 3} more');
      }
    } catch (e) {
      print('  Error: $e');
    }
    
    print('');
  }
  
  /// Gets the store inventory.
  ///
  /// Returns:
  /// A Future that completes when the operation is done
  Future<void> _getStoreInventory() async {
    print('Getting store inventory...');
    
    try {
      // The store inventory is a special endpoint, not easily modeled
      // with our repository abstraction. In a real application, we might
      // create a custom service for this.
      
      // For this example, we'll use HttpClient directly
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('$apiUrl/store/inventory'));
      request.headers.add('Accept', 'application/json');
      
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      
      if (response.statusCode != 200) {
        print('  Error: ${response.statusCode}');
        return;
      }
      
      final inventory = json.decode(body) as Map<String, dynamic>;
      
      print('  Store inventory:');
      inventory.forEach((status, count) {
        print('    $status: $count');
      });
    } catch (e) {
      print('  Error: $e');
    }
    
    print('');
  }
  
  /// Finds users.
  ///
  /// Returns:
  /// A Future that completes when the operation is done
  Future<void> _findUsers() async {
    print('Finding users...');
    
    try {
      // Get the User concept
      final userConcept = _domain.findConcept('User');
      if (userConcept == null) {
        print('  Error: User concept not found');
        return;
      }
      
      // Create a repository
      final repository = _factory.createRepository(userConcept);
      
      // Find users
      final users = await repository.findAll();
      
      print('  Found ${users.length} users');
      
      // Print the first few users
      for (int i = 0; i < users.length && i < 3; i++) {
        final user = users[i];
        final username = user.getAttribute<String>('username');
        final id = user.getAttribute<int>('id');
        print('  User $i: $username (ID: $id)');
      }
      
      if (users.length > 3) {
        print('  ... and ${users.length - 3} more');
      }
    } catch (e) {
      print('  Error: $e');
      print('  Note: The PetStore API may not support listing all users');
    }
    
    print('');
  }
}

/// Runs the PetStore example.
///
/// This function can be called directly to run the example.
///
/// Returns:
/// A Future that completes when the example is done
Future<void> runPetStoreExample() async {
  final example = PetStoreExample();
  await example.run();
} 