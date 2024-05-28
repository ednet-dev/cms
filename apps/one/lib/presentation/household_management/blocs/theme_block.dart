// theme_bloc.dart
import 'package:ednet_one/presentation/household_management/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Cubit<ThemeData> {
  ThemeBloc() : super(cheerfulLightTheme);

  void toggleTheme() {
    if (state.brightness == Brightness.dark) {
      emit(cheerfulLightTheme);
    } else {
      emit(cheerfulDarkTheme);
    }
  }
}
