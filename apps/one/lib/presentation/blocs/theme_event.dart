import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final ThemeData themeData;

  ChangeThemeEvent(this.themeData);
}
