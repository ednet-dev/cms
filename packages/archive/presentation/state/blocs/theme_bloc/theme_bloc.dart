import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/theme_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

// Import ThemeService from main.dart
import 'package:ednet_one/main.dart' show themeService;

/// Bloc for managing theme-related state and logic
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeService _themeService = themeService;

  ThemeBloc()
    : super(
        ThemeState(
          themeData: AppTheme.darkTheme,
          isDarkMode: true,
          themeName: ThemeNames.cli,
        ),
      ) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
    on<InitializeThemeEvent>(_onInitializeTheme);

    // Initialize the theme state from ThemeService
    add(InitializeThemeEvent());
  }

  /// Handles the initialize theme event by reading the current theme from ThemeService
  void _onInitializeTheme(
    InitializeThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    final isDarkMode =
        _themeService.currentThemeMode == ThemeMode.dark ||
        (_themeService.currentThemeMode == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);

    final currentThemeName = _themeService.currentThemeStyle;
    final themeData = _themeService.getThemeByName(
      currentThemeName,
      isDarkMode,
    );

    emit(
      ThemeState(
        themeData: themeData,
        isDarkMode: isDarkMode,
        themeName: currentThemeName,
      ),
    );
  }

  /// Handles the toggle theme event by switching between light and dark mode
  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    // Toggle using ThemeService
    await _themeService.toggleThemeMode();

    final isDarkMode =
        _themeService.currentThemeMode == ThemeMode.dark ||
        (_themeService.currentThemeMode == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);

    final themeData = _themeService.getThemeByName(state.themeName, isDarkMode);

    emit(
      ThemeState(
        themeData: themeData,
        isDarkMode: isDarkMode,
        themeName: state.themeName,
      ),
    );
  }

  /// Handles the change theme event by changing to a specific theme
  void _onChangeTheme(ChangeThemeEvent event, Emitter<ThemeState> emit) async {
    // Update theme style in ThemeService
    await _themeService.setThemeStyle(event.themeName);

    final themeData = _themeService.getThemeByName(
      event.themeName,
      state.isDarkMode,
    );

    emit(
      ThemeState(
        themeData: themeData,
        isDarkMode: state.isDarkMode,
        themeName: event.themeName,
      ),
    );
  }
}
