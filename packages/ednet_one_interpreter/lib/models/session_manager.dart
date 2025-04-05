import 'package:shared_preferences/shared_preferences.dart';
import 'package:ednet_one_interpreter/presentation/blocs/domain_state.dart';

/// Manages the persistence of session state for the domain model interpreter.
///
/// This class provides functionality to save and restore session information,
/// allowing users to continue from where they left off when they restart the application.
class SessionManager {
  // Keys for SharedPreferences
  static const _keySelectedDomain = 'selected_domain';
  static const _keySelectedModel = 'selected_model';
  static const _keySelectedConcept = 'selected_concept';
  static const _keyUseStaging = 'use_staging';
  static const _keyLastEditTimestamp = 'last_edit_timestamp';
  static const _keyNavigationPath = 'navigation_path';
  static const _keyLayoutType = 'layout_type';
  static const _keyIsDarkMode = 'is_dark_mode';
  static const _keyActiveTheme = 'active_theme';

  /// Saves the current session state to persistent storage.
  ///
  /// This method captures the current domain model selection, UI preferences,
  /// and other session-related information.
  Future<void> saveSession(DomainState state) async {
    final prefs = await SharedPreferences.getInstance();

    if (state.selectedDomain != null) {
      prefs.setString(_keySelectedDomain, state.selectedDomain!.code);
    } else {
      prefs.remove(_keySelectedDomain);
    }

    if (state.selectedModel != null) {
      prefs.setString(_keySelectedModel, state.selectedModel!.code);
    } else {
      prefs.remove(_keySelectedModel);
    }

    if (state.selectedConcept != null) {
      prefs.setString(_keySelectedConcept, state.selectedConcept!.code);
    } else {
      prefs.remove(_keySelectedConcept);
    }

    prefs.setBool(_keyUseStaging, state.useStaging);
    prefs.setInt(_keyLastEditTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  /// Loads the saved session state from persistent storage.
  ///
  /// Returns a map containing the saved session information, which can be used
  /// to restore the application state to the last known good state.
  Future<Map<String, dynamic>> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'domainCode': prefs.getString(_keySelectedDomain),
      'modelCode': prefs.getString(_keySelectedModel),
      'conceptCode': prefs.getString(_keySelectedConcept),
      'useStaging': prefs.getBool(_keyUseStaging) ?? true,
      'lastEditTimestamp': prefs.getInt(_keyLastEditTimestamp),
    };
  }

  /// Saves navigation state such as the current path in the UI.
  ///
  /// This allows restoring not just what model was being edited,
  /// but also which screen the user was on.
  Future<void> saveNavigationState(List<String> path, String layoutType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_keyNavigationPath, path);
    prefs.setString(_keyLayoutType, layoutType);
  }

  /// Loads navigation state from persistent storage.
  Future<Map<String, dynamic>> loadNavigationState() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'path': prefs.getStringList(_keyNavigationPath) ?? ['Home'],
      'layoutType': prefs.getString(_keyLayoutType) ?? 'default',
    };
  }

  /// Saves UI theme preferences.
  Future<void> saveThemePreferences(bool isDarkMode, String activeTheme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyIsDarkMode, isDarkMode);
    prefs.setString(_keyActiveTheme, activeTheme);
  }

  /// Loads UI theme preferences from persistent storage.
  Future<Map<String, dynamic>> loadThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isDarkMode': prefs.getBool(_keyIsDarkMode) ?? false,
      'activeTheme': prefs.getString(_keyActiveTheme) ?? 'default',
    };
  }

  /// Clears all saved session data.
  ///
  /// This can be used for troubleshooting or when the user explicitly
  /// wants to reset to a clean state.
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySelectedDomain);
    await prefs.remove(_keySelectedModel);
    await prefs.remove(_keySelectedConcept);
    await prefs.remove(_keyUseStaging);
    await prefs.remove(_keyLastEditTimestamp);
    await prefs.remove(_keyNavigationPath);
    await prefs.remove(_keyLayoutType);
    await prefs.remove(_keyIsDarkMode);
    await prefs.remove(_keyActiveTheme);
  }
}
