import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../strategy/theme_strategy.dart';
import '../strategy/standard_theme_strategy.dart';
import '../theme_service.dart';

/// Provider for managing theme strategies in the application
///
/// This class is part of the "holy trinity" architecture, managing the theme
/// strategy aspect of the application. It allows registering multiple theme
/// strategies, selecting between them, and provides the active strategy to
/// widgets that need theme decisions.
///
/// The ThemeProvider should be placed near the top of the widget tree using
/// a ChangeNotifierProvider, allowing all descendant widgets to access the
/// current theme strategy through Provider.of<ThemeProvider>.
class ThemeProvider extends ChangeNotifier {
  /// Map of available theme strategies by ID
  final Map<String, ThemeStrategy> _strategies = {};

  /// The currently active theme strategy
  late ThemeStrategy _activeStrategy;

  /// The theme service for persistence
  final ThemeService _themeService;

  /// Default strategy ID to use if none is specified
  static const String defaultStrategyId = 'standard';

  /// Storage key for persisting selected theme strategy
  static const String prefsKey = 'selected_theme_strategy';

  /// Constructor for ThemeProvider
  ///
  /// Automatically registers built-in strategies and sets the default active strategy.
  /// If [initialStrategyId] is provided, it will be used instead of the default.
  ThemeProvider(this._themeService, {String? initialStrategyId}) {
    // Register built-in strategies
    _registerBuiltInStrategies();

    // Set initial active strategy
    final strategyId = initialStrategyId ?? defaultStrategyId;
    _activeStrategy =
        _strategies[strategyId] ?? _strategies[defaultStrategyId]!;
  }

  /// Register the built-in theme strategies
  void _registerBuiltInStrategies() {
    // Register the standard theme strategy for light and dark modes
    final bool isDarkMode = _themeService.currentThemeMode == ThemeMode.dark;

    if (isDarkMode) {
      registerStrategy(StandardThemeStrategy.dark());
    } else {
      registerStrategy(StandardThemeStrategy.light());
    }

    // Additional strategies can be registered here
  }

  /// The currently active theme strategy
  ThemeStrategy get activeStrategy => _activeStrategy;

  /// List of all available theme strategies
  List<ThemeStrategy> get availableStrategies => _strategies.values.toList();

  /// Register a new theme strategy
  ///
  /// This method adds a strategy to the available strategies. If a strategy
  /// with the same ID already exists, it will be replaced.
  ///
  /// [strategy] - The theme strategy to register
  void registerStrategy(ThemeStrategy strategy) {
    _strategies[strategy.id] = strategy;
    notifyListeners();
  }

  /// Set the active theme strategy by ID
  ///
  /// This method changes the active theme strategy. If the specified
  /// strategy ID is not found, no change will occur.
  ///
  /// [strategyId] - The ID of the strategy to activate
  ///
  /// Returns true if the strategy was found and activated, false otherwise.
  bool setActiveStrategy(String strategyId) {
    if (_strategies.containsKey(strategyId)) {
      _activeStrategy = _strategies[strategyId]!;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Toggle between light and dark themes while maintaining the same strategy
  ///
  /// This method toggles the theme mode without changing the theme strategy.
  Future<void> toggleThemeMode() async {
    await _themeService.toggleThemeMode();

    // Re-register strategies for the new theme mode
    _registerBuiltInStrategies();

    notifyListeners();
  }

  /// Alias for toggleThemeMode for more intuitive naming in UI
  Future<void> toggleTheme() async {
    await toggleThemeMode();
  }
}

/// Extension methods for accessing ThemeProvider from BuildContext
extension ThemeProviderExtension on BuildContext {
  /// Get the active theme strategy from the nearest ThemeProvider
  ///
  /// This is a convenient way to access the current theme strategy
  /// directly from a BuildContext.
  ///
  /// Example:
  /// ```dart
  /// final themeStrategy = context.themeStrategy;
  /// ```
  ThemeStrategy get themeStrategy {
    return Provider.of<ThemeProvider>(this, listen: false).activeStrategy;
  }

  /// Get a color for a concept using the current theme strategy
  ///
  /// This is a convenience method to get an appropriate color for a concept.
  ///
  /// Example:
  /// ```dart
  /// final errorColor = context.conceptColor('Error');
  /// ```
  Color conceptColor(String conceptType, {String? role}) {
    return themeStrategy.getColorForConcept(conceptType, colorRole: role);
  }

  /// Get a text style for a concept using the current theme strategy
  ///
  /// This is a convenience method to get an appropriate text style for a concept.
  ///
  /// Example:
  /// ```dart
  /// final titleStyle = context.conceptTextStyle('User', role: 'title');
  /// ```
  TextStyle conceptTextStyle(String conceptType, {String? role}) {
    return themeStrategy.getTextStyleForConcept(conceptType, textRole: role);
  }

  /// Get an icon for a concept using the current theme strategy
  ///
  /// This is a convenience method to get an appropriate icon for a concept.
  ///
  /// Example:
  /// ```dart
  /// final userIcon = context.conceptIcon('User');
  /// ```
  IconData conceptIcon(String conceptType) {
    return themeStrategy.getIconForConcept(conceptType);
  }

  /// Get decoration for a concept using the current theme strategy
  ///
  /// This is a convenience method to get an appropriate decoration for a concept.
  ///
  /// Example:
  /// ```dart
  /// final cardDecoration = context.conceptDecoration('Card');
  /// ```
  BoxDecoration conceptDecoration(String conceptType, {String? role}) {
    return themeStrategy.getDecorationForConcept(
      conceptType,
      containerRole: role,
    );
  }

  /// Get padding for a concept using the current theme strategy
  ///
  /// This is a convenience method to get appropriate padding for a concept.
  ///
  /// Example:
  /// ```dart
  /// final cardPadding = context.conceptPadding('Card');
  /// ```
  EdgeInsets conceptPadding(String conceptType, {String? role}) {
    return themeStrategy.getPaddingForConcept(conceptType, containerRole: role);
  }
}
