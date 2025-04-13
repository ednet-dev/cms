part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Theme provider for EDNet Core Flutter Shell Architecture
///
/// This file organizes all theme definitions and provides a structured
/// approach to theme management with disclosure level awareness and
/// integration with the Configuration Injector.

/// Central class for accessing and managing application themes with Shell Architecture integration
class ShellTheme {
  /// Get the theme data for light mode with the specified style
  static ThemeData getLightTheme({
    String style = ThemeNames.minimalistic,
    ThemeConfiguration? configuration,
  }) {
    return _getThemeByStyle(style, false, configuration);
  }

  /// Get the theme data for dark mode with the specified style
  static ThemeData getDarkTheme({
    String style = ThemeNames.minimalistic,
    ThemeConfiguration? configuration,
  }) {
    return _getThemeByStyle(style, true, configuration);
  }

  /// Get theme by style name and dark mode flag with configuration overrides
  static ThemeData _getThemeByStyle(
    String style,
    bool isDarkMode,
    ThemeConfiguration? configuration,
  ) {
    final effectiveStyle = configuration?.themeName ?? style;
    final themes = isDarkMode ? _darkThemes : _lightThemes;

    // Create base theme
    var baseTheme = themes[effectiveStyle] ??
        (isDarkMode ? _minimalisticDarkTheme : _minimalisticLightTheme);

    // Apply custom colors from configuration if available
    if (configuration?.customColors != null) {
      baseTheme = _applyCustomColors(baseTheme, configuration!.customColors!);
    }

    return baseTheme;
  }

  /// Apply custom colors from configuration
  static ThemeData _applyCustomColors(
    ThemeData theme,
    Map<String, dynamic> customColors,
  ) {
    // Create a new colorScheme with custom colors
    var colorScheme = theme.colorScheme;

    if (customColors.containsKey('primary')) {
      final primaryColor = Color(customColors['primary']);
      colorScheme = colorScheme.copyWith(primary: primaryColor);
    }

    if (customColors.containsKey('secondary')) {
      final secondaryColor = Color(customColors['secondary']);
      colorScheme = colorScheme.copyWith(secondary: secondaryColor);
    }

    // Return updated theme
    return theme.copyWith(colorScheme: colorScheme);
  }

  /// Default light theme for the application
  static ThemeData get defaultLightTheme => _minimalisticLightTheme;

  /// Default dark theme for the application
  static ThemeData get defaultDarkTheme => _minimalisticDarkTheme;

  /// Maps of all style themes organized by mode
  static final Map<String, ThemeData> _lightThemes = {
    ThemeNames.cli: _cliLightTheme,
    ThemeNames.cheerful: _cheerfulLightTheme,
    ThemeNames.minimalistic: _minimalisticLightTheme,
    ThemeNames.corporate: _corporateLightTheme,
    ThemeNames.creative: _creativeLightTheme,
  };

  static final Map<String, ThemeData> _darkThemes = {
    ThemeNames.cli: _cliDarkTheme,
    ThemeNames.cheerful: _cheerfulDarkTheme,
    ThemeNames.minimalistic: _minimalisticDarkTheme,
    ThemeNames.corporate: _corporateDarkTheme,
    ThemeNames.creative: _creativeDarkTheme,
  };

  /// Creates a theme based on the current disclosure level
  static ThemeData withDisclosureLevel(
    ThemeData baseTheme,
    DisclosureLevel level,
  ) {
    // Adjust visual density based on disclosure level
    VisualDensity density;
    switch (level) {
      case DisclosureLevel.minimal:
      case DisclosureLevel.basic:
        density = VisualDensity.compact;
        break;
      case DisclosureLevel.standard:
      case DisclosureLevel.intermediate:
        density = VisualDensity.standard;
        break;
      case DisclosureLevel.advanced:
      case DisclosureLevel.detailed:
      case DisclosureLevel.complete:
      case DisclosureLevel.debug:
        density = VisualDensity.comfortable;
        break;
    }

    // Return updated theme with appropriate visual density
    return baseTheme.copyWith(
      visualDensity: density,
      primaryColor: ThemeColors.getDisclosureLevelColor(level),
    );
  }

  /// Get a theme data object from a theme configuration
  static ThemeData fromConfiguration(ThemeConfiguration configuration) {
    final isDarkMode = configuration.themeMode == ThemeModes.dark;
    return _getThemeByStyle(configuration.themeName, isDarkMode, configuration);
  }
}

//
// CLI themes
//

/// Dark CLI theme with terminal-like appearance
final ThemeData _cliDarkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: ThemeColors.darkPrimary,
    secondary: ThemeColors.darkSecondary,
    surface: ThemeColors.darkSurface,
    onSurface: ThemeColors.darkOnSurface,
    error: ThemeColors.darkError,
    onError: ThemeColors.darkOnError,
  ),
  scaffoldBackgroundColor: ThemeColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeColors.darkBackground,
    foregroundColor: ThemeColors.darkPrimary,
    elevation: 0,
  ),
  textTheme: _buildCliTextTheme(ThemeColors.darkPrimary),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    labelStyle: TextStyle(color: ThemeColors.darkPrimary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ThemeColors.darkPrimary,
      foregroundColor: ThemeColors.darkBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
    ),
  ),
  iconTheme: const IconThemeData(color: ThemeColors.darkPrimary),
  visualDensity: VisualDensity.compact,
  useMaterial3: true,
);

/// Light CLI theme with clean, minimal appearance
final ThemeData _cliLightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: ThemeColors.lightPrimary,
    secondary: ThemeColors.lightSecondary,
    surface: ThemeColors.lightSurface,
    onSurface: ThemeColors.lightOnSurface,
    error: ThemeColors.lightError,
    onError: ThemeColors.lightOnError,
  ),
  scaffoldBackgroundColor: ThemeColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeColors.lightBackground,
    foregroundColor: ThemeColors.lightPrimary,
    elevation: 0,
  ),
  textTheme: _buildCliTextTheme(ThemeColors.lightPrimary),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    labelStyle: TextStyle(color: ThemeColors.lightPrimary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ThemeColors.lightPrimary,
      foregroundColor: ThemeColors.lightBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
    ),
  ),
  iconTheme: const IconThemeData(color: ThemeColors.lightPrimary),
  visualDensity: VisualDensity.compact,
  useMaterial3: true,
);

//
// Cheerful themes
//

/// Cheerful dark theme with vibrant colors
final ThemeData _cheerfulDarkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.yellow,
    secondary: ThemeColors.cheerfulDarkAccent,
    surface: ThemeColors.cheerfulDarkBackground,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: ThemeColors.cheerfulDarkBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.yellow[700],
    foregroundColor: Colors.black87,
    elevation: 4,
  ),
  textTheme: _buildStandardTextTheme(Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.cheerfulDarkAccent),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange[700]!),
    ),
    labelStyle: TextStyle(color: ThemeColors.cheerfulDarkAccent),
  ),
  useMaterial3: true,
);

/// Cheerful light theme with bright colors
final ThemeData _cheerfulLightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.blue,
    secondary: ThemeColors.cheerfulLightAccent,
    surface: ThemeColors.lightSurface,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: ThemeColors.lightBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue[700],
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  textTheme: _buildStandardTextTheme(Colors.black),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue[700]!),
    ),
    labelStyle: const TextStyle(color: Colors.blue),
  ),
  useMaterial3: true,
);

//
// Minimalistic themes
//

/// Minimalistic dark theme with clean design
final ThemeData _minimalisticDarkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: ThemeColors.darkPrimary,
    secondary: ThemeColors.darkSecondary,
    surface: ThemeColors.darkSurface,
    onSurface: ThemeColors.darkOnSurface,
  ),
  scaffoldBackgroundColor: ThemeColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeColors.darkBackground,
    foregroundColor: ThemeColors.darkPrimary,
    elevation: 0,
  ),
  textTheme: _buildMinimalisticTextTheme(ThemeColors.darkPrimary),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.darkPrimary),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.darkSecondary),
    ),
    labelStyle: TextStyle(color: ThemeColors.darkPrimary),
  ),
  useMaterial3: true,
);

/// Minimalistic light theme with clean design
final ThemeData _minimalisticLightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: ThemeColors.lightPrimary,
    secondary: ThemeColors.lightSecondary,
    surface: ThemeColors.lightSurface,
    onSurface: ThemeColors.lightOnSurface,
  ),
  scaffoldBackgroundColor: ThemeColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeColors.lightBackground,
    foregroundColor: ThemeColors.lightPrimary,
    elevation: 0,
  ),
  textTheme: _buildMinimalisticTextTheme(ThemeColors.lightPrimary),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.lightPrimary),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.lightSecondary),
    ),
    labelStyle: TextStyle(color: ThemeColors.lightPrimary),
  ),
  useMaterial3: true,
);

//
// Corporate themes
//

/// Corporate dark theme for professional applications
final ThemeData _corporateDarkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF2196F3),
    secondary: Color(0xFF64B5F6),
    surface: Color(0xFF212121),
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1976D2),
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  textTheme: _buildStandardTextTheme(Colors.white),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2196F3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF64B5F6), width: 2.0),
    ),
    labelStyle: TextStyle(color: Color(0xFF2196F3)),
  ),
  useMaterial3: true,
);

/// Corporate light theme for professional applications
final ThemeData _corporateLightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2196F3),
    secondary: Color(0xFF64B5F6),
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1976D2),
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  textTheme: _buildStandardTextTheme(Colors.black),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2196F3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF1976D2), width: 2.0),
    ),
    labelStyle: TextStyle(color: Color(0xFF2196F3)),
  ),
  useMaterial3: true,
);

//
// Creative themes
//

/// Creative dark theme for designers and creative applications
final ThemeData _creativeDarkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFF4081),
    secondary: Color(0xFFFF80AB),
    surface: Color(0xFF212121),
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Color(0xFFFF4081),
    elevation: 0,
  ),
  textTheme: _buildTextTheme(Colors.white, 'creative'),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color(0xFFFF4081)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color(0xFFFF80AB), width: 2.0),
    ),
    labelStyle: TextStyle(color: Color(0xFFFF4081)),
  ),
  useMaterial3: true,
);

/// Creative light theme for designers and creative applications
final ThemeData _creativeLightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFF4081),
    secondary: Color(0xFFFF80AB),
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFFFF4081),
    elevation: 0,
  ),
  textTheme: _buildTextTheme(Colors.black, 'creative'),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color(0xFFFF4081)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color(0xFFFF80AB), width: 2.0),
    ),
    labelStyle: TextStyle(color: Color(0xFFFF4081)),
  ),
  useMaterial3: true,
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
TextTheme _buildStandardTextTheme(Color color) {
  return TextTheme(
    displayLarge: ThemeTextStyles.buildStandardTextStyle(
      color,
      24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: ThemeTextStyles.buildStandardTextStyle(
      color,
      22,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: ThemeTextStyles.buildStandardTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: ThemeTextStyles.buildStandardTextStyle(
      color,
      24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: ThemeTextStyles.buildStandardTextStyle(
      color,
      22,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: ThemeTextStyles.buildStandardTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: ThemeTextStyles.buildStandardTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: ThemeTextStyles.buildStandardTextStyle(
      color,
      18,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: ThemeTextStyles.buildStandardTextStyle(
      color,
      16,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: ThemeTextStyles.buildStandardTextStyle(color, 16),
    bodyMedium: ThemeTextStyles.buildStandardTextStyle(color, 14),
    bodySmall: ThemeTextStyles.buildStandardTextStyle(color, 12),
    labelLarge: ThemeTextStyles.buildStandardTextStyle(color, 14),
    labelMedium: ThemeTextStyles.buildStandardTextStyle(color, 12),
    labelSmall: ThemeTextStyles.buildStandardTextStyle(color, 10),
  );
}

/// Helper function to build minimalistic text theme
TextTheme _buildMinimalisticTextTheme(Color color) {
  return TextTheme(
    displayLarge: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      24,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      22,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      22,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      20,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      18,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: ThemeTextStyles.buildMinimalisticTextStyle(
      color,
      16,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: ThemeTextStyles.buildMinimalisticTextStyle(color, 16),
    bodyMedium: ThemeTextStyles.buildMinimalisticTextStyle(color, 14),
    bodySmall: ThemeTextStyles.buildMinimalisticTextStyle(color, 12),
    labelLarge: ThemeTextStyles.buildMinimalisticTextStyle(color, 14),
    labelMedium: ThemeTextStyles.buildMinimalisticTextStyle(color, 12),
    labelSmall: ThemeTextStyles.buildMinimalisticTextStyle(color, 10),
  );
}

/// Helper function to build theme-specific text theme
TextTheme _buildTextTheme(Color color, String themeName) {
  switch (themeName) {
    case 'creative':
      return TextTheme(
        displayLarge: TextStyle(
          color: color,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        displayMedium: TextStyle(
          color: color,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        displaySmall: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          color: color,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          color: color,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        titleSmall: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        bodyLarge: TextStyle(
          color: color,
          fontSize: 16,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        bodyMedium: TextStyle(
          color: color,
          fontSize: 14,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        bodySmall: TextStyle(
          color: color,
          fontSize: 12,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        labelLarge: TextStyle(
          color: color,
          fontSize: 14,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        labelMedium: TextStyle(
          color: color,
          fontSize: 12,
          letterSpacing: 0.3,
          height: 1.3,
        ),
        labelSmall: TextStyle(
          color: color,
          fontSize: 10,
          letterSpacing: 0.3,
          height: 1.3,
        ),
      );
    default:
      return _buildStandardTextTheme(color);
  }
}

/// Extension methods for Theme to support accessibility features
extension ThemeAccessibility on ThemeData {
  /// Creates a theme with increased contrast for better visibility
  ThemeData withHighContrast() {
    final colorScheme = this.colorScheme;

    // Create a high contrast color scheme
    final highContrastColorScheme = colorScheme.copyWith(
      primary: colorScheme.primary.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white,
      onPrimary: colorScheme.primary.computeLuminance() > 0.5
          ? Colors.white
          : Colors.black,
      surface: colorScheme.surface.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white,
      onSurface: colorScheme.surface.computeLuminance() > 0.5
          ? Colors.white
          : Colors.black,
    );

    return copyWith(
      colorScheme: highContrastColorScheme,
      textTheme: textTheme.apply(
        bodyColor: highContrastColorScheme.onSurface,
        displayColor: highContrastColorScheme.onSurface,
      ),
    );
  }

  /// Creates a theme with larger text for improved readability
  ThemeData withLargeText() {
    return copyWith(
      textTheme: textTheme.apply(
        fontSizeFactor: 1.25,
        fontSizeDelta: 2.0,
      ),
    );
  }

  /// Creates a theme with reduced motion for users with motion sensitivity
  ThemeData withReducedMotion() {
    return copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
