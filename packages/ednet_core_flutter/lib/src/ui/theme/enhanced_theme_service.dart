part of ednet_core_flutter;

/// Enhanced theme service that manages themes, theme switching, and accessibility
class EnhancedThemeService extends ChangeNotifier {
  /// Light theme data
  final ThemeData lightTheme;

  /// Dark theme data
  final ThemeData darkTheme;

  /// Current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  /// Current theme style (visual design style)
  String _themeStyle = 'default';

  /// Disclosure level for UI components
  DisclosureLevel _disclosureLevel = DisclosureLevel.standard;

  /// Accessibility features enabled
  final Map<String, bool> _accessibilityFeatures = {
    'highContrast': false,
    'largeText': false,
    'reduceMotion': false,
  };

  /// Shared preferences keys
  static const String _themeModeKey = 'ednet_theme_mode';
  static const String _themeStyleKey = 'ednet_theme_style';
  static const String _disclosureLevelKey = 'ednet_disclosure_level';
  static const String _accessibilityKey = 'ednet_accessibility';

  /// Constructor
  EnhancedThemeService({
    required this.lightTheme,
    required this.darkTheme,
    ThemeMode initialThemeMode = ThemeMode.system,
    String initialStyle = 'default',
    DisclosureLevel initialDisclosure = DisclosureLevel.standard,
  })  : _themeMode = initialThemeMode,
        _themeStyle = initialStyle,
        _disclosureLevel = initialDisclosure {
    _loadSavedPreferences();
  }

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Get current theme style
  String get themeStyle => _themeStyle;

  /// Get current disclosure level
  DisclosureLevel get disclosureLevel => _disclosureLevel;

  /// Get accessibility features
  Map<String, bool> get accessibilityFeatures =>
      Map.unmodifiable(_accessibilityFeatures);

  /// Set theme mode and save preference
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveThemeMode();
    }
  }

  /// Set theme style and save preference
  Future<void> setThemeStyle(String style) async {
    if (_themeStyle != style) {
      _themeStyle = style;
      notifyListeners();
      await _saveThemeStyle();
    }
  }

  /// Set disclosure level and save preference
  Future<void> setDisclosureLevel(DisclosureLevel level) async {
    if (_disclosureLevel != level) {
      _disclosureLevel = level;
      notifyListeners();
      await _saveDisclosureLevel();
    }
  }

  /// Set accessibility feature
  Future<void> setAccessibilityFeature(String feature, bool enabled) async {
    if (_accessibilityFeatures.containsKey(feature) &&
        _accessibilityFeatures[feature] != enabled) {
      _accessibilityFeatures[feature] = enabled;
      notifyListeners();
      await _saveAccessibilityFeatures();
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleThemeMode() async {
    ThemeMode newMode;
    if (_themeMode == ThemeMode.light) {
      newMode = ThemeMode.dark;
    } else if (_themeMode == ThemeMode.dark) {
      newMode = ThemeMode.system;
    } else {
      newMode = ThemeMode.light;
    }
    await setThemeMode(newMode);
  }

  /// Get the current theme based on theme mode and platform brightness
  ThemeData getCurrentTheme(BuildContext? context) {
    // Determine if we should use dark or light theme
    final bool useDarkTheme;

    switch (_themeMode) {
      case ThemeMode.light:
        useDarkTheme = false;
        break;
      case ThemeMode.dark:
        useDarkTheme = true;
        break;
      case ThemeMode.system:
        final platformBrightness = context != null
            ? MediaQuery.platformBrightnessOf(context)
            : WidgetsBinding.instance.platformDispatcher.platformBrightness;
        useDarkTheme = platformBrightness == Brightness.dark;
        break;
    }

    // Get base theme
    ThemeData baseTheme = useDarkTheme ? darkTheme : lightTheme;

    // Apply accessibility features
    return _applyAccessibilityFeatures(baseTheme);
  }

  /// Apply accessibility features to theme
  ThemeData _applyAccessibilityFeatures(ThemeData theme) {
    var updatedTheme = theme;

    // High contrast
    if (_accessibilityFeatures['highContrast'] == true) {
      final contrastColorScheme = theme.colorScheme.copyWith(
        primary: theme.colorScheme.primary.withOpacity(1.0),
        onPrimary: theme.colorScheme.brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        secondary: theme.colorScheme.secondary.withOpacity(1.0),
        onSecondary: theme.colorScheme.brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
      );

      updatedTheme = theme.copyWith(
        colorScheme: contrastColorScheme,
      );
    }

    // Large text
    if (_accessibilityFeatures['largeText'] == true) {
      final textTheme = theme.textTheme;
      final enlargedTextTheme = textTheme.copyWith(
        displayLarge: textTheme.displayLarge
            ?.copyWith(fontSize: textTheme.displayLarge!.fontSize! * 1.2),
        displayMedium: textTheme.displayMedium
            ?.copyWith(fontSize: textTheme.displayMedium!.fontSize! * 1.2),
        displaySmall: textTheme.displaySmall
            ?.copyWith(fontSize: textTheme.displaySmall!.fontSize! * 1.2),
        headlineLarge: textTheme.headlineLarge
            ?.copyWith(fontSize: textTheme.headlineLarge!.fontSize! * 1.2),
        headlineMedium: textTheme.headlineMedium
            ?.copyWith(fontSize: textTheme.headlineMedium!.fontSize! * 1.2),
        headlineSmall: textTheme.headlineSmall
            ?.copyWith(fontSize: textTheme.headlineSmall!.fontSize! * 1.2),
        titleLarge: textTheme.titleLarge
            ?.copyWith(fontSize: textTheme.titleLarge!.fontSize! * 1.2),
        titleMedium: textTheme.titleMedium
            ?.copyWith(fontSize: textTheme.titleMedium!.fontSize! * 1.2),
        titleSmall: textTheme.titleSmall
            ?.copyWith(fontSize: textTheme.titleSmall!.fontSize! * 1.2),
        bodyLarge: textTheme.bodyLarge
            ?.copyWith(fontSize: textTheme.bodyLarge!.fontSize! * 1.2),
        bodyMedium: textTheme.bodyMedium
            ?.copyWith(fontSize: textTheme.bodyMedium!.fontSize! * 1.2),
        bodySmall: textTheme.bodySmall
            ?.copyWith(fontSize: textTheme.bodySmall!.fontSize! * 1.2),
        labelLarge: textTheme.labelLarge
            ?.copyWith(fontSize: textTheme.labelLarge!.fontSize! * 1.2),
        labelMedium: textTheme.labelMedium
            ?.copyWith(fontSize: textTheme.labelMedium!.fontSize! * 1.2),
        labelSmall: textTheme.labelSmall
            ?.copyWith(fontSize: textTheme.labelSmall!.fontSize! * 1.2),
      );

      updatedTheme = updatedTheme.copyWith(
        textTheme: enlargedTextTheme,
      );
    }

    return updatedTheme;
  }

  /// Load saved preferences
  Future<void> _loadSavedPreferences() async {
    await Future.wait([
      _loadSavedThemeMode(),
      _loadSavedThemeStyle(),
      _loadSavedDisclosureLevel(),
      _loadSavedAccessibilityFeatures(),
    ]);
  }

  /// Load saved theme mode from preferences
  Future<void> _loadSavedThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);
      if (savedMode != null) {
        if (savedMode == 'light') {
          _themeMode = ThemeMode.light;
        } else if (savedMode == 'dark') {
          _themeMode = ThemeMode.dark;
        } else {
          _themeMode = ThemeMode.system;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  /// Save theme mode to preferences
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String modeValue;
      switch (_themeMode) {
        case ThemeMode.light:
          modeValue = 'light';
          break;
        case ThemeMode.dark:
          modeValue = 'dark';
          break;
        case ThemeMode.system:
          modeValue = 'system';
          break;
      }
      await prefs.setString(_themeModeKey, modeValue);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Load saved theme style from preferences
  Future<void> _loadSavedThemeStyle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedStyle = prefs.getString(_themeStyleKey);
      if (savedStyle != null) {
        _themeStyle = savedStyle;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme style: $e');
    }
  }

  /// Save theme style to preferences
  Future<void> _saveThemeStyle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeStyleKey, _themeStyle);
    } catch (e) {
      debugPrint('Error saving theme style: $e');
    }
  }

  /// Load saved disclosure level from preferences
  Future<void> _loadSavedDisclosureLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLevel = prefs.getInt(_disclosureLevelKey);
      if (savedLevel != null &&
          savedLevel >= 0 &&
          savedLevel < DisclosureLevel.values.length) {
        _disclosureLevel = DisclosureLevel.values[savedLevel];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading disclosure level: $e');
    }
  }

  /// Save disclosure level to preferences
  Future<void> _saveDisclosureLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_disclosureLevelKey, _disclosureLevel.index);
    } catch (e) {
      debugPrint('Error saving disclosure level: $e');
    }
  }

  /// Load saved accessibility features from preferences
  Future<void> _loadSavedAccessibilityFeatures() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFeatures = prefs.getString(_accessibilityKey);
      if (savedFeatures != null) {
        final Map<String, dynamic> decodedFeatures = json.decode(savedFeatures);
        decodedFeatures.forEach((key, value) {
          if (_accessibilityFeatures.containsKey(key)) {
            _accessibilityFeatures[key] = value as bool;
          }
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading accessibility features: $e');
    }
  }

  /// Save accessibility features to preferences
  Future<void> _saveAccessibilityFeatures() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _accessibilityKey, json.encode(_accessibilityFeatures));
    } catch (e) {
      debugPrint('Error saving accessibility features: $e');
    }
  }

  /// Get current theme mode as a string
  String get themeModeString {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Create default themes
  static EnhancedThemeService createDefault() {
    return EnhancedThemeService(
      lightTheme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
    );
  }

  /// Build light theme
  static ThemeData _buildLightTheme() {
    final baseTheme = ThemeData.light();
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2C62EE),
      brightness: Brightness.light,
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Enhanced form styling
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  /// Build dark theme
  static ThemeData _buildDarkTheme() {
    final baseTheme = ThemeData.dark();
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2C62EE),
      brightness: Brightness.dark,
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Enhanced form styling
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
