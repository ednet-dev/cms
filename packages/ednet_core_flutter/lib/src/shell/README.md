# EDNet Shell Architecture

A powerful domain model interpreter with flexible UX customization capabilities for EDNet-based applications.

## Overview

The EDNet Shell Architecture provides a complete runtime environment for domain models generated with EDNet. It serves as the bridge between domain models and UI representation, enabling domain experts to focus on modeling while developers can customize the user experience through a well-defined extension system.

This architecture follows several core principles:

1. **Domain Model Integrity**: Domain models remain pure and focused on business logic, free from UI concerns
2. **Progressive Disclosure**: UI complexity adapts to user needs, revealing more advanced features as required
3. **Clean Customization**: Well-defined extension points allow for targeted customization
4. **Pattern-Based Design**: Leverages Enterprise Integration Patterns for robust and scalable integration

## Key Components

### ShellApp

The central component that coordinates domain model interpretation and UX representation:

```dart
// Initialize with a domain model
final shell = ShellApp(domain: myDomainModel);

// Configure for specific user needs
shell.configureDisclosureLevel(
  userRole: 'expert',
  defaultLevel: DisclosureLevel.advanced
);

// Launch the UI
runApp(ShellAppRunner(shellApp: shell));
```

### UX Adapters

Adapters bridge the gap between domain models and their UI representation:

```dart
// Register a custom adapter for a specific entity type
shell.registerAdapter<ProjectEntity>(ProjectUXAdapterFactory());

// Register disclosure-specific adapters
shell.registerAdapterWithDisclosure<DocumentEntity>(
  DocumentAdvancedUXAdapterFactory(),
  DisclosureLevel.advanced
);
```

### Configuration Injection

The Configuration Injector enables flexible configuration of all aspects of the shell:

```dart
// Create an injector
final injector = ConfigurationInjector();

// Register various configuration types
injector.registerConfiguration(myUxConfig, ConfigurationType.ux);
injector.registerConfiguration(myDataConfig, ConfigurationType.data);

// Apply configurations to shell
injector.configure(shell);
```

### Canonical Model

The UX Canonical Model standardizes entity representation for UI components:

```dart
// Create a canonical model from an entity
final model = UXCanonicalModel.fromEntity(
  myEntity, 
  DisclosureLevel.intermediate
);

// Access UI-specific data
final formFields = model.getFormFields();
final displayProps = model.getDisplayProperties();
```

### Enterprise Integration Patterns

The architecture leverages several patterns from Enterprise Integration Patterns:

1. **Channel Adapter**: Bridges domain models with UI
2. **Message Filter**: Selectively processes UI components
3. **Message Aggregator**: Combines related entities for visualization
4. **Canonical Data Model**: Standardizes entity representation for UI

## Progressive Disclosure

A core feature of the Shell Architecture is progressive disclosure of UI elements based on user expertise level:

```dart
enum DisclosureLevel {
  minimal,    // Essential information only
  basic,      // Standard operation
  intermediate, // More detailed information
  advanced,   // Expert capabilities
  complete,   // All possible information and actions
}
```

Benefits of progressive disclosure:
- **Reduced cognitive load**: Users aren't overwhelmed by complexity
- **Focused interfaces**: Only relevant options are shown
- **Guided exploration**: Users can discover advanced features gradually
- **Contextual complexity**: UI adapts to user needs and expertise

## UX Customization

### Field Descriptors

Field descriptors define how entity attributes should be rendered in forms:

```dart
UXFieldDescriptor(
  fieldName: 'dueDate',
  displayName: 'Due Date',
  fieldType: UXFieldType.date,
  required: true,
)
.withDisclosureLevel(DisclosureLevel.intermediate)
.withHint('When the project must be completed')
```

### Custom Adapters

Create custom UX adapters to completely control how entities are displayed:

```dart
class ProjectUXAdapter extends ProgressiveUXAdapter<ProjectEntity> {
  @override
  Widget buildListItem(BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.minimal
  }) {
    // Custom list item implementation with progress indicators, etc.
  }
  
  // Other UI representation methods...
}
```

### YAML Configuration

UX customization can be configured through YAML files:

```yaml
ux:
  name: "Project UX Configuration"
  priority: 10
  defaultDisclosureLevel: intermediate
  
  fieldCustomizations:
    ProjectEntity:
      dueDate:
        displayName: "Deadline"
        disclosureLevel: basic
        validators:
          - type: required
            message: "A deadline is required for all projects"
```

## Implementation Guide

### 1. Domain Model Generation

First, generate your domain model using EDNet Core:

```bash
ednet generate --from domain.yaml --output lib/domain
```

### 2. Shell Configuration

Create a shell configuration:

```dart
final config = ShellConfiguration(
  defaultDisclosureLevel: DisclosureLevel.basic,
  features: {'filtering', 'sorting', 'export'},
);
```

### 3. Custom UX Adapters

Implement custom adapters for entity types requiring specialized UI:

```dart
// Register the adapter factory
UXAdapterRegistry().register<ProjectEntity>(ProjectUXAdapterFactory());
```

### 4. Launching the Shell

Initialize and launch the shell app:

```dart
// Initialize with domain and configuration
final shell = ShellApp(
  domain: domainModel,
  configuration: config,
);

// Apply any additional configuration
final injector = ConfigurationInjector();
injector.registerConfiguration(myCustomConfig, ConfigurationType.custom);
injector.configure(shell);

// Launch the UI
runApp(ShellAppRunner(shellApp: shell));
```

## Advanced Topics

### Custom Field Renderers

Register custom field renderers for specialized input types:

```dart
final fieldDescriptor = UXFieldDescriptor(...)
  .withCustomRenderer((context, fieldName, value, onChanged) {
    // Return a custom widget for this field
    return MySpecializedInputWidget(
      value: value,
      onChanged: onChanged,
    );
  });
```

### Domain Model Visualization

Create interactive visualizations of domain models:

```dart
final visualizer = DomainModelVisualizerFactory.forAggregate(
  correlationId: 'project-123',
  context: context,
  root: projectEntity,
  children: projectTasks,
  disclosureLevel: DisclosureLevel.intermediate,
);

// Get the visualization widget
final widget = visualizer.getAggregatedResult();
```

### Message Processing

Leverage Enterprise Integration Patterns for complex UI workflows:

```dart
// Create a filter for UI components
final filter = UXComponentFilter(
  EntityFilterCriteria.ofType('Project')
    .and(EntityFilterCriteria.whereAttribute('status', 'active')),
  sourceChannel,
  targetChannel,
);

// Start processing messages
filter.start();
```

## Integration with EDNet Core

The Shell Architecture is fully integrated with EDNet Core:

1. Leverages EDNet domain models for UI generation
2. Respects domain rules and constraints
3. Maintains domain integrity through clean separation of concerns
4. Enables full cycle evolution of domain models

## Customization Points

The architecture provides multiple customization points:

1. **Entity Adapters**: Control how entities are visualized
2. **Field Renderers**: Customize form field rendering
3. **Disclosure Levels**: Define what's visible at each level
4. **Validators**: Custom validation logic for fields
5. **Formatters**: Control how values are displayed
6. **Themes**: Visual styling of components
7. **Layouts**: Arrangement of UI elements
8. **Messages**: Custom handling of UI events

## Best Practices

1. **Progressive Enhancement**: Start with minimal UI and add complexity gradually
2. **Domain Alignment**: Ensure UI customizations reflect domain semantics
3. **User-Centered Design**: Customize based on user roles and workflows
4. **Consistency**: Maintain consistent patterns across the application
5. **Performance**: Use lazy loading and virtualization for large datasets
6. **Accessibility**: Ensure UI components are accessible to all users
7. **Testing**: Test UI components with different disclosure levels
8. **Documentation**: Document customization decisions and rationale

## Master-Detail Pattern with Constraint Validation

The Shell now includes a master-detail navigation pattern that integrates with constraint validation, providing an optimal UX for navigating domain models.

### Architecture

The master-detail navigation pattern is structured as follows:

1. **Domain Selection (Header)** - Select from available domains
2. **Model Navigation (Left)** - Browse models within the selected domain
3. **Concept/Aggregate Root Navigation (Middle-Left)** - Browse concepts within the selected model
4. **Entity List (Middle-Right)** - View entities of the selected concept
5. **Entity Details (Right)** - View and edit entity details with constraint validation

As users navigate through relationships, the UI shifts left to keep focus on the current selection while maintaining context.

### Key Components

- **MasterDetailNavigator** - The main widget implementing the navigation pattern
- **ConstraintValidatedForm** - Form component that validates based on domain model constraints
- **BreadcrumbNavigation** - Tracks navigation history and provides an easy way to navigate back
- **Navigation History** - Maintains context as users navigate the domain model

### Using Master-Detail Navigation

To use the master-detail navigation pattern in your app:

```dart
// Create a ShellApp with your domain model
final shellApp = ShellApp(
  domain: myDomain,
  configuration: ShellConfiguration(
    defaultDisclosureLevel: DisclosureLevel.intermediate,
    features: {'constraint_validation', 'master_detail_navigation'},
  ),
);

// Use the MasterDetailNavigator in your UI
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Domain Explorer')),
    body: MasterDetailNavigator(
      shellApp: shellApp,
      initialModel: myModel, // Optional initial selection
      showDomainSelector: true,
      disclosureLevel: DisclosureLevel.intermediate,
    ),
  );
}
```

### Constraint Validation

The master-detail pattern automatically integrates with the constraint validation system:

1. When an entity is selected, its attributes are displayed in a constraint-validated form
2. Constraints from the domain model (min/max values, required fields, patterns, etc.) are enforced
3. Visual indicators show constraints next to field labels
4. Validation messages are displayed when constraints are violated

The constraint validation is based on the TypeConstraintValidator implementation and provides real-time feedback as users interact with forms.

### Example

See `src/shell/example/shell_app_with_master_detail.dart` for a complete example of how to use the master-detail navigation pattern with constraint validation.

## Usage Guidelines

When implementing constraint validation in your own forms:

1. **Define Constraints in Domain Model** - Ensure your domain model includes constraints on attributes
2. **Use ConstraintValidatedForm** - Use this component for automatic constraint validation
3. **Configure Disclosure Level** - Use an appropriate disclosure level for your user personas
4. **Handle Form Submission** - Implement the onSubmit callback to handle form data

For optimal UX:

1. Use progressive disclosure to show more complex constraints to advanced users
2. Provide clear error messages for constraint violations
3. Use appropriate input types for different attribute types
4. Validate on change for immediate feedback

## Customization

You can customize the master-detail navigation by:

1. Registering custom adapters for specific entity types
2. Configuring the disclosure level for different user roles
3. Providing custom themes for the UI components
4. Implementing custom entity visualization components

See the ShellConfiguration class for more customization options. 