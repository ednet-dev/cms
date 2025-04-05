import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'theme_event.dart';

class ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;

  ThemeState({required this.themeData, required this.isDarkMode});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: cliDarkTheme, isDarkMode: true)) {
    on<ToggleThemeEvent>((event, emit) {
      final isDarkMode = !state.isDarkMode;
      final currentThemeName = themes[isDarkMode ? 'light' : 'dark']!
          .keys
          .firstWhere(
              (name) =>
                  themes[state.isDarkMode ? 'dark' : 'light']![name] ==
                  state.themeData,
              orElse: () => themes[isDarkMode ? 'dark' : 'light']!.keys.first);
      final newThemeData =
          themes[isDarkMode ? 'dark' : 'light']![currentThemeName]!;
      emit(ThemeState(themeData: newThemeData, isDarkMode: isDarkMode));
    });

    on<ChangeThemeEvent>((event, emit) {
      emit(
          ThemeState(themeData: event.themeData, isDarkMode: state.isDarkMode));
    });
  }
}
