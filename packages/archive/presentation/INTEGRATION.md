# EDNet Core Flutter - Shell Architecture Integration Guide

## Overview

This document provides a detailed guide for integrating the Shell Architecture components from the `ednet_core_flutter` package into the EDNet One application. The Shell Architecture provides a domain-driven approach to UI development with progressive disclosure and semantic styling.

## Key Concepts

1. **Shell App**: The central hub that connects domain models with their visual representations
2. **Progressive Disclosure**: UI complexity adapts based on user expertise and needs
3. **Adapter Pattern**: Custom UI representations for domain entities
4. **Semantic Styling**: Visual design based on semantic meaning

## Integration Steps

### 1. Update Dependencies

Ensure your pubspec.yaml includes the ednet_core_flutter package:

```yaml
dependencies:
  ednet_core_flutter:
    path: ../../packages/ednet_core_flutter
```

Run `flutter pub get` to update dependencies.

### 2. Initialize Shell App

Replace the standard MaterialApp with ShellAppRunner:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApplication();
  
  runApp(
    ShellAppRunner(
      shellApp: shellApp,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    ),
  );
}

Future<void> initializeApplication() async {
  // Create OneApplication
  oneApplication = OneApplication();
  await oneApplication.initializeApplication();
  
  // Configure shell
  final shellConfiguration = ShellConfiguration(
    defaultDisclosureLevel: DisclosureLevel.basic,
    features: {'responsive_layout', 'semantic_pinning'},
  );
  
  // Create ShellApp with domain
  shellApp = ShellApp(
    domain: oneApplication.domains.first,
    configuration: shellConfiguration,
  );
}
```

### 3. Register Custom Adapters

Create adapters for your domain entities:

```dart
// Create an adapter factory for a concept
class PersonUXAdapterFactory implements UXAdapterFactory<Person> {
  @override
  UXAdapter<Person> createAdapter(Person entity, {DisclosureLevel? level}) {
    return PersonUXAdapter(entity, level ?? DisclosureLevel.basic);
  }
}

// Implement the adapter
class PersonUXAdapter extends UXAdapter<Person> {
  PersonUXAdapter(Person entity, DisclosureLevel level) 
    : super(entity, level);
    
  @override
  Widget buildListItem(BuildContext context, {DisclosureLevel? disclosureLevel}) {
    // Create a list item representation
    return ListTile(
      title: Text(entity.firstName),
      subtitle: Text(entity.lastName),
    );
  }
  
  @override
  Widget buildForm(BuildContext context, {DisclosureLevel? disclosureLevel}) {
    // Build a form for editing the entity
    return Column(
      children: [
        TextFormField(
          initialValue: entity.firstName,
          decoration: InputDecoration(labelText: 'First Name'),
        ),
        TextFormField(
          initialValue: entity.lastName,
          decoration: InputDecoration(labelText: 'Last Name'),
        ),
      ],
    );
  }
}
```

Register the adapters with the shell:

```dart
// Register adapters for your entities
shellApp.registerAdapter<Person>(PersonUXAdapterFactory());
```

### 4. Use Semantic Components

Wrap your UI components with ResponsiveSemanticWrapper:

```dart
ResponsiveSemanticWrapper(
  disclosureLevel: DisclosureLevel.intermediate,
  semanticPriority: 80,
  child: YourWidget(),
)
```

### 5. Implement Navigation

Use the Shell navigation service:

```dart
// Navigate to a domain entity
shellApp.navigateToEntity(personEntity);

// Navigate to a specific path
shellApp.navigateTo('/settings');

// Use breadcrumbs
shellApp.buildBreadcrumbNavigation(context)
```

### 6. Test Progressive Disclosure

Verify that your UI adapts correctly to different disclosure levels:

```dart
// Change disclosure level
shellApp.configureDisclosureLevel(
  userRole: 'admin',
  defaultLevel: DisclosureLevel.advanced
);
```

## Examples

### Basic Entity List

```dart
Widget buildEntityList() {
  return shellApp.buildEntityList<Person>(
    context,
    'Person',
    personList,
    disclosureLevel: DisclosureLevel.basic,
  );
}
```

### Domain Visualization

```dart
Widget buildModelVisualization() {
  final model = shellApp.getModel('TestModel');
  if (model == null) return Text('Model not found');
  
  return UnifiedVisualizationCanvas(
    model: model,
    disclosureLevel: DisclosureLevel.intermediate,
  );
}
```

### Form Builder

```dart
Widget buildEntityForm(Person person) {
  return shellApp.buildEntityForm<Person>(
    context,
    person,
    disclosureLevel: DisclosureLevel.advanced,
  );
}
```

## Troubleshooting

1. **Import Issues**: Ensure you're importing the correctly structured package
2. **Adapter Registration**: Verify that adapters are registered for all entity types
3. **Navigation**: Check that paths match expected routes in the shell
4. **Disclosure Levels**: Test with different disclosure levels to ensure proper UI adaptation

## Next Steps

1. Create custom theme components
2. Implement domain-specific visualizations
3. Integrate with existing state management
4. Add user role management for disclosure control 