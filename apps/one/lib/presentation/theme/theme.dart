import 'package:flutter/material.dart';
import 'theme_constants.dart';

/// Theme definitions for the EDNet One application
///
/// This file organizes all theme definitions used throughout the application
/// into a structured, maintainable class hierarchy with static access methods.

/// Central class for accessing application themes
class AppTheme {
  /// Get the theme data for light mode with the specified style
  static ThemeData getLightTheme({String style = ThemeNames.cli}) {
    return _getThemeByStyle(style, false);
  }

  /// Get the theme data for dark mode with the specified style
  static ThemeData getDarkTheme({String style = ThemeNames.cli}) {
    return _getThemeByStyle(style, true);
  }

  /// Get theme by style name and dark mode flag
  static ThemeData _getThemeByStyle(String style, bool isDarkMode) {
    final themes = isDarkMode ? _darkThemes : _lightThemes;
    return themes[style] ?? (isDarkMode ? _cliDarkTheme : _cliLightTheme);
  }

  /// Default light theme for the application
  static ThemeData get lightTheme => _cliLightTheme;

  /// Default dark theme for the application
  static ThemeData get darkTheme => _cliDarkTheme;

  /// Maps of all style themes organized by mode
  static final Map<String, ThemeData> _lightThemes = {
    ThemeNames.cli: _cliLightTheme,
    ThemeNames.cheerful: _cheerfulLightTheme,
    ThemeNames.minimalistic: _minimalisticLightTheme,
  };

  static final Map<String, ThemeData> _darkThemes = {
    ThemeNames.cli: _cliDarkTheme,
    ThemeNames.cheerful: _cheerfulDarkTheme,
    ThemeNames.minimalistic: _minimalisticDarkTheme,
  };
}

/// Map of all available themes for the application
final Map<String, Map<String, ThemeData>> themes = {
  ThemeModes.light: {
    ThemeNames.cheerful: _cheerfulLightTheme,
    ThemeNames.minimalistic: _minimalisticLightTheme,
    ThemeNames.cli: _cliLightTheme,
  },
  ThemeModes.dark: {
    ThemeNames.cheerful: _cheerfulDarkTheme,
    ThemeNames.minimalistic: _minimalisticDarkTheme,
    ThemeNames.cli: _cliDarkTheme,
  },
};

//
// CLI themes
//

/// Dark CLI theme with terminal-like appearance
final ThemeData _cliDarkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: ThemeColors.darkPrimary,
    secondary: ThemeColors.darkSecondary,
    surface: ThemeColors.darkSurface,
    onSurface: ThemeColors.darkOnSurface,
    background: ThemeColors.darkBackground,
    onBackground: ThemeColors.darkOnBackground,
    error: ThemeColors.darkError,
    onError: ThemeColors.darkOnError,
  ),
  scaffoldBackgroundColor: ThemeColors.darkBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: ThemeColors.darkBackground,
    titleTextStyle: TextStyle(
      color: ThemeColors.darkPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: ThemeColors.darkPrimary),
    actionsIconTheme: IconThemeData(color: ThemeColors.darkPrimary),
    elevation: 0,
  ),
  textTheme: _buildCliTextTheme(ThemeColors.darkPrimary),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    labelStyle: TextStyle(color: ThemeColors.darkPrimary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ThemeColors.darkPrimary,
      foregroundColor: ThemeColors.darkBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: ThemeColors.darkPrimary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),
  iconTheme: IconThemeData(color: ThemeColors.darkPrimary),
  visualDensity: VisualDensity.compact,
  useMaterial3: true,
);

/// Light CLI theme with clean, minimal appearance
final ThemeData _cliLightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: ThemeColors.lightPrimary,
    secondary: ThemeColors.lightSecondary,
    surface: ThemeColors.lightSurface,
    onSurface: ThemeColors.lightOnSurface,
    background: ThemeColors.lightBackground,
    onBackground: ThemeColors.lightOnBackground,
    error: ThemeColors.lightError,
    onError: ThemeColors.lightOnError,
  ),
  scaffoldBackgroundColor: ThemeColors.lightBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: ThemeColors.lightBackground,
    titleTextStyle: TextStyle(
      color: ThemeColors.lightPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: ThemeColors.lightPrimary),
    actionsIconTheme: IconThemeData(color: ThemeColors.lightPrimary),
    elevation: 0,
  ),
  textTheme: _buildCliTextTheme(ThemeColors.lightPrimary),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    labelStyle: TextStyle(color: ThemeColors.lightPrimary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ThemeColors.lightPrimary,
      foregroundColor: ThemeColors.lightBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: ThemeColors.lightPrimary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),
  iconTheme: IconThemeData(color: ThemeColors.lightPrimary),
  visualDensity: VisualDensity.compact,
  useMaterial3: true,
);

//
// Cheerful themes
//

/// Cheerful dark theme with vibrant colors
final ThemeData _cheerfulDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.yellow,
    accentColor: ThemeColors.cheerfulDarkAccent,
    brightness: Brightness.dark,
    backgroundColor: ThemeColors.cheerfulDarkBackground,
  ).copyWith(surface: ThemeColors.cheerfulDarkBackground),
  scaffoldBackgroundColor: ThemeColors.cheerfulDarkBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.yellow[700],
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.black87),
    actionsIconTheme: IconThemeData(color: Colors.black87),
  ),
  textTheme: _buildTextTheme(Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.cheerfulDarkAccent),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange[700]!),
    ),
    labelStyle: TextStyle(color: ThemeColors.cheerfulDarkAccent),
  ),
);

/// Cheerful light theme with bright colors
final ThemeData _cheerfulLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: ThemeColors.cheerfulLightAccent,
    brightness: Brightness.light,
    backgroundColor: ThemeColors.lightBackground,
  ).copyWith(surface: ThemeColors.lightSurface),
  scaffoldBackgroundColor: ThemeColors.lightBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue[700],
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: _buildTextTheme(Colors.black),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue[700]!),
    ),
    labelStyle: TextStyle(color: Colors.blue),
  ),
);

//
// Minimalistic themes
//

/// Minimalistic dark theme with clean design
final ThemeData _minimalisticDarkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: ThemeColors.darkPrimary,
    secondary: ThemeColors.darkSecondary,
    surface: ThemeColors.darkSurface,
    onSurface: ThemeColors.darkOnSurface,
  ),
  scaffoldBackgroundColor: ThemeColors.darkBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: ThemeColors.darkBackground,
    titleTextStyle: TextStyle(
      color: ThemeColors.darkPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: ThemeColors.darkPrimary),
    actionsIconTheme: IconThemeData(color: ThemeColors.darkPrimary),
  ),
  textTheme: _buildMinimalisticTextTheme(ThemeColors.darkPrimary),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.darkPrimary),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.darkSecondary),
    ),
    labelStyle: TextStyle(color: ThemeColors.darkPrimary),
  ),
);

/// Minimalistic light theme with clean design
final ThemeData _minimalisticLightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: ThemeColors.lightPrimary,
    secondary: ThemeColors.lightSecondary,
    background: ThemeColors.lightBackground,
    surface: ThemeColors.lightSurface,
    onBackground: ThemeColors.lightOnBackground,
    onSurface: ThemeColors.lightOnSurface,
  ),
  scaffoldBackgroundColor: ThemeColors.lightBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: ThemeColors.lightBackground,
    titleTextStyle: TextStyle(
      color: ThemeColors.lightPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: ThemeColors.lightPrimary),
    actionsIconTheme: IconThemeData(color: ThemeColors.lightPrimary),
  ),
  textTheme: _buildMinimalisticTextTheme(ThemeColors.lightPrimary),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.lightPrimary),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.lightSecondary),
    ),
    labelStyle: TextStyle(color: ThemeColors.lightPrimary),
  ),
);

//
// TextTheme Builder Functions
//

/// Helper function to build CLI text theme
TextTheme _buildCliTextTheme(Color color) {
  return TextTheme(
    displayLarge: ThemeTextStyles.buildCliTextStyle(
      color,
      24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: ThemeTextStyles.buildCliTextStyle(
      color,
      22,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: ThemeTextStyles.buildCliTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: ThemeTextStyles.buildCliTextStyle(
      color,
      24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: ThemeTextStyles.buildCliTextStyle(
      color,
      22,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: ThemeTextStyles.buildCliTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: ThemeTextStyles.buildCliTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: ThemeTextStyles.buildCliTextStyle(
      color,
      18,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: ThemeTextStyles.buildCliTextStyle(
      color,
      16,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: ThemeTextStyles.buildCliTextStyle(color, 16),
    bodyMedium: ThemeTextStyles.buildCliTextStyle(color, 14),
    bodySmall: ThemeTextStyles.buildCliTextStyle(color, 12),
    labelLarge: ThemeTextStyles.buildCliTextStyle(color, 14),
    labelMedium: ThemeTextStyles.buildCliTextStyle(color, 12),
    labelSmall: ThemeTextStyles.buildCliTextStyle(color, 10),
  );
}

/// Helper function to build standard text theme
TextTheme _buildTextTheme(Color color) {
  return TextTheme(
    displayLarge: ThemeTextStyles.buildCliTextStyle(color, 24),
    displayMedium: ThemeTextStyles.buildCliTextStyle(color, 22),
    displaySmall: ThemeTextStyles.buildCliTextStyle(color, 20),
    headlineLarge: ThemeTextStyles.buildCliTextStyle(color, 24),
    headlineMedium: ThemeTextStyles.buildCliTextStyle(color, 22),
    headlineSmall: ThemeTextStyles.buildCliTextStyle(color, 20),
    titleLarge: ThemeTextStyles.buildCliTextStyle(color, 20),
    titleMedium: ThemeTextStyles.buildCliTextStyle(color, 18),
    titleSmall: ThemeTextStyles.buildCliTextStyle(color, 16),
    bodyLarge: ThemeTextStyles.buildCliTextStyle(color, 16),
    bodyMedium: ThemeTextStyles.buildCliTextStyle(color, 14),
    bodySmall: ThemeTextStyles.buildCliTextStyle(color, 12),
    labelLarge: ThemeTextStyles.buildCliTextStyle(color, 14),
    labelMedium: ThemeTextStyles.buildCliTextStyle(color, 12),
    labelSmall: ThemeTextStyles.buildCliTextStyle(color, 10),
  );
}

/// Helper function to build minimalistic text theme
TextTheme _buildMinimalisticTextTheme(Color color) {
  return TextTheme(
    displayLarge: ThemeTextStyles.buildCliTextStyle(color, 24),
    displayMedium: ThemeTextStyles.buildCliTextStyle(color, 22),
    displaySmall: ThemeTextStyles.buildCliTextStyle(color, 20),
    headlineLarge: ThemeTextStyles.buildCliTextStyle(color, 24),
    headlineMedium: ThemeTextStyles.buildCliTextStyle(color, 22),
    headlineSmall: ThemeTextStyles.buildCliTextStyle(color, 20),
    titleLarge: ThemeTextStyles.buildCliTextStyle(color, 20),
    titleMedium: ThemeTextStyles.buildCliTextStyle(color, 18),
    titleSmall: ThemeTextStyles.buildCliTextStyle(color, 16),
    bodyLarge: ThemeTextStyles.buildCliTextStyle(color, 16),
    bodyMedium: ThemeTextStyles.buildCliTextStyle(color, 14),
    bodySmall: ThemeTextStyles.buildCliTextStyle(color, 12),
    labelLarge: ThemeTextStyles.buildCliTextStyle(color, 14),
    labelMedium: ThemeTextStyles.buildCliTextStyle(color, 12),
    labelSmall: ThemeTextStyles.buildCliTextStyle(color, 10),
  );
}
