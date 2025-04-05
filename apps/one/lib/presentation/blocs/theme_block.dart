import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/theme_service.dart';
import 'theme_event.dart';

/// State for the theme bloc containing theme data and mode information
class ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;

  ThemeState({required this.themeData, required this.isDarkMode});
}

/// Bloc for managing theme-related state and logic
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeService _themeService = ThemeService();

  ThemeBloc() : super(ThemeState(themeData: cliDarkTheme, isDarkMode: true)) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
  }

  /// Handles the toggle theme event by switching between light and dark mode
  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final isDarkMode = !state.isDarkMode;
    final newThemeData = _themeService.toggleBrightness(
      state.themeData,
      state.isDarkMode,
    );
    emit(ThemeState(themeData: newThemeData, isDarkMode: isDarkMode));
  }

  /// Handles the change theme event by changing to a specific theme
  void _onChangeTheme(ChangeThemeEvent event, Emitter<ThemeState> emit) {
    emit(ThemeState(themeData: event.themeData, isDarkMode: state.isDarkMode));
  }
}
