# Theme Migration Plan

This document outlines the detailed migration plan for theme components from `ednet_one` to the `ednet_core_flutter` Shell Architecture.

## Completed Components

- ✅ `presentation/theme/theme_constants.dart` → `src/ui/theme/theme_constants.dart`
- ✅ `presentation/theme/text_styles.dart` → `src/ui/theme/text_styles.dart` 
- ✅ `presentation/theme/theme.dart` → `src/ui/theme/theme.dart`
- ✅ `presentation/theme/theme_service.dart` → `src/ui/theme/theme_service.dart`
- ✅ `presentation/theme/theme_components/theme_component.dart` → `src/ui/theme/components/theme_component.dart`
- ✅ `presentation/theme/extensions/theme_extensions.dart` → `src/ui/theme/extensions/theme_extensions.dart`
- ✅ `presentation/theme/extensions/theme_spacing.dart` → `src/ui/theme/extensions/theme_spacing.dart`
- ✅ `presentation/theme/extensions/disclosure_level_theme_extension.dart` → New extension created for Shell Architecture
- ✅ `presentation/theme/extensions/semantic_colors_extension.dart` → New extension created for Shell Architecture

## In Progress Components

- 🔄 `presentation/theme/theme_components/cheerful_theme_component.dart` → `src/ui/theme/components/cheerful_theme_component.dart`

## Pending Components

- ⌛ `presentation/theme/theme_components/cli_theme_component.dart` → `src/ui/theme/components/cli_theme_component.dart`
- ⌛ `presentation/theme/theme_components/minimalistic_theme_component.dart` → `src/ui/theme/components/minimalistic_theme_component.dart`
- ⌛ `presentation/theme/theme_components/custom_colors.dart` → `src/ui/theme/components/custom_colors.dart`
- ⌛ `presentation/theme/theme_components/list_item_card.dart` → `src/ui/theme/components/list_item_card.dart`
- ⌛ `presentation/theme/strategy/theme_strategy.dart` → `src/ui/theme/strategy/theme_strategy.dart`
- ⌛ `presentation/theme/strategy/standard_theme_strategy.dart` → `src/ui/theme/strategy/standard_theme_strategy.dart`
- ⌛ `presentation/theme/providers/theme_provider.dart` → `src/ui/theme/providers/theme_provider.dart`

## Implementation Tasks

### Fixed Issues

- ✅ Added required imports and part directives to barrel file
- ✅ Created theme spacing extensions with disclosure level support
- ✅ Created theme context extensions with semantic concept awareness
- ✅ Created disclosure level theme extension
- ✅ Created semantic colors extension
- ✅ Fixed linting errors in theme extensions

### Remaining Issues

1. **Fix linting issues in CheerfulThemeComponent**:
   - WidgetStateProperty vs MaterialStateProperty migration
   - withValues vs withOpacity method usage
   - Ensure integration with the disclosure level system

### Next Steps

1. **Complete CheerfulThemeComponent migration**:
   - Fix all linting errors
   - Ensure proper integration with disclosure level
   - Test with sample Flutter app

2. **Implement remaining theme components**:
   - CLI Theme Component
   - Minimalistic Theme Component 
   - Custom Colors utility
   - ListItemCard component

3. **Implement theme strategy**:
   - Migrate theme strategy interface
   - Implement standard theme strategy
   - Connect with the Shell Architecture's concept of UX Adapters

4. **Implement theme provider**:
   - Create a theme provider that integrates with the Shell Architecture
   - Connect with the Configuration Injector system
   - Implement UX Channel for theme changes

## Architecture Integration Points

The migrated theme system needs to properly integrate with the following Shell Architecture components:

1. **Progressive Disclosure System**:
   - Theme components must adapt based on disclosure level
   - Colors, typography, and spacing should scale with disclosure level

2. **Configuration Injection**:
   - Theme configuration should be injectable via the Configuration system
   - Support for YAML-defined theme customizations

3. **UX Adaptation**:
   - Theme should support adaptations for different semantic concepts
   - Provide ways to customize appearance of domain entities

4. **Message-based Architecture**:
   - Theme changes should propagate through the UX Channel system
   - Components should react to theme change messages

## Testing Strategy

1. **Component Tests**:
   - Test each theme component in isolation
   - Verify color schemes and styles are applied correctly

2. **Integration Tests**:
   - Test theme integration with Shell components
   - Verify disclosure level changes affect theme appearance
   - Test theme switching functionality

3. **Visual Regression Tests**:
   - Capture screenshots of UI with different themes
   - Compare with baseline screenshots to detect unexpected changes 