# EDNet UX Component Architecture

This module provides a flexible architecture for customizing UI representations of domain entities while maintaining the core principles of Domain-Driven Design.

## Core Concepts

### Progressive Disclosure

Progressive disclosure is a design pattern that reveals information gradually, showing only what's necessary at first and progressively revealing more complex features as users need them. This makes interfaces more approachable while still supporting advanced functionality.

Our implementation defines several disclosure levels:

- **Minimal**: Only essential information, suitable for overview screens and lists
- **Basic**: Standard operation level with common fields and actions
- **Intermediate**: More detailed information for power users
- **Advanced**: Comprehensive information for expert users
- **Complete**: All possible information and actions, including administrative functions

### Adapter Pattern

The UX Adapter pattern serves as a bridge between domain entities and their UI representations. Each entity type can have custom adapters that determine how it's displayed in different contexts (list items, detail views, forms, etc.).

Adapters provide consistent, reusable UI patterns while respecting domain boundaries.

## Key Components

### `DisclosureLevel`

An enum that defines the different levels of information disclosure. Controls which UI elements and entity fields are displayed.

```dart
enum DisclosureLevel {
  minimal,
  basic,
  intermediate,
  advanced,
  complete;
}
```

### `UXAdapter<T extends Entity<T>>`

The core interface for adapting domain entities to UI components.

```dart
abstract class UXAdapter<T extends Entity<T>> {
  Widget buildForm(BuildContext context, {DisclosureLevel disclosureLevel});
  Widget buildListItem(BuildContext context, {DisclosureLevel disclosureLevel});
  Widget buildDetailView(BuildContext context, {DisclosureLevel disclosureLevel});
  Widget buildVisualization(BuildContext context, {DisclosureLevel disclosureLevel});
  // ...
}
```

### `UXAdapterRegistry`

A registry that manages adapters for different entity types, enabling client applications to override default UI representations.

```dart
class UXAdapterRegistry {
  void register<T extends Entity<T>>(UXAdapterFactory<T> factory);
  void registerWithDisclosure<T extends Entity<T>>(UXAdapterFactory<T> factory, DisclosureLevel level);
  UXAdapter<T> getAdapter<T extends Entity<T>>(T entity, {DisclosureLevel? disclosureLevel});
}
```

### `UXFieldDescriptor`

Describes form fields to be rendered in UI forms, with support for progressive disclosure.

```dart
class UXFieldDescriptor {
  String fieldName;
  String displayName;
  UXFieldType fieldType;
  bool required;
  List<UXFieldValidator> validators;
  Map<String, dynamic> metadata;
  
  UXFieldDescriptor withDisclosureLevel(DisclosureLevel level);
  // ...
}
```

### `DefaultFormBuilder<T extends Entity<T>>`

A form builder that can render any entity using field descriptors with support for progressive disclosure.

### Enterprise Integration Patterns

The architecture leverages several Enterprise Integration Patterns:

- **Channel Adapter**: `ModelUXChannelAdapter` connects domain models with UI components
- **Message Filter**: `UXComponentFilter` selectively displays UI components based on criteria
- **Message Aggregator**: `DomainModelVisualizer` collects related entities for unified visualization

## Usage Examples

### Basic Entity UX Extension Methods

Any entity can be easily displayed using the extension methods:

```dart
// Get a list item representation of the entity
Widget listItem = myEntity.buildListItem(context);

// Get a form for editing the entity with intermediate disclosure
Widget form = myEntity.buildForm(
  context, 
  disclosureLevel: DisclosureLevel.intermediate
);

// Get a detailed view of the entity
Widget detailView = myEntity.buildDetailView(context);
```

### Creating a Custom Adapter

1. Create an adapter implementation:

```dart
class MyEntityAdapter extends ProgressiveUXAdapter<MyEntity> {
  MyEntityAdapter(MyEntity entity) : super(entity);
  
  @override
  Widget buildListItem(BuildContext context, {
    DisclosureLevel disclosureLevel = DisclosureLevel.minimal
  }) {
    // Custom list item implementation
    return ListTile(
      title: Text(entity.name),
      // Progressive disclosure based on level
      subtitle: disclosureLevel.isAtLeast(DisclosureLevel.basic)
          ? Text(entity.description)
          : null,
    );
  }
  
  // Implement other methods...
}
```

2. Create a factory:

```dart
class MyEntityAdapterFactory implements UXAdapterFactory<MyEntity> {
  @override
  UXAdapter<MyEntity> create(MyEntity entity) {
    return MyEntityAdapter(entity);
  }
}
```

3. Register the adapter:

```dart
// Register the adapter globally
void registerAdapters() {
  UXAdapterRegistry().register<MyEntity>(MyEntityAdapterFactory());
}
```

### Using Progressive Disclosure

Field descriptors can specify at which disclosure level they should appear:

```dart
List<UXFieldDescriptor> getFieldDescriptors({
  DisclosureLevel disclosureLevel = DisclosureLevel.basic
}) {
  final allFields = [
    // Basic fields visible to everyone
    UXFieldDescriptor(
      fieldName: 'name',
      displayName: 'Name',
      fieldType: UXFieldType.text,
      required: true,
    ).withDisclosureLevel(DisclosureLevel.basic),
    
    // More detailed fields for intermediate users
    UXFieldDescriptor(
      fieldName: 'technicalDetails',
      displayName: 'Technical Details',
      fieldType: UXFieldType.longText,
    ).withDisclosureLevel(DisclosureLevel.intermediate),
    
    // Advanced fields only for expert users
    UXFieldDescriptor(
      fieldName: 'internalId',
      displayName: 'Internal ID',
      fieldType: UXFieldType.text,
    ).withDisclosureLevel(DisclosureLevel.advanced),
  ];
  
  // Filter fields based on the current disclosure level
  return filterFieldsByDisclosure(allFields, disclosureLevel);
}
```

## Benefits

1. **Separation of Concerns**: Domain models remain pure, while UI concerns are handled by adapters
2. **Progressive Disclosure**: UI complexity adapts to user needs and expertise levels
3. **Client Customization**: Client code can override any aspect of UI representation
4. **Reusable Patterns**: Common UI patterns are implemented once and reused across the application
5. **Consistent Interface**: Users experience consistent UI patterns regardless of the underlying entity type

## Integration with DDD

This architecture respects the principles of Domain-Driven Design by:

- Keeping domain models free of UI concerns
- Adapting domain concepts to UI without corrupting the model
- Allowing domain experts and UI designers to work independently
- Supporting rich domain models with complex visualization needs
- Enabling incremental improvement of both domain and UI layers

## Architecture Diagram

```
┌─────────────────┐     ┌───────────────────┐     ┌─────────────────┐
│  Domain Layer   │     │ Application Layer  │     │     UI Layer    │
│                 │     │                    │     │                 │
│  ┌───────────┐  │     │  ┌─────────────┐  │     │  ┌───────────┐  │
│  │           │  │     │  │             │  │     │  │           │  │
│  │  Entity   │◄─┼─────┼──┤  UXAdapter  │◄─┼─────┼──┤   Widget  │  │
│  │           │  │     │  │             │  │     │  │           │  │
│  └───────────┘  │     │  └─────────────┘  │     │  └───────────┘  │
│                 │     │                    │     │                 │
└─────────────────┘     └───────────────────┘     └─────────────────┘
                               │   ▲
                               │   │ 
                               ▼   │ 
                        ┌────────────────┐
                        │                │
                        │ UXAdapterRegistry │
                        │                │
                        └────────────────┘
                               │   ▲
                               │   │ 
                               ▼   │ 
┌─────────────────────────────────────────────────────────┐
│                                                         │
│                    Client Application                   │
│                                                         │
│  ┌───────────────┐    ┌────────────────┐    ┌───────┐  │
│  │Custom UXAdapter│    │DisclosureLevel │    │UI     │  │
│  │Implementation  │    │Configuration   │    │Themes │  │
│  └───────────────┘    └────────────────┘    └───────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
``` 