# ModelInstanceService Memory File

## Current Status

The `ModelInstanceService` class currently has several issues that need to be addressed to align it with the new EDNet Shell architecture:

1. **Linter Error**: Line 220-221 has a linter error related to the `removeWhere()` method, which returns `void` but is being used in a condition.

2. **Modeling Approach**: Currently using string-based configuration instead of leveraging the EDNet core domain model classes.

3. **Integration**: Not integrated with the Shell architecture for UX representation.

## Required Changes

### 1. Fix the Immediate Linter Error

The `deleteConfiguration` method has an error in its implementation. The `removeWhere` method on collections returns `void`, not a boolean indicating whether items were removed. We need to track the count before and after removal.

```dart
Future<bool> deleteConfiguration(String configId) async {
  final initialCount = _configurations.length;
  _configurations.removeWhere((c) => c.id == configId);
  final removed = initialCount > _configurations.length;
  
  if (removed) {
    return await saveConfigurations();
  }
  return false;
}
```

### 2. Align with EDNet Core Domain Modeling

Refactor the configuration classes to use proper EDNet domain modeling by:

1. Converting `ModelInstanceConfig` to extend `Entity<ModelInstanceConfig>`
2. Creating a proper concept and attribute definitions
3. Using the EDNet validation mechanism

Example approach:

```dart
class ModelInstanceConfig extends Entity<ModelInstanceConfig> {
  // Entity properties via attributes
  String get name => getAttribute<String>('name') ?? '';
  set name(String value) => setAttribute('name', value);
  
  // Other properties similarly...
  
  // Constructor with concept definition
  ModelInstanceConfig() {
    // Define concept and attributes
    var concept = Concept(Model(Domain('ConfigDomain'), 'ConfigModel'), 'ModelInstanceConfig');
    
    // Define attributes
    var nameAttr = Attribute(concept, 'name');
    nameAttr.type = AttributeType('String');
    nameAttr.required = true;
    concept.attributes.add(nameAttr);
    
    // Other attributes similarly...
    
    this.concept = concept;
  }
}
```

### 3. Integrate with Shell Architecture

1. Create a `ModelInstanceConfigUXAdapter` that implements `UXAdapter<ModelInstanceConfig>`
2. Register the adapter with the Shell's adapter registry
3. Use the Shell's form building and rendering capabilities

Example:

```dart
class ModelInstanceConfigUXAdapter extends ProgressiveUXAdapter<ModelInstanceConfig> {
  ModelInstanceConfigUXAdapter(ModelInstanceConfig entity) : super(entity);
  
  @override
  List<UXFieldDescriptor> getFieldDescriptors({
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
  }) {
    return [
      UXFieldDescriptor(
        fieldName: 'name',
        displayName: 'Configuration Name',
        fieldType: UXFieldType.text,
        required: true,
      ).withDisclosureLevel(DisclosureLevel.minimal),
      
      // Other fields with appropriate disclosure levels
    ];
  }
  
  @override
  Map<String, dynamic> getInitialFormData() {
    return {
      'name': entity.name,
      'description': entity.description,
      // Other fields
    };
  }
}
```

## Integration with Project Architecture

To complete the integration:

1. Modify `ModelInstanceService` to work with the Shell
2. Register adapters during application initialization
3. Use the Shell's UI building capabilities in the presentation layer

## Action Plan

1. Fix the immediate linter error
2. Refactor the domain model classes to use EDNet properly
3. Create UX adapters for the configuration classes
4. Update the service to work with these changes
5. Integrate with the presentation layer using the Shell architecture 