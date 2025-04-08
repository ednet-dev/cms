import 'package:flutter/material.dart';

/// Utility class for creating consistent text styles across the application
class ThemeTextStyles {
  /// Build a CLI-style text with monospace font
  static TextStyle buildCliTextStyle(
    Color color,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: 'monospace',
      letterSpacing: 0.2,
    );
  }

  /// Build a standard text style
  static TextStyle buildStandardTextStyle(
    Color color,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight);
  }

  /// Build a minimalistic text style
  static TextStyle buildMinimalisticTextStyle(
    Color color,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.5,
      height: 1.2,
    );
  }
}
