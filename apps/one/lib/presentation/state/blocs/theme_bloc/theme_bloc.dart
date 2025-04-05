import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../di/service_locator.dart';
import '../../../theme/theme.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/theme_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

/// Bloc for managing theme-related state and logic
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeService _themeService = sl<ThemeService>();

  ThemeBloc()
    : super(
        ThemeState(
          themeData: cliDarkTheme,
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
