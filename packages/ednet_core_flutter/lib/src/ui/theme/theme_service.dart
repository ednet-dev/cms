part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Service for managing application themes within the Shell Architecture
///
/// This service integrates with the Configuration Injector pattern
/// to provide theme management capabilities that respect the Shell Architecture's
/// separation of concerns and progressive disclosure principles.
class ThemeService {
  static const String _themeKey = 'shell_theme_mode';
  static const String _themeStyleKey = 'shell_theme_style';
  static const String _themeLightValue = 'light';
  static const String _themeDarkValue = 'dark';
  static const String _themeSystemValue = 'system';
  static const String _themeAccessibilityKey = 'shell_theme_accessibility';
  static const String _themeDisclosureLevelKey = 'shell_disclosure_level';

  /// Current theme mode
  ThemeMode _currentThemeMode = ThemeMode.system;

  /// Current theme style name
  String _currentThemeStyle = ThemeNames.minimalistic;

  /// Current accessibility settings
  final Map<AccessibilityFeature, bool> _accessibilityFeatures = {
    AccessibilityFeature.highContrast: false,
    AccessibilityFeature.largeText: false,
    AccessibilityFeature.reducedMotion: false,
  };

  /// Current disclosure level for progressive UI
  DisclosureLevel _disclosureLevel = DisclosureLevel.standard;

  /// Theme change listeners
  final List<void Function()> _listeners = [];

  /// Configuration Injector reference
  ConfigurationInjector? _injector;

  /// Get the current theme mode
  ThemeMode get currentThemeMode => _currentThemeMode;

  /// Get the current theme style name
  String get currentThemeStyle => _currentThemeStyle;

  /// Get the current disclosure level
  DisclosureLevel get disclosureLevel => _disclosureLevel;

  /// Get the light theme data for the current style
  ThemeData get lightTheme => _getThemeWithAccessibility(
        ShellTheme.getLightTheme(style: _currentThemeStyle),
      );

  /// Get the dark theme data for the current style
  ThemeData get darkTheme => _getThemeWithAccessibility(
        ShellTheme.getDarkTheme(style: _currentThemeStyle),
      );

  /// Get the current theme with accessibility features and disclosure level applied
  ThemeData getCurrentTheme(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = _currentThemeMode == ThemeMode.dark ||
        (_currentThemeMode == ThemeMode.system &&
            brightness == Brightness.dark);

    final baseTheme = isDark ? darkTheme : lightTheme;
    return ShellTheme.withDisclosureLevel(baseTheme, _disclosureLevel);
  }

  /// Apply accessibility features to a theme
  ThemeData _getThemeWithAccessibility(ThemeData theme) {
    var result = theme;

    if (_accessibilityFeatures[AccessibilityFeature.highContrast] == true) {
      result = result.withHighContrast();
    }

    if (_accessibilityFeatures[AccessibilityFeature.largeText] == true) {
      result = result.withLargeText();
    }

    if (_accessibilityFeatures[AccessibilityFeature.reducedMotion] == true) {
      result = result.withReducedMotion();
    }

    return result;
  }

  /// Set the Configuration Injector reference
  void setInjector(ConfigurationInjector injector) {
    _injector = injector;
    _applyThemeConfiguration();
  }

  /// Initialize the theme service by loading the saved theme preferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final savedThemeMode = prefs.getString(_themeKey);
    if (savedThemeMode == _themeLightValue) {
      _currentThemeMode = ThemeMode.light;
    } else if (savedThemeMode == _themeDarkValue) {
      _currentThemeMode = ThemeMode.dark;
    } else {
      _currentThemeMode = ThemeMode.system;
    }

    // Load theme style
    final savedThemeStyle = prefs.getString(_themeStyleKey);
    if (savedThemeStyle != null) {
      _currentThemeStyle = savedThemeStyle;
    }

    // Load accessibility features
    final savedAccessibility = prefs.getString(_themeAccessibilityKey);
    if (savedAccessibility != null) {
      try {
        final features =
            Map<String, dynamic>.from(json.decode(savedAccessibility));

        for (final feature in AccessibilityFeature.values) {
          if (features.containsKey(feature.name)) {
            _accessibilityFeatures[feature] = features[feature.name] as bool;
          }
        }
      } catch (e) {
        // If there's an error parsing, just use defaults
      }
    }

    // Load disclosure level
    final savedDisclosureLevel = prefs.getString(_themeDisclosureLevelKey);
    if (savedDisclosureLevel != null) {
      try {
        _disclosureLevel = DisclosureLevel.values.firstWhere(
          (level) => level.name == savedDisclosureLevel,
          orElse: () => DisclosureLevel.standard,
        );
      } catch (e) {
        // If there's an error parsing, just use standard level
      }
    }

    // Apply loaded configuration to injector if available
    if (_injector != null) {
      _applyThemeConfiguration();
    }
  }

  /// Set the theme mode and save the preference
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_currentThemeMode == mode) return;

    _currentThemeMode = mode;
    _notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.light) {
      await prefs.setString(_themeKey, _themeLightValue);
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(_themeKey, _themeDarkValue);
    } else {
      await prefs.setString(_themeKey, _themeSystemValue);
    }

    _applyThemeConfiguration();
  }

  /// Set the theme style and save the preference
  Future<void> setThemeStyle(String styleName) async {
    if (_currentThemeStyle == styleName) return;

    if (ShellTheme._lightThemes.containsKey(styleName)) {
      _currentThemeStyle = styleName;
      _notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeStyleKey, styleName);

      _applyThemeConfiguration();
    }
  }

  /// Set accessibility feature
  Future<void> setAccessibilityFeature(
    AccessibilityFeature feature,
    bool enabled,
  ) async {
    if (_accessibilityFeatures[feature] == enabled) return;

    _accessibilityFeatures[feature] = enabled;
    _notifyListeners();

    await _saveAccessibilityFeatures();
    _applyThemeConfiguration();
  }

  /// Save accessibility features to preferences
  Future<void> _saveAccessibilityFeatures() async {
    final prefs = await SharedPreferences.getInstance();

    final featureMap = <String, bool>{};
    for (final entry in _accessibilityFeatures.entries) {
      featureMap[entry.key.name] = entry.value;
    }

    await prefs.setString(_themeAccessibilityKey, json.encode(featureMap));
  }

  /// Set disclosure level and save the preference
  Future<void> setDisclosureLevel(DisclosureLevel level) async {
    if (_disclosureLevel == level) return;

    _disclosureLevel = level;
    _notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeDisclosureLevelKey, level.name);

    _applyThemeConfiguration();
  }

  /// Apply the current theme configuration to the injector
  void _applyThemeConfiguration() {
    if (_injector == null) return;

    // Create a theme configuration based on current settings
    final themeConfig = ThemeConfiguration(
      themeName: _currentThemeStyle,
      themeMode: _currentThemeMode == ThemeMode.dark
          ? ThemeModes.dark
          : (_currentThemeMode == ThemeMode.light
              ? ThemeModes.light
              : ThemeModes.system),
    );

    // Create a UX configuration with accessibility and disclosure level
    final uxConfig = UXConfiguration(
      name: 'Theme and Accessibility',
      defaultDisclosureLevel: _disclosureLevel,
    );

    // Register configurations with the injector
    _injector!.registerConfiguration(
      GenericConfiguration(
        name: 'Theme Configuration',
        settings: {'theme': themeConfig.toMap()},
      ),
      ConfigurationType.ux,
    );

    _injector!.registerConfiguration(uxConfig, ConfigurationType.ux);
  }

  /// Toggle between light and dark theme modes
  Future<void> toggleThemeMode() async {
    if (_currentThemeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Returns a theme based on the provided style name and dark mode flag
  ThemeData getThemeByName(String name, bool isDarkMode) {
    final baseTheme = isDarkMode
        ? ShellTheme.getDarkTheme(style: name)
        : ShellTheme.getLightTheme(style: name);

    return _getThemeWithAccessibility(baseTheme);
  }

  /// Returns a list of available theme style names
  List<String> getAvailableThemeStyles() {
    return ShellTheme._lightThemes.keys.toList();
  }

  /// Add a listener to be notified of theme changes
  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  /// Remove a previously added listener
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  /// Notify listeners of a theme change
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Get a theme configuration based on current settings
  ThemeConfiguration getCurrentThemeConfiguration() {
    return ThemeConfiguration(
      themeName: _currentThemeStyle,
      themeMode: _currentThemeMode == ThemeMode.dark
          ? ThemeModes.dark
          : (_currentThemeMode == ThemeMode.light
              ? ThemeModes.light
              : ThemeModes.system),
    );
  }
}

/// Accessibility features supported by the theme service
enum AccessibilityFeature {
  /// High contrast mode for better visibility
  highContrast,

  /// Large text mode for better readability
  largeText,

  /// Reduced motion for users sensitive to animations
  reducedMotion,
}
