# EDNet Shell Architecture Theme System

The EDNet Shell Architecture Theme System provides a powerful and flexible theming solution for Flutter applications that are built on the EDNet Core framework. It is designed to support progressive disclosure UI patterns and provide semantic styling based on domain model concepts.

## Key Features

### Progressive Disclosure

The theme system is built around the concept of progressive disclosure - showing different levels of UI complexity based on user needs:

- Different theme styles and densities for each disclosure level
- Automatic adjustment of colors, typography, and spacing
- Eight disclosure levels: minimal, basic, standard, intermediate, advanced, detailed, complete, and debug

### Semantic Styling

Domain concepts are styled according to their semantic meaning:

- Entities, concepts, attributes, and relationships each have distinct visual treatments
- Colors, typography, and decorations reflect the domain model semantics
- Consistent styling across the application based on domain concepts

### Theme Components

The system includes multiple theme components:

- **CheerfulThemeComponent**: A vibrant, colorful theme with strong visual hierarchy
- **CLIThemeComponent**: A monospace-focused theme inspired by terminal interfaces
- **MinimalisticThemeComponent**: A clean, minimal theme with reduced visual noise

### Extensibility

The architecture provides extension points at multiple levels:

- **ThemeExtensions**: Add custom theme data through Flutter's ThemeExtension system
- **DisclosureLevelThemeExtension**: Customize appearance per disclosure level
- **SemanticColorsExtension**: Define colors for domain concepts

## Usage

### Accessing Theme Properties

```dart
// Get spacing based on disclosure level
final padding = context.disclosureLevelSpacing(DisclosureLevel.standard);

// Get styling for a domain concept
final entityStyle = context.conceptTextStyle('entity');
final entityColor = context.conceptColor('entity');

// Get decoration for a semantic concept
final decoration = context.conceptDecoration('model', level: DisclosureLevel.detailed);
```

### Working with Disclosure Levels

```dart
// Adjust UI based on disclosure level
Widget build(BuildContext context, DisclosureLevel level) {
  return Container(
    padding: context.disclosureLevelCardPadding(level),
    decoration: context.conceptDecoration('entity', level: level),
    child: Text(
      'Entity Name',
      style: context.conceptTextStyle('entity', 
          role: 'title', level: level),
    ),
  );
}
```

### Theme Customization

```dart
// Apply a theme with disclosure level support
final themeWithDisclosureLevel = context.getThemeForDisclosureLevel(
    DisclosureLevel.advanced);

// Use it with Theme widget
return Theme(
  data: themeWithDisclosureLevel,
  child: YourWidget(),
);
```

## Architecture Integration

The theme system integrates with other Shell Architecture components:

- **UX Adapters**: Theme extensions provide styling for adapters
- **Configuration Injection**: Themes can be configured through the injection system
- **Message Channels**: Theme changes propagate through the UX message system

## Future Enhancements

Planned enhancements for the theme system include:

- More built-in theme styles
- YAML-based theme configuration
- User-customizable themes with persistence
- Animation transitions between disclosure levels 