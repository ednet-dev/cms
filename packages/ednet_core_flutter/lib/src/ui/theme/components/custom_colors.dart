part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Custom colors extension for the theme system
///
/// This class adds domain-specific colors to the standard ColorScheme
/// for use throughout the application, supporting the Shell Architecture's
/// semantic color system.
extension CustomColors on ColorScheme {
  /// Color for domain-related elements
  Color get domainColor => brightness == Brightness.light
      ? const Color(0xFF3F51B5) // Indigo
      : const Color(0xFF9FA8DA); // Light indigo

  /// Color for model-related elements
  Color get modelColor => brightness == Brightness.light
      ? const Color(0xFF009688) // Teal
      : const Color(0xFF80CBC4); // Light teal

  /// Color for concept-related elements
  Color get conceptColor => brightness == Brightness.light
      ? const Color(0xFFFF5722) // Deep orange
      : const Color(0xFFFFAB91); // Light deep orange

  /// Color for entity-related elements
  Color get entityColor => brightness == Brightness.light
      ? const Color(0xFF673AB7) // Deep purple
      : const Color(0xFFB39DDB); // Light deep purple

  /// Color for attribute-related elements
  Color get attributeColor => brightness == Brightness.light
      ? const Color(0xFF4CAF50) // Green
      : const Color(0xFF81C784); // Light green

  /// Color for relationship-related elements
  Color get relationshipColor => brightness == Brightness.light
      ? const Color(0xFF2196F3) // Blue
      : const Color(0xFF90CAF9); // Light blue

  /// Success color (beyond what's in the standard colorScheme)
  Color get success => brightness == Brightness.light
      ? const Color(0xFF4CAF50) // Green
      : const Color(0xFF81C784); // Light green

  /// Neutral color for info messages
  Color get neutral => brightness == Brightness.light
      ? const Color(0xFF607D8B) // Blue grey
      : const Color(0xFF90A4AE); // Light blue grey

  /// Background color for cards in the dashboard
  Color get cardBackground =>
      brightness == Brightness.light ? Colors.white : const Color(0xFF2D2D2D);

  /// Border color for cards and sections
  Color get borderColor =>
      brightness == Brightness.light ? Colors.black12 : Colors.white12;

  /// Color for highlighting items on hover
  Color get hoverHighlight => brightness == Brightness.light
      ? Colors.black.withOpacity(0.05)
      : Colors.white.withOpacity(0.1);

  /// Background color for selected items
  Color get selectedBackground => brightness == Brightness.light
      ? primary.withOpacity(0.1)
      : primary.withOpacity(0.2);

  /// Text color for code blocks or terminal output
  Color get codeText => brightness == Brightness.light
      ? const Color(0xFF212121)
      : const Color(0xFFE0E0E0);

  /// Background color for code blocks or terminal output
  Color get codeBackground => brightness == Brightness.light
      ? const Color(0xFFF5F5F5)
      : const Color(0xFF1E1E1E);

  /// Color for disclosure level indicator based on the current level
  Color getDisclosureLevelColor(DisclosureLevel level) =>
      ThemeColors.getDisclosureLevelColor(level).withOpacity(
        brightness == Brightness.light ? 0.8 : 1.0,
      );
}
