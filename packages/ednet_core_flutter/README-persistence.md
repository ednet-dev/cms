# EDNet Core Flutter Shell Persistence

This document explains how to properly integrate the ShellApp with EDNet Core's domain repositories to persist and restore entities.

## Overview

The ShellApp in EDNet Core Flutter can connect to EDNet Core's repository system to save and load entities. This enables proper domain-driven persistence that follows all domain rules.

## TDD Approach

We follow a Test-Driven Development (TDD) approach when implementing persistence features:

1. **Red**: Write tests that verify our persistence requirements
2. **Green**: Implement the minimal code to make the tests pass
3. **Refactor**: Improve the implementation without changing the functionality

## Example Implementation

Here's a complete example of how to enable persistence in the ShellApp:

```dart
// 1. First implement a persistence manager
class ShellPersistence {
  final Domain domain;
  
  ShellPersistence(this.domain);
  
  // Check if domain has a session
  bool get hasDomainSession {
    // Access the domain's session if it exists
    final domainSession = domain.metadata?['domainSession'] as DomainSession?;
    return domainSession != null;
  }
  
  // Create or get domain session
  DomainSession? getDomainSession() {
    // First check if we already have one
    final existingSession = domain.metadata?['domainSession'] as DomainSession?;
    if (existingSession != null) {
      return existingSession;
    }
    
    // Create domain models from domain
    final domainModels = DomainModels();
    domainModels.domain = domain;
    
    // Create a new session
    final session = DomainSession(domainModels);
    
    // Save session in domain metadata for reuse
    domain.metadata ??= {};
    domain.metadata!['domainSession'] = session;
    
    return session;
  }
  
  // Save entity to repository
  Future<bool> saveEntity(String conceptCode, Map<String, dynamic> entityData) async {
    // Get session
    final session = getDomainSession();
    if (session == null) return false;
    
    // Get repository
    final repository = session.getRepository(conceptCode);
    if (repository == null) return false;
    
    // Begin transaction
    final transaction = session.beginTransaction('Save$conceptCode');
    
    try {
      // Get or create entity
      final entity = entityData.containsKey('id') && entityData['id'] != null
          ? await repository.findById(entityData['id'])
          : repository.create();
      
      if (entity == null) return false;
      
      // Update entity values
      for (var key in entityData.keys) {
        if (key != 'id' && key != 'oid') {
          entity.setAttribute(key, entityData[key]);
        }
      }
      
      // Save entity
      final success = await repository.save(entity);
      if (!success) {
        transaction.rollback();
        return false;
      }
      
      // Update ID in data
      entityData['id'] = entity.oid.toString();
      
      // Commit transaction
      transaction.commit();
      return true;
    } catch (e) {
      transaction.rollback();
      return false;
    }
  }
  
  // Load entities from repository
  Future<List<Map<String, dynamic>>> loadEntities(String conceptCode) async {
    // Get session
    final session = getDomainSession();
    if (session == null) return [];
    
    // Get repository
    final repository = session.getRepository(conceptCode);
    if (repository == null) return [];
    
    // Get concept
    final concept = _findConcept(conceptCode);
    if (concept == null) return [];
    
    // Load entities
    final entities = await repository.findAll();
    
    // Convert to maps
    return entities.map((entity) {
      final map = <String, dynamic>{
        'id': entity.oid.toString(),
      };
      
      // Copy attribute values
      for (var attribute in concept.attributes) {
        if (attribute is Attribute) {
          final value = entity.getAttribute(attribute.code);
          if (value != null) {
            map[attribute.code] = value;
          }
        }
      }
      
      return map;
    }).toList();
  }
  
  // Helper to find concept
  Concept? _findConcept(String conceptCode) {
    for (var model in domain.models) {
      for (var concept in model.concepts) {
        if (concept.code == conceptCode) {
          return concept;
        }
      }
    }
    return null;
  }
}

// 2. Add persistence to ShellApp
class ShellApp {
  // ... existing code ...
  
  late final ShellPersistence _persistence;
  
  ShellApp({required Domain domain /* ... other params ... */}) {
    // Initialize persistence
    _persistence = ShellPersistence(domain);
    // ... other initialization ...
  }
  
  // Method to save an entity
  Future<bool> saveEntity(String conceptCode, Map<String, dynamic> entityData) {
    return _persistence.saveEntity(conceptCode, entityData);
  }
  
  // Method to load entities
  Future<List<Map<String, dynamic>>> loadEntities(String conceptCode) {
    return _persistence.loadEntities(conceptCode);
  }
}

// 3. In your ConceptExplorer, update the form save method:
Future<void> _saveEntityForm(Map<String, dynamic> entity, Map<String, TextEditingController> controllers) async {
  // Update form values
  // ... existing code to extract form values ...
  
  // Save to repository
  final conceptCode = widget.concept.code;
  final success = await widget.shellApp.saveEntity(conceptCode, entity);
  
  if (success) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Entity saved successfully')),
    );
    
    // Refresh entities list
    await _loadEntities();
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save entity')),
    );
  }
}

// 4. Load entities when initializing the explorer:
@override
void initState() {
  super.initState();
  // ... other initialization ...
  
  // Load entities
  _loadEntities();
}

Future<void> _loadEntities() async {
  setState(() {
    _isLoading = true;
  });
  
  try {
    final conceptCode = widget.concept.code;
    final entities = await widget.shellApp.loadEntities(conceptCode);
    
    setState(() {
      if (entities.isNotEmpty) {
        _entities = entities;
      }
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
  }
}
```

## Testing Persistence

To verify your persistence implementation works correctly, you can create tests that:

1. Create a ShellApp with a test domain
2. Save an entity through the ShellApp
3. Verify the entity was saved successfully
4. Load entities and verify the saved entity is included
5. Update the entity and save it again
6. Verify changes were persisted

Here's an example test:

```dart
testWidgets('ShellApp should save and load entities', (WidgetTester tester) async {
  // Create a test domain
  final domain = Domain();
  domain.code = 'TestDomain';
  
  // Add a model and concept
  final model = Model();
  model.code = 'TestModel';
  domain.models.add(model);
  
  final concept = Concept();
  concept.code = 'TestConcept';
  model.concepts.add(concept);
  
  // Create shell app
  final shellApp = ShellApp(domain: domain);
  
  // Create an entity to save
  final entityData = {
    'name': 'Test Entity',
    'description': 'This is a test entity',
  };
  
  // Save entity
  final saveResult = await shellApp.saveEntity('TestConcept', entityData);
  expect(saveResult, isTrue);
  
  // Verify ID was added
  expect(entityData['id'], isNotNull);
  
  // Load entities
  final loadedEntities = await shellApp.loadEntities('TestConcept');
  
  // Verify entity was loaded
  expect(loadedEntities, isNotEmpty);
  expect(loadedEntities.first['name'], equals('Test Entity'));
  expect(loadedEntities.first['id'], equals(entityData['id']));
  
  // Update entity
  entityData['description'] = 'Updated description';
  final updateResult = await shellApp.saveEntity('TestConcept', entityData);
  expect(updateResult, isTrue);
  
  // Verify update was saved
  final updatedEntities = await shellApp.loadEntities('TestConcept');
  expect(updatedEntities.first['description'], equals('Updated description'));
});
```

## Integration with EDNetOne Application

To use this in the EDNetOne application, ensure your main.dart properly initializes the shell:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize OneApplication
  final oneApp = OneApplication();
  await oneApp.initializeApplication();

  // Run with enhanced ShellApp experience
  runApp(EDNetOneApp(application: oneApp));
}

class EDNetOneApp extends StatelessWidget {
  final OneApplication application;

  const EDNetOneApp({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDNetOne',
      debugShowCheckedModeBanner: false,
      theme: _buildRichTheme(),
      home: ShellAppRunner(
        shellApp: _buildEnhancedShellApp(),
        theme: _buildRichTheme(),
      ),
    );
  }

  /// Build a shell app with persistence enabled
  ShellApp _buildEnhancedShellApp() {
    // Create a feature-rich shell app instance
    final shellApp = ShellApp(
      domain: application.groupedDomains.first,
      domains: application.groupedDomains,
      configuration: ShellConfiguration(
        // Enable persistence features
        features: {
          'persistence_enabled',
          'entity_creation',
          'entity_editing',
          // ... other features ...
        },
      ),
    );

    return shellApp;
  }

  // ... other methods ...
} 