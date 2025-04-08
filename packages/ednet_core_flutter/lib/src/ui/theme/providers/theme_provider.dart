part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Theme-related message types for the UX Channel
class ThemeMessageTypes {
  /// Message type for theme mode change
  static const String themeModeChanged = 'theme_mode_changed';

  /// Message type for theme style change
  static const String themeStyleChanged = 'theme_style_changed';

  /// Message type for accessibility feature change
  static const String accessibilityChanged = 'accessibility_changed';

  /// Message type for disclosure level change
  static const String disclosureLevelChanged = 'disclosure_level_changed';

  /// Message type for theme configuration request
  static const String themeConfigRequest = 'theme_config_request';

  /// Message type for theme configuration response
  static const String themeConfigResponse = 'theme_config_response';
}

/// Provider for theme-related services in the Shell Architecture.
///
/// This provider implements the message-based UX Channel pattern for theme changes,
/// allowing components to subscribe to theme updates without direct coupling.
class ThemeProvider {
  /// Singleton instance of the ThemeProvider
  static final ThemeProvider _instance = ThemeProvider._internal();

  /// Factory constructor to return the singleton instance
  factory ThemeProvider() => _instance;

  /// Private constructor for singleton pattern
  ThemeProvider._internal() {
    // Create a UX Channel for theme messages
    _themeChannel = UXChannel('theme_channel', name: 'Theme Channel');

    // Listen to theme service changes
    _themeService.addListener(_notifyListeners);
  }

  /// The theme service instance
  final ThemeService _themeService = ThemeService();

  /// The UX channel for theme messages
  late final UXChannel _themeChannel;

  /// Get the theme channel
  UXChannel get channel => _themeChannel;

  /// Get the current theme mode
  ThemeMode get themeMode => _themeService.currentThemeMode;

  /// Get the current theme style
  String get themeStyle => _themeService.currentThemeStyle;

  /// Get the current disclosure level
  DisclosureLevel get disclosureLevel => _themeService.disclosureLevel;

  /// Get the light theme data
  ThemeData get lightTheme => _themeService.lightTheme;

  /// Get the dark theme data
  ThemeData get darkTheme => _themeService.darkTheme;

  /// Initialize the theme provider
  Future<void> init() async {
    await _themeService.init();
    _notifyThemeConfig();
  }

  /// Set the theme injector
  void setInjector(ConfigurationInjector injector) {
    _themeService.setInjector(injector);
  }

  /// Set the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    await _themeService.setThemeMode(mode);
    _notifyThemeModeChanged(mode);
  }

  /// Set the theme style
  Future<void> setThemeStyle(String style) async {
    await _themeService.setThemeStyle(style);
    _notifyThemeStyleChanged(style);
  }

  /// Set an accessibility feature
  Future<void> setAccessibilityFeature(
      AccessibilityFeature feature, bool enabled) async {
    await _themeService.setAccessibilityFeature(feature, enabled);
    _notifyAccessibilityChanged(feature, enabled);
  }

  /// Set the disclosure level
  Future<void> setDisclosureLevel(DisclosureLevel level) async {
    await _themeService.setDisclosureLevel(level);
    _notifyDisclosureLevelChanged(level);
  }

  /// Toggle between light and dark theme modes
  Future<void> toggleThemeMode() async {
    await _themeService.toggleThemeMode();
    _notifyThemeModeChanged(_themeService.currentThemeMode);
  }

  /// Get a theme based on style name and dark mode flag
  ThemeData getThemeByName(String name, bool isDarkMode) {
    return _themeService.getThemeByName(name, isDarkMode);
  }

  /// Get all available theme styles
  List<String> getAvailableThemeStyles() {
    return _themeService.getAvailableThemeStyles();
  }

  /// Get the current theme with accessibility and disclosure level applied
  ThemeData getCurrentTheme(BuildContext context) {
    return _themeService.getCurrentTheme(context);
  }

  /// Subscribe to theme mode changes
  void onThemeModeChanged(Function(ThemeMode) handler) {
    _themeChannel.onUXMessageType(
      ThemeMessageTypes.themeModeChanged,
      (message) =>
          handler(ThemeMode.values[message.payload['themeMode'] as int]),
    );
  }

  /// Subscribe to theme style changes
  void onThemeStyleChanged(Function(String) handler) {
    _themeChannel.onUXMessageType(
      ThemeMessageTypes.themeStyleChanged,
      (message) => handler(message.payload['themeStyle'] as String),
    );
  }

  /// Subscribe to accessibility feature changes
  void onAccessibilityChanged(Function(AccessibilityFeature, bool) handler) {
    _themeChannel.onUXMessageType(
      ThemeMessageTypes.accessibilityChanged,
      (message) => handler(
        AccessibilityFeature.values[message.payload['feature'] as int],
        message.payload['enabled'] as bool,
      ),
    );
  }

  /// Subscribe to disclosure level changes
  void onDisclosureLevelChanged(Function(DisclosureLevel) handler) {
    _themeChannel.onUXMessageType(
      ThemeMessageTypes.disclosureLevelChanged,
      (message) => handler(
        DisclosureLevel.values[message.payload['level'] as int],
      ),
    );
  }

  /// Request the current theme configuration
  void requestThemeConfig() {
    _themeChannel.sendUXMessage(UXMessage.create(
      type: ThemeMessageTypes.themeConfigRequest,
      payload: {},
      source: 'theme_provider',
    ));

    // Respond immediately with current config
    _notifyThemeConfig();
  }

  /// Subscribe to theme configuration responses
  void onThemeConfigResponse(Function(Map<String, dynamic>) handler) {
    _themeChannel.onUXMessageType(
      ThemeMessageTypes.themeConfigResponse,
      (message) => handler(message.payload),
    );
  }

  /// Notify about theme mode changes
  void _notifyThemeModeChanged(ThemeMode mode) {
    _themeChannel.sendUXMessage(UXMessage.create(
      type: ThemeMessageTypes.themeModeChanged,
      payload: {'themeMode': mode.index},
      source: 'theme_provider',
    ));
  }

  /// Notify about theme style changes
  void _notifyThemeStyleChanged(String style) {
    _themeChannel.sendUXMessage(UXMessage.create(
      type: ThemeMessageTypes.themeStyleChanged,
      payload: {'themeStyle': style},
      source: 'theme_provider',
    ));
  }

  /// Notify about accessibility feature changes
  void _notifyAccessibilityChanged(AccessibilityFeature feature, bool enabled) {
    _themeChannel.sendUXMessage(UXMessage.create(
      type: ThemeMessageTypes.accessibilityChanged,
      payload: {
        'feature': feature.index,
        'enabled': enabled,
      },
      source: 'theme_provider',
    ));
  }

  /// Notify about disclosure level changes
  void _notifyDisclosureLevelChanged(DisclosureLevel level) {
    _themeChannel.sendUXMessage(UXMessage.create(
      type: ThemeMessageTypes.disclosureLevelChanged,
      payload: {'level': level.index},
      source: 'theme_provider',
    ));
  }

  /// Notify about the current theme configuration
  void _notifyThemeConfig() {
    final config = _themeService.getCurrentThemeConfiguration();
    _themeChannel.sendUXMessage(UXMessage.create(
      type: ThemeMessageTypes.themeConfigResponse,
      payload: {
        'themeMode': _themeService.currentThemeMode.index,
        'themeStyle': _themeService.currentThemeStyle,
        'disclosureLevel': _themeService.disclosureLevel.index,
        'config': config.toMap(),
      },
      source: 'theme_provider',
    ));
  }

  /// Notify all listeners when the theme service changes
  void _notifyListeners() {
    _notifyThemeModeChanged(_themeService.currentThemeMode);
    _notifyThemeStyleChanged(_themeService.currentThemeStyle);
    _notifyDisclosureLevelChanged(_themeService.disclosureLevel);
    _notifyThemeConfig();
  }

  /// Dispose the theme provider
  void dispose() {
    _themeService.removeListener(_notifyListeners);
    _themeChannel.dispose();
  }
}
