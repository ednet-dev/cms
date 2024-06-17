// theme_bloc.dart
import 'package:ednet_one/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(cheerfulDarkTheme) {
    on<ToggleThemeEvent>((event, emit) {
      emit(state.brightness == Brightness.dark
          ? cheerfulLightTheme
          : cheerfulDarkTheme);
    });
  }
}
